SELECT
  category,
  product,
  SUM(profit) AS profit,
  SUM(revenue) AS revenue
FROM fact_sales
GROUP BY 1,2
ORDER BY profit DESC
LIMIT 20;