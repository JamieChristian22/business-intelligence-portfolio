SELECT c.customer_id,c.plan,c.price,c.is_churned,
SUM(e.sessions) sessions,
SUM(e.feature_events) feature_events,
SUM(e.support_tickets) support_tickets
FROM dim_customer c
JOIN fact_daily_events e ON e.customer_id=c.customer_id
GROUP BY c.customer_id,c.plan,c.price,c.is_churned
ORDER BY support_tickets DESC;
