SELECT
  month,
  revenue,
  cogs,
  opex,
  ebit,
  net_income,
  (revenue - cogs) / NULLIF(revenue,0) AS gross_margin_pct,
  net_income / NULLIF(revenue,0)       AS net_margin_pct,
  accounts_receivable,
  accounts_receivable / NULLIF(revenue/30.0, 0) AS ar_days
FROM financial_performance_monthly
ORDER BY month;