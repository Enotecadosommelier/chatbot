from sqlalchemy import Column, Integer, String, Float, DateTime, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import datetime
import os

Base = declarative_base()

class FichaTecnica(Base):
    __tablename__ = '1_Fichas_Tecnicas'
    id = Column(Integer, primary_key=True)
    nome_drink = Column(String, nullable=False)
    categoria = Column(String)  # Signature, Classic, Zero-Proof
    preco_venda = Column(Float)
    receita_modo_preparo = Column(String)
    custo_unitario_base = Column(Float)
    custo_real_com_quebra = Column(Float)

class Insumo(Base):
    __tablename__ = '2_Insumos'
    id = Column(Integer, primary_key=True)
    nome_insumo = Column(String, nullable=False)
    categoria_insumo = Column(String)  # Alcoólico, Não-Alcoólico, Fruta, Guarnição
    volume_garrafa_ml = Column(Float)
    custo_garrafa = Column(Float)
    custo_por_ml = Column(Float)

class MovimentacaoEstoque(Base):
    __tablename__ = '3_Movimentacao_Estoque'
    id = Column(Integer, primary_key=True)
    nome_bebida = Column(String, nullable=False)
    qtd_almoxarifado_amox = Column(Float)
    qtd_bar_hotel = Column(Float)
    qtd_bar_praia = Column(Float)
    custo_unitario_reposicao = Column(Float)

class VendaHistorico(Base):
    __tablename__ = '4_Historico_Vendas'
    id_venda = Column(String, primary_key=True) # Changed to String for alphanumeric codes
    data_hora = Column(DateTime, default=datetime.datetime.utcnow)
    nome_drink = Column(String)
    quantidade = Column(Integer)
    nome_funcionario = Column(String)
    local_consumo = Column(String)  # Pool Bar, Restaurante, Beach Club
    faturamento_liquido_unid = Column(Float)

# Database setup
DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./bar_management.db")
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False} if "sqlite" in DATABASE_URL else {})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def init_db():
    Base.metadata.create_all(bind=engine)
