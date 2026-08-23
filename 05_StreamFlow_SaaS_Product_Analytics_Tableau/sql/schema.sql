CREATE TABLE dim_plan (
    plan_key INTEGER PRIMARY KEY,
    plan VARCHAR(50) NOT NULL,
    price DECIMAL(12,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE dim_customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    signup_date DATE NOT NULL,
    plan_key INTEGER NOT NULL,
    churn_date DATE,
    is_churned INTEGER NOT NULL CHECK (is_churned IN (0,1)),
    plan VARCHAR(50) NOT NULL,
    price DECIMAL(12,2) NOT NULL CHECK (price >= 0),
    FOREIGN KEY (plan_key) REFERENCES dim_plan(plan_key)
);

CREATE TABLE fact_daily_events (
    event_date DATE NOT NULL,
    customer_id VARCHAR(20) NOT NULL,
    sessions INTEGER NOT NULL CHECK (sessions >= 0),
    feature_events INTEGER NOT NULL CHECK (feature_events >= 0),
    support_tickets INTEGER NOT NULL CHECK (support_tickets >= 0),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id)
);
