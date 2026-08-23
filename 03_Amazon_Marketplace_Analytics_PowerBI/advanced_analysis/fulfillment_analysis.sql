SELECT fulfillment,SUM(gmv) gmv,COUNT(*) orders,AVG(rating) rating,
SUM(returned)*1.0/COUNT(*) return_rate,SUM(cancelled)*1.0/COUNT(*) cancellation_rate
FROM fact_marketplace_orders GROUP BY fulfillment;
