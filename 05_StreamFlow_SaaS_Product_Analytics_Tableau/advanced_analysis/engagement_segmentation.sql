WITH last30 AS (
    SELECT customer_id,
           SUM(sessions) sessions_30,
           SUM(feature_events) feature_events_30,
           SUM(support_tickets) support_tickets_30,
           COUNT(DISTINCT event_date) active_days_30
    FROM fact_daily_events
    WHERE event_date > (SELECT MAX(event_date) FROM fact_daily_events) - INTERVAL '30 day'
    GROUP BY customer_id
)
SELECT *,
       CASE
         WHEN sessions_30 >= PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sessions_30) OVER ()
          AND feature_events_30 >= PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY feature_events_30) OVER ()
         THEN 'Power User'
         WHEN active_days_30 <= PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY active_days_30) OVER ()
         THEN 'At Risk'
         ELSE 'Healthy'
       END AS engagement_segment
FROM last30;
