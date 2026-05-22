# Bar Management System - Luxury Hotel (The Surf Lodge Model)

This project provides a comprehensive backend and data generation system for managing a luxury hotel bar. It integrates technical drink sheets, input costs, inventory control by location, and sales history.

## 📊 Data Structure

The system is organized into four main entities, exported as semicolon-delimited CSVs for direct consumption by Power BI or Excel:

1.  **1_Fichas_Tecnicas**: Drink recipes, categories, and sales prices.
2.  **2_Insumos**: Detailed ingredient costs, bottle volumes, and calculated cost per ml.
3.  **3_Movimentacao_Estoque**: Real-time stock levels across three locations (Almoxarifado, Bar Hotel, Praia) with replacement costs.
4.  **4_Historico_Vendas**: Record of transactions including date, drink, quantity, server, and location.

## 🚀 Setup & Execution

1.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

2.  **Generate data & reports:**
    Runs the simulation script that populates the database and generates CSV/TXT files.
    ```bash
    python generate_hotel_data.py
    ```

3.  **Run the API:**
    Exposes the data via FastAPI endpoints for dynamic integration.
    ```bash
    uvicorn main:app --reload
    ```

## 📈 Power BI Integration

### API Endpoints
- `GET /1_fichas_tecnicas`
- `GET /2_insumos`
- `GET /3_movimentacao_estoque`
- `GET /4_historico_vendas`
- `GET /v_ranking_upselling` (Aggregated for Power BI)
- `GET /v_evolucao_vendas` (Aggregated for Power BI)

### DAX Formulas

Use these formulas for advanced metrics:

**A) Dynamic CMV (Cost of Goods Sold):**
```dax
CMV_Dinamico = DIVIDE(SUM(v_fichas_tecnicas_cmv[Custo_Total]) * SUM(v_evolucao_vendas[Quantidade]), SUM(v_evolucao_vendas[Faturamento_Total]), 0)
```

**B) Upselling Revenue (Signature Drinks):**
```dax
Receita_Upselling = CALCULATE(SUM(v_evolucao_vendas[Faturamento_Total]), v_fichas_tecnicas_cmv[Categoria] = "Signature")
```

**C) Upselling Conversion Rate per Employee:**
```dax
Taxa_Upselling_Funcionario = DIVIDE([Receita_Upselling], SUM(v_evolucao_vendas[Faturamento_Total]), 0)
```

---
*Developed for high-end hospitality operations.*
