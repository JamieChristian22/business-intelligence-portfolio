-- Funnel Conversion Analysis
SELECT
  stage,
  COUNT(DISTINCT user_id) AS users,
  COUNT(DISTINCT user_id) * 1.0 /
    LAG(COUNT(DISTINCT user_id)) OVER (ORDER BY stage) AS conversion_rate
FROM funnel_data
GROUP BY stage
ORDER BY stage;