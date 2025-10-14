# Business Intelligence Portfolio — Data Scaffold

This `/data` folder provides clean, ready-to-use CSV inputs aligned to the dashboards and case studies in this repository.

## Folder Structure
```
data/
├── dim/
│   └── dim_date.csv
├── executive_overview/
│   └── profitability_by_month.csv
├── financial_performance/
│   └── financial_performance_monthly.csv
├── kpi/
│   └── kpi_data_dictionary.csv
├── netflix_content/
│   └── netflix_content.csv
├── sales_performance/
│   └── sales_transactions.csv
└── traffic_minnesota/
    └── traffic_volume_daily.csv
```

## How to Use (Power BI)
1. **Get Data → Text/CSV** for each file you need.
2. Set **Data Type**: ensure `date_key` is **Whole Number** where present.
3. Create relationships:
   - `fact_sales[date_key]` → `dim_date[date_key]`
   - `traffic_volume_daily[date_key]` → `dim_date[date_key]`
   - For monthly tables, create a `MonthStart` column and relate to `dim_date[date]`.
4. Mark `dim_date[date]` as the **Date table**.
5. Add measures from `DAX_Measures.md`.

## How to Use (Tableau)
1. Connect to **Text File** → select the CSV(s).
2. For date relationships, use `date_key` (join on `dim_date`) or join on the **Month** date for monthly tables.
3. Build sheets for KPIs listed in `README_Snippets/*` and `kpi/kpi_data_dictionary.csv`.

## Datasets → Dashboards
- `sales_performance/sales_transactions.csv` → **Sales Performance**
- `executive_overview/profitability_by_month.csv` → **Executive Profitability**
- `traffic_minnesota/traffic_volume_daily.csv` → **Minnesota Interstate Traffic**
- `netflix_content/netflix_content.csv` → **Netflix Content Analytics**
- `financial_performance/financial_performance_monthly.csv` → **Financial Performance**
- `dim/dim_date.csv` → **Date table for all projects**
- `kpi/kpi_data_dictionary.csv` → **Metric definitions**

## License
Data here is **synthetic** and released under the repo’s license.
