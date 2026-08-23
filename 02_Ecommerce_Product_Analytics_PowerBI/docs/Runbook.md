# Reproduction Runbook

1. Install Python 3.10+.
2. Run `pip install -r requirements.txt`.
3. Run `python python/kpi_validation.py`.
4. Load the CSV files in `data/` into Power BI.
5. Create Date, Device, and Traffic Source dimension relationships to the fact table using matching fields or surrogate keys in Power Query.
6. Do not create a Product Category relationship unless the fact table is extended with a valid category key.
7. Add measures from `docs/DAX_Measures.dax`.
8. Build report pages from `docs/PowerBI_Report_Design.md`.
9. Reconcile headline KPIs against `docs/KPI_Validation_Results.csv`.
