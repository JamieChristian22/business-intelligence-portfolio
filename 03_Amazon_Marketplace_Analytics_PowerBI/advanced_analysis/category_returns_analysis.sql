SELECT category,SUM(gmv) gmv,COUNT(*) orders,
SUM(returned)*1.0/COUNT(*) return_rate,AVG(rating) avg_rating
FROM fact_marketplace_orders GROUP BY category ORDER BY return_rate DESC;
