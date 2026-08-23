WITH segments AS (
    SELECT device, traffic_source,
           SUM(sessions) sessions,
           SUM(orders) orders,
           SUM(revenue) revenue,
           SUM(returns) returns
    FROM fact_web_analytics
    GROUP BY device, traffic_source
)
SELECT *,
       orders * 1.0 / NULLIF(sessions,0) conversion_rate,
       revenue * 1.0 / NULLIF(orders,0) aov,
       revenue * 1.0 / NULLIF(sessions,0) revenue_per_session,
       returns * 1.0 / NULLIF(orders,0) return_rate,
       NTILE(4) OVER (ORDER BY revenue DESC) revenue_quartile
FROM segments
ORDER BY revenue DESC;
