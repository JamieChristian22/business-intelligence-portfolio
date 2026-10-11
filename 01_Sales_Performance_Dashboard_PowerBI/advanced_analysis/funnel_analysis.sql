-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- Valid aggregate stage ratio only. Without distinct LeadID, there is no person-level conversion path.
SELECT c.channel,SUM(s.leads) AS leads,SUM(s.dealswon) AS won_deals,
 SUM(s.dealswon)*1.0/NULLIF(SUM(s.leads),0) AS aggregate_win_rate
FROM fact_sales s JOIN dim_channel c ON c.channelkey=s.channelkey
GROUP BY c.channel ORDER BY aggregate_win_rate DESC;
