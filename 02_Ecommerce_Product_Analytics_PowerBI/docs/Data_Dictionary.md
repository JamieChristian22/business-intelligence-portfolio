# Data Dictionary

## Fact_Web_Analytics
| Column | Type | Definition |
|---|---|---|
| Date | Date | Observation date |
| Device | Text | Mobile, Desktop, or Tablet |
| TrafficSource | Text | Acquisition source |
| Sessions | Integer | Recorded site sessions |
| Orders | Integer | Completed orders |
| Revenue | Decimal | Gross revenue attributed to the row |
| Returns | Integer | Returned orders/transactions represented in source |
| BounceRate | Decimal | Bounce rate stored from 0 to 1 |

## Dim_Date
Derived from observed dates and includes DateKey, Year, Quarter, Month, MonthName, YearMonth, Weekday, IsWeekend.

## Dim_Device
Derived from observed Device values.

## Dim_TrafficSource
Derived from observed TrafficSource values.

## Dim_ProductCategory
Source/reference table containing Category, BaseAOV, and MarginPct. The current fact data does not contain a product-category key, so it is intentionally not represented as an active relationship.
