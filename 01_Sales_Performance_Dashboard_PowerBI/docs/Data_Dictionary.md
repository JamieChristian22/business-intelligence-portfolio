# Data Dictionary

## Fact_Sales
| Field | Type | Meaning |
|---|---|---|
| DateKey | Integer | Foreign key to Dim_Date |
| RegionKey | Integer | Foreign key to Dim_Region |
| ChannelKey | Integer | Foreign key to Dim_Channel |
| ProductKey | Integer | Foreign key to Dim_Product |
| Revenue | Decimal | Revenue attributed to the row |
| Profit | Decimal | Profit attributed to the row |
| Leads | Integer | Lead volume |
| DealsWon | Integer | Won deals |

## Dimensions
- **Dim_Date:** Date, Year, Month, MonthName, Quarter, DateKey
- **Dim_Region:** RegionKey, Region
- **Dim_Channel:** ChannelKey, Channel
- **Dim_Product:** ProductKey, Product
