#!/usr/bin/env python3
"""Read-only, reproducible audit of five simulated BI star-schema projects.

Published KPI CSVs are *inputs to verify*, never overwritten. Run from repo root:
python -m tools.validate_bi --output reports/bi-validation.json
"""
from __future__ import annotations
import argparse
import json
import math
from pathlib import Path

import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
PROJECTS = (
    "01_Sales_Performance_Dashboard_PowerBI",
    "02_Ecommerce_Product_Analytics_PowerBI",
    "03_Amazon_Marketplace_Analytics_PowerBI",
    "04_FPNA_Executive_Analytics_PowerBI",
    "05_StreamFlow_SaaS_Product_Analytics_Tableau",
)

def fail(message):
    raise ValueError(message)

def data(project, basename):
    path = ROOT / project / "data" / f"{basename}.csv"
    df = pd.read_csv(path, low_memory=False)
    if df.empty or not df.columns.is_unique:
        fail(f"{path}: empty file or duplicate columns")
    if df.isna().any().any() and basename not in {"Dim_Customer"}:
        fail(f"{path}: unexpected null fields")
    return df

def keys_unique(df, key, project):
    if df[key].isna().any() or df[key].duplicated().any():
        fail(f"{project}: {key} dimension key must be nonnull and unique")

def foreign(fact, key, dim, project):
    if fact[key].isna().any() or not fact[key].isin(dim[key]).all():
        fail(f"{project}: orphan {key} fact record")

def bounded(df, column, low=0, high=None):
    x = pd.to_numeric(df[column], errors="coerce")
    if x.isna().any() or not np.isfinite(x.to_numpy()).all():
        fail(f"{column}: invalid/nonfinite values")
    if (x < low).any() or (high is not None and (x > high).any()):
        fail(f"{column}: outside expected range")

def nonzero(dividend, divisor, label):
    if divisor == 0:
        fail(f"{label}: zero denominator")
    return dividend / divisor

def check_published(project, actual):
    path=ROOT / project / "docs/KPI_Validation_Results.csv"
    rows=pd.read_csv(path)
    if not {"KPI","ValidatedValue"}.issubset(rows.columns) or rows["KPI"].duplicated().any():
        fail(f"{project}: invalid published KPI CSV")
    expected=rows.set_index("KPI")["ValidatedValue"].to_dict()
    checked={}
    for name,value in actual.items():
        if name not in expected:
            fail(f"{project}: missing published KPI {name}")
        recorded=float(expected[name])
        if not math.isfinite(recorded) or not math.isclose(float(value), recorded, rel_tol=1e-8, abs_tol=0.011):
            fail(f"{project}: {name} published={recorded} computed={value}")
        checked[name]={"computed": round(float(value),8), "published":recorded}
    return checked, len(expected)-len(checked)

def sales():
    name=PROJECTS[0]
    f=data(name,"Fact_Sales")
    for dim, key in (("Dim_Date","DateKey"),("Dim_Region","RegionKey"),("Dim_Channel","ChannelKey"),("Dim_Product","ProductKey")):
        d=data(name,dim);keys_unique(d,key,name);foreign(f,key,d,name)
    for col in ("Revenue","Leads","DealsWon"):
        bounded(f,col)
    if (f["DealsWon"]>f["Leads"]).any():
        fail("Sales: deals won exceed leads")
    R=float(f.Revenue.sum());P=float(f.Profit.sum());L=float(f.Leads.sum());W=float(f.DealsWon.sum())
    values={"Total Revenue":R,"Total Profit":P,"Profit Margin":nonzero(P,R,"sales margin"),
            "Total Leads":L,"Deals Won":W,"Conversion Rate":nonzero(W,L,"sales conversion"),
            "Average Deal Size":nonzero(R,W,"deal size")}
    return f,values,{"grain":"one sales fact row", "fact_rows":len(f),"dimensions_checked":4}

