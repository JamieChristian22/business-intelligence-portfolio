# 🧮 SQL Queries — Business Intelligence Portfolio

This folder contains reusable **SQL scripts** used for data ingestion, cleaning, modeling, and validation across BI case studies. Each script is designed for reproducibility and aligns with the star schema structure used in Power BI and data warehouse modeling.

---

## 🗂️ Structure

```
02_SQL_Queries/
├─ 00_ddl_create_schemas.sql       # Create database schemas (staging, mart)
├─ 10_stage_load.sql               # Load raw data into staging tables
├─ 20_transform_clean.sql          # Clean and standardize data
├─ 30_model_star.sql               # Build star schema (fact/dim tables)
├─ 40_data_quality_tests.sql       # Validate keys, nulls, and referential integrity
└─ archive/                        # Old or deprecated SQL scripts
```

---

## 🧰 Tools & Environments

- **Database Systems:** PostgreSQL, MySQL, SQLite  
- **Execution:** DBeaver, Azure Data Studio, pgAdmin, VS Code SQL extension  
- **ETL Integration:** Compatible with Power BI, Excel, or Python pipelines  

---

## 📑 Example Snippets

### 🏗️ Create Schemas
```sql
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS mart;
```

### 📥 Load Raw CSV
```sql
\copy staging.stg_sales FROM 'data/raw/sales.csv' WITH (FORMAT csv, HEADER true);
```

### 🧹 Clean Data
```sql
CREATE TABLE IF NOT EXISTS staging.cln_sales AS
SELECT
  trim(sale_id) AS sale_id,
  date(order_date) AS order_date,
  CAST(amount AS NUMERIC(10,2)) AS amount
FROM staging.stg_sales
WHERE sale_id IS NOT NULL;
```

### 🌟 Build Star Schema
```sql
CREATE TABLE mart.dim_customer AS
SELECT DISTINCT customer_id, customer_name, region
FROM staging.cln_customers;

CREATE TABLE mart.fact_sales AS
SELECT s.sale_id, s.order_date, s.amount, c.customer_id
FROM staging.cln_sales s
JOIN mart.dim_customer c USING (customer_id);
```

### ✅ Data Quality Check
```sql
SELECT COUNT(*) FROM mart.fact_sales WHERE amount IS NULL;
SELECT customer_id, COUNT(*) FROM mart.dim_customer GROUP BY 1 HAVING COUNT(*) > 1;
```

---

## 🧭 Versioning

Each script follows a `##_filename.sql` numbering system to maintain execution order.  
Major updates (e.g., new data models) should be version-tagged via Git commits.

---

## 📌 Notes

- Use consistent casing (`snake_case`) for table and column names.  
- Always test `SELECT` statements before `CREATE` or `INSERT`.  
- Keep raw-to-clean transformations documented in the commit message.

---

**Owner:** Jamie Christian  
**Focus:** SQL-first BI data modeling & ETL foundations
