import database, models
from database import SessionLocal, engine
from datetime import datetime, timedelta
import random

def seed_data():
    db = SessionLocal()

    # Clean up existing data (optional, but good for reproducibility)
    models.Base.metadata.drop_all(bind=engine)
    models.Base.metadata.create_all(bind=engine)

    # 1. Ingredients
    ingredients_data = [
        ("Tequila Blanco", "Alcoólico", "ml", 0.08, "Jose Cuervo"),
        ("Triple Sec", "Alcoólico", "ml", 0.04, "Cointreau"),
        ("Suco de Limão", "Fruta", "ml", 0.01, "Local Market"),
        ("Melancia Fresca", "Fruta", "grama", 0.005, "Local Market"),
        ("Xarope Simples", "Insumo Artesanal", "ml", 0.002, "In-house"),
        ("Gin", "Alcoólico", "ml", 0.09, "Hendricks"),
        ("Pepino", "Fruta", "unidade", 0.50, "Local Market"),
        ("Tônica", "Não-Alcoólico", "ml", 0.02, "Fever Tree"),
        ("Vodka", "Alcoólico", "ml", 0.07, "Grey Goose"),
        ("Purê de Maracujá", "Fruta", "ml", 0.03, "Local Market"),
        ("Hortelã", "Guarnição", "unidade", 0.10, "Local Market")
    ]

    ingrediente_objs = []
    for nome, cat, uni, custo, fornec in ingredients_data:
        ing = models.Ingrediente(nome=nome, categoria=cat, unidade=uni, custo_unidade=custo, fornecedor=fornec)
        db.add(ing)
        ingrediente_objs.append(ing)
    db.commit()

    # 2. Recipes (Fichas Técnicas)
    drinks_data = [
        ("Watermelon Margarita", "Signature", 22.0, "The Surf Lodge classic"),
        ("Cucumber Gin Tonic", "Classic", 18.0, "Refreshing and crisp"),
        ("Passion Fruit Martini", "Signature", 20.0, "Sweet and tangy"),
        ("Virgin Mint Lemonade", "Zero-Proof", 12.0, "Non-alcoholic refreshment")
    ]

    drink_objs = []
    for nome, cat, preco, desc in drinks_data:
        drink = models.FichaTecnica(nome_drink=nome, categoria=cat, preco_venda=preco, descricao=desc, copo_utilizado="Highball")
        db.add(drink)
        drink_objs.append(drink)
    db.commit()

    # 3. Composition (Composicao_Drink)
    # Watermelon Margarita (id 1)
    db.add_all([
        models.ComposicaoDrink(id_drink=1, id_ingrediente=1, quantidade_utilizada=60, fator_desperdicio=1.05),
        models.ComposicaoDrink(id_drink=1, id_ingrediente=2, quantidade_utilizada=30, fator_desperdicio=1.0),
        models.ComposicaoDrink(id_drink=1, id_ingrediente=3, quantidade_utilizada=30, fator_desperdicio=1.1),
        models.ComposicaoDrink(id_drink=1, id_ingrediente=4, quantidade_utilizada=100, fator_desperdicio=1.2)
    ])
    # Cucumber Gin Tonic (id 2)
    db.add_all([
        models.ComposicaoDrink(id_drink=2, id_ingrediente=6, quantidade_utilizada=50, fator_desperdicio=1.05),
        models.ComposicaoDrink(id_drink=2, id_ingrediente=8, quantidade_utilizada=200, fator_desperdicio=1.0),
        models.ComposicaoDrink(id_drink=2, id_ingrediente=7, quantidade_utilizada=0.2, fator_desperdicio=1.1)
    ])
    # Passion Fruit Martini (id 3)
    db.add_all([
        models.ComposicaoDrink(id_drink=3, id_ingrediente=9, quantidade_utilizada=60, fator_desperdicio=1.05),
        models.ComposicaoDrink(id_drink=3, id_ingrediente=10, quantidade_utilizada=40, fator_desperdicio=1.1),
        models.ComposicaoDrink(id_drink=3, id_ingrediente=5, quantidade_utilizada=15, fator_desperdicio=1.0)
    ])
    # Virgin Mint Lemonade (id 4)
    db.add_all([
        models.ComposicaoDrink(id_drink=4, id_ingrediente=3, quantidade_utilizada=45, fator_desperdicio=1.1),
        models.ComposicaoDrink(id_drink=4, id_ingrediente=5, quantidade_utilizada=20, fator_desperdicio=1.0),
        models.ComposicaoDrink(id_drink=4, id_ingrediente=11, quantidade_utilizada=5, fator_desperdicio=1.2)
    ])
    db.commit()

    # 4. Employees (Funcionarios)
    employees_data = [
        ("Alice Silva", "Sommelier"),
        ("Bruno Santos", "Bartender"),
        ("Carla Oliveira", "Garçom")
    ]
    employee_objs = []
    for nome, cargo in employees_data:
        emp = models.Funcionario(nome=nome, cargo=cargo)
        db.add(emp)
        employee_objs.append(emp)
    db.commit()

    # 5. Sales (Vendas_Lancamentos)
    locais = ["Piscina", "Restaurante", "Beach Club"]
    start_date = datetime.utcnow() - timedelta(days=7)

    for i in range(50):
        venda_date = start_date + timedelta(days=random.randint(0, 7), hours=random.randint(0, 23))
        venda = models.Venda(
            data_hora=venda_date,
            id_drink=random.randint(1, 4),
            quantidade=random.randint(1, 3),
            id_funcionario=random.randint(1, 3),
            local_consumo=random.choice(locais),
            id_quarto_hospede=str(random.randint(100, 500))
        )
        db.add(venda)
    db.commit()

    print("Database seeded successfully!")
    db.close()

if __name__ == "__main__":
    seed_data()
