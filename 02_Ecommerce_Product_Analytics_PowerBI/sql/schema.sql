CREATE TABLE fact_web_analytics (
  date DATE,
  device TEXT,
  trafficsource TEXT,
  sessions INT,
  orders INT,
  revenue NUMERIC(12,2),
  returns INT,
  bouncerate NUMERIC(6,3)
);

CREATE TABLE dim_productcategory (
  category TEXT PRIMARY KEY,
  baseaov NUMERIC(10,2),
  marginpct NUMERIC(6,3)
);
