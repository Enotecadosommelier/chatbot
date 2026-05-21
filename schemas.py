from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class IngredienteBase(BaseModel):
    nome: str
    categoria: str
    unidade: str
    custo_unidade: float
    fornecedor: Optional[str] = None

class Ingrediente(IngredienteBase):
    id: int
    class Config:
        from_attributes = True

class FichaTecnicaBase(BaseModel):
    nome_drink: str
    categoria: str
    preco_venda: float
    rendimento: int = 1
    descricao: Optional[str] = None
    copo_utilizado: Optional[str] = None

class FichaTecnica(FichaTecnicaBase):
    id: int
    class Config:
        from_attributes = True

class VendaBase(BaseModel):
    id_drink: int
    quantidade: int = 1
    id_funcionario: int
    local_consumo: str
    id_quarto_hospede: Optional[str] = None

class Venda(VendaBase):
    id: int
    data_hora: datetime
    class Config:
        from_attributes = True

class FuncionarioBase(BaseModel):
    nome: str
    cargo: str

class Funcionario(FuncionarioBase):
    id: int
    class Config:
        from_attributes = True

# Power BI View Schemas
class ViewFichaTecnicaCMV(BaseModel):
    nome: str
    categoria: str
    preco: float
    custo_total: float
    cmv_percent: float

class ViewRankingUpselling(BaseModel):
    nome_funcionario: str
    total_vendas_standard: int
    total_vendas_premium: int
    receita_gerada: float

class ViewEvolucaoVendas(BaseModel):
    data: str
    local_consumo: str
    receita_total: float
    cmv_medio_dia: float
