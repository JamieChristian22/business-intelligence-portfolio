CREATE TABLE dim_seller (
  sellerkey INT PRIMARY KEY,
  seller TEXT,
  tier TEXT
);

CREATE TABLE fact_marketplace_orders (
  datekey INT,
  sellerkey INT REFERENCES dim_seller(sellerkey),
  category TEXT,
  fulfillment TEXT,
  units INT,
  itemprice NUMERIC(10,2),
  gmv NUMERIC(12,2),
  rating NUMERIC(4,2),
  cancelled INT,
  returned INT
);
