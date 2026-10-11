-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- NO TRUE COHORT: the supplied sales fact has no LeadID/customer acquisition date.
-- Defensible alternative: quarterly channel performance, not retention.
SELECT d.year,d.quarter,c.channel,SUM(s.leads) AS leads,SUM(s.dealswon) AS wins,
 SUM(s.revenue) AS revenue,SUM(s.dealswon)*1.0/NULLIF(SUM(s.leads),0) AS win_rate
FROM fact_sales s JOIN dim_date d ON d.datekey=s.datekey
 JOIN dim_channel c ON c.channelkey=s.channelkey
GROUP BY d.year,d.quarter,c.channel ORDER BY d.year,d.quarter,c.channel;
