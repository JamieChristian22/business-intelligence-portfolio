# Data Dictionary

## Dim_Customer
| Field | Meaning |
|---|---|
| CustomerID | Unique customer identifier |
| SignupDate | Subscription signup date |
| PlanKey | Foreign key to plan |
| ChurnDate | Churn date when recorded |
| IsChurned | 1 if churned, otherwise 0 |
| Plan | Current plan label |
| Price | Current monthly plan price |

## Dim_Plan
PlanKey, Plan, Price.

## Fact_Daily_Events
| Field | Meaning |
|---|---|
| Date | Event/activity date |
| CustomerID | Customer identifier |
| Sessions | Sessions recorded that day |
| FeatureEvents | Feature interactions recorded that day |
| SupportTickets | Support tickets recorded that day |

## Dim_Date
Derived calendar dimension covering event-tracking dates.
