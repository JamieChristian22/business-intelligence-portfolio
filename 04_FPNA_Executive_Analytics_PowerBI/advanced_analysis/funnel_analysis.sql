-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- User conversion funnel does not apply to financial budget datasets.
-- Revenue-to-operating-profit bridge by month (no invented user_activity/funnel_data).
WITH exp AS (SELECT month_start,SUM(actual) AS opex FROM fact_budget_actual GROUP BY month_start)
SELECT r.month_start,r.revenue,r.cogs,(r.revenue-r.cogs) AS gross_profit,
 e.opex,(r.revenue-r.cogs-e.opex) AS operating_profit
FROM fact_revenue_cogs r JOIN exp e ON e.month_start=r.month_start ORDER BY r.month_start;
