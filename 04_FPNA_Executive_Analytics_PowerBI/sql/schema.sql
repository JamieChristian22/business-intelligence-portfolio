CREATE TABLE fact_budgetactual (
  monthstart DATE,
  department TEXT,
  account TEXT,
  budget NUMERIC(14,2),
  actual NUMERIC(14,2),
  variance NUMERIC(14,2),
  variancepct NUMERIC(8,4)
);

CREATE TABLE fact_revenuecogs (
  monthstart DATE PRIMARY KEY,
  revenue NUMERIC(14,2),
  cogs NUMERIC(14,2),
  grossprofit NUMERIC(14,2),
  grossmargin NUMERIC(8,4)
);
