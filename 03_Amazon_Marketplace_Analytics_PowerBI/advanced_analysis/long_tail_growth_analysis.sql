SELECT ds.tier,COUNT(DISTINCT ds.seller_key) sellers,
SUM(f.gmv) gmv,AVG(f.gmv) avg_row_gmv,
SUM(f.returned)*1.0/COUNT(*) return_rate,
SUM(f.cancelled)*1.0/COUNT(*) cancellation_rate
FROM fact_marketplace_orders f JOIN dim_seller ds ON ds.seller_key=f.seller_key
GROUP BY ds.tier ORDER BY gmv DESC;
