# DAX_Measures.md

## Model setup (relationships)
- Relate `fact_sales[date_key]` → `dim_date[date_key]`
- Relate `traffic_volume_daily[date_key]` → `dim_date[date_key]`
- For monthly tables, add a calculated **MonthStart** column and relate to `dim_date[date]` (month-level):

```DAX
-- In profitability_by_month
MonthStart = DATE(YEAR([month]), MONTH([month]), 1)

-- In financial_performance_monthly
MonthStart = [month]  -- already first-of-month; keep as is
```

**Mark the date table**: Modeling → Mark as date table → `dim_date[date]`.

---

## Core Sales (from `fact_sales`)

```DAX
Revenue :=
SUM ( fact_sales[revenue] )

COGS :=
SUM ( fact_sales[cost] )

Gross Margin :=
[Revenue] - [COGS]

Gross Margin % :=
DIVIDE ( [Gross Margin], [Revenue] )

Profit :=
SUM ( fact_sales[profit] )

Orders :=
DISTINCTCOUNT ( fact_sales[order_id] )

Avg Order Value :=
DIVIDE ( [Revenue], [Orders] )

Units Sold :=
SUM ( fact_sales[quantity] )

Discount % (Weighted) :=
VAR DiscRev =
    SUMX (
        fact_sales,
        fact_sales[unit_price] * fact_sales[quantity] * fact_sales[discount]
    )
RETURN DIVIDE ( DiscRev, [Revenue] + DiscRev )  -- pre-discount basis

Revenue MTD :=
TOTALMTD ( [Revenue], dim_date[date] )

Revenue QTD :=
TOTALQTD ( [Revenue], dim_date[date] )

Revenue YTD :=
TOTALYTD ( [Revenue], dim_date[date] )
```
---

## Executive Profitability (from `profitability_by_month`)

```DAX
Exec Revenue :=
SUM ( profitability_by_month[revenue] )

Exec COGS :=
SUM ( profitability_by_month[cogs] )

Exec Opex :=
SUM ( profitability_by_month[opex] )

Exec Gross Margin :=
[Exec Revenue] - [Exec COGS]

Exec Net Income :=
[Exec Gross Margin] - [Exec Opex]

Exec Gross Margin % :=
DIVIDE ( [Exec Gross Margin], [Exec Revenue] )

Exec Net Margin % :=
DIVIDE ( [Exec Net Income], [Exec Revenue] )

Exec Revenue YTD :=
TOTALYTD ( [Exec Revenue], dim_date[date] )
```
---

## Finance (from `financial_performance_monthly`)

```DAX
Fin Revenue :=
SUM ( financial_performance_monthly[revenue] )

Fin COGS :=
SUM ( financial_performance_monthly[cogs] )

Fin Opex :=
SUM ( financial_performance_monthly[opex] )

Fin EBIT :=
SUM ( financial_performance_monthly[ebit] )

Fin Net Income :=
SUM ( financial_performance_monthly[net_income] )

Fin Gross Margin % :=
DIVIDE ( [Fin Revenue] - [Fin COGS], [Fin Revenue] )

Fin Net Margin % :=
DIVIDE ( [Fin Net Income], [Fin Revenue] )

Accounts Receivable :=
SUM ( financial_performance_monthly[accounts_receivable] )

AR Days :=
VAR AR = [Accounts Receivable]
VAR Rev = [Fin Revenue]
RETURN DIVIDE ( AR, DIVIDE ( Rev, 30 ) )
```
---

## Traffic (from `traffic_volume_daily`)

```DAX
Traffic Volume :=
SUM ( traffic_volume_daily[volume] )

Incidents :=
SUM ( traffic_volume_daily[incidents] )

Avg Speed (mph) :=
AVERAGE ( traffic_volume_daily[avg_speed_mph] )

Traffic per Segment :=
CALCULATE ( [Traffic Volume], ALLEXCEPT ( traffic_volume_daily, traffic_volume_daily[segment_id] ) )

Holiday Traffic Lift % :=
VAR Base =
    CALCULATE ( [Traffic Volume], FILTER ( dim_date, dim_date[is_holiday_us] = FALSE () ) )
VAR Hol =
    CALCULATE ( [Traffic Volume], FILTER ( dim_date, dim_date[is_holiday_us] = TRUE () ) )
RETURN DIVIDE ( Hol - Base, Base )
```
---

## Netflix (from `netflix_content`)

```DAX
Titles :=
COUNTROWS ( netflix_content )

Movies :=
CALCULATE ( [Titles], netflix_content[type] = "Movie" )

TV Shows :=
CALCULATE ( [Titles], netflix_content[type] = "TV Show" )

Avg IMDB Rating :=
AVERAGE ( netflix_content[imdb_rating] )

Avg IMDB by Genre :=
AVERAGEX ( VALUES ( netflix_content[genre] ), [Avg IMDB Rating] )

Movie Share % :=
DIVIDE ( [Movies], [Titles] )

TV Share % :=
DIVIDE ( [TV Shows], [Titles] )
```
