# Reviewed Tableau Calculation Design — StreamFlow SaaS

> **Implementation status:** reviewed formulas and modeling specification only. They are **not automatically applied to, nor verified inside, the existing `.twbx`**. Validate Tableau version, relationship behavior and filters in Desktop before publishing.

## 1. Critical data model rule: avoid customer MRR duplication

The source has one `Dim_Customer` row per customer, but potentially many `Fact_Daily_Events` rows per customer. A physical row-level join can duplicate customer price once per event, so `SUM([Price])` after a physical join can **overstate MRR**.

Preferred: model `Dim_Customer` and `Fact_Daily_Events` as separate logical tables connected via a **relationship on CustomerID**, and audit each worksheet aggregation. For monthly MRR, prefer a curated unique customer × month-end snapshot (e.g., `saas_monthly_mrr.csv`) rather than summing a repeated `{ FIXED [CustomerID] : ... }` expression at event grain.

## 2. Parameters

Create a *Date* parameter `[As Of Date]` with explicit month-end data coverage. Do not derive it from filters that may shift with the selection and accidentally rewrite cohort eligibility.

## 3. Customer-grain calculated fields (Dim_Customer logical table)

### Active Customer ID as of selected date

```tableau
IF [SignupDate] <= [As Of Date]
AND (ISNULL([ChurnDate]) OR [ChurnDate] > [As Of Date])
THEN [CustomerID]
END
```

### Active Subscriber Count

```tableau
COUNTD([Active Customer ID as of selected date])
```

### Active Subscription Price (only on a customer-grain source)

```tableau
IF [SignupDate] <= [As Of Date]
AND (ISNULL([ChurnDate]) OR [ChurnDate] > [As Of Date])
THEN [Price]
ELSE 0
END
```

**Ending MRR:** `SUM([Active Subscription Price])` **only** when validated against one customer row per customer in the target worksheet/source. If events are physically joined, use a unique customer/month-end aggregate table. **ARR run rate:** `12 × ending MRR` (not collected revenue).

### Recorded churn share (all signup customers)

```tableau
COUNTD(IF [IsChurned] = 1 THEN [CustomerID] END)
/
COUNTD([CustomerID])
```

This is **not** a calendar-month churn hazard rate. For period churn, compute churned-at-start subscribers with exposure denominator and explicit snapshot boundaries.

## 4. D30 cohort retention

### Lifecycle day

```tableau
DATEDIFF('day', [SignupDate], [Date])
```

### Eligible for D30 on snapshot date

```tableau
DATEDIFF('day', [SignupDate], [As Of Date]) >= 36
```

### Active between days 30 and 36 (customer-level LOD, activity logical table)

```tableau
{ FIXED [CustomerID] :
    MAX(IF DATEDIFF('day', [SignupDate], [Date]) >= 30
            AND DATEDIFF('day', [SignupDate], [Date]) <= 36
            AND [Sessions] > 0
        THEN 1 ELSE 0 END)
}
```

Use only mature customers in the denominator, with explicit signup cohort boundaries. Due to Tableau LOD context-filter behavior, test that cohort filters do not accidentally change snapshot date or omit eligible nonactive customers. For strict cohort controls, consume independently reconciled SQL mart `saas_cohort_d30.csv` from the demo reference rather than trusting an unreviewed worksheet.

## 5. Engagement, MAU and activation

### Daily Active Users (DAU)

```tableau
COUNTD(IF [Sessions] > 0 THEN [CustomerID] END)
```

Break down at *calendar date* grain. **Calendar MAU** = `COUNTD(IF [Sessions] > 0 THEN [CustomerID] END)` with month-of-event date on the axis. A rolling 30-day MAU is a different window and requires an explicit 30-day lookback.

### First-week activation components

```tableau
IF DATEDIFF('day', [SignupDate], [Date]) >= 0
AND DATEDIFF('day', [SignupDate], [Date]) <= 6
THEN [Sessions]
ELSE 0 END
```

```tableau
IF DATEDIFF('day', [SignupDate], [Date]) >= 0
AND DATEDIFF('day', [SignupDate], [Date]) <= 6
THEN [FeatureEvents]
ELSE 0 END
```

Create separate customer-grain `FIXED [CustomerID]` sums, then classify activation as 3+ sessions **and** 5+ feature events during days 0–6. Validate with SQL for customers without any events.

## 6. Manual verification checklist

- [ ] Test one-to-many event joins for overcounting of MRR and subscription price.
- [ ] Validate snapshot boundary (`churn_date > as_of_date`) against billing policy.
- [ ] Audit D30 denominator excludes unmatured new signups and includes no-activity customers.
- [ ] Compare day 30–36 windows to SQL date arithmetic on 20 sampled customers.
- [ ] Test COUNTD behavior after adding plan/cohort filters and Tableau context filters.
- [ ] Verify metric definitions and filters with business/product owner before publication.

**Not supported by source:** NRR/GRR, historic expansions, time-bounded recurring net churn movement, and causal effect of onboarding. They require extra source systems and experiment design.
