from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from models import SessionLocal, init_db, FichaTecnica, Venda, Funcionario, Ingrediente, ComposicaoDrink
from logic import calcular_custo_item, calcular_cmv_individual
from sqlalchemy import func
import datetime

app = FastAPI()

# Initialize Database
init_db()

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def read_root():
    return {"message": "Bar Management API for Power BI"}

@app.get("/v_fichas_tecnicas_cmv")
def get_fichas_cmv(db: Session = Depends(get_db)):
    drinks = db.query(FichaTecnica).all()
    results = []
    for drink in drinks:
        custo_total = 0
        for comp in drink.composicao:
            custo_total += calcular_custo_item(
                comp.quantidade_utilizada,
                comp.ingrediente.custo_por_unidade,
                comp.fator_desperdicio
            )

        results.append({
            "id": drink.id,
            "nome": drink.nome,
            "categoria": drink.categoria,
            "preco_venda": drink.preco_venda,
            "custo_total": round(custo_total, 2),
            "cmv_teorico": round(calcular_cmv_individual(custo_total, drink.preco_venda) * 100, 2)
        })
    return results

@app.get("/v_ranking_upselling")
def get_ranking_upselling(db: Session = Depends(get_db)):
    # Vendas agrupadas por funcionário e por categoria de drink
    query = (
        db.query(
            Funcionario.nome.label("funcionario"),
            FichaTecnica.categoria.label("categoria_drink"),
            func.sum(Venda.quantidade).label("total_quantidade"),
            func.sum(Venda.quantidade * FichaTecnica.preco_venda).label("faturamento_total")
        )
        .join(Venda, Funcionario.id == Venda.id_funcionario)
        .join(FichaTecnica, FichaTecnica.id == Venda.id_drink)
        .group_by(Funcionario.nome, FichaTecnica.categoria)
        .all()
    )

    return [dict(row._mapping) for row in query]

@app.get("/v_evolucao_vendas")
def get_evolucao_vendas(db: Session = Depends(get_db)):
    # Histórico de vendas diárias por local de consumo
    query = (
        db.query(
            func.date(Venda.data_hora).label("data"),
            Venda.local_consumo,
            func.sum(Venda.quantidade).label("quantidade"),
            func.sum(Venda.quantidade * FichaTecnica.preco_venda).label("faturamento_total")
        )
        .join(FichaTecnica, FichaTecnica.id == Venda.id_drink)
        .group_by(func.date(Venda.data_hora), Venda.local_consumo)
        .order_by(func.date(Venda.data_hora))
        .all()
    )

    return [dict(row._mapping) for row in query]

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
