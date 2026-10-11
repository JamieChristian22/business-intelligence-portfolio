-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- Seller concentration and cumulative contribution, tie stable via seller_key.
WITH sellers AS (SELECT seller_key,SUM(gmv) AS gmv,COUNT(*) AS orders,
 SUM(returned)*1.0/NULLIF(COUNT(*),0) AS return_rate
 FROM fact_marketplace_orders GROUP BY seller_key)
SELECT seller_key,gmv,orders,return_rate,
 gmv/NULLIF(SUM(gmv) OVER (),0) AS gmv_share,
 SUM(gmv) OVER (ORDER BY gmv DESC,seller_key ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
 /NULLIF(SUM(gmv) OVER (),0) AS cumulative_gmv_share
FROM sellers ORDER BY gmv DESC,seller_key;
