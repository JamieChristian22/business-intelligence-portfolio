import pandas as pd

ba = pd.read_csv("../data/Fact_BudgetActual.csv", parse_dates=["MonthStart"])
rev = pd.read_csv("../data/Fact_RevenueCOGS.csv", parse_dates=["MonthStart"])

total_budget = ba["Budget"].sum()
total_actual = ba["Actual"].sum()
variance_pct = (total_actual-total_budget)/total_budget

var_dept = ba.groupby("Department")["Variance"].sum().sort_values(ascending=False)
gm = rev["GrossMargin"].mean()
rev_growth = (rev["Revenue"].iloc[-1]-rev["Revenue"].iloc[0]) / rev["Revenue"].iloc[0]

print("Variance %:", round(variance_pct,4))
print("Top overspend dept:", var_dept.index[0], round(var_dept.iloc[0],2))
print("Avg gross margin:", round(gm,4))
print("Revenue growth:", round(rev_growth,4))
