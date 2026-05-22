def calcular_custo_por_ml(custo_garrafa, volume_ml):
    """
    Calcula o custo por ml de um insumo.
    """
    if not volume_ml or volume_ml == 0:
        return 0
    return custo_garrafa / volume_ml

def calcular_custo_dose(quantidade_ml, custo_por_ml, fator_desperdicio=1.0):
    """
    Calcula o custo de uma dose usada em um drink.
    """
    return (quantidade_ml * custo_por_ml) * (fator_desperdicio or 1.0)

def calcular_cmv(custo_total, preco_venda):
    """
    Calcula o CMV em porcentagem.
    """
    if not preco_venda or preco_venda == 0:
        return 0
    return (custo_total / preco_venda) * 100
