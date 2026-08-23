# Reproduction Runbook

1. `pip install -r requirements.txt`
2. Run `python python/kpi_validation.py`
3. Load both fact tables and derived dimensions into Power BI.
4. Relate dates using MonthStart.
5. Build Department and Account dimensions from the included CSVs.
6. Add DAX from `docs/DAX_Measures.dax`.
7. Build pages from `docs/PowerBI_Report_Design.md`.
8. Reconcile totals to `docs/KPI_Validation_Results.csv`.
9. Use `docs/Forecasting_Methodology.md` for run-rate calculations.
