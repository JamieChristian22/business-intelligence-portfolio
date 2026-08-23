from pathlib import Path
import pandas as pd
ROOT=Path(__file__).resolve().parents[1]
DATA=ROOT/"data"
OUT=ROOT/"docs"/"KPI_Validation_Results.csv"
ba=pd.read_csv(DATA/"Fact_BudgetActual.csv")
rc=pd.read_csv(DATA/"Fact_RevenueCOGS.csv")
assert {"MonthStart","Department","Account","Budget","Actual","Variance","VariancePct"}.issubset(ba.columns)
assert {"MonthStart","Revenue","COGS"}.issubset(rc.columns)
assert ba.isna().sum().sum()==0
assert rc.isna().sum().sum()==0
assert (ba["Budget"]>=0).all() and (ba["Actual"]>=0).all()
assert (rc["Revenue"]>=0).all() and (rc["COGS"]>=0).all()

budget=ba["Budget"].sum(); actual=ba["Actual"].sum()
variance=actual-budget
revenue=rc["Revenue"].sum(); cogs=rc["COGS"].sum()
gp=revenue-cogs
opex=actual
op=gp-opex
overspend=(ba.loc[ba["Actual"]>ba["Budget"],"Actual"]-ba.loc[ba["Actual"]>ba["Budget"],"Budget"]).sum()

pd.DataFrame({
"KPI":["Total Budget","Total Actual","Budget Variance","Budget Variance %","Revenue","COGS","Gross Profit","Gross Margin","Operating Profit","Operating Margin","Positive Variance Exposure"],
"ValidatedValue":[budget,actual,variance,variance/budget,revenue,cogs,gp,gp/revenue,op,op/revenue,overspend]
}).to_csv(OUT,index=False)
print("Validation passed.")
