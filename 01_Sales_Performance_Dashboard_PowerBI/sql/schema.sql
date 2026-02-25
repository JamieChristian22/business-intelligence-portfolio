-- Star schema (PostgreSQL-compatible)
CREATE TABLE dim_date (
  datekey INT PRIMARY KEY,
  date DATE NOT NULL,
  year INT,
  month INT,
  monthname TEXT,
  quarter TEXT
);

CREATE TABLE dim_region (
  regionkey INT PRIMARY KEY,
  region TEXT NOT NULL
);

CREATE TABLE dim_channel (
  channelkey INT PRIMARY KEY,
  channel TEXT NOT NULL
);

CREATE TABLE dim_product (
  productkey INT PRIMARY KEY,
  product TEXT NOT NULL,
  category TEXT
);

CREATE TABLE fact_sales (
  datekey INT REFERENCES dim_date(datekey),
  regionkey INT REFERENCES dim_region(regionkey),
  channelkey INT REFERENCES dim_channel(channelkey),
  productkey INT REFERENCES dim_product(productkey),
  revenue NUMERIC(12,2),
  profit NUMERIC(12,2),
  leads INT,
  dealswon INT
);
