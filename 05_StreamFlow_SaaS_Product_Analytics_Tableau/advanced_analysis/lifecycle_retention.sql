SELECT
    c.customer_id,
    MAX(CASE WHEN e.event_date BETWEEN c.signup_date + INTERVAL '7 day'
                                  AND c.signup_date + INTERVAL '13 day' THEN 1 ELSE 0 END) AS d7_retained,
    MAX(CASE WHEN e.event_date BETWEEN c.signup_date + INTERVAL '30 day'
                                  AND c.signup_date + INTERVAL '36 day' THEN 1 ELSE 0 END) AS d30_retained,
    MAX(CASE WHEN e.event_date BETWEEN c.signup_date + INTERVAL '60 day'
                                  AND c.signup_date + INTERVAL '66 day' THEN 1 ELSE 0 END) AS d60_retained,
    MAX(CASE WHEN e.event_date BETWEEN c.signup_date + INTERVAL '90 day'
                                  AND c.signup_date + INTERVAL '96 day' THEN 1 ELSE 0 END) AS d90_retained
FROM dim_customer c
LEFT JOIN fact_daily_events e ON e.customer_id=c.customer_id
GROUP BY c.customer_id;
