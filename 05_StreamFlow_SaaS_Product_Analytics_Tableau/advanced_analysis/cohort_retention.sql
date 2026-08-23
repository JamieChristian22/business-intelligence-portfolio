WITH base AS (
    SELECT c.customer_id,
           DATE_TRUNC('month', c.signup_date) AS signup_cohort,
           MAX(CASE WHEN e.event_date BETWEEN c.signup_date + INTERVAL '30 day'
                                         AND c.signup_date + INTERVAL '36 day' THEN 1 ELSE 0 END) AS d30_retained
    FROM dim_customer c
    LEFT JOIN fact_daily_events e ON e.customer_id=c.customer_id
    GROUP BY c.customer_id, DATE_TRUNC('month', c.signup_date)
)
SELECT signup_cohort, COUNT(*) cohort_size, AVG(d30_retained*1.0) d30_retention
FROM base GROUP BY signup_cohort ORDER BY signup_cohort;
