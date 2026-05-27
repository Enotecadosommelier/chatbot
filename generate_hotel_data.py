import pandas as pd
from models import SessionLocal, init_db, FichaTecnica, Insumo, MovimentacaoEstoque, VendaHistorico, Estoque_Inicial_Mensal
from logic import aplicar_margem_quebra, calcular_faturamento_liquido
from datetime import datetime, timedelta
import random
import string

def generate_req_code():
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))

def get_seasonality_multiplier(month):
    """
    High Season (Dec, Jan, Feb, Jul): 1.5x
    Low Season (Apr, May, Aug, Sep): 0.4x (60% reduction)
    Other: 1.0x
    """
    if month in [12, 1, 2, 7]:
        return 1.5
    elif month in [4, 5, 8, 9]:
        return 0.4
    return 1.0

def generate_data():
    init_db()
    db = SessionLocal()

    # 1. Fichas Técnicas
    fichas_data = [
        {"nome_drink": "Pink Flamingo", "categoria": "Signature", "preco_venda": 22.0, "custo_unitario_base": 4.66},
        {"nome_drink": "The Surf Lodge Seasonal Tequila", "categoria": "Signature", "preco_venda": 24.0, "custo_unitario_base": 4.81},
        {"nome_drink": "Sun Drop", "categoria": "Zero-Proof", "preco_venda": 18.0, "custo_unitario_base": 3.86},
        {"nome_drink": "Classic Margarita", "categoria": "Classic", "preco_venda": 18.0, "custo_unitario_base": 4.18},
    ]
    fichas_map = {}
    for f in fichas_data:
        f["custo_real_com_quebra"] = aplicar_margem_quebra(f["custo_unitario_base"])
        db.add(FichaTecnica(**f))
        fichas_map[f["nome_drink"]] = f

    # 2. Insumos
    insumos = ["Tequila Blanco", "Casamigos Blanco", "Martini Fiero", "Whispering Angel Rosé"]
    for name in insumos:
        db.add(Insumo(nome_insumo=name, categoria_insumo="Alcoólico", volume_garrafa_ml=750, custo_garrafa=30.0, custo_por_ml=0.04))

    # 3. Monthly Initial Stock for 12 Months
    current_year = datetime.now().year
    beverages = ["Tequila Blanco", "Casamigos Blanco", "Martini Fiero", "Whispering Angel Rosé", "Vodka Premium"]

    for month in range(1, 13):
        for bev in beverages:
            db.add(Estoque_Inicial_Mensal(
                mes_referencia=month,
                ano_referencia=current_year,
                nome_bebida=bev,
                qtd_inicial_amox=random.uniform(50, 200),
                qtd_inicial_bar_hotel=random.uniform(5, 20),
                qtd_inicial_bar_praia=random.uniform(5, 30)
            ))

    # 4. Sales History for 12 Months with Seasonality
    funcionarios = ["João Silva", "Maria Santos", "Carlos Oliveira"]
    locais = ["Pool Bar", "Restaurante", "Beach Club"]

    start_date = datetime(current_year, 1, 1)
    for day in range(365):
        current_date = start_date + timedelta(days=day)
        month = current_date.month
        multiplier = get_seasonality_multiplier(month)

        # Base number of daily sales: random between 10 and 20, adjusted by seasonality
        daily_sales_count = int(random.randint(10, 20) * multiplier)

        for _ in range(daily_sales_count):
            drink_name = random.choice(list(fichas_map.keys()))
            drink_info = fichas_map[drink_name]
            db.add(VendaHistorico(
                id_venda=generate_req_code(),
                data_hora=current_date.replace(hour=random.randint(10, 22), minute=random.randint(0, 59)),
                nome_drink=drink_name,
                quantidade=random.randint(1, 4),
                nome_funcionario=random.choice(funcionarios),
                local_consumo=random.choice(locais),
                faturamento_liquido_unid=calcular_faturamento_liquido(drink_info["preco_venda"])
            ))

    # 5. Inventory Movement (Current State)
    for bev in beverages:
        db.add(MovimentacaoEstoque(
            nome_bebida=bev,
            qtd_almoxarifado_amox=random.uniform(10, 100),
            qtd_bar_hotel=random.uniform(2, 15),
            qtd_bar_praia=random.uniform(2, 20),
            custo_unitario_reposicao=35.0
        ))

    db.commit()

    # EXPORT CSVs
    tables = {
        "1_Fichas_Tecnicas": FichaTecnica,
        "2_Insumos": Insumo,
        "3_Movimentacao_Estoque": MovimentacaoEstoque,
        "4_Historico_Vendas": VendaHistorico,
        "estoque_mensal_referencia": Estoque_Inicial_Mensal
    }

    all_content = []
    for name, model in tables.items():
        query = db.query(model).all()
        data = [dict(row.__dict__) for row in query]
        for d in data: d.pop('_sa_instance_state', None)
        df = pd.DataFrame(data)
        df.to_csv(f"{name}.csv", sep=';', index=False)
        all_content.append(f"--- {name} ---\n" + df.to_csv(sep=';', index=False) + "\n")

    with open("Painel_Integrado_Hotel.txt", "w") as f:
        f.write("\n".join(all_content))

    db.close()
    print("Annual data with seasonality generated and exported successfully.")

if __name__ == "__main__":
    generate_data()
