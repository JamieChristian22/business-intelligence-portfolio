-- 1. Executive KPI reconciliation
SELECT
    SUM(sessions) AS total_sessions,
    SUM(orders) AS total_orders,
    SUM(revenue) AS total_revenue,
    SUM(returns) AS total_returns,
    SUM(orders) * 1.0 / NULLIF(SUM(sessions),0) AS conversion_rate,
    SUM(revenue) * 1.0 / NULLIF(SUM(orders),0) AS aov,
    SUM(returns) * 1.0 / NULLIF(SUM(orders),0) AS return_rate,
    SUM(revenue) * 1.0 / NULLIF(SUM(sessions),0) AS revenue_per_session,
    SUM(bounce_rate * sessions) * 1.0 / NULLIF(SUM(sessions),0) AS weighted_bounce_rate
FROM fact_web_analytics;

-- 2. Device performance
SELECT device,
       SUM(sessions) AS sessions,
       SUM(orders) AS orders,
       SUM(revenue) AS revenue,
       SUM(orders) * 1.0 / NULLIF(SUM(sessions),0) AS conversion_rate,
       SUM(revenue) * 1.0 / NULLIF(SUM(orders),0) AS aov,
       SUM(returns) * 1.0 / NULLIF(SUM(orders),0) AS return_rate,
       SUM(bounce_rate*sessions) * 1.0 / NULLIF(SUM(sessions),0) AS weighted_bounce_rate
FROM fact_web_analytics
GROUP BY device
ORDER BY revenue DESC;

-- 3. Traffic source quality
SELECT traffic_source,
       SUM(sessions) AS sessions,
       SUM(orders) AS orders,
       SUM(revenue) AS revenue,
       SUM(orders) * 1.0 / NULLIF(SUM(sessions),0) AS conversion_rate,
       SUM(revenue) * 1.0 / NULLIF(SUM(orders),0) AS aov,
       SUM(revenue) * 1.0 / NULLIF(SUM(sessions),0) AS revenue_per_session,
       SUM(bounce_rate*sessions) * 1.0 / NULLIF(SUM(sessions),0) AS weighted_bounce_rate,
       DENSE_RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM fact_web_analytics
GROUP BY traffic_source
ORDER BY revenue DESC;

-- 4. Device × traffic diagnostic
WITH segment AS (
    SELECT device, traffic_source,
           SUM(sessions) sessions,
           SUM(orders) orders,
           SUM(revenue) revenue
    FROM fact_web_analytics
    GROUP BY device, traffic_source
)
SELECT *,
       orders * 1.0 / NULLIF(sessions,0) AS conversion_rate,
       revenue * 1.0 / NULLIF(sessions,0) AS revenue_per_session,
       NTILE(4) OVER (ORDER BY sessions DESC) AS traffic_volume_quartile
FROM segment
ORDER BY sessions DESC;

-- 5. Monthly performance
SELECT DATE_TRUNC('month', full_date) AS month,
       SUM(sessions) sessions,
       SUM(orders) orders,
       SUM(revenue) revenue,
       SUM(orders) * 1.0 / NULLIF(SUM(sessions),0) conversion_rate,
       SUM(revenue) * 1.0 / NULLIF(SUM(orders),0) aov
FROM fact_web_analytics
GROUP BY DATE_TRUNC('month', full_date)
ORDER BY month;

-- 6. Year-over-year revenue
WITH yearly AS (
    SELECT EXTRACT(YEAR FROM full_date) AS year,
           SUM(revenue) AS revenue,
           SUM(orders) AS orders,
           SUM(sessions) AS sessions
    FROM fact_web_analytics
    GROUP BY EXTRACT(YEAR FROM full_date)
)
SELECT year, revenue,
       LAG(revenue) OVER (ORDER BY year) AS prior_revenue,
       (revenue - LAG(revenue) OVER (ORDER BY year))
       / NULLIF(LAG(revenue) OVER (ORDER BY year),0) AS revenue_yoy,
       orders * 1.0 / NULLIF(sessions,0) AS conversion_rate
FROM yearly
ORDER BY year;

-- 7. High-volume, below-average conversion opportunities
WITH base AS (
    SELECT device, traffic_source,
           SUM(sessions) sessions,
           SUM(orders) orders,
           SUM(orders) * 1.0 / NULLIF(SUM(sessions),0) AS conversion_rate
    FROM fact_web_analytics
    GROUP BY device, traffic_source
),
bench AS (
    SELECT AVG(sessions) AS avg_sessions,
           SUM(orders) * 1.0 / NULLIF(SUM(sessions),0) AS overall_conversion
    FROM base
)
SELECT b.*
FROM base b CROSS JOIN bench x
WHERE b.sessions > x.avg_sessions
  AND b.conversion_rate < x.overall_conversion
ORDER BY b.sessions DESC, b.conversion_rate ASC;
