CREATE TABLE dim_date (
    date_key INTEGER PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    year INTEGER NOT NULL,
    quarter VARCHAR(2) NOT NULL,
    month INTEGER NOT NULL,
    month_name VARCHAR(12) NOT NULL,
    year_month VARCHAR(7) NOT NULL
);

CREATE TABLE dim_device (
    device_key INTEGER PRIMARY KEY,
    device VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE dim_traffic_source (
    traffic_source_key INTEGER PRIMARY KEY,
    traffic_source VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE fact_web_analytics (
    full_date DATE NOT NULL,
    device VARCHAR(20) NOT NULL,
    traffic_source VARCHAR(50) NOT NULL,
    sessions INTEGER NOT NULL CHECK (sessions >= 0),
    orders INTEGER NOT NULL CHECK (orders >= 0),
    revenue DECIMAL(18,2) NOT NULL CHECK (revenue >= 0),
    returns INTEGER NOT NULL CHECK (returns >= 0),
    bounce_rate DECIMAL(8,5) NOT NULL CHECK (bounce_rate BETWEEN 0 AND 1),
    CHECK (orders <= sessions),
    CHECK (returns <= orders)
);
