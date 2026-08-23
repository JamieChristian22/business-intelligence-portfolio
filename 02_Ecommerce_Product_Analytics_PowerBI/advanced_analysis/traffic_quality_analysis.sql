SELECT traffic_source,
       SUM(sessions) sessions,
       SUM(orders) orders,
       SUM(revenue) revenue,
       SUM(revenue) * 1.0 / NULLIF(SUM(sessions),0) revenue_per_session,
       SUM(orders) * 1.0 / NULLIF(SUM(sessions),0) conversion_rate,
       SUM(revenue) * 1.0 / NULLIF(SUM(orders),0) aov,
       SUM(returns) * 1.0 / NULLIF(SUM(orders),0) return_rate,
       SUM(bounce_rate*sessions) * 1.0 / NULLIF(SUM(sessions),0) weighted_bounce_rate
FROM fact_web_analytics
GROUP BY traffic_source
ORDER BY revenue_per_session DESC;
