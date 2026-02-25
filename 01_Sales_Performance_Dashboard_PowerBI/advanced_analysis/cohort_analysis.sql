-- Cohort Retention Analysis
SELECT
  DATE_TRUNC('month', signup_date) AS cohort_month,
  DATE_TRUNC('month', activity_date) AS activity_month,
  COUNT(DISTINCT user_id) AS active_users
FROM user_activity
GROUP BY cohort_month, activity_month
ORDER BY cohort_month, activity_month;