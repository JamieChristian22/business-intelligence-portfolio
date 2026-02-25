-- Customer Segmentation (High vs Low Value)
SELECT
  CASE
    WHEN total_spent > 1000 THEN 'High Value'
    WHEN total_spent > 500 THEN 'Mid Value'
    ELSE 'Low Value'
  END AS segment,
  COUNT(*) AS customers,
  AVG(total_spent) AS avg_spent
FROM customers
GROUP BY segment;