# Reproduction Runbook

1. `pip install -r requirements.txt`
2. `python python/kpi_validation.py`
3. Load all five CSV files from `data/` into Power BI.
4. Relate each dimension key one-to-many to `Fact_Sales`.
5. Mark `Dim_Date[Date]` as the date column.
6. Create measures from `docs/DAX_Measures.dax`.
7. Build pages from `docs/PowerBI_Report_Design.md`.
8. Reconcile cards to `docs/KPI_Validation_Results.csv`.
