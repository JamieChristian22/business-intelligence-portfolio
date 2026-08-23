# MRR Bridge and NRR Extension

The current source does not contain historical subscription movement events for:
- new MRR
- expansion MRR
- contraction MRR
- reactivation MRR
- churn MRR by accounting month

Therefore NRR and GRR are intentionally not fabricated.

## Production Extension

Add a `Fact_Subscription_MRR_Movements` table:

| Field | Meaning |
|---|---|
| Month | Reporting month |
| CustomerID | Customer |
| BeginningMRR | Opening MRR |
| NewMRR | New logo MRR |
| ExpansionMRR | Upgrade/seat expansion |
| ContractionMRR | Downgrade |
| ChurnMRR | Lost recurring revenue |
| EndingMRR | Closing MRR |

Then calculate:

`GRR = (Beginning MRR - Contraction MRR - Churn MRR) / Beginning MRR`

`NRR = (Beginning MRR + Expansion MRR - Contraction MRR - Churn MRR) / Beginning MRR`
