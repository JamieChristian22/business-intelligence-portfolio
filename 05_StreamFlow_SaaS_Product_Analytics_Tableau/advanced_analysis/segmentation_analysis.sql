-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- Engagement diagnostics (not a predictive ML model).
WITH activity AS (SELECT c.customer_id,c.plan,SUM(COALESCE(e.sessions,0)) AS sessions,
 SUM(COALESCE(e.feature_events,0)) AS features,SUM(COALESCE(e.support_tickets,0)) AS tickets,
 MAX(CASE WHEN e.event_date>=c.signup_date+INTERVAL '30 days' AND e.event_date<c.signup_date+INTERVAL '37 days' AND e.sessions>0 THEN 1 ELSE 0 END) AS d30
 FROM dim_customer c LEFT JOIN fact_daily_events e ON c.customer_id=e.customer_id
 WHERE c.signup_date<=CAST(:as_of_date AS date)-INTERVAL '36 days' GROUP BY c.customer_id,c.plan)
SELECT plan,CASE WHEN sessions>=10 THEN 'High Sessions' ELSE 'Lower Sessions' END AS engagement_tier,
 COUNT(*) AS customers,AVG(d30*1.0) AS d30_retention,AVG(tickets*1.0) AS avg_ticket_count
FROM activity GROUP BY plan,engagement_tier ORDER BY plan,engagement_tier;
