WITH x AS (
SELECT r.region,c.channel,p.product,SUM(s.revenue) revenue,SUM(s.profit) profit,SUM(s.leads) leads,SUM(s.dealswon) deals_won
FROM fact_sales s JOIN dim_region r ON r.regionkey=s.regionkey
JOIN dim_channel c ON c.channelkey=s.channelkey JOIN dim_product p ON p.productkey=s.productkey
GROUP BY r.region,c.channel,p.product)
SELECT *,profit*1.0/NULLIF(revenue,0) margin,deals_won*1.0/NULLIF(leads,0) conversion_rate,
NTILE(4) OVER(ORDER BY revenue DESC) revenue_quartile FROM x ORDER BY revenue DESC;
