# SQL Review & Limitations — 04_FPNA_Executive_Analytics_PowerBI

**Dialect:** queries in `advanced_analysis/` use PostgreSQL-compatible SQL (DATE_TRUNC or INTERVAL only where indicated). The independent enterprise warehouse uses SQLite, with separate executable SQL in `enterprise_platform/sql/marts.sql`. Do not mix these dialects without translation.

- `cohort_analysis.sql`: financial trend rather than customer cohort.
- `funnel_analysis.sql`: financial profit bridge, not customer funnel.
- `segmentation_analysis.sql`: project-specific analytical segmentation and defensible denominators.

**Next manual validation:** Import original CSVs into PostgreSQL using the original `sql/schema.sql` definitions, reconcile row counts with original `python/kpi_validation.py`, run SQL and compare outputs to Power BI/Tableau visuals. The upgrade environment did not execute these queries on the original data because the source CSVs were not obtainable as files.
