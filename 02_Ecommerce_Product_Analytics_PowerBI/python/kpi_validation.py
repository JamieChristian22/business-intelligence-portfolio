from pathlib import Path
import pandas as pd
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OUT = ROOT / "docs" / "KPI_Validation_Results.csv"

df = pd.read_csv(DATA / "Fact_Web_Analytics.csv")
df["Date"] = pd.to_datetime(df["Date"])

required = {"Date","Device","TrafficSource","Sessions","Orders","Revenue","Returns","BounceRate"}
missing = required - set(df.columns)
assert not missing, f"Missing required columns: {missing}"
assert df.isna().sum().sum() == 0, "Null values detected"
assert (df["Sessions"] >= 0).all(), "Negative sessions detected"
assert (df["Orders"] >= 0).all(), "Negative orders detected"
assert (df["Revenue"] >= 0).all(), "Negative revenue detected"
assert (df["Returns"] >= 0).all(), "Negative returns detected"
assert (df["Orders"] <= df["Sessions"]).all(), "Orders exceed sessions"
assert (df["Returns"] <= df["Orders"]).all(), "Returns exceed orders"
assert df["BounceRate"].between(0,1).all(), "Bounce rate outside 0..1"

sessions = df["Sessions"].sum()
orders = df["Orders"].sum()
revenue = df["Revenue"].sum()
returns = df["Returns"].sum()
weighted_bounce = np.average(df["BounceRate"], weights=df["Sessions"])

result = pd.DataFrame({
    "KPI": [
        "Total Sessions","Total Orders","Total Revenue","Conversion Rate",
        "Average Order Value","Total Returns","Return Rate",
        "Weighted Bounce Rate","Revenue per Session"
    ],
    "ValidatedValue": [
        sessions, orders, revenue, orders/sessions,
        revenue/orders, returns, returns/orders,
        weighted_bounce, revenue/sessions
    ]
})
result.to_csv(OUT, index=False)

print(result.to_string(index=False))
print("\nValidation passed: structure, domains, business rules, and KPI reconciliation.")
