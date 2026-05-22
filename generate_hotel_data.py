import pandas as pd
from models import SessionLocal, init_db, FichaTecnica, Insumo, MovimentacaoEstoque, VendaHistorico
from datetime import datetime, timedelta
import random
import os

def generate_data():
    init_db()
    db = SessionLocal()

    # 1. Fichas Técnicas
    fichas = [
        {"nome_drink": "Pink Flamingo", "categoria": "Signature", "preco_venda": 22.0, "receita_modo_preparo": "30ml Tequila, 60ml Martini, 60ml Rosé, 15ml Agave, Limão, Melancia. Shake and strain."},
        {"nome_drink": "The Surf Lodge Seasonal Tequila", "categoria": "Signature", "preco_venda": 24.0, "receita_modo_preparo": "45ml Casamigos, 120ml Água de Coco, 8ml Agave, Gomo de Limão. Built in glass."},
        {"nome_drink": "Sun Drop", "categoria": "Zero-Proof", "preco_venda": 18.0, "receita_modo_preparo": "60ml Pentire, 60ml Watermelon, 15ml Simple Syrup, 20ml Limão. Stir."},
        {"nome_drink": "Classic Margarita", "categoria": "Classic", "preco_venda": 18.0, "receita_modo_preparo": "50ml Tequila, 25ml Lime, 15ml Agave. Shake."},
    ]
    for f in fichas:
        db.add(FichaTecnica(**f))

    # 2. Insumos
    insumos = [
        {"nome_insumo": "Tequila Blanco", "categoria_insumo": "Alcoólico", "volume_garrafa_ml": 750, "custo_garrafa": 35.0},
        {"nome_insumo": "Casamigos Blanco", "categoria_insumo": "Alcoólico", "volume_garrafa_ml": 750, "custo_garrafa": 60.0},
        {"nome_insumo": "Martini Fiero", "categoria_insumo": "Alcoólico", "volume_garrafa_ml": 750, "custo_garrafa": 15.0},
        {"nome_insumo": "Whispering Angel Rosé", "categoria_insumo": "Alcoólico", "volume_garrafa_ml": 750, "custo_garrafa": 25.0},
        {"nome_insumo": "Pentire Adrift", "categoria_insumo": "Não-Alcoólico", "volume_garrafa_ml": 700, "custo_garrafa": 30.0},
        {"nome_insumo": "Água de Coco", "categoria_insumo": "Não-Alcoólico", "volume_garrafa_ml": 1000, "custo_garrafa": 5.0},
        {"nome_insumo": "Limão Siciliano", "categoria_insumo": "Fruta", "volume_garrafa_ml": 1000, "custo_garrafa": 10.0},
    ]
    for i in insumos:
        i["custo_por_ml"] = i["custo_garrafa"] / i["volume_garrafa_ml"]
        db.add(Insumo(**i))

    # 3. Movimentação Estoque
    estoque = [
        {"nome_bebida": "Tequila Blanco", "qtd_almoxarifado_amox": 120, "qtd_bar_hotel": 12, "qtd_bar_praia": 24, "custo_unitario_reposicao": 35.0},
        {"nome_bebida": "Casamigos Blanco", "qtd_almoxarifado_amox": 48, "qtd_bar_hotel": 6, "qtd_bar_praia": 6, "custo_unitario_reposicao": 60.0},
        {"nome_bebida": "Martini Fiero", "qtd_almoxarifado_amox": 2, "qtd_bar_hotel": 1, "qtd_bar_praia": 0, "custo_unitario_reposicao": 15.0}, # Alerta baixo
        {"nome_bebida": "Whispering Angel Rosé", "qtd_almoxarifado_amox": 300, "qtd_bar_hotel": 60, "qtd_bar_praia": 120, "custo_unitario_reposicao": 25.0}, # Alerta alto
        {"nome_bebida": "Vodka Premium", "qtd_almoxarifado_amox": 1, "qtd_bar_hotel": 0, "qtd_bar_praia": 0, "custo_unitario_reposicao": 45.0}, # Alerta ruptura
    ]
    for e in estoque:
        db.add(MovimentacaoEstoque(**e))

    # 4. Histórico Vendas
    funcionarios = ["João Silva", "Maria Santos", "Carlos Oliveira"]
    locais = ["Pool Bar", "Restaurante", "Beach Club"]
    drinks_list = [f["nome_drink"] for f in fichas]

    start_date = datetime.utcnow() - timedelta(days=10)
    for i in range(100):
        db.add(VendaHistorico(
            data_hora=start_date + timedelta(days=random.randint(0, 10), hours=random.randint(10, 22)),
            nome_drink=random.choice(drinks_list),
            quantidade=random.randint(1, 5),
            nome_funcionario=random.choice(funcionarios),
            local_consumo=random.choice(locais)
        ))

    db.commit()

    # Export to CSV
    tables = {
        "1_Fichas_Tecnicas": FichaTecnica,
        "2_Insumos": Insumo,
        "3_Movimentacao_Estoque": MovimentacaoEstoque,
        "4_Historico_Vendas": VendaHistorico
    }

    all_content = []

    for name, model in tables.items():
        query = db.query(model).all()
        data = [dict(row.__dict__) for row in query]
        for d in data: d.pop('_sa_instance_state', None)
        df = pd.DataFrame(data)
        filename = f"{name}.csv"
        df.to_csv(filename, sep=';', index=False)

        all_content.append(f"--- {name} ---")
        all_content.append(df.to_csv(sep=';', index=False))
        all_content.append("\n")

    with open("Painel_Integrado_Hotel.txt", "w") as f:
        f.write("\n".join(all_content))

    db.close()
    print("Data generated and exported successfully.")

if __name__ == "__main__":
    generate_data()
