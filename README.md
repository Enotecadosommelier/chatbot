# Bar Management System - Financial Audit & Inventory

This system manages luxury bar operations with advanced financial auditing features, including operational waste margins, net revenue calculations, and 12-month seasonality simulation.

## 📊 Core Data Structure (CSV/Semicolon)

1.  **1_Fichas_Tecnicas**: Includes `Custo_Unitario_Base` and `Custo_Real_Com_Quebra` (+8%).
2.  **2_Insumos**: Detailed costs and volumes per ingredient.
3.  **3_Movimentacao_Estoque**: Stock levels by location (Current State).
4.  **4_Historico_Vendas**: Full 12-month transaction history with seasonality.
5.  **estoque_mensal_referencia**: Monthly snapshot of initial stock for auditing purposes.

## 🚀 Audit & Seasonality Rules

-   **Technical Waste (8%)**: Applied to base costs to account for pouring errors and breakages.
-   **Net Revenue (90%)**: Calculated by deducting 10% (taxes/service) from the gross sales price.
-   **Annual Simulation**: Sales history covers 12 months with high/low season variations.
    -   **High Season (1.5x volume)**: Dec, Jan, Feb, Jul.
    -   **Low Season (0.4x volume)**: Apr, May, Aug, Sep.
-   **Monthly Inventory Control**: Recorded on the 1st day of each month.

## 📈 Power BI Integration

### Specialized Audit Views
-   `GET /v_auditoria_financeira_fb`: Consolidated view of sales with net revenue and adjusted costs.
-   `GET /estoque_mensal_referencia`: Monthly stock snapshots for "Slow Moving" analysis.

---
*Built for advanced hospitality financial control.*
