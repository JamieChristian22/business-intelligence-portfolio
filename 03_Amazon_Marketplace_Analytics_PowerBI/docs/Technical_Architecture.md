# Technical Architecture

```text
Marketplace CSV Sources
        ↓
Python/Pandas Validation
        ├── Seller Scorecards
        ├── Concentration Model
        └── KPI Reconciliation
        ↓
Star-Schema Semantic Model
Seller / Date / Category / Fulfillment → Fact Marketplace Orders
        ↓
DAX Measures
        ↓
Power BI Executive + Diagnostic Pages
        ↓
Risk Management + Seller Growth Decisions
```
