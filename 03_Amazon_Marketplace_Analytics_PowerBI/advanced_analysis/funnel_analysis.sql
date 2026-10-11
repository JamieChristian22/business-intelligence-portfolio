-- Reviewed enterprise upgrade, 2026-10-10.
-- Query uses PostgreSQL syntax unless noted; load original tables as named in sql/schema.sql.
-- No visitor/cart/checkout customer-funnel events in order fact.
-- Valid ORDER QUALITY diagnostic instead; returned/cancelled are mutually exclusive only if contract enforces it.
SELECT fulfillment,COUNT(*) AS orders,SUM(cancelled) AS cancellations,SUM(returned) AS returns,
 SUM(cancelled)*1.0/NULLIF(COUNT(*),0) AS cancellation_rate,
 SUM(returned)*1.0/NULLIF(COUNT(*),0) AS return_rate
FROM fact_marketplace_orders GROUP BY fulfillment;
