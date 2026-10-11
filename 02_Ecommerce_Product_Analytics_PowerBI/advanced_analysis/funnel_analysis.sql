-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- Original source has sessions and orders ONLY; cannot calculate add-to-cart / checkout stages.
SELECT device,traffic_source,SUM(sessions) AS sessions,SUM(orders) AS orders,
 SUM(orders)*1.0/NULLIF(SUM(sessions),0) AS orders_per_session,
 SUM(revenue)*1.0/NULLIF(SUM(orders),0) AS aov
FROM fact_web_analytics GROUP BY device,traffic_source ORDER BY sessions DESC;
