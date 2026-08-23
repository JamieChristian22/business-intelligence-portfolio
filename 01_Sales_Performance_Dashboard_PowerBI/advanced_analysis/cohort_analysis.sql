SELECT d.year,d.quarter,c.channel,SUM(s.revenue) revenue,SUM(s.profit) profit,
SUM(s.leads) leads,SUM(s.dealswon) deals_won,
SUM(s.dealswon)*1.0/NULLIF(SUM(s.leads),0) conversion_rate
FROM fact_sales s JOIN dim_date d ON d.datekey=s.datekey JOIN dim_channel c ON c.channelkey=s.channelkey
GROUP BY d.year,d.quarter,c.channel ORDER BY d.year,d.quarter,c.channel;
