# 03 Amazon Marketplace Analytics PowerBI

![Power BI](https://img.shields.io/badge/Tool-PowerBI-yellow)
![SQL](https://img.shields.io/badge/SQL-Advanced-blue)
![Python](https://img.shields.io/badge/Python-Analytics-green)

## 📊 Dashboard Preview
> Insert screenshot here (export from Power BI/Tableau)

---

# Amazon Marketplace Analytics (Power BI)

**Dashboard file:** `Dashboard.pbix`

## Business Problem
Marketplace operations needs visibility into GMV, seller concentration risk, fulfillment performance, and customer experience (ratings/returns).

## KPI Definitions (aligned to dashboard)
- **GMV** = SUM(GMV)
- **Top Seller Concentration (Top 10)** = GMV top 10 sellers / Total GMV
- **FBA GMV Share** = GMV where Fulfillment='FBA' / Total GMV
- **Return Rate** = Returned / Orders
- **Cancellation Rate** = Cancelled / Orders
- **Avg Rating** = AVG(Rating)

## Key Findings (from included dataset)
- **Total GMV:** $11,630,430
- **Top 10 sellers GMV share:** 30.7%
- **FBA GMV share:** 61.9%
- **Cancellation rate:** 2.22%
- **Return rate:** 5.93%
- **Average rating:** 4.30 / 5.0

## Recommendations
1. Reduce concentration risk by accelerating mid-tier seller programs (promotions + tooling).
2. Expand FBA adoption to improve customer experience and reduce cancellations.
3. Target categories with high returns using listing quality audits and sizing/detail improvements.

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
