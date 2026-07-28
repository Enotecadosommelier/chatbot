# Análise de Carteira Quantitativa de Criptomoedas

Este diretório contém uma análise pontual (não relacionada ao chatbot de vinhos deste repositório), gerada a pedido do usuário: uma proposta de carteira institucional de criptoativos com foco em preservação de capital e retorno ajustado ao risco.

- `relatorio.html` — relatório completo (panorama de mercado, filtro quantitativo, carteira sugerida, simulação de Monte Carlo, avaliação da BitradeX, regras de risco e 20 maiores riscos).
- `monte_carlo_simulacao.py` — script Python/NumPy usado para gerar a simulação de Monte Carlo (100.000 caminhos por horizonte, GBM correlacionado entre os ativos).

Dados de mercado levantados em 12/07/2026 via agregadores públicos (CoinGecko, CoinMarketCap, CoinDesk). Não constitui recomendação de investimento personalizada.
