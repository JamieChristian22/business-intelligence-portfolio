from pathlib import Path
import pandas as pd
import numpy as np

ROOT=Path(__file__).resolve().parents[1]
DATA=ROOT/"data"
OUT=ROOT/"docs"/"KPI_Validation_Results.csv"

f=pd.read_csv(DATA/"Fact_Marketplace_Orders.csv")
s=pd.read_csv(DATA/"Dim_Seller.csv")

required={"DateKey","SellerKey","Category","Fulfillment","Units","ItemPrice","GMV","Rating","Cancelled","Returned"}
assert required.issubset(f.columns)
assert f.isna().sum().sum()==0
assert (f["Units"]>=0).all()
assert (f["ItemPrice"]>0).all()
assert (f["GMV"]>=0).all()
assert f["Rating"].between(1,5).all()
assert f["Cancelled"].isin([0,1]).all()
assert f["Returned"].isin([0,1]).all()
assert f["SellerKey"].isin(s["SellerKey"]).all()

gmv=f["GMV"].sum()
orders=len(f)
units=f["Units"].sum()
returns=f["Returned"].sum()
cancels=f["Cancelled"].sum()
weighted=np.average(f["Rating"],weights=np.maximum(f["Units"],1))

sp=f.groupby("SellerKey")["GMV"].sum().sort_values(ascending=False)
top10=sp.head(10).sum()/gmv

pd.DataFrame({
"KPI":["Gross Merchandise Value","Orders","Units Sold","Average Order GMV","Average Unit Value","Return Rate","Cancellation Rate","Weighted Rating","Top 10 Seller GMV Share"],
"ValidatedValue":[gmv,orders,units,gmv/orders,gmv/units,returns/orders,cancels/orders,weighted,top10]
}).to_csv(OUT,index=False)

print("Validation passed.")
