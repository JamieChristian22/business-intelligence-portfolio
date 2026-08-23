SELECT r.region,c.channel,SUM(s.leads) leads,SUM(s.dealswon) deals_won,
SUM(s.leads)-SUM(s.dealswon) unconverted_leads,
SUM(s.dealswon)*1.0/NULLIF(SUM(s.leads),0) conversion_rate
FROM fact_sales s JOIN dim_region r ON r.regionkey=s.regionkey
JOIN dim_channel c ON c.channelkey=s.channelkey
GROUP BY r.region,c.channel ORDER BY conversion_rate;
