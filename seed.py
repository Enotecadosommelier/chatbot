from models import SessionLocal, init_db, Ingrediente, FichaTecnica, ComposicaoDrink, Funcionario, Venda
from datetime import datetime, timedelta
import random

def seed_data():
    init_db()
    db = SessionLocal()

    # 1. Ingredientes
    ingredientes_data = [
        {"nome": "Tequila Blanco", "categoria": "Alcoólico", "unidade": "ml", "custo_por_unidade": 0.045, "fornecedor": "Distribuidora A"},
        {"nome": "Martini Fiero", "categoria": "Alcoólico", "unidade": "ml", "custo_por_unidade": 0.018, "fornecedor": "Distribuidora B"},
        {"nome": "Vinho Rosé Whispering Angel", "categoria": "Alcoólico", "unidade": "ml", "custo_por_unidade": 0.022, "fornecedor": "Distribuidora C"},
        {"nome": "Xarope Agave", "categoria": "Não-Alcoólico", "unidade": "ml", "custo_por_unidade": 0.012, "fornecedor": "Distribuidora A"},
        {"nome": "Suco Limão", "categoria": "Fruta", "unidade": "ml", "custo_por_unidade": 0.006, "fornecedor": "Hortifruti"},
        {"nome": "Suco Melancia", "categoria": "Fruta", "unidade": "ml", "custo_por_unidade": 0.004, "fornecedor": "Hortifruti"},
        {"nome": "Casamigos Blanco", "categoria": "Alcoólico", "unidade": "ml", "custo_por_unidade": 0.08, "fornecedor": "Distribuidora A"},
        {"nome": "Água de Coco Vita Coco", "categoria": "Não-Alcoólico", "unidade": "ml", "custo_por_unidade": 0.008, "fornecedor": "Distribuidora B"},
        {"nome": "Gomo de Limão", "categoria": "Guarnição", "unidade": "unidade", "custo_por_unidade": 0.15, "fornecedor": "Hortifruti"},
        {"nome": "Pentire Adrift", "categoria": "Não-Alcoólico", "unidade": "ml", "custo_por_unidade": 0.045, "fornecedor": "Distribuidora C"},
        {"nome": "Watermelon Mixer", "categoria": "Não-Alcoólico", "unidade": "ml", "custo_por_unidade": 0.015, "fornecedor": "Distribuidora A"},
        {"nome": "Xarope Simples", "categoria": "Insumo Artesanal", "unidade": "ml", "custo_por_unidade": 0.008, "fornecedor": "Interno"},
    ]

    ingredientes_objs = {}
    for data in ingredientes_data:
        ing = Ingrediente(**data)
        db.add(ing)
        db.flush()
        ingredientes_objs[data["nome"]] = ing

    # 2. Fichas Técnicas
    drinks_data = [
        {
            "nome": "Pink Flamingo",
            "categoria": "Signature",
            "preco_venda": 22.00,
            "composicao": [
                ("Tequila Blanco", 30, 1.0),
                ("Martini Fiero", 60, 1.0),
                ("Vinho Rosé Whispering Angel", 60, 1.0),
                ("Xarope Agave", 15, 1.0),
                ("Suco Limão", 30, 1.15),
                ("Suco Melancia", 120, 1.1),
            ]
        },
        {
            "nome": "The Surf Lodge Seasonal Tequila",
            "categoria": "Signature",
            "preco_venda": 24.00,
            "composicao": [
                ("Casamigos Blanco", 45, 1.0),
                ("Água de Coco Vita Coco", 120, 1.0),
                ("Xarope Agave", 8, 1.0),
                ("Gomo de Limão", 1, 1.0),
            ]
        },
        {
            "nome": "Sun Drop",
            "categoria": "Zero-Proof",
            "preco_venda": 18.00,
            "composicao": [
                ("Pentire Adrift", 60, 1.0),
                ("Watermelon Mixer", 60, 1.0),
                ("Xarope Simples", 15, 1.0),
                ("Suco Limão", 20, 1.15),
            ]
        }
    ]

    drinks_objs = []
    for d_data in drinks_data:
        drink = FichaTecnica(
            nome=d_data["nome"],
            categoria=d_data["categoria"],
            preco_venda=d_data["preco_venda"]
        )
        db.add(drink)
        db.flush()
        drinks_objs.append(drink)

        for ing_nome, quant, fator in d_data["composicao"]:
            comp = ComposicaoDrink(
                id_drink=drink.id,
                id_ingrediente=ingredientes_objs[ing_nome].id,
                quantidade_utilizada=quant,
                fator_desperdicio=fator
            )
            db.add(comp)

    # 3. Funcionários
    funcionarios_data = [
        {"nome": "João Silva", "cargo": "Bartender"},
        {"nome": "Maria Santos", "cargo": "Bartender"},
        {"nome": "Carlos Oliveira", "cargo": "Garçom"},
    ]
    func_objs = []
    for f_data in funcionarios_data:
        f = Funcionario(**f_data)
        db.add(f)
        db.flush()
        func_objs.append(f)

    # 4. Vendas (Mock de 7 dias)
    locais = ["Pool Bar", "Restaurante", "Beach Club"]
    start_date = datetime.utcnow() - timedelta(days=7)

    for i in range(50):
        venda = Venda(
            data_hora=start_date + timedelta(days=random.randint(0, 7), hours=random.randint(10, 22)),
            id_drink=random.choice(drinks_objs).id,
            quantidade=random.randint(1, 5),
            id_funcionario=random.choice(func_objs).id,
            local_consumo=random.choice(locais),
            id_quarto_hospede=str(random.randint(100, 500))
        )
        db.add(venda)

    db.commit()
    db.close()
    print("Database seeded successfully!")

if __name__ == "__main__":
    seed_data()
