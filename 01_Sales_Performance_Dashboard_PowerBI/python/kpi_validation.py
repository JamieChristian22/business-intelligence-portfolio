from pathlib import Path
import pandas as pd
ROOT=Path(__file__).resolve().parents[1]; DATA=ROOT/"data"; OUT=ROOT/"docs"/"KPI_Validation_Results.csv"
f=pd.read_csv(DATA/"Fact_Sales.csv"); r=pd.read_csv(DATA/"Dim_Region.csv"); c=pd.read_csv(DATA/"Dim_Channel.csv"); p=pd.read_csv(DATA/"Dim_Product.csv"); d=pd.read_csv(DATA/"Dim_Date.csv")
req={"DateKey","RegionKey","ChannelKey","ProductKey","Revenue","Profit","Leads","DealsWon"}
assert req.issubset(f.columns)
assert f.isna().sum().sum()==0
assert (f.Revenue>=0).all() and (f.Leads>=0).all() and (f.DealsWon>=0).all()
assert (f.DealsWon<=f.Leads).all()
assert f.RegionKey.isin(r.RegionKey).all() and f.ChannelKey.isin(c.ChannelKey).all()
assert f.ProductKey.isin(p.ProductKey).all() and f.DateKey.isin(d.DateKey).all()
R=f.Revenue.sum(); P=f.Profit.sum(); L=f.Leads.sum(); W=f.DealsWon.sum()
pd.DataFrame({"KPI":["Total Revenue","Total Profit","Profit Margin","Total Leads","Deals Won","Conversion Rate","Average Deal Size"],
"ValidatedValue":[R,P,P/R,L,W,W/L,R/W]}).to_csv(OUT,index=False)
print("Validation passed.")
