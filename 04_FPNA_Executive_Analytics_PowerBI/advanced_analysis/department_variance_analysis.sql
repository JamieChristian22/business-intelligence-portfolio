SELECT month_start,department,SUM(budget) budget,SUM(actual) actual,
SUM(actual)-SUM(budget) variance
FROM fact_budget_actual GROUP BY month_start,department
ORDER BY department,month_start;
