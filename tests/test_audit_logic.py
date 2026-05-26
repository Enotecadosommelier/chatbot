from logic import aplicar_margem_quebra, calcular_faturamento_liquido
import pytest

def test_aplicar_margem_quebra():
    # Base $4.66 + 8% = $5.0328
    assert aplicar_margem_quebra(4.66) == pytest.approx(5.0328)
    # Default margem check
    assert aplicar_margem_quebra(100) == 108

def test_calcular_faturamento_liquido():
    # Price $22.0 - 10% = $19.8
    assert calcular_faturamento_liquido(22.0) == pytest.approx(19.8)
    # Price $18.0 - 10% = $16.2
    assert calcular_faturamento_liquido(18.0) == pytest.approx(16.2)
