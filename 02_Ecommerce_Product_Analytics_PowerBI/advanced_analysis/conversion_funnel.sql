-- Observed funnel supported by source fields: Sessions -> Orders
SELECT device, traffic_source,
       SUM(sessions) AS sessions,
       SUM(orders) AS orders,
       SUM(sessions) - SUM(orders) AS non_converting_sessions,
       SUM(orders) * 1.0 / NULLIF(SUM(sessions),0) AS conversion_rate
FROM fact_web_analytics
GROUP BY device, traffic_source
ORDER BY conversion_rate ASC;
