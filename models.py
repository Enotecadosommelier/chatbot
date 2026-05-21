from sqlalchemy import Column, Integer, String, Float, ForeignKey, DateTime, Text
from sqlalchemy.orm import relationship, declarative_base
import datetime

Base = declarative_base()

class Ingrediente(Base):
    __tablename__ = 'ingredientes'

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(100), nullable=False)
    categoria = Column(String(50))  # Alcoólico, Não-Alcoólico, Fruta, Guarnição, Insumo Artesanal
    unidade = Column(String(20))    # ml, grama, unidade
    custo_unidade = Column(Float, nullable=False)
    fornecedor = Column(String(100))

    composicoes = relationship("ComposicaoDrink", back_populates="ingrediente")

class FichaTecnica(Base):
    __tablename__ = 'fichas_tecnicas'

    id = Column(Integer, primary_key=True, index=True)
    nome_drink = Column(String(100), nullable=False)
    categoria = Column(String(50))  # Signature, Classic, Zero-Proof
    preco_venda = Column(Float, nullable=False)
    rendimento = Column(Integer, default=1)
    descricao = Column(Text)
    copo_utilizado = Column(String(50))

    composicao = relationship("ComposicaoDrink", back_populates="drink")
    vendas = relationship("Venda", back_populates="drink")

class ComposicaoDrink(Base):
    __tablename__ = 'composicao_drink'

    id = Column(Integer, primary_key=True, index=True)
    id_drink = Column(Integer, ForeignKey('fichas_tecnicas.id'))
    id_ingrediente = Column(Integer, ForeignKey('ingredientes.id'))
    quantidade_utilizada = Column(Float, nullable=False)
    fator_desperdicio = Column(Float, default=1.0)

    drink = relationship("FichaTecnica", back_populates="composicao")
    ingrediente = relationship("Ingrediente", back_populates="composicoes")

class Funcionario(Base):
    __tablename__ = 'funcionarios'

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String(100), nullable=False)
    cargo = Column(String(50))

    vendas = relationship("Venda", back_populates="funcionario")

class Venda(Base):
    __tablename__ = 'vendas_lancamentos'

    id = Column(Integer, primary_key=True, index=True)
    data_hora = Column(DateTime, default=datetime.datetime.utcnow)
    id_drink = Column(Integer, ForeignKey('fichas_tecnicas.id'))
    quantidade = Column(Integer, default=1)
    id_funcionario = Column(Integer, ForeignKey('funcionarios.id'))
    local_consumo = Column(String(50)) # Piscina, Restaurante, Beach Club
    id_quarto_hospede = Column(String(20))

    drink = relationship("FichaTecnica", back_populates="vendas")
    funcionario = relationship("Funcionario", back_populates="vendas")
