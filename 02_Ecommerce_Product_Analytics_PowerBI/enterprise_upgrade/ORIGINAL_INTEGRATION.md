# Ecommerce Product Analytics: original-model SQL/ETL integration

**Original source snapshot:** 18,073 rows in `ec_orders`. **Decision:** Order-attributed payments, product cost and properly qualified funnels.

This addendum documents the actual uploaded BI model. The earlier CASE_STUDY.md describes the separately generated enterprise demonstration and its scenario analyses.

## End-to-end evidence

1. The [native dashboard](../dashboard/Dashboard.pbix) is preserved byte for byte. Its identity and decoded model metadata are in [the workbook manifest](../../enterprise_platform/evidence/workbooks/manifest.json).
2. Reconstructed original snapshots are in `enterprise_platform/data/original/`. Contracts enforce the actual available fields and table grains.
3. The [integrated SQL](../../enterprise_platform/integration/marts.sql) includes `mart_ecommerce_monthly` and related diagnostic views. It runs from the actual original-model tables.
4. Source/warehouse counts and KPI totals reconcile in [the validation report](../../enterprise_platform/evidence/VALIDATION_REPORT.md). Negative mutations, rollback and policy checks are in [the executed test suite](../../enterprise_platform/evidence/automated_tests.json).
5. Portable outputs use original BI field names. The [native handoff](../../enterprise_platform/integration/bi/README.md) provides Power Query, DAX and relationship repair assets. Native expected-value cases remain pending until run in the BI engine.

## Original-model finding and implementation

Original Date has no relationships. Original orders/payment 1:1 path is replaced by a validated payment join in M, with revenue on orders and single-direction dimension filters.

## Business interpretation

Report only metrics supported by the original schema. A stakeholder can trace every field through FIELD_LINEAGE.csv, inspect the query and reproduce the aggregate. Treat analyses as observations on simulated historical data. Do not claim realized savings, causal conversion uplift, client deployment, production security or a refreshed native report.

## Interview walkthrough

Explain the source grain first. Show one source-to-target mapping and the relevant SQL join/aggregation. Identify how a bad input is rejected and how a failed refresh leaves the prior release intact. Close with the remaining native acceptance gate and why the metric definition matters to the decision.
