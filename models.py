from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime, create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker
import datetime

Base = declarative_base()

class Ingrediente(Base):
    __tablename__ = 'ingredientes'
    id = Column(Integer, primary_key=True)
    nome = Column(String, nullable=False)
    categoria = Column(String)  # Alcoólico, Não-Alcoólico, Fruta, Guarnição, Insumo Artesanal
    unidade = Column(String)    # ml, grama, unidade
    custo_por_unidade = Column(Float)
    fornecedor = Column(String)

    composicoes = relationship("ComposicaoDrink", back_populates="ingrediente")

class FichaTecnica(Base):
    __tablename__ = 'fichas_tecnicas'
    id = Column(Integer, primary_key=True)
    nome = Column(String, nullable=False)
    categoria = Column(String)  # Signature, Classic, Zero-Proof
    preco_venda = Column(Float)
    rendimento = Column(Integer, default=1)
    descricao = Column(String)
    copo_utilizado = Column(String)

    composicao = relationship("ComposicaoDrink", back_populates="drink")
    vendas = relationship("Venda", back_populates="drink")

class ComposicaoDrink(Base):
    __tablename__ = 'composicao_drink'
    id = Column(Integer, primary_key=True)
    id_drink = Column(Integer, ForeignKey('fichas_tecnicas.id'))
    id_ingrediente = Column(Integer, ForeignKey('ingredientes.id'))
    quantidade_utilizada = Column(Float)
    fator_desperdicio = Column(Float, default=1.0)

    drink = relationship("FichaTecnica", back_populates="composicao")
    ingrediente = relationship("Ingrediente", back_populates="composicoes")

class Funcionario(Base):
    __tablename__ = 'funcionarios'
    id = Column(Integer, primary_key=True)
    nome = Column(String, nullable=False)
    cargo = Column(String)

    vendas = relationship("Venda", back_populates="funcionario")

class Venda(Base):
    __tablename__ = 'vendas_lancamentos'
    id = Column(Integer, primary_key=True)
    data_hora = Column(DateTime, default=datetime.datetime.utcnow)
    id_drink = Column(Integer, ForeignKey('fichas_tecnicas.id'))
    quantidade = Column(Integer)
    id_funcionario = Column(Integer, ForeignKey('funcionarios.id'))
    local_consumo = Column(String) # Pool Bar, Restaurante, Beach Club
    id_quarto_hospede = Column(String)

    drink = relationship("FichaTecnica", back_populates="vendas")
    funcionario = relationship("Funcionario", back_populates="vendas")

# Database setup
SQLALCHEMY_DATABASE_URL = "sqlite:///./bar_management.db"
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def init_db():
    Base.metadata.create_all(bind=engine)
