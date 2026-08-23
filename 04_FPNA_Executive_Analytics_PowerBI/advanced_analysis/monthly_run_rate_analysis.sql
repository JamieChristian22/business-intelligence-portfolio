WITH m AS (
SELECT month_start,SUM(actual) actual FROM fact_budget_actual GROUP BY month_start
)
SELECT month_start,actual,
AVG(actual) OVER(ORDER BY month_start ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) three_month_avg,
AVG(actual) OVER(ORDER BY month_start ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)*12 annualized_run_rate
FROM m ORDER BY month_start;
