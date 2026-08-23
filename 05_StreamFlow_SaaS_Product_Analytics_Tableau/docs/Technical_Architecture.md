# Technical Architecture

```text
Dim_Customer + Dim_Plan + Fact_Daily_Events
                    │
                    ▼
          Python / SQL Validation
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
 Activation     Retention    Engagement
        └───────────┼───────────┘
                    ▼
          SaaS KPI Semantic Layer
                    ▼
             Tableau Dashboard
                    ▼
  Product / Growth / Customer Success Decisions
```
