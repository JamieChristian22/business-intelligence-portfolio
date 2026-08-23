SELECT plan,
COUNT(*) customers,
SUM(is_churned) churned,
SUM(is_churned)*1.0/COUNT(*) recorded_churn_rate,
SUM(CASE WHEN is_churned=1 THEN price ELSE 0 END) churned_mrr
FROM dim_customer GROUP BY plan ORDER BY churned_mrr DESC;
