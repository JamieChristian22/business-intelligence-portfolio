# Technical Architecture

```text
Fact_BudgetActual.csv      Fact_RevenueCOGS.csv
         │                         │
         └──────────┬──────────────┘
                    ↓
            Python / SQL Validation
                    ↓
         Date / Department / Account
                    ↓
            Power BI Semantic Model
                    ↓
              Governed DAX KPIs
                    ↓
 Executive FP&A Dashboard + Run-Rate Forecast
                    ↓
     Variance Actions + Cost Scenarios
```
