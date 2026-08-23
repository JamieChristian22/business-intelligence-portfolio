# Data Dictionary

## Fact_Marketplace_Orders
| Field | Meaning |
|---|---|
| DateKey | YYYYMMDD date key |
| SellerKey | Seller foreign key |
| Category | Product category |
| Fulfillment | FBA or FBM |
| Units | Units in the transaction row |
| ItemPrice | Unit price |
| GMV | Gross merchandise value |
| Rating | Customer rating from 1 to 5 |
| Cancelled | 1 if cancelled, else 0 |
| Returned | 1 if returned, else 0 |

## Dim_Seller
Seller, Tier, SellerKey. Tier contains Top, Mid, and LongTail segmentation.

## Derived Dimensions
Dim_Date, Dim_Category, and Dim_Fulfillment are deterministically derived from observed source values.
