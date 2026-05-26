# Bar Management System - Financial Audit & Inventory

This system manages luxury bar operations with advanced financial auditing features, including operational waste margins and net revenue calculations.

## 📊 Core Data Structure (CSV/Semicolon)

1.  **1_Fichas_Tecnicas**: Includes `Custo_Unitario_Base` and `Custo_Real_Com_Quebra` (+8%).
2.  **2_Insumos**: Detailed costs and volumes per ingredient.
3.  **3_Movimentacao_Estoque**: Stock levels by location.
4.  **4_Historico_Vendas**: Includes alphanumeric IDs and `Faturamento_Liquido_Unid` (-10%).

## 🚀 Audit & Business Rules

-   **Technical Waste (8%)**: Applied to base costs to account for pouring errors and breakages.
-   **Net Revenue (90%)**: Calculated by deducting 10% (taxes/service) from the gross sales price.
-   **Alphanumeric Requisitions**: Sales IDs now follow hotel group standards (e.g., `QKRDYYTL`).

## 📈 Power BI Integration

### Specialized Audit View
-   `GET /v_auditoria_financeira_fb`: Consolidated view of sales with net revenue and costs including operational waste.

### DAX Formulas for Power BI

Use the following formulas for your dashboard:

**A) CMV Dinâmico Geral (Com Margem de Quebra):**
```dax
CMV_Dinamico = DIVIDE(SUM(v_auditoria_financeira_fb[custo_total_com_quebra]), SUM(v_auditoria_financeira_fb[faturamento_liquido_total]), 0)
```

**B) Receita de Upselling (Signature Drinks):**
```dax
Receita_Upselling = CALCULATE(SUM(v_auditoria_financeira_fb[faturamento_liquido_total]), '1_Fichas_Tecnicas'[categoria] = "Signature")
```

**C) Margem de Contribuição Operacional:**
```dax
Margem_Operacional = SUM(v_auditoria_financeira_fb[faturamento_liquido_total]) - SUM(v_auditoria_financeira_fb[custo_total_com_quebra])
```

---
*Built for advanced hospitality financial control.*