def ecommerce():
    name=PROJECTS[1];f=data(name,"Fact_Web_Analytics")
    for fact_key,dim_name,dim_key in (("Date","Dim_Date","Full_Date"),("Device","Dim_Device","Device"),("TrafficSource","Dim_TrafficSource","TrafficSource")):
        d=data(name,dim_name)
        k=dim_key if dim_key in d.columns else "FullDate" if dim_key=="Full_Date" and "FullDate" in d.columns else dim_key
        if k not in d.columns:
            fail(f"{name}: missing dimension {dim_key}")
        keys_unique(d,k,name)
        if not f[fact_key].isin(d[k]).all():
            fail(f"{name}: unmatched {fact_key}")
    for col in ("Sessions","Orders","Revenue","Returns"):bounded(f,col)
    bounded(f,"BounceRate",0,1)
    if (f.Orders>f.Sessions).any() or (f.Returns>f.Orders).any():
        fail("Ecommerce: orders/sessions/returns impossible")
    S=float(f.Sessions.sum());O=float(f.Orders.sum());R=float(f.Revenue.sum());T=float(f.Returns.sum())
    values={"Total Sessions":S,"Total Orders":O,"Total Revenue":R,
            "Conversion Rate":nonzero(O,S,"ecommerce conversion"),"Average Order Value":nonzero(R,O,"AOV"),
            "Total Returns":T,"Return Rate":nonzero(T,O,"return rate"),
            "Weighted Bounce Rate":float(np.average(f.BounceRate,weights=f.Sessions)),
            "Revenue per Session":nonzero(R,S,"RPS")}
    return f,values,{"grain":"date x device x traffic source", "fact_rows":len(f),"dimensions_checked":3}

def marketplace():
    name=PROJECTS[2];f=data(name,"Fact_Marketplace_Orders")
    s=data(name,"Dim_Seller");keys_unique(s,"SellerKey",name);foreign(f,"SellerKey",s,name)
    for field,dimension,key in (("DateKey","Dim_Date","DateKey"),("Category","Dim_Category","Category"),("Fulfillment","Dim_Fulfillment","Fulfillment")):
        d=data(name,dimension);k=key if key in d.columns else key.lower()
        if k not in d.columns:fail(f"{name}: missing dimension {key}")
        keys_unique(d,k,name)
        if not f[field].isin(d[k]).all():fail(f"{name}: orphan {field}")
    for col in ("Units","ItemPrice","GMV"):bounded(f,col)
    bounded(f,"Rating",1,5)
    for col in ("Cancelled","Returned"):
        if not f[col].isin([0,1]).all():fail(f"Marketplace: invalid binary {col}")
    gmv=float(f.GMV.sum());orders=len(f);units=float(f.Units.sum())
    ranks=f.groupby("SellerKey")["GMV"].sum().nlargest(10)
    values={"Gross Merchandise Value":gmv,"Orders":orders,"Units Sold":units,
        "Average Order GMV":nonzero(gmv,orders,"GMV/order"),
        "Average Unit Value":nonzero(gmv,units,"GMV/unit"),
        "Return Rate":float(f.Returned.sum()/orders),"Cancellation Rate":float(f.Cancelled.sum()/orders),
        "Weighted Rating":float(np.average(f.Rating,weights=np.maximum(f.Units,1))),
        "Top 10 Seller GMV Share":nonzero(float(ranks.sum()),gmv,"top10 share")}
    return f,values,{"grain":"marketplace order fact row", "fact_rows":len(f),"dimensions_checked":4}

def fpna():
    name=PROJECTS[3];ba=data(name,"Fact_BudgetActual");rc=data(name,"Fact_RevenueCOGS")
    for key,dim in (("Department","Dim_Department"),("Account","Dim_Account")):
        d=data(name,dim);keys_unique(d,key,name)
        if not ba[key].isin(d[key]).all():fail(f"FPNA: orphan {key}")
    for col in ("Budget","Actual"):bounded(ba,col)
    for col in ("Revenue","COGS"):bounded(rc,col)
    variance=ba.Actual-ba.Budget
    if not np.allclose(ba.Variance.to_numpy(),variance.to_numpy(),atol=0.011,rtol=0):
        fail("FPNA: row-level Actual-Budget differs from Variance")
    pct=np.where(ba.Budget.to_numpy()>0,variance.to_numpy()/ba.Budget.to_numpy(),0)
    if (ba.Budget==0).any():
        fail("FPNA: zero-budget percentage requires documented convention")
    if not np.allclose(ba.VariancePct.to_numpy(),pct,atol=0.00011,rtol=0):
        fail("FPNA: per-row VariancePct differs from (Actual-Budget)/Budget")
    budget=float(ba.Budget.sum());actual=float(ba.Actual.sum());rev=float(rc.Revenue.sum());cogs=float(rc.COGS.sum())
    gross=rev-cogs;operating=gross-actual
    values={"Total Budget":budget,"Total Actual":actual,
        "Budget Variance":actual-budget,"Budget Variance %":nonzero(actual-budget,budget,"budget variance"),
        "Revenue":rev,"COGS":cogs,"Gross Profit":gross,
        "Gross Margin":nonzero(gross,rev,"gross margin"),"Operating Profit":operating,
        "Operating Margin":nonzero(operating,rev,"operating margin"),
        "Positive Variance Exposure":float(variance.clip(lower=0).sum())}
    return ba,values,{"grain":"month x department x account (budget/actual); independent revenue/COGS month",
        "fact_rows":len(ba),"secondary_fact_rows":len(rc),"dimensions_checked":2}

