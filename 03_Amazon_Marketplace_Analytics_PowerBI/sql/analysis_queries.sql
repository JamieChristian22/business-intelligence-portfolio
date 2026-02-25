-- Top seller concentration
WITH seller_gmv AS (
  SELECT s.seller, SUM(o.gmv) AS gmv
  FROM fact_marketplace_orders o
  JOIN dim_seller s ON s.sellerkey = o.sellerkey
  GROUP BY s.seller
),
tot AS (SELECT SUM(gmv) AS total_gmv FROM seller_gmv),
top10 AS (SELECT SUM(gmv) AS top10_gmv FROM (SELECT gmv FROM seller_gmv ORDER BY gmv DESC LIMIT 10) t)
SELECT (SELECT top10_gmv FROM top10) / (SELECT total_gmv FROM tot) AS top10_share;

-- Fulfillment performance
SELECT fulfillment,
       SUM(gmv) AS gmv,
       AVG(cancelled) AS cancel_rate,
       AVG(returned) AS return_rate,
       AVG(rating) AS avg_rating
FROM fact_marketplace_orders
GROUP BY fulfillment
ORDER BY gmv DESC;
