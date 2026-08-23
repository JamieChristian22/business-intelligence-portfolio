-- Executive KPI reconciliation
SELECT SUM(gmv) gmv, COUNT(*) orders, SUM(units) units,
SUM(returned)*1.0/COUNT(*) return_rate,
SUM(cancelled)*1.0/COUNT(*) cancellation_rate,
SUM(gmv)*1.0/COUNT(*) avg_order_gmv
FROM fact_marketplace_orders;

-- Seller ranking and cumulative GMV share
WITH s AS (
 SELECT seller_key, SUM(gmv) gmv, COUNT(*) orders,
 SUM(returned) returns, SUM(cancelled) cancellations, AVG(rating) avg_rating
 FROM fact_marketplace_orders GROUP BY seller_key
)
SELECT s.*,
 gmv*1.0/SUM(gmv) OVER() gmv_share,
 DENSE_RANK() OVER(ORDER BY gmv DESC) gmv_rank,
 SUM(gmv) OVER(ORDER BY gmv DESC ROWS UNBOUNDED PRECEDING)
 / SUM(gmv) OVER() cumulative_gmv_share
FROM s ORDER BY gmv DESC;

-- Seller tier performance
SELECT ds.tier, SUM(f.gmv) gmv, COUNT(*) orders, SUM(f.units) units,
SUM(f.returned)*1.0/COUNT(*) return_rate,
SUM(f.cancelled)*1.0/COUNT(*) cancellation_rate,
AVG(f.rating) avg_rating
FROM fact_marketplace_orders f JOIN dim_seller ds ON ds.seller_key=f.seller_key
GROUP BY ds.tier ORDER BY gmv DESC;

-- Fulfillment comparison
SELECT fulfillment, SUM(gmv) gmv, COUNT(*) orders, SUM(units) units,
SUM(returned)*1.0/COUNT(*) return_rate,
SUM(cancelled)*1.0/COUNT(*) cancellation_rate,
AVG(rating) avg_rating
FROM fact_marketplace_orders GROUP BY fulfillment ORDER BY gmv DESC;

-- Category health
SELECT category, SUM(gmv) gmv, COUNT(*) orders, SUM(units) units,
SUM(returned)*1.0/COUNT(*) return_rate,
SUM(cancelled)*1.0/COUNT(*) cancellation_rate,
AVG(rating) avg_rating
FROM fact_marketplace_orders GROUP BY category ORDER BY gmv DESC;
