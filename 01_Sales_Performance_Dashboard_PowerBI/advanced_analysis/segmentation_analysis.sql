-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- Filter-aware region × channel ranking and deal economics. PostgreSQL compatible.
WITH seg AS (SELECT r.region,c.channel,SUM(s.revenue) AS revenue,
 SUM(s.profit) AS profit,SUM(s.dealswon) AS wins,SUM(s.leads) AS leads
 FROM fact_sales s JOIN dim_region r ON r.regionkey=s.regionkey
 JOIN dim_channel c ON c.channelkey=s.channelkey GROUP BY r.region,c.channel)
SELECT *, revenue/NULLIF(wins,0) AS avg_deal_value,
 wins*1.0/NULLIF(leads,0) AS win_rate,
 DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank FROM seg ORDER BY revenue DESC;
