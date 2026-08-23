WITH s AS (
SELECT seller_key,SUM(gmv) gmv FROM fact_marketplace_orders GROUP BY seller_key
)
SELECT seller_key,gmv,
gmv*1.0/SUM(gmv) OVER() gmv_share,
SUM(gmv) OVER(ORDER BY gmv DESC ROWS UNBOUNDED PRECEDING)/SUM(gmv) OVER() cumulative_share
FROM s ORDER BY gmv DESC;
