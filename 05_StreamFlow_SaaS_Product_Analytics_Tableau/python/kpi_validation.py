from pathlib import Path
import pandas as pd
import numpy as np

ROOT=Path(__file__).resolve().parents[1]
DATA=ROOT/"data"
OUT=ROOT/"docs"/"KPI_Validation_Results.csv"

c=pd.read_csv(DATA/"Dim_Customer.csv",parse_dates=["SignupDate","ChurnDate"])
p=pd.read_csv(DATA/"Dim_Plan.csv")
e=pd.read_csv(DATA/"Fact_Daily_Events.csv",parse_dates=["Date"])

assert {"CustomerID","SignupDate","PlanKey","ChurnDate","IsChurned","Plan","Price"}.issubset(c.columns)
assert {"PlanKey","Plan","Price"}.issubset(p.columns)
assert {"Date","CustomerID","Sessions","FeatureEvents","SupportTickets"}.issubset(e.columns)
assert c["CustomerID"].is_unique
assert p["PlanKey"].is_unique
assert c["PlanKey"].isin(p["PlanKey"]).all()
assert e["CustomerID"].isin(c["CustomerID"]).all()
assert c["IsChurned"].isin([0,1]).all()
assert (c["Price"]>=0).all()
assert (e[["Sessions","FeatureEvents","SupportTickets"]]>=0).all().all()

asof=e["Date"].max()
active=c[(c["SignupDate"]<=asof)&(c["ChurnDate"].isna()| (c["ChurnDate"]>asof))]
mrr=active["Price"].sum()
arr=mrr*12

print(f"Customers: {len(c):,}")
print(f"Event rows: {len(e):,}")
print(f"Active customers: {len(active):,}")
print(f"MRR: ${mrr:,.2f}")
print(f"ARR run rate: ${arr:,.2f}")
print("Validation passed.")
