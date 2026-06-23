from logic import calcular_custo_por_ml, calcular_custo_dose, calcular_cmv
import pytest

def test_calcular_custo_por_ml():
    # Bottle $35.0, Volume 750ml
    assert calcular_custo_por_ml(35.0, 750) == pytest.approx(0.046666666)
    # Zero volume handling
    assert calcular_custo_por_ml(35.0, 0) == 0

def test_calcular_custo_dose():
    # 50ml dose, $0.05 per ml, no waste
    assert calcular_custo_dose(50, 0.05, 1.0) == pytest.approx(2.5)
    # 50ml dose, $0.05 per ml, 1.1 waste factor
    assert calcular_custo_dose(50, 0.05, 1.1) == pytest.approx(2.75)

def test_cmv_logic():
    # Price $22.0, Cost $4.40 -> CMV 20%
    assert calcular_cmv(4.40, 22.0) == pytest.approx(20.0)
    # Target range check (18-22%)
    cmv = calcular_cmv(4.50, 24.0)
    assert 18.0 <= cmv <= 22.0
