-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- FP&A data has financial accounts/departments, not customers: no user cohort can be inferred.
-- Use department-by-month variance TREND to answer the finance question.
SELECT month_start,department,SUM(budget) AS budget,SUM(actual) AS actual,
 SUM(actual-budget) AS signed_variance,
 SUM(actual-budget)*1.0/NULLIF(SUM(budget),0) AS variance_pct
FROM fact_budget_actual GROUP BY month_start,department ORDER BY month_start,department;
