from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
import database, models, schemas

app = FastAPI(title="Surf Lodge Drink Management API")

# Initialize DB
database.init_db()

@app.get("/")
def read_root():
    return {"message": "Welcome to the Surf Lodge Drink Management API"}

def get_drink_cost(drink: models.FichaTecnica):
    total_cost = 0.0
    for comp in drink.composicao:
        cost = comp.quantidade_utilizada * comp.ingrediente.custo_unidade * comp.fator_desperdicio
        total_cost += cost
    return total_cost / drink.rendimento

@app.get("/v_fichas_tecnicas_cmv", response_model=List[schemas.ViewFichaTecnicaCMV])
def view_fichas_tecnicas_cmv(db: Session = Depends(database.get_db)):
    drinks = db.query(models.FichaTecnica).all()
    results = []
    for d in drinks:
        custo_total = get_drink_cost(d)
        cmv = (custo_total / d.preco_venda) * 100 if d.preco_venda > 0 else 0
        results.append(schemas.ViewFichaTecnicaCMV(
            nome=d.nome_drink,
            categoria=d.categoria,
            preco=d.preco_venda,
            custo_total=round(custo_total, 2),
            cmv_percent=round(cmv, 2)
        ))
    return results

@app.get("/v_ranking_upselling", response_model=List[schemas.ViewRankingUpselling])
def view_ranking_upselling(db: Session = Depends(database.get_db)):
    funcionarios = db.query(models.Funcionario).all()
    # Define premium as price > 18 USD (just an example threshold)
    PREMIUM_THRESHOLD = 18.0

    results = []
    for f in funcionarios:
        total_vendas_standard = 0
        total_vendas_premium = 0
        receita_gerada = 0.0

        for venda in f.vendas:
            preco = venda.drink.preco_venda
            subtotal = preco * venda.quantidade
            receita_gerada += subtotal

            if preco >= PREMIUM_THRESHOLD:
                total_vendas_premium += venda.quantidade
            else:
                total_vendas_standard += venda.quantidade

        results.append(schemas.ViewRankingUpselling(
            nome_funcionario=f.nome,
            total_vendas_standard=total_vendas_standard,
            total_vendas_premium=total_vendas_premium,
            receita_gerada=round(receita_gerada, 2)
        ))
    return results

@app.get("/v_evolucao_vendas", response_model=List[schemas.ViewEvolucaoVendas])
def view_evolucao_vendas(db: Session = Depends(database.get_db)):
    vendas = db.query(models.Venda).all()
    # Group by date and local_consumo
    grouped = {}

    for v in vendas:
        date_str = v.data_hora.strftime("%Y-%m-%d")
        key = (date_str, v.local_consumo)

        if key not in grouped:
            grouped[key] = {"receita": 0.0, "custo_total": 0.0}

        preco = v.drink.preco_venda
        quantidade = v.quantidade
        custo_unitario = get_drink_cost(v.drink)

        grouped[key]["receita"] += preco * quantidade
        grouped[key]["custo_total"] += custo_unitario * quantidade

    results = []
    for (date_str, local), totals in grouped.items():
        cmv_medio = (totals["custo_total"] / totals["receita"]) * 100 if totals["receita"] > 0 else 0
        results.append(schemas.ViewEvolucaoVendas(
            data=date_str,
            local_consumo=local,
            receita_total=round(totals["receita"], 2),
            cmv_medio_dia=round(cmv_medio, 2)
        ))

    return sorted(results, key=lambda x: (x.data, x.local_consumo))
