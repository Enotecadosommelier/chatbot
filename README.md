# Sistema de Gestão de Bar - Hotel de Luxo

Este projeto implementa um backend para gestão de fichas técnicas de drinks, controle de CMV e métricas de upselling, baseado no modelo do The Surf Lodge (Montauk).

## 🚀 Como executar o projeto

1.  **Instalar dependências:**
    ```bash
    pip install -r requirements.txt
    ```

2.  **Popular o banco de dados (Mock Data):**
    ```bash
    python seed.py
    ```

3.  **Executar a API (FastAPI):**
    ```bash
    uvicorn main:app --reload
    ```

4.  **Executar Testes:**
    ```bash
    PYTHONPATH=. pytest
    ```

## 📊 Integração com Power BI

A API fornece três endpoints principais para consumo no Power BI:
- `GET /v_fichas_tecnicas_cmv`: Dados cadastrais e CMV teórico.
- `GET /v_ranking_upselling`: Performance de vendas por funcionário e categoria.
- `GET /v_evolucao_vendas`: Histórico diário por local de consumo.

### Fórmulas DAX Recomendadas

Para as análises no Power BI, utilize as seguintes métricas:

**A) CMV Dinâmico Geral:**
```dax
CMV_Dinamico = DIVIDE(SUM(v_fichas_tecnicas_cmv[Custo_Total]) * SUM(v_evolucao_vendas[Quantidade]), SUM(v_evolucao_vendas[Faturamento_Total]), 0)
```

**B) Receita de Upselling (Vendas de drinks 'Signature'):**
```dax
Receita_Upselling = CALCULATE(SUM(v_evolucao_vendas[Faturamento_Total]), v_fichas_tecnicas_cmv[Categoria] = "Signature")
```

**C) % de Conversão de Upselling por Funcionário:**
```dax
Taxa_Upselling_Funcionario = DIVIDE([Receita_Upselling], SUM(v_evolucao_vendas[Faturamento_Total]), 0)
```

---

## 🛠️ Estrutura do Banco de Dados

- **Ingredientes**: Cadastro de insumos e custos.
- **Fichas_Tecnicas**: Definição dos drinks e preços.
- **Composicao_Drink**: Relacionamento N:N entre drinks e ingredientes com fator de desperdício.
- **Vendas_Lancamentos**: Registro operacional de vendas.
- **Funcionarios**: Cadastro da equipe.
