# Reproduction Runbook

1. Install Python 3.10+.
2. `pip install -r requirements.txt`
3. Run `python python/kpi_validation.py`
4. Load the CSV files from `data/` into Power BI.
5. Relate Dim_Seller[SellerKey] one-to-many to Fact_Marketplace_Orders[SellerKey].
6. Build Date/Category/Fulfillment dimensions in Power Query or use the included derived CSVs.
7. Add DAX from `docs/DAX_Measures.dax`.
8. Build pages using `docs/PowerBI_Report_Design.md`.
9. Reconcile headline KPIs to `docs/KPI_Validation_Results.csv`.
