-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- Distinguish gross over-spend from net variance; row-level accounting grain matters.
SELECT department,SUM(budget) AS budget,SUM(actual) AS actual,
 SUM(actual-budget) AS net_signed_variance,
 SUM(CASE WHEN actual>budget THEN actual-budget ELSE 0 END) AS gross_unfavorable_variance,
 SUM(CASE WHEN actual<budget THEN budget-actual ELSE 0 END) AS gross_favorable_variance
FROM fact_budget_actual GROUP BY department ORDER BY gross_unfavorable_variance DESC;
