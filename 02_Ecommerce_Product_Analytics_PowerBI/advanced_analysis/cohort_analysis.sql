SELECT
    EXTRACT(YEAR FROM full_date) AS year,
    EXTRACT(QUARTER FROM full_date) AS quarter,
    device,
    SUM(sessions) sessions,
    SUM(orders) orders,
    SUM(revenue) revenue,
    SUM(orders) * 1.0 / NULLIF(SUM(sessions),0) conversion_rate,
    SUM(revenue) * 1.0 / NULLIF(SUM(orders),0) aov
FROM fact_web_analytics
GROUP BY EXTRACT(YEAR FROM full_date), EXTRACT(QUARTER FROM full_date), device
ORDER BY year, quarter, device;
