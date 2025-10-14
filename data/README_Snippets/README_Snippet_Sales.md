## Sales Performance Dashboard — README Snippet
**Business Question:** Which segments/regions/products drive revenue and margin?  
**Data:** `fact_sales` joined to `dim_date` (daily), 2024–2025.  
**Model:** Star-like (fact_sales) with date dimension.  
**Metrics:** Revenue, COGS, Gross Margin %, Orders, AOV, Units Sold.  
**Reproduce:** Load `sales_transactions.csv` + `dim_date.csv`. Create relationships on `date_key`. Add DAX from `DAX_Measures.md` (Revenue, COGS, GM%).  
**Key Visuals:** Revenue by Month, Top Products by Profit, Region vs Segment heatmap.  
