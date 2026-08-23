# Technical Architecture

```text
CSV Sources
   ↓
Python/Pandas Quality Validation ──→ SQL Analytical Layer
   ↓                                  ↓
Power BI Star Schema / Semantic Model
   ↓
DAX Measures
   ↓
Executive Dashboard
   ↓
Insights → Recommendations → Scenario Model
```

Principles: star schema, governed measures, independent reconciliation, explicit assumptions, reproducible analysis.
