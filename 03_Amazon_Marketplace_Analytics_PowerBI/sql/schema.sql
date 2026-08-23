CREATE TABLE dim_seller (
 seller_key INTEGER PRIMARY KEY,
 seller VARCHAR(50) NOT NULL,
 tier VARCHAR(20) NOT NULL
);

CREATE TABLE fact_marketplace_orders (
 date_key INTEGER NOT NULL,
 seller_key INTEGER NOT NULL,
 category VARCHAR(50) NOT NULL,
 fulfillment VARCHAR(10) NOT NULL CHECK (fulfillment IN ('FBA','FBM')),
 units INTEGER NOT NULL CHECK (units >= 0),
 item_price DECIMAL(18,2) NOT NULL CHECK (item_price > 0),
 gmv DECIMAL(18,2) NOT NULL CHECK (gmv >= 0),
 rating DECIMAL(3,2) NOT NULL CHECK (rating BETWEEN 1 AND 5),
 cancelled INTEGER NOT NULL CHECK (cancelled IN (0,1)),
 returned INTEGER NOT NULL CHECK (returned IN (0,1)),
 FOREIGN KEY (seller_key) REFERENCES dim_seller(seller_key)
);
