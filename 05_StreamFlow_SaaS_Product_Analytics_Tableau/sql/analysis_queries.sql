-- Active customers and current MRR as of an explicit reporting date
SELECT
    COUNT(*) AS active_customers,
    SUM(price) AS mrr,
    SUM(price) * 12 AS arr_run_rate,
    AVG(price) AS arpu
FROM dim_customer
WHERE signup_date <= :as_of_date
  AND (churn_date IS NULL OR churn_date > :as_of_date);

-- Recorded churn by plan
SELECT plan,
       COUNT(*) AS customers,
       SUM(is_churned) AS churned_customers,
       SUM(is_churned) * 1.0 / COUNT(*) AS recorded_churn_rate,
       SUM(CASE WHEN is_churned=1 THEN price ELSE 0 END) AS churned_mrr
FROM dim_customer
GROUP BY plan
ORDER BY churned_mrr DESC;

-- Monthly engagement
SELECT DATE_TRUNC('month', event_date) AS month,
       COUNT(DISTINCT customer_id) AS mau,
       SUM(sessions) AS sessions,
       SUM(feature_events) AS feature_events,
       SUM(support_tickets) AS support_tickets,
       SUM(sessions) * 1.0 / COUNT(DISTINCT customer_id) AS sessions_per_user
FROM fact_daily_events
GROUP BY DATE_TRUNC('month', event_date)
ORDER BY month;
