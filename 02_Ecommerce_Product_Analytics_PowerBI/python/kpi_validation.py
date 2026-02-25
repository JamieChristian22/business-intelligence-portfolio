import pandas as pd
df = pd.read_csv("../data/Fact_Web_Analytics.csv", parse_dates=["Date"])

conv = df["Orders"].sum() / df["Sessions"].sum()
aov = df["Revenue"].sum() / max(df["Orders"].sum(),1)

device = df.groupby("Device").agg({"Orders":"sum","Sessions":"sum","Revenue":"sum"})
device["ConversionRate"] = device["Orders"]/device["Sessions"]
device["AOV"] = device["Revenue"]/device["Orders"].clip(lower=1)

print("Overall Conversion:", round(conv,4))
print("Overall AOV:", round(aov,2))
print(device[["ConversionRate","AOV"]].sort_values("ConversionRate", ascending=False))
