-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- Weighted bounce avoids averaging ratios across unequal session volumes.
SELECT device,traffic_source,SUM(sessions) AS sessions,SUM(orders) AS orders,
 SUM(revenue) AS revenue,SUM(orders)*1.0/NULLIF(SUM(sessions),0) conversion_rate,
 SUM(bounce_rate*sessions)*1.0/NULLIF(SUM(sessions),0) AS weighted_bounce_rate,
 SUM(revenue)*1.0/NULLIF(SUM(sessions),0) revenue_per_session
FROM fact_web_analytics GROUP BY device,traffic_source ORDER BY revenue DESC;
