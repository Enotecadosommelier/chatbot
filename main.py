from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from sqlalchemy import func
from models import SessionLocal, init_db, FichaTecnica, Insumo, MovimentacaoEstoque, VendaHistorico
import datetime

app = FastAPI()

# Initialize database
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
    return {"message": "Luxury Bar Management - Financial Audit System"}

@app.get("/1_fichas_tecnicas")
def get_fichas(db: Session = Depends(get_db)):
    return db.query(FichaTecnica).all()

@app.get("/2_insumos")
def get_insumos(db: Session = Depends(get_db)):
    return db.query(Insumo).all()

@app.get("/3_movimentacao_estoque")
def get_estoque(db: Session = Depends(get_db)):
    return db.query(MovimentacaoEstoque).all()

@app.get("/4_historico_vendas")
def get_vendas(db: Session = Depends(get_db)):
    return db.query(VendaHistorico).all()

# Financial Audit View for Power BI
@app.get("/v_auditoria_financeira_fb")
def get_auditoria_financeira(db: Session = Depends(get_db)):
    query = (
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
    return [dict(row._mapping) for row in query]

# Views for Power BI
@app.get("/v_ranking_upselling")
def get_ranking_upselling(db: Session = Depends(get_db)):
    query = (
        db.query(
            FichaTecnica.categoria.label("categoria"),
            func.sum(VendaHistorico.quantidade).label("total_quantidade"),
            func.sum(VendaHistorico.quantidade * FichaTecnica.preco_venda).label("faturamento_bruto_total"),
            func.sum(VendaHistorico.quantidade * VendaHistorico.faturamento_liquido_unid).label("faturamento_liquido_total")
        )
        .join(FichaTecnica, FichaTecnica.nome_drink == VendaHistorico.nome_drink)
        .group_by(FichaTecnica.categoria)
        .all()
    )
    return [dict(row._mapping) for row in query]

@app.get("/v_evolucao_vendas")
def get_evolucao_vendas(db: Session = Depends(get_db)):
    query = (
        db.query(
            func.date(VendaHistorico.data_hora).label("data"),
            VendaHistorico.local_consumo,
            func.sum(VendaHistorico.quantidade).label("quantidade"),
            func.sum(VendaHistorico.quantidade * VendaHistorico.faturamento_liquido_unid).label("faturamento_liquido_total")
        )
        .join(FichaTecnica, FichaTecnica.nome_drink == VendaHistorico.nome_drink)
        .group_by(func.date(VendaHistorico.data_hora), VendaHistorico.local_consumo)
        .order_by(func.date(VendaHistorico.data_hora))
        .all()
    )
    return [dict(row._mapping) for row in query]
