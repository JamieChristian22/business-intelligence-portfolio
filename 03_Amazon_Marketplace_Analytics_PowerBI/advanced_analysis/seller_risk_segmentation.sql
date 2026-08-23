WITH s AS (
SELECT seller_key,SUM(gmv) gmv,COUNT(*) orders,AVG(rating) rating,
SUM(returned)*1.0/COUNT(*) return_rate,
SUM(cancelled)*1.0/COUNT(*) cancellation_rate
FROM fact_marketplace_orders GROUP BY seller_key
)
SELECT *,
CASE
 WHEN gmv >= AVG(gmv) OVER() AND (return_rate >= 0.08 OR rating < 4.0) THEN 'High Priority'
 WHEN return_rate >= 0.08 OR rating < 4.0 THEN 'Monitor'
 ELSE 'Healthy'
END risk_segment
FROM s ORDER BY gmv DESC;
