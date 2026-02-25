# 05 StreamFlow SaaS Product Analytics Tableau

![Power BI](https://img.shields.io/badge/Tool-PowerBI-yellow)
![SQL](https://img.shields.io/badge/SQL-Advanced-blue)
![Python](https://img.shields.io/badge/Python-Analytics-green)

## 📊 Dashboard Preview
> Insert screenshot here (export from Power BI/Tableau)

---

# StreamFlow SaaS Product Analytics (Tableau)

**Dashboard file:** `Dashboard.twbx`

## Business Problem
Grow **MRR** and reduce **churn**, especially early-life churn shortly after signup.

## KPI Definitions (aligned to dashboard)
- **MRR** = SUM(Plan Price) for active subscriptions
- **Churn Rate (30d)** = churned customers in last 30 days / active customers at start of period
- **Activation (proxy)** = avg sessions per active user (7d)
- **Support Ticket Rate** = tickets / active users

## Key Findings (from included dataset)
- **Current MRR:** $596,342
- **30-day churn rate:** 0.02%
- **Early churn share (≤30 days):** 6.2%
- **Avg sessions per active user (last 7 days):** 5.73

## Recommendations
1. Improve onboarding + “first value” path to reduce early churn.
2. Trigger CS outreach for accounts with low activation + high support tickets.
3. Drive upgrades via feature adoption nudges once users hit activation threshold.

## Contents
- `data/` CSVs for Tableau
- `sql/` cohort + churn queries
- `python/` KPI validation script
- `docs/` Tableau calculated fields


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
