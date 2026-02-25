# 01 Sales Performance Dashboard PowerBI

![Power BI](https://img.shields.io/badge/Tool-PowerBI-yellow)
![SQL](https://img.shields.io/badge/SQL-Advanced-blue)
![Python](https://img.shields.io/badge/Python-Analytics-green)

## 📊 Dashboard Preview
> Insert screenshot here (export from Power BI/Tableau)

---

# Sales Performance Analytics (Power BI)

**Dashboard file:** `Dashboard.pbix`

## Business Problem
Leadership needs a single source of truth for revenue, profitability, and pipeline conversion to diagnose regional variance and allocate quota + headcount effectively.

## Stakeholders
VP of Sales, Regional Directors, Finance (FP&A), RevOps

## Data Model (Star Schema)
- **Fact_Sales** keyed by Date/Region/Channel/Product
- **Dim_Date**, **Dim_Region**, **Dim_Channel**, **Dim_Product**

## KPI Definitions (aligned to dashboard)
- **Total Revenue** = SUM(Revenue)
- **Total Profit** = SUM(Profit)
- **Profit Margin** = Total Profit / Total Revenue
- **Conversion Rate** = Deals Won / Leads
- **Avg Deal Size (Won)** = AVG(Revenue where DealsWon=1)
- **YoY Revenue Growth** = (Revenue CY - Revenue PY) / Revenue PY

## Key Findings (from included dataset)
- **YoY revenue growth:** -85.1% (latest year vs prior year)
- **Top region:** West contributes **36.2%** of total revenue
- **Overall conversion rate:** 6.9%
- **Avg deal size (won):** $1,322

## Recommendations
1. Replicate West playbook in underperforming regions (qualification + enterprise motion).
2. Improve lead scoring and SDR→AE handoff to raise conversion rate (target +3–5 pts).
3. Rebalance quota / capacity to regions with higher profit margin and close rate.

## Contents
- `data/` CSVs (dims + fact) to reproduce the model
- `sql/` DDL + analysis queries
- `python/` KPI validation script
- `docs/` DAX measures + Power Query notes


---

## 💼 Executive Impact
This analysis supports strategic decision-making by identifying revenue drivers, inefficiencies, and optimization opportunities.

**Estimated Business Impact:**
- Revenue uplift potential: +5–15%
- Cost optimization: 5–10%
- Conversion improvements: +3–7%

---

## 🧠 Why This Matters
This project demonstrates the ability to:
- Translate data into business decisions
- Communicate insights to stakeholders
- Build end-to-end BI solutions

---

## 🚀 Recruiter Takeaway
This is not just a dashboard — this is a **decision-making system**.
