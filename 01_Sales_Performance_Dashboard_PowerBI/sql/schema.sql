CREATE TABLE dim_date (datekey INTEGER PRIMARY KEY, date DATE NOT NULL, year INTEGER NOT NULL, month INTEGER NOT NULL, monthname VARCHAR(9) NOT NULL, quarter VARCHAR(2) NOT NULL);
CREATE TABLE dim_region (regionkey INTEGER PRIMARY KEY, region VARCHAR(50) NOT NULL);
CREATE TABLE dim_channel (channelkey INTEGER PRIMARY KEY, channel VARCHAR(50) NOT NULL);
CREATE TABLE dim_product (productkey INTEGER PRIMARY KEY, product VARCHAR(100) NOT NULL);
CREATE TABLE fact_sales (
 datekey INTEGER NOT NULL, regionkey INTEGER NOT NULL, channelkey INTEGER NOT NULL, productkey INTEGER NOT NULL,
 revenue DECIMAL(18,2) NOT NULL CHECK (revenue >= 0), profit DECIMAL(18,2) NOT NULL,
 leads INTEGER NOT NULL CHECK (leads >= 0), dealswon INTEGER NOT NULL CHECK (dealswon >= 0 AND dealswon <= leads),
 FOREIGN KEY(datekey) REFERENCES dim_date(datekey), FOREIGN KEY(regionkey) REFERENCES dim_region(regionkey),
 FOREIGN KEY(channelkey) REFERENCES dim_channel(channelkey), FOREIGN KEY(productkey) REFERENCES dim_product(productkey)
);
