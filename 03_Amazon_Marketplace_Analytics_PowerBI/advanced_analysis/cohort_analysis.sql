-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- Original marketplace data has orders, not user signup or seller onboarding events.
-- Genuine signup cohorts cannot be computed. Order-based seller FIRST-SEEN key is only a proxy.
WITH seller_first AS (SELECT seller_key,MIN(date_key) AS first_observed_date_key FROM fact_marketplace_orders GROUP BY seller_key)
SELECT f.first_observed_date_key,COUNT(*) AS sellers,
 SUM(s.gmv) AS full_history_gmv,COUNT(s.seller_key) AS order_rows
FROM seller_first f JOIN fact_marketplace_orders s ON s.seller_key=f.seller_key
GROUP BY f.first_observed_date_key ORDER BY f.first_observed_date_key;
