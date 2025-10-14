-- No negative revenue/cost/profit and profit = revenue - cost
SELECT COUNT(*) AS bad_rows
FROM fact_sales
WHERE revenue < 0 OR cost < 0 OR profit <> (revenue - cost);

-- date_key coverage
SELECT COUNT(*) AS missing_date_keys
FROM fact_sales f
LEFT JOIN dim_date d ON d.date_key = f.date_key
WHERE d.date_key IS NULL;