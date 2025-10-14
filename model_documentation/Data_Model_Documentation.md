# 📘 Data Model Documentation — Business Intelligence Portfolio

This document describes the core analytical model powering the portfolio: facts, dimensions, keys, granularity, and relationships.

## 🔷 Core Tables

### fact_sales (Fact)
- **Grain:** One row per **order_id**
- **Keys:** `order_id (PK)`, `date_key (FK → dim_date[date_key])`
- **Important Columns:** region, segment, category, product, unit_price, quantity, discount, revenue, cost, profit, customer_id
- **Consumers:** Sales Performance (Power BI), Executive Overview (aggregations)

### dim_date (Dimension)
- **Grain:** One row per **calendar date**
- **Key:** `date_key (PK, YYYYMMDD)`
- **Attributes:** date, year, quarter, month, month_name, day_name, week_of_year, is_weekend, is_holiday_us
- **Usage:** Time intelligence (YTD/MTD/QTD), joins to daily facts and MonthStart on monthly facts

### profitability_by_month (Monthly Fact)
- **Grain:** One row per **month**
- **Key:** `month` (use **MonthStart** for relationship to `dim_date[date]`)
- **Measures:** revenue, cogs, opex, gross_margin, net_income, gross_margin_pct, net_margin_pct
- **Consumers:** Executive Overview dashboard

### financial_performance_monthly (Monthly Fact)
- **Grain:** One row per **month**
- **Key:** `month` (MonthStart)
- **Measures:** revenue, cogs, opex, ebit, net_income, gross/net margin %, AR, inventory, AP, cash
- **Consumers:** Financial Performance dashboard (EBIT, AR Days)

### traffic_volume_daily (Daily Fact)
- **Grain:** date + segment_id
- **Keys:** `date_key (FK → dim_date[date_key])`
- **Measures:** volume, incidents, avg_speed_mph; attributes include weather, temperature_f, precipitation_in
- **Consumers:** Traffic Analytics dashboard (Tableau)

### netflix_content (Content Dimension / Factless)
- **Grain:** Title
- **Keys:** `title_id (PK)`
- **Attributes:** type (Movie/TV), release_year, country, genre, imdb_rating, duration_min OR (seasons, episodes)
- **Consumers:** Netflix Content analytics

### Optional Dimensions (Derivable)
- `dim_product(product_key, category, product)`
- `dim_customer(customer_key, customer_id)`

## 🔗 Relationships
- `fact_sales[date_key]` → `dim_date[date_key]` (many-to-one)
- `traffic_volume_daily[date_key]` → `dim_date[date_key]` (many-to-one)
- `profitability_by_month[MonthStart]` → `dim_date[date]` (many-to-one)
- `financial_performance_monthly[MonthStart]` → `dim_date[date]` (many-to-one)
- Optional: `fact_sales.product` → `dim_product.product` (string match) and `fact_sales.customer_id` → `dim_customer.customer_id`

## 🧮 Measures & Time Intelligence
See **DAX_Measures.md** for Revenue, COGS, Gross Margin %, Net Margin %, AR Days, traffic volume, and Netflix KPIs.
- Mark `dim_date` as the **Date Table**.
- Use `TOTALYTD`, `TOTALMTD`, `SAMEPERIODLASTYEAR` as needed.

## 🧪 Data Quality Checks
- Profit = Revenue − Cost on all rows (no negatives).
- All `fact_*` rows have a valid matching `date_key` in `dim_date`.
- Monthly tables use first-of-month dates for relationship consistency.

## 🗺️ Lineage
1. **Raw CSVs** in `/data` (synthetic)  
2. **SQL / Power Query** transforms & data quality checks in `/02_SQL_Queries/`  
3. **Power BI Model** with DAX measures in `/03_DAX_Measures/`  
4. **Dashboards** in `/04_Dashboards/`  
5. **Case Studies** summarize insights and business recommendations

---

**Files in this folder:**  
- `Data_Model_ERD.png` — overall model diagram  
- `Star_Schema_Sales.png` — detailed sales star schema  
- `Data_Lineage_Diagram.png` — end-to-end flow  
