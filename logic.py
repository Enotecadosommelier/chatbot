def calcular_custo_item(quantidade, custo_por_unidade, fator_desperdicio=1.0):
    """
    Calcula o custo de um ingrediente na composição de um drink.
    Fórmula: (Quantidade * Custo por Unidade) * Fator_Desperdicio
    """
    return (quantidade * custo_por_unidade) * (fator_desperdicio or 1.0)

def calcular_custo_total_drink(composicao_items):
    """
    Soma os custos de todos os ingredientes de um drink.
    composicao_items: Lista de dicionários ou objetos contendo quantidade, custo_unidade, fator_desperdicio.
    """
    custo_total = 0
    for item in composicao_items:
        custo_total += calcular_custo_item(
            item['quantidade'],
            item['custo_unidade'],
            item['fator_desperdicio']
        )
    return custo_total

def calcular_cmv_individual(custo_total, preco_venda):
    """
    Calcula o CMV individual do drink em porcentagem.
    """
    if not preco_venda or preco_venda == 0:
        return 0
    return (custo_total / preco_venda)
