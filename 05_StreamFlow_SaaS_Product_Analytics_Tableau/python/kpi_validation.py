import pandas as pd
from datetime import date, timedelta

today = date(2026,2,24)
cust = pd.read_csv("../data/Dim_Customer.csv", parse_dates=["SignupDate","ChurnDate"])

active = cust[(cust["SignupDate"].dt.date<=today) & ((cust["ChurnDate"].isna()) | (cust["ChurnDate"].dt.date>today))]
mrr = active["Price"].sum()

window_start = today - timedelta(days=30)
active_start = cust[(cust["SignupDate"].dt.date<=window_start) & ((cust["ChurnDate"].isna()) | (cust["ChurnDate"].dt.date>window_start))]
churned_window = cust[(cust["ChurnDate"].notna()) & (cust["ChurnDate"].dt.date>window_start) & (cust["ChurnDate"].dt.date<=today)]
churn_rate_30 = len(churned_window)/max(len(active_start),1)

churned = cust[cust["ChurnDate"].notna()].copy()
churned["TenureDays"] = (churned["ChurnDate"] - churned["SignupDate"]).dt.days
early_share = (churned["TenureDays"]<=30).mean()

print("MRR:", int(mrr))
print("Churn 30d:", round(churn_rate_30,4))
print("Early churn share:", round(early_share,4))
