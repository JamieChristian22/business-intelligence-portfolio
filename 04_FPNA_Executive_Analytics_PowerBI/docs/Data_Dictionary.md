# Data Dictionary

## Fact_BudgetActual
| Column | Meaning |
|---|---|
| MonthStart | Month period |
| Department | Operating department |
| Account | Expense account |
| Budget | Planned expense |
| Actual | Actual expense |
| Variance | Actual minus Budget |
| VariancePct | Variance divided by Budget |

## Fact_RevenueCOGS
Monthly revenue and cost of goods sold used for gross profit and margin analysis.

## Derived Dimensions
Dim_Date, Dim_Department, Dim_Account are created directly from observed source values.
