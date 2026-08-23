# Technical Architecture

```text
Fact_Web_Analytics.csv
        │
        ├── Python/Pandas data quality + KPI reconciliation
        │
        ├── SQL analytical layer
        │
        ▼
Derived Dimensions
(Date / Device / Traffic Source)
        │
        ▼
Power BI Semantic Model
        │
        ▼
Governed DAX Measures
        │
        ▼
Executive + Diagnostic Report Pages
        │
        ▼
Insights → Optimization Priorities → Impact Model
```

## Modeling Principle
Only relationships supported by the actual source fields are modeled. Product Category is retained as a reference source but not falsely joined to the web analytics fact table.
