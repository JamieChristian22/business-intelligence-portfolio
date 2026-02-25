-- Current MRR (active subscriptions)
SELECT SUM(price) AS mrr
FROM dim_customer
WHERE signupdate <= CURRENT_DATE
  AND (churndate IS NULL OR churndate > CURRENT_DATE);

-- 30-day churn rate
WITH active_start AS (
  SELECT COUNT(*) AS active_cnt
  FROM dim_customer
  WHERE signupdate <= (CURRENT_DATE - INTERVAL '30 day')
    AND (churndate IS NULL OR churndate > (CURRENT_DATE - INTERVAL '30 day'))
),
churned AS (
  SELECT COUNT(*) AS churn_cnt
  FROM dim_customer
  WHERE churndate > (CURRENT_DATE - INTERVAL '30 day')
    AND churndate <= CURRENT_DATE
)
SELECT churn_cnt::NUMERIC / NULLIF(active_cnt,0) AS churn_rate_30d
FROM active_start, churned;

-- Cohort churn by signup month
WITH cohorts AS (
  SELECT DATE_TRUNC('month', signupdate) AS cohort_month,
         customerid,
         churndate
  FROM dim_customer
),
cohort_stats AS (
  SELECT cohort_month,
         COUNT(*) AS cohort_size,
         SUM(CASE WHEN churndate IS NOT NULL THEN 1 ELSE 0 END) AS churned
  FROM cohorts
  GROUP BY cohort_month
)
SELECT cohort_month,
       cohort_size,
       churned,
       churned::NUMERIC / NULLIF(cohort_size,0) AS cohort_churn_rate
FROM cohort_stats
ORDER BY cohort_month;
