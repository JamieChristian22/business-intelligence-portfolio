# Tableau Calculated Fields

## Active Customer as of Dataset End
```text
IF [SignupDate] <= { FIXED : MAX([Date]) }
AND (ISNULL([ChurnDate]) OR [ChurnDate] > { FIXED : MAX([Date]) })
THEN [CustomerID]
END
```

## MRR
```text
{ FIXED [CustomerID] :
    MAX(
        IF [SignupDate] <= { FIXED : MAX([Date]) }
        AND (ISNULL([ChurnDate]) OR [ChurnDate] > { FIXED : MAX([Date]) })
        THEN [Price]
        END
    )
}
```
Use `SUM([MRR])` at customer grain.

## ARR Run Rate
```text
SUM([MRR]) * 12
```

## ARPU
```text
SUM([MRR]) / COUNTD([Active Customer as of Dataset End])
```

## Lifecycle Day
```text
DATEDIFF('day', [SignupDate], [Date])
```

## First-7-Day Activation Components
```text
IF [Lifecycle Day] >= 0 AND [Lifecycle Day] <= 6 THEN [Sessions] END
```

```text
IF [Lifecycle Day] >= 0 AND [Lifecycle Day] <= 6 THEN [FeatureEvents] END
```

Create customer-level LOD totals and classify activated when Sessions >= 3 and FeatureEvents >= 5.

## D30 Retained
```text
IF [Lifecycle Day] >= 30 AND [Lifecycle Day] <= 36 AND [Sessions] > 0
THEN 1 ELSE 0 END
```

## Recorded Churn Flag
```text
MAX([IsChurned])
```

## Recorded Churn Rate
```text
SUM([Recorded Churn Flag]) / COUNTD([CustomerID])
```

## DAU
```text
COUNTD([CustomerID])
```
Place Date at day grain.

## Trailing MAU
Use a 30-day relative date filter and `COUNTD([CustomerID])`.

## Stickiness
Use average daily COUNTD(CustomerID) divided by trailing-30-day COUNTD(CustomerID).

## Sessions per Active User
```text
SUM([Sessions]) / COUNTD([CustomerID])
```

## Feature Events per Active User
```text
SUM([FeatureEvents]) / COUNTD([CustomerID])
```

## Customer Health Score
The packaged validation output uses percentile scoring:
- Sessions30: 35%
- FeatureEvents30: 35%
- ActiveDays30: 25%
- inverse SupportTickets30 percentile: 5%

Use the supplied `User_Health_Scorecard.csv` for exact reconciled values.
