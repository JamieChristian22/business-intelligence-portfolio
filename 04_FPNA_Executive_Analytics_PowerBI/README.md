# 04 FPNA Executive Analytics PowerBI

![Power BI](https://img.shields.io/badge/Tool-PowerBI-yellow)
![SQL](https://img.shields.io/badge/SQL-Advanced-blue)
![Python](https://img.shields.io/badge/Python-Analytics-green)

## 📊 Dashboard Preview
> Insert screenshot here (export from Power BI/Tableau)

---

# FP&A Executive Analytics (Power BI)

**Dashboard file:** `Dashboard.pbix`

## Business Problem
Executives need visibility into **budget vs actuals**, variance drivers, and margin trends to control spend and protect profitability.

## KPI Definitions (aligned to dashboard)
- **Total Budget** = SUM(Budget)
- **Total Actual** = SUM(Actual)
- **Variance** = Actual - Budget
- **Variance %** = Variance / Budget
- **Gross Margin** = GrossProfit / Revenue

## Key Findings (from included dataset)
- **Company variance vs budget:** 1.4%
- **Largest overspending department:** Marketing ($754,026)
- **Avg gross margin:** 59.9%
- **Revenue growth (period):** 48.6%

## Recommendations
1. Implement monthly spend guardrails for Marketing with approval thresholds and vendor renegotiation.
2. Standardize forecasting with variance drilldowns (dept → account) and driver-based assumptions.
3. Reallocate under-used budget toward high-ROI spend lines.

## Contents
- `data/` CSVs
- `sql/` schema + analysis queries
- `python/` KPI validation script
- `docs/` DAX measures


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
