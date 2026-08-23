SELECT department,account,SUM(actual)-SUM(budget) variance,
(SUM(actual)-SUM(budget))*1.0/NULLIF(SUM(budget),0) variance_pct
FROM fact_budget_actual GROUP BY department,account ORDER BY variance DESC;
