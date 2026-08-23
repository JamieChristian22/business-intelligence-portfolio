-- Executive budget KPIs
SELECT SUM(budget) budget, SUM(actual) actual,
SUM(actual)-SUM(budget) variance,
(SUM(actual)-SUM(budget))*1.0/NULLIF(SUM(budget),0) variance_pct
FROM fact_budget_actual;

-- Department variance
SELECT department,SUM(budget) budget,SUM(actual) actual,
SUM(actual)-SUM(budget) variance,
(SUM(actual)-SUM(budget))*1.0/NULLIF(SUM(budget),0) variance_pct
FROM fact_budget_actual GROUP BY department ORDER BY variance DESC;

-- Account drivers
SELECT account,SUM(budget) budget,SUM(actual) actual,
SUM(actual)-SUM(budget) variance,
(SUM(actual)-SUM(budget))*1.0/NULLIF(SUM(budget),0) variance_pct
FROM fact_budget_actual GROUP BY account ORDER BY variance DESC;

-- Positive variance exposure
SELECT SUM(CASE WHEN actual > budget THEN actual-budget ELSE 0 END) positive_variance_exposure
FROM fact_budget_actual;

-- Monthly profitability
SELECT r.month_start,r.revenue,r.cogs,
r.revenue-r.cogs gross_profit,
(r.revenue-r.cogs)*1.0/NULLIF(r.revenue,0) gross_margin,
b.actual opex,
r.revenue-r.cogs-b.actual operating_profit
FROM fact_revenue_cogs r
JOIN (
 SELECT month_start,SUM(actual) actual
 FROM fact_budget_actual GROUP BY month_start
) b ON b.month_start=r.month_start
ORDER BY r.month_start;
