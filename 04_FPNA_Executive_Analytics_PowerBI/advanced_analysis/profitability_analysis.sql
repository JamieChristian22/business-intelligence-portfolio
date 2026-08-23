SELECT month_start,revenue,cogs,revenue-cogs gross_profit,
(revenue-cogs)*1.0/NULLIF(revenue,0) gross_margin
FROM fact_revenue_cogs ORDER BY month_start;
