import pandas as pd

fact = pd.read_csv("../data/Fact_Sales.csv")
dim_date = pd.read_csv("../data/Dim_Date.csv")
dim_region = pd.read_csv("../data/Dim_Region.csv")

df = fact.merge(dim_date[["DateKey","Year"]], on="DateKey", how="left").merge(dim_region, on="RegionKey", how="left")

total_revenue = df["Revenue"].sum()
total_profit = df["Profit"].sum()
profit_margin = total_profit / total_revenue

conversion = df["DealsWon"].sum() / df["Leads"].sum()
avg_deal_won = df.loc[df["DealsWon"]==1, "Revenue"].mean()

rev_by_year = df.groupby("Year")["Revenue"].sum().sort_index()
yoy = (rev_by_year.iloc[-1]-rev_by_year.iloc[-2]) / rev_by_year.iloc[-2]

rev_region = df.groupby("Region")["Revenue"].sum().sort_values(ascending=False)

print("Total Revenue:", round(total_revenue,2))
print("Profit Margin:", round(profit_margin,4))
print("Conversion Rate:", round(conversion,4))
print("Avg Deal Size (Won):", round(avg_deal_won,2))
print("YoY Growth:", round(yoy,4))
print("Top Region:", rev_region.index[0], "Share:", round(rev_region.iloc[0]/rev_region.sum(),4))
