-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- True D30 retention with maturity filter and age-30..36 session activity.
-- PostgreSQL syntax; as_of must be supplied by calling client for a fixed data coverage date.
WITH base AS (
 SELECT c.customer_id,DATE_TRUNC('month',c.signup_date)::date AS signup_cohort,
 MAX(CASE WHEN e.event_date>=c.signup_date+INTERVAL '30 days'
               AND e.event_date<c.signup_date+INTERVAL '37 days' AND e.sessions>0 THEN 1 ELSE 0 END) AS retained_d30
 FROM dim_customer c LEFT JOIN fact_daily_events e ON c.customer_id=e.customer_id
 WHERE c.signup_date<=CAST(:as_of_date AS date)-INTERVAL '36 days'
 GROUP BY c.customer_id,DATE_TRUNC('month',c.signup_date)::date
)
SELECT signup_cohort,COUNT(*) AS eligible_customers,SUM(retained_d30) AS retained_customers,
 AVG(retained_d30*1.0) AS d30_retention
FROM base GROUP BY signup_cohort ORDER BY signup_cohort;
