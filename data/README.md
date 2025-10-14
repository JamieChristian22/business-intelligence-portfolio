# 📂 Data Directory — BI Portfolio

This `data/` folder holds the core datasets that power your dashboards and case studies.  
They’re structured, documented, and ready for use in Power BI, Tableau, or any BI tool.

---

## 📁 Folder & File Layout

data/
├── dim/
│ └── dim_date.csv
├── executive_overview/
│ └── profitability_by_month.csv
├── financial_performance/
│ └── financial_performance_monthly.csv
├── kpi/
│ └── kpi_data_dictionary.csv
├── netflix_content/
│ └── netflix_content.csv
├── sales_performance/
│ └── sales_transactions.csv
└── traffic_minnesota/
└── traffic_volume_daily.csv

| Folder | File | Purpose |
|---|---|---|
| `dim/` | `dim_date.csv` | The master date dimension — includes year, quarter, month, week, holiday flags, etc. |
| `sales_performance/` | `sales_transactions.csv` | Order-level fact table: revenue, cost, discount, profit, product, segment, region. |
| `executive_overview/` | `profitability_by_month.csv` | Monthly-level summary: revenue, COGS, operating expenses, gross & net margins. |
| `financial_performance/` | `financial_performance_monthly.csv` | Finance metrics + balance sheet proxies: AR, inventory, EBIT, net income, margins. |
| `traffic_minnesota/` | `traffic_volume_daily.csv` | Traffic data for Minnesota interstates: volume, avg speed, incidents, by date and segment. |
| `netflix_content/` | `netflix_content.csv` | Media catalog data: title attributes and IMDB ratings. |
| `kpi/` | `kpi_data_dictionary.csv` | Definitions, formulas, grain, and owners for all metrics used across projects. |

---

## 🧩 Usage Guide

### Power BI / Power BI Desktop
1. Use **Get Data → Text/CSV** to load each relevant CSV.
2. Set correct data types (e.g., `date_key` → Whole Number, `date` → Date).
3. Create relationships:
   - `sales_transactions[date_key]` → `dim_date[date_key]`
   - `traffic_volume_daily[date_key]` → `dim_date[date_key]`
   - For monthly-level tables (profitability, financial), correlate via a `MonthStart` column or first-of-month dates to `dim_date[date]`.
4. Mark `dim_date[date]` as the **Date Table** in the model.
5. Use your DAX measures (in `DAX_Measures.md` in root) to generate metrics and visuals.

### Tableau / Other Tools
- Connect each CSV as a separate data source.
- Join on `date_key` for daily-level tables or `month`/`MonthStart` for monthly summaries.
- Use the `kpi_data_dictionary` CSV to standardize metric names and definitions in tooltips or documentation.

---

## 📊 Dashboard-to-Data Mapping

| Dashboard | Source File(s) | Key Metrics |
|---|---|---|
| **Sales Performance** | `sales_transactions.csv` + `dim_date.csv` | Revenue, Units Sold, Gross Margin %, Discount impact, Top Products |
| **Executive Overview** | `profitability_by_month.csv` + `dim_date.csv` | Net Income, Operating Expense trends, Margin ratios |
| **Financial Performance** | `financial_performance_monthly.csv` + `dim_date.csv` | EBIT, Net Income, AR Days, Margin progression |
| **Traffic Analytics** | `traffic_volume_daily.csv` + `dim_date.csv` | Volume trends, Speed, Incidents, Holiday effects |
| **Netflix Content Analytics** | `netflix_content.csv` | Genre ratings, Type & Country breakdown, IMDB insights |

---

## 🛡️ Data & Licensing Notes

- All datasets here are **synthetic/anonymized** for demonstration.  
- They are released under the same **MIT License** as the main repository.  
- Feel free to reuse or adapt them for templates, case studies, or extensions.

---

Let me know if you want a version with embedded sample rows (preview), badges (row counts, last-updated), or links back to your DAX/SQL files.
::contentReference[oaicite:0]{index=0}
