WITH monthly AS (
  SELECT
    DATE_TRUNC('month', CAST(order_date AS DATE)) AS month,
    SUM(revenue) AS revenue,
    SUM(cost)    AS cogs
  FROM fact_sales
  GROUP BY 1
)
SELECT
  m.month,
  m.revenue,
  m.cogs,
  (m.revenue * 0.20)                      AS opex,
  (m.revenue - m.cogs)                    AS gross_margin,
  (m.revenue - m.cogs) - (m.revenue*0.20) AS net_income,
  CASE WHEN m.revenue=0 THEN 0 ELSE (m.revenue - m.cogs)/m.revenue END AS gross_margin_pct,
  CASE WHEN m.revenue=0 THEN 0 ELSE ((m.revenue - m.cogs) - (m.revenue*0.20))/m.revenue END AS net_margin_pct
FROM monthly m
ORDER BY 1;