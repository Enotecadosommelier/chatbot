import numpy as np

np.random.seed(42)

assets = ["BTC","ETH","BNB","SOL","XRP","LINK","AVAX","AAVE","SUI","TAO","USDT"]
weights = np.array([0.18,0.15,0.10,0.09,0.07,0.06,0.04,0.03,0.01,0.02,0.25], dtype=np.float32)
assert abs(weights.sum()-1) < 1e-6

mu    = np.array([0.15,0.18,0.12,0.25,0.10,0.20,0.20,0.18,0.22,0.28,0.04], dtype=np.float32)
sigma = np.array([0.50,0.65,0.55,0.85,0.70,0.75,0.90,0.80,1.00,1.10,0.005], dtype=np.float32)

n = len(assets)
corr = np.array([
#   BTC   ETH   BNB   SOL   XRP   LINK  AVAX  AAVE  SUI   TAO   USDT
   [1.00, 0.85, 0.75, 0.70, 0.55, 0.65, 0.68, 0.60, 0.60, 0.55, 0.00],
   [0.85, 1.00, 0.70, 0.75, 0.50, 0.75, 0.72, 0.70, 0.65, 0.55, 0.00],
   [0.75, 0.70, 1.00, 0.65, 0.50, 0.60, 0.60, 0.55, 0.55, 0.45, 0.00],
   [0.70, 0.75, 0.65, 1.00, 0.50, 0.65, 0.75, 0.60, 0.70, 0.55, 0.00],
   [0.55, 0.50, 0.50, 0.50, 1.00, 0.50, 0.45, 0.40, 0.45, 0.35, 0.00],
   [0.65, 0.75, 0.60, 0.65, 0.50, 1.00, 0.65, 0.65, 0.60, 0.55, 0.00],
   [0.68, 0.72, 0.60, 0.75, 0.45, 0.65, 1.00, 0.65, 0.70, 0.55, 0.00],
   [0.60, 0.70, 0.55, 0.60, 0.40, 0.65, 0.65, 1.00, 0.60, 0.50, 0.00],
   [0.60, 0.65, 0.55, 0.70, 0.45, 0.60, 0.70, 0.60, 1.00, 0.55, 0.00],
   [0.55, 0.55, 0.45, 0.55, 0.35, 0.55, 0.55, 0.50, 0.55, 1.00, 0.00],
   [0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 1.00],
], dtype=np.float64)

eigval, eigvec = np.linalg.eigh(corr)
eigval_clipped = np.clip(eigval, 1e-8, None)
corr_psd = eigvec @ np.diag(eigval_clipped) @ eigvec.T
d = np.sqrt(np.diag(corr_psd))
corr_psd = corr_psd / np.outer(d, d)
L = np.linalg.cholesky(corr_psd).astype(np.float32)

N_SIMS = 100_000
BATCH = 4000
horizons = {"30d":30, "90d":90, "180d":180, "365d":365}
dt = np.float32(1/365)

results = {}
rng = np.random.default_rng(42)

for label, days in horizons.items():
    final_returns = np.empty(N_SIMS, dtype=np.float32)
    max_dds = np.empty(N_SIMS, dtype=np.float32)
    drift = (mu - 0.5*sigma**2) * dt
    diffusion = sigma * np.sqrt(dt)

    n_batches = N_SIMS // BATCH
    for b in range(n_batches):
        z = rng.standard_normal((BATCH, days, n)).astype(np.float32)
        z_corr = z @ L.T
        log_returns = drift + diffusion * z_corr
        cum_path = np.cumsum(log_returns, axis=1)
        asset_path_rel = np.exp(cum_path)
        portfolio_path = (asset_path_rel * weights).sum(axis=2)
        # prepend t0=1
        port_full = np.concatenate([np.ones((BATCH,1), dtype=np.float32), portfolio_path], axis=1)
        running_max = np.maximum.accumulate(port_full, axis=1)
        drawdown = port_full/running_max - 1
        max_dds[b*BATCH:(b+1)*BATCH] = drawdown.min(axis=1)
        final_returns[b*BATCH:(b+1)*BATCH] = port_full[:,-1] - 1
        del z, z_corr, log_returns, cum_path, asset_path_rel, portfolio_path, port_full, running_max, drawdown

    port_return = final_returns
    max_dd = max_dds

    p10, p50, p90 = np.percentile(port_return, [10,50,90])
    var95 = np.percentile(port_return, 5)
    es95 = port_return[port_return <= var95].mean()
    prob_profit = (port_return > 0).mean()
    mean_dd = max_dd.mean()
    p5_dd = np.percentile(max_dd, 5)

    ann_factor = np.sqrt(365/days)
    mean_ret = port_return.mean()
    std_ret = port_return.std()
    sharpe_like = (mean_ret/std_ret)*ann_factor if std_ret>0 else np.nan
    downside = port_return[port_return<0]
    downside_std = downside.std() if len(downside)>0 else np.nan
    sortino_like = (mean_ret/downside_std)*ann_factor if downside_std and downside_std>0 else np.nan

    results[label] = dict(p10=p10,p50=p50,p90=p90,var95=var95,es95=es95,
                           prob_profit=prob_profit, mean_dd=mean_dd, p5_dd=p5_dd,
                           sharpe=sharpe_like, sortino=sortino_like)

for label, r in results.items():
    print(f"\n== Horizonte {label} ==")
    print(f"  Cenario pessimista (P10): {r['p10']*100:+.2f}%")
    print(f"  Cenario provavel   (P50): {r['p50']*100:+.2f}%")
    print(f"  Cenario otimista   (P90): {r['p90']*100:+.2f}%")
    print(f"  VaR 95%: {r['var95']*100:+.2f}%   Expected Shortfall 95%: {r['es95']*100:+.2f}%")
    print(f"  Probabilidade de retorno positivo: {r['prob_profit']*100:.1f}%")
    print(f"  Drawdown medio: {r['mean_dd']*100:.2f}%   Drawdown P5 (pior 5%): {r['p5_dd']*100:.2f}%")
    print(f"  Sharpe anualizado (aprox): {r['sharpe']:.2f}   Sortino anualizado (aprox): {r['sortino']:.2f}")

print("\n== STRESS TESTS (choque instantaneo) ==")
crash_scenarios = {"Crash -50%": -0.50, "Crash -80%": -0.80}
risk_weight = weights[:-1].sum()
for name, shock in crash_scenarios.items():
    port_shock = risk_weight*shock
    print(f"  {name}: impacto na carteira = {port_shock*100:.1f}% (USDT protegido)")
