SELECT
  DATE_TRUNC('month', CAST(order_date AS DATE)) AS month,
  SUM(revenue)                         AS revenue,
  SUM(cost)                            AS cogs,
  SUM(revenue - cost)                  AS gross_margin,
  CASE WHEN SUM(revenue) = 0 THEN 0
       ELSE SUM(revenue - cost) / SUM(revenue) END AS gross_margin_pct,
  SUM(profit)                          AS profit,
  COUNT(DISTINCT order_id)             AS orders,
  SUM(quantity)                        AS units_sold,
  SUM(revenue) / NULLIF(COUNT(DISTINCT order_id), 0) AS avg_order_value
FROM fact_sales
GROUP BY 1
ORDER BY 1;