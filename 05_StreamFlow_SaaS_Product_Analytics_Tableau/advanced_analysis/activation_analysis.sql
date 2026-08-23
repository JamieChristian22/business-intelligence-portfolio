WITH first7 AS (
    SELECT c.customer_id,
           c.plan,
           SUM(CASE WHEN e.event_date BETWEEN c.signup_date AND c.signup_date + INTERVAL '6 day'
                    THEN e.sessions ELSE 0 END) AS first7_sessions,
           SUM(CASE WHEN e.event_date BETWEEN c.signup_date AND c.signup_date + INTERVAL '6 day'
                    THEN e.feature_events ELSE 0 END) AS first7_feature_events
    FROM dim_customer c
    LEFT JOIN fact_daily_events e ON e.customer_id=c.customer_id
    GROUP BY c.customer_id,c.plan
)
SELECT plan,
       COUNT(*) AS eligible_customers,
       SUM(CASE WHEN first7_sessions >= 3 AND first7_feature_events >= 5 THEN 1 ELSE 0 END) AS activated,
       AVG(CASE WHEN first7_sessions >= 3 AND first7_feature_events >= 5 THEN 1.0 ELSE 0.0 END) AS activation_rate
FROM first7
GROUP BY plan;
