CREATE TABLE dim_plan (
  plankey INT PRIMARY KEY,
  plan TEXT,
  price INT
);

CREATE TABLE dim_customer (
  customerid TEXT PRIMARY KEY,
  signupdate DATE,
  plankey INT REFERENCES dim_plan(plankey),
  churndate DATE,
  ischurned INT,
  plan TEXT,
  price INT
);

CREATE TABLE fact_daily_events (
  date DATE,
  customerid TEXT REFERENCES dim_customer(customerid),
  sessions INT,
  featureevents INT,
  supporttickets INT
);