def saas():
    name=PROJECTS[4];c=data(name,"Dim_Customer");p=data(name,"Dim_Plan");e=data(name,"Fact_Daily_Events")
    keys_unique(c,"CustomerID",name);keys_unique(p,"PlanKey",name)
    foreign(c,"PlanKey",p,name);foreign(e,"CustomerID",c,name)
    if not c.IsChurned.isin([0,1]).all():fail("SaaS: IsChurned must be binary")
    bounded(c,"Price")
    for col in ("Sessions","FeatureEvents","SupportTickets"):bounded(e,col)
    if (c.merge(p[["PlanKey","Plan","Price"]],on="PlanKey",suffixes=("_c","_p"))
       .eval("Plan_c != Plan_p or Price_c != Price_p")).any():
        fail("SaaS: customer plan label/price disagrees with dimension")
    e_dates=pd.to_datetime(e.Date,errors="coerce");signup=pd.to_datetime(c.SignupDate,errors="coerce")
    churn=pd.to_datetime(c.ChurnDate,errors="coerce")
    if e_dates.isna().any() or signup.isna().any():fail("SaaS: invalid event/signup date")
    asof=e_dates.max()
    active=c[(signup<=asof)&(churn.isna()|(churn>asof))]
    if (churn.notna() & (churn<signup)).any():fail("SaaS: churn before signup")
    mrr=float(active.Price.sum());count=len(active);total=len(c)
    recorded_churn=int(c.IsChurned.sum())
    values={"Total Customers":total,"Active Customers":count,
        "Recorded Churned Customers":recorded_churn,
        "Recorded Churn Rate":nonzero(recorded_churn,total,"churn rate"),
        "MRR":mrr,"ARR":mrr*12,"ARPU":nonzero(mrr,count,"ARPU")}
    return e,values,{"grain":"customer x day event, with customer and plan dimensions",
        "fact_rows":len(e),"customer_rows":total,"dimensions_checked":2,"asof":asof.date().isoformat(),
        "published_kpi_subset_only":True}

def validate():
    checks=(sales,ecommerce,marketplace,fpna,saas)
    output={}
    for project,calc in zip(PROJECTS,checks):
        frame,values,profile=calc()
        verified,unchecked=check_published(project,values)
        output[project]={"profile":profile,"kpis_checked":verified,"published_kpis_not_checked":unchecked}
    return {"status":"PASS_SOURCE_KPI_RECONCILIATION",
            "disclosure":"Historical synthetic portfolio datasets; not independently verified production business impact",
            "projects":output,"project_count":len(output),
            "validated_kpi_count":sum(len(x["kpis_checked"]) for x in output.values()),
            "limits":"Native PBIX/TWBX dashboards and all advanced SQL queries were not rendered or executed; SaaS published KPI subset audited."}

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output",type=Path,default=ROOT/"reports/bi-validation.json")
    args=parser.parse_args()
    result=validate()
    args.output.parent.mkdir(parents=True,exist_ok=True)
    args.output.write_text(json.dumps(result,indent=2)+"\n",encoding="utf-8")
    print(json.dumps({"status":result["status"],"projects":{k:{"rows":v["profile"]["fact_rows"],"kpis":len(v["kpis_checked"]),
              "unverified_published_kpis":v["published_kpis_not_checked"]} for k,v in result["projects"].items()}},indent=2))

if __name__=="__main__":
    main()
