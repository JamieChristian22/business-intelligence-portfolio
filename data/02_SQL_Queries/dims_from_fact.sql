-- DimProduct
CREATE TABLE IF NOT EXISTS dim_product AS
SELECT
  ROW_NUMBER() OVER () AS product_key,
  category,
  product
FROM (
  SELECT DISTINCT category, product FROM fact_sales
) d;

-- DimCustomer
CREATE TABLE IF NOT EXISTS dim_customer AS
SELECT
  ROW_NUMBER() OVER () AS customer_key,
  customer_id
FROM (
  SELECT DISTINCT customer_id FROM fact_sales
) d;