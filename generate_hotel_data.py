import pandas as pd
from models import SessionLocal, init_db, FichaTecnica, Insumo, MovimentacaoEstoque, VendaHistorico
from logic import aplicar_margem_quebra, calcular_faturamento_liquido
from datetime import datetime, timedelta
import random
import string

def generate_req_code():
    """Generates an alphanumeric requisition code."""
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))

def generate_data():
    init_db()
    db = SessionLocal()

    # 1. Fichas Técnicas with Base Costs
    fichas_data = [
        {"nome_drink": "Pink Flamingo", "categoria": "Signature", "preco_venda": 22.0, "custo_unitario_base": 4.66},
        {"nome_drink": "The Surf Lodge Seasonal Tequila", "categoria": "Signature", "preco_venda": 24.0, "custo_unitario_base": 4.81},
        {"nome_drink": "Sun Drop", "categoria": "Zero-Proof", "preco_venda": 18.0, "custo_unitario_base": 3.86},
        {"nome_drink": "Classic Margarita", "categoria": "Classic", "preco_venda": 18.0, "custo_unitario_base": 4.18},
    ]

    fichas_map = {}
    for f in fichas_data:
        f["custo_real_com_quebra"] = aplicar_margem_quebra(f["custo_unitario_base"])
        obj = FichaTecnica(**f)
        db.add(obj)
        fichas_map[f["nome_drink"]] = f

    # 2. Insumos
    insumos = [
        {"nome_insumo": "Tequila Blanco", "categoria_insumo": "Alcoólico", "volume_garrafa_ml": 750, "custo_garrafa": 35.0},
        {"nome_insumo": "Casamigos Blanco", "categoria_insumo": "Alcoólico", "volume_garrafa_ml": 750, "custo_garrafa": 60.0},
    ]
    for i in insumos:
        i["custo_por_ml"] = i["custo_garrafa"] / i["volume_garrafa_ml"]
        db.add(Insumo(**i))

    # 3. Movimentação Estoque
    estoque = [
        {"nome_bebida": "Tequila Blanco", "qtd_almoxarifado_amox": 120, "qtd_bar_hotel": 12, "qtd_bar_praia": 24, "custo_unitario_reposicao": 35.0},
    ]
    for e in estoque:
        db.add(MovimentacaoEstoque(**e))

    # 4. Histórico Vendas with Alphanumeric IDs and Net Revenue
    funcionarios = ["João Silva", "Maria Santos", "Carlos Oliveira"]
    locais = ["Pool Bar", "Restaurante", "Beach Club"]

    start_date = datetime.utcnow() - timedelta(days=10)
    for i in range(150):
        drink_name = random.choice(list(fichas_map.keys()))
        drink_info = fichas_map[drink_name]

        db.add(VendaHistorico(
            id_venda=generate_req_code(),
            data_hora=start_date + timedelta(days=random.randint(0, 10), hours=random.randint(10, 22)),
            nome_drink=drink_name,
            quantidade=random.randint(1, 5),
            nome_funcionario=random.choice(funcionarios),
            local_consumo=random.choice(locais),
            faturamento_liquido_unid=calcular_faturamento_liquido(drink_info["preco_venda"])
        ))

    db.commit()

    # Export for Power BI
    export_config = {
        "1_Fichas_Tecnicas": FichaTecnica,
        "2_Insumos": Insumo,
        "3_Movimentacao_Estoque": MovimentacaoEstoque,
        "4_Historico_Vendas": VendaHistorico
    }

    all_content = []
    for name, model in export_config.items():
        query = db.query(model).all()
        data = [dict(row.__dict__) for row in query]
        for d in data: d.pop('_sa_instance_state', None)
        df = pd.DataFrame(data)
        df.to_csv(f"{name}.csv", sep=';', index=False)

        all_content.append(f"--- {name} ---")
        all_content.append(df.to_csv(sep=';', index=False))
        all_content.append("\n")

    # Auditoria Financeira View Export
    audit_query = (
        db.query(
            VendaHistorico.data_hora,
            VendaHistorico.nome_drink,
            VendaHistorico.local_consumo,
            VendaHistorico.quantidade,
            VendaHistorico.nome_funcionario,
            (VendaHistorico.quantidade * VendaHistorico.faturamento_liquido_unid).label("faturamento_liquido_total"),
            (VendaHistorico.quantidade * FichaTecnica.custo_real_com_quebra).label("custo_total_com_quebra")
        )
        .join(FichaTecnica, FichaTecnica.nome_drink == VendaHistorico.nome_drink)
        .all()
    )
    audit_df = pd.DataFrame([dict(row._mapping) for row in audit_query])
    audit_df.to_csv("v_auditoria_financeira_fb.csv", sep=';', index=False)

    all_content.append("--- v_auditoria_financeira_fb ---")
    all_content.append(audit_df.to_csv(sep=';', index=False))

    with open("Painel_Integrado_Hotel.txt", "w") as f:
        f.write("\n".join(all_content))

    db.close()
    print("Audit data generated and exported successfully.")

if __name__ == "__main__":
    generate_data()
