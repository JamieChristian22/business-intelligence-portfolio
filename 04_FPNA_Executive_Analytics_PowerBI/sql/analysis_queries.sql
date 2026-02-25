-- Variance by department
SELECT department,
       SUM(actual) AS actual,
       SUM(budget) AS budget,
       SUM(actual) - SUM(budget) AS variance,
       (SUM(actual) - SUM(budget)) / NULLIF(SUM(budget),0) AS variance_pct
FROM fact_budgetactual
GROUP BY department
ORDER BY variance DESC;

-- Margin trend
SELECT monthstart,
       revenue,
       cogs,
       grossprofit,
       grossmargin
FROM fact_revenuecogs
ORDER BY monthstart;
