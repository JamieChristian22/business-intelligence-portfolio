-- Device conversion
SELECT device,
       SUM(orders)::NUMERIC / NULLIF(SUM(sessions),0) AS conversion_rate,
       SUM(revenue)::NUMERIC / NULLIF(SUM(orders),0)  AS aov
FROM fact_web_analytics
GROUP BY device
ORDER BY conversion_rate DESC;

-- Traffic source performance
SELECT trafficsource,
       SUM(revenue) AS revenue,
       SUM(orders)::NUMERIC / NULLIF(SUM(sessions),0) AS conversion_rate,
       SUM(revenue)::NUMERIC / NULLIF(SUM(orders),0)  AS aov
FROM fact_web_analytics
GROUP BY trafficsource
ORDER BY revenue DESC;
