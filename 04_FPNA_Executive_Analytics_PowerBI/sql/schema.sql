CREATE TABLE fact_budget_actual (
 month_start DATE NOT NULL,
 department VARCHAR(50) NOT NULL,
 account VARCHAR(50) NOT NULL,
 budget DECIMAL(18,2) NOT NULL CHECK (budget >= 0),
 actual DECIMAL(18,2) NOT NULL CHECK (actual >= 0),
 variance DECIMAL(18,2) NOT NULL,
 variance_pct DECIMAL(12,6)
);

CREATE TABLE fact_revenue_cogs (
 month_start DATE NOT NULL,
 revenue DECIMAL(18,2) NOT NULL CHECK (revenue >= 0),
 cogs DECIMAL(18,2) NOT NULL CHECK (cogs >= 0)
);
