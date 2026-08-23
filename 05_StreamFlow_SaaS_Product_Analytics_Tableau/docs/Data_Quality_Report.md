# Data Quality Report

- **CustomerRows:** 9,500
- **PlanRows:** 3
- **EventRows:** 805,200
- **CustomerDuplicateRows:** 0
- **PlanDuplicateRows:** 0
- **EventDuplicateRows:** 0
- **CustomerNullCells:** 0
- **EventNullCells:** 0
- **InvalidPlanKeys:** 0
- **InvalidChurnFlags:** 0
- **NegativeSessions:** 0
- **NegativeFeatureEvents:** 0
- **NegativeSupportTickets:** 0
- **OrphanEventCustomers:** 0

## Interpretation
Blank `ChurnDate` is expected for non-churned customers and is not treated as a data-quality failure. All other structural/business-rule checks are automated.
