# Reproduction Runbook

1. Install Python 3.10+.
2. `pip install -r requirements.txt`
3. Run `python python/kpi_validation.py`.
4. Load `Dim_Customer.csv`, `Dim_Plan.csv`, `Fact_Daily_Events.csv`, and `Dim_Date.csv` into Tableau.
5. Relate CustomerID from customer to events and PlanKey from customer to plan.
6. Use calculated fields from `docs/Tableau_Calculated_Fields.md`.
7. Build dashboards using `docs/Tableau_Dashboard_Design.md`.
8. Reconcile headline KPI values with `docs/KPI_Validation_Results.csv`.
9. Use cohort/retention outputs for validation before publishing.
