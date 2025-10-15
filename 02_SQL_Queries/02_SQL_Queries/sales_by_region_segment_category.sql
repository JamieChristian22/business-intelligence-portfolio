SELECT
  region,
  segment,
  category,
  SUM(revenue) AS revenue,
  SUM(cost)    AS cogs,
  SUM(revenue - cost) AS gross_margin
FROM fact_sales
GROUP BY 1,2,3
ORDER BY revenue DESC;