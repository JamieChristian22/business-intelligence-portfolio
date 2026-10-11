-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- No CustomerID or signup date in original daily-aggregate ecommerce source: true cohorts not identifiable.
-- Defensible quarterly device TREND; this is NOT retention analysis.
SELECT EXTRACT(YEAR FROM full_date) AS year,EXTRACT(QUARTER FROM full_date) AS quarter,device,
 SUM(sessions) AS sessions,SUM(orders) AS orders,
 SUM(orders)*1.0/NULLIF(SUM(sessions),0) AS conversion_rate,
 SUM(revenue)*1.0/NULLIF(SUM(orders),0) AS aov
FROM fact_web_analytics GROUP BY 1,2,3 ORDER BY 1,2,3;
