-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- Signup -> activation (first week) -> retained at D30, only mature signups.
-- Per-customer flags avoid counting daily events as unique customers.
WITH life AS (SELECT c.customer_id,
 SUM(CASE WHEN e.event_date>=c.signup_date AND e.event_date<c.signup_date+INTERVAL '7 days' THEN COALESCE(e.sessions,0) ELSE 0 END) AS sessions_week1,
 SUM(CASE WHEN e.event_date>=c.signup_date AND e.event_date<c.signup_date+INTERVAL '7 days' THEN COALESCE(e.feature_events,0) ELSE 0 END) AS features_week1,
 MAX(CASE WHEN e.event_date>=c.signup_date+INTERVAL '30 days' AND e.event_date<c.signup_date+INTERVAL '37 days' AND e.sessions>0 THEN 1 ELSE 0 END) AS retained_d30
 FROM dim_customer c LEFT JOIN fact_daily_events e ON c.customer_id=e.customer_id
 WHERE c.signup_date<=CAST(:as_of_date AS date)-INTERVAL '36 days' GROUP BY c.customer_id)
SELECT COUNT(*) AS mature_signups,
 SUM(CASE WHEN sessions_week1>=3 AND features_week1>=5 THEN 1 ELSE 0 END) AS activated,
 SUM(retained_d30) AS retained_d30,
 SUM(CASE WHEN sessions_week1>=3 AND features_week1>=5 AND retained_d30=1 THEN 1 ELSE 0 END) AS activated_and_retained
FROM life;
