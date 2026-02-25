import pandas as pd
orders = pd.read_csv("../data/Fact_Marketplace_Orders.csv")
sellers = pd.read_csv("../data/Dim_Seller.csv")
df = orders.merge(sellers[["SellerKey","Seller","Tier"]], on="SellerKey", how="left")

gmv_total = df["GMV"].sum()
seller_gmv = df.groupby("Seller")["GMV"].sum().sort_values(ascending=False)
top10_share = seller_gmv.head(10).sum()/gmv_total

fba_share = df.loc[df["Fulfillment"]=="FBA","GMV"].sum()/gmv_total
cancel_rate = df["Cancelled"].mean()
return_rate = df["Returned"].mean()
avg_rating = df["Rating"].mean()

print("GMV:", round(gmv_total,2))
print("Top10 share:", round(top10_share,4))
print("FBA share:", round(fba_share,4))
print("Cancel rate:", round(cancel_rate,4))
print("Return rate:", round(return_rate,4))
print("Avg rating:", round(avg_rating,2))
