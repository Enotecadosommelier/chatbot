from logic import calcular_custo_item, calcular_custo_total_drink, calcular_cmv_individual
import pytest

def test_calcular_custo_item():
    # 30ml * $0.045 = $1.35
    assert calcular_custo_item(30, 0.045) == pytest.approx(1.35)
    # 30ml * $0.006 * 1.15 = $0.207
    assert calcular_custo_item(30, 0.006, 1.15) == pytest.approx(0.207)

def test_calcular_custo_total_drink():
    composicao = [
        {'quantidade': 30, 'custo_unidade': 0.045, 'fator_desperdicio': 1.0},
        {'quantidade': 30, 'custo_unidade': 0.006, 'fator_desperdicio': 1.15}
    ]
    # 1.35 + 0.207 = 1.557
    assert calcular_custo_total_drink(composicao) == pytest.approx(1.557)

def test_calcular_cmv_individual():
    custo_total = 4.40
    preco_venda = 22.00
    # 4.40 / 22.00 = 0.2 (20%)
    assert calcular_cmv_individual(custo_total, preco_venda) == pytest.approx(0.2)
    assert calcular_cmv_individual(custo_total, 0) == 0
