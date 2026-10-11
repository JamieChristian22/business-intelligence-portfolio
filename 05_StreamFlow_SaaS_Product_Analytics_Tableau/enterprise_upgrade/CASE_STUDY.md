> **Scope: separately generated enterprise demonstration.** This earlier case study uses generated demo marts and scenario estimates. For the actual uploaded model integration, see [ORIGINAL_INTEGRATION.md](ORIGINAL_INTEGRATION.md).

# SaaS Activation, Retention & Revenue Health — BI Case Study

**Stakeholders:** Head of Product, Customer Success Leader  
**Stack:** Tableau, SQL, dimensional analytics, KPI validation, Python QA  
**Portfolio status:** original workbook exists in linked GitHub source; proprietary visuals and workbook internals **not independently validated** in this upgrade.  
**Upgrade status:** reviewed analytical specifications and executable standalone demo marts included.

## 1. Business context and decision

**Problem:** Early cancellations constrain subscriber retention; the team needs lifecycle cohorts and customer engagement segments with consistent eligibility windows.

**Specific decision:** Prioritize onboarding improvements for a measurable improvement in mature-cohort D30 retention.

**Scope:** Customer-level signup/subscription record and daily customer-level engagement event aggregate.

### Success definition

Business stakeholders must agree on KPI filters, numerator/denominator, date scope, what actions are permissible, and when to reconsider a recommendation. Evidence must reconcile raw inputs with independently calculated output before release.

## 2. Discovery: stakeholder questions

1. What exactly would leadership do differently after viewing this report?
2. Which source system owns the metric, and who approves its definition?
3. What is the correct date grain, customer/account/order grain and default slicer scope?
4. How should the report treat blanks, returns, outliers, duplicates and division by zero?
5. What threshold triggers action, and who is the operational owner?
6. What alternative explanation could invalidate the apparent finding?

## 3. KPI contracts

| KPI | Calculation | Important interpretation |
|---|---|---|
| D30 retention | `Customers with activity on days 30–36 / eligible signup customers` | Must exclude signup cohorts not yet 36 days old |
| MRR snapshot | `SUM(Price) for active customers as of date` | Flat-plan snapshot; not a subscription movement bridge |
| Recorded churn | `Recorded churn customers / ever-signed customers` | Not an interval churn hazard/rate |
| MAU | `COUNTD(CustomerID) with active event in month` | Define calendar month vs rolling 30 days |
| Health score | `Normalized engagement/active days/ticket score` | Model heuristic; validation required |

Business rules: use sums or counts at correct grain before calculating ratios; return a blank on a zero denominator; label whether money means revenue, GMV, profit, or scenario exposure. Each metric must have a date scope and owner.

## 4. Analytical hypotheses

1. Low first-week activation is associated with a lower probability of being active on day 30.
2. Support ticket volume may signal onboarding friction but is not itself a causal churn driver.
3. High engagement cohorts may be subject to maturity bias if newer users are included in denominator.

These are hypotheses to test against source records, **not causal findings established by this document**. Segment comparisons require checks for sample size, mix shift, selection bias, and measurement error.

## 5. Data model and transformation strategy

**Input layer:** original repository stores source CSV extracts and a Dashboard.twbx workbook.  
**Contract layer:** validate required columns, source granularity, appropriate date keys, null rates, valid categorical values and numeric domains.  
**Curated layer:** dimension attributes and fact metrics must retain unique business grain.  
**Semantic layer:** publish governed measures with clear date/segment context.  
**Consumption:** executive summary + diagnostic drilldown + recommendation/action register.

The independent platform under `../../enterprise_platform/` uses *new synthetic data* and its own reproducible schema. It is provided as a **reference implementation** of these techniques, not as an assertion that the original PBIX/TWBX reads those synthetic tables.

## 6. Analysis and interpretation

**Proposed diagnostic:** Test a structured 7-day onboarding flow with well-defined activation criteria, then track D30 outcomes for only mature signup cohorts.

**Scenario method and source reconciliation:** The original source impact note reports recorded churned MRR **$1,788.00**. Preventing 5% of that historical recorded churn value is a **$89.40 monthly retention scenario**, not an observed improvement or proof of an achievable rate. NRR requires expansion/contraction/movement history absent from the original sources.

### What a defensible executive insight must contain

- Report time window and baseline, numerator and denominator.
- Show absolute and relative changes alongside the segment size.
- Explain a likely operating mechanism, competing explanation and measurement risk.
- Quantify upside with a named formula and *unchanged-variable assumptions*.
- Propose next validation/experiment; never present hypothetical upside as captured dollars.

## 7. Visualization and interaction requirements

| View | Component | Interaction / validation |
|---|---|---|
| Executive overview | KPI cards, comparative trend, exception indicator | Readable unit/period subtitle, correct blank handling |
| Diagnostics | Segment ranking and variance/efficiency decomposition | Sort and filter without changing base KPI definition |
| Intervention | Prioritized segment table with owners | Evidence, threshold, next action and review date |
| Data trust | Coverage, freshness, data reconciliation panel | Surface definition, record count and known gaps |

Theme: accessible labels, consistent red/green semantics for favorable/unfavorable, non-color-only signals, concise tooltips and an exportable definition panel.

## 8. Business acceptance criteria

- [ ] Business owner approves KPI denominator, date scope and definitions.
- [ ] Test selected filters against a separately calculated SQL/Python result.
- [ ] Confirm workbook chart totals match data source at default and narrowed slices.
- [ ] Confirm sorting/ranking responds to filters as intended.
- [ ] Confirm all impact statements are scenarios with transparent units and assumptions.
- [ ] Confirm that PDF/export screenshots and README figures match the current dataset version.
- [ ] Confirm report accessibility and mobile/responsive behavior where applicable.

## 9. Known limitations and risks

Simulated flat-plan subscriptions; incomplete month-by-month MRR movement ledger prevents defensible GRR/NRR. Event-level sessions are aggregated daily, not individual clickstream events.

**Evidence:** Reconcile `dim_customer` to `fact_daily_events`, check D30 lifecycle boundaries, and verify Tableau calculated fields in packaged TWBX.

## 10. Review checklist and remaining manual QA

- [ ] Replace generic cohort SQL using missing user_activity with actual Customer/Event schema.
- [ ] Separate recorded churn share from time-bounded churn rates.
- [ ] Do not describe monthly plan price sums as NRR or as historical expansion without movements.
- [ ] Validate the original proprietary Dashboard.twbx workbook with Tableau Desktop before claiming it is production-ready.
- [ ] Sign off any newly adopted DAX/SQL change with the KPI owner.
- [ ] Document exact visual screenshots and test outcomes once application validation is complete.

## 11. Portfolio interview talk track (STAR)

**Situation:** Early cancellations constrain subscriber retention; the team needs lifecycle cohorts and customer engagement segments with consistent eligibility windows.  
**Task:** Prioritize onboarding improvements for a measurable improvement in mature-cohort D30 retention.  
**Action:** Defined KPI contracts, mapped raw/semantic grains, built segment comparisons, documented anomalies and scoped a business intervention.  
**Result:** A reproducible decision framework and quantifiable *scenario* model. No claimed employer outcome; explain what controlled test would be needed to measure realized impact.
