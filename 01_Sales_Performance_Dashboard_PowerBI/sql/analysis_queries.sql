-- Regional revenue + share
WITH regional AS (
  SELECT r.region, SUM(s.revenue) AS revenue
  FROM fact_sales s
  JOIN dim_region r ON r.regionkey = s.regionkey
  GROUP BY r.region
),
tot AS (SELECT SUM(revenue) AS total_revenue FROM regional)
SELECT region,
       revenue,
       revenue / (SELECT total_revenue FROM tot) AS revenue_share,
       RANK() OVER (ORDER BY revenue DESC) AS revenue_rank
FROM regional
ORDER BY revenue DESC;

-- YoY growth
WITH yearly AS (
  SELECT d.year, SUM(s.revenue) AS revenue
  FROM fact_sales s
  JOIN dim_date d ON d.datekey = s.datekey
  GROUP BY d.year
)
SELECT year,
       revenue,
       revenue - LAG(revenue) OVER (ORDER BY year) AS yoy_delta,
       (revenue - LAG(revenue) OVER (ORDER BY year)) / NULLIF(LAG(revenue) OVER (ORDER BY year),0) AS yoy_growth
FROM yearly
ORDER BY year;
