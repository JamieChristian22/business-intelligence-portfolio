> **Scope: separately generated enterprise demonstration.** This earlier case study uses generated demo marts and scenario estimates. For the actual uploaded model integration, see [ORIGINAL_INTEGRATION.md](ORIGINAL_INTEGRATION.md).

# FP&A Budget Control & Executive Planning — BI Case Study

**Stakeholders:** FP&A Director, Finance Controller  
**Stack:** Power BI, SQL, dimensional analytics, KPI validation, Python QA  
**Portfolio status:** original workbook exists in linked GitHub source; proprietary visuals and workbook internals **not independently validated** in this upgrade.  
**Upgrade status:** reviewed analytical specifications and executable standalone demo marts included.

## 1. Business context and decision

**Problem:** Budget vs actual trends require consistent sign convention, financial bridges and accountable department explanation.

**Specific decision:** Escalate explainable overspend and quantify controllable action without equating all variance with recoverable savings.

**Scope:** Month × Department × Account budget/actual, plus separate monthly revenue and COGS.

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
| Signed expense variance | `SUM(Actual)-SUM(Budget)` | Positive = overspend; negative = underspend |
| Variance percent | `(Actual-Budget)/Budget` | Requires valid budget denominator |
| Gross overspend pool | `SUM(MAX(Actual-Budget,0))` | Sum at account/month grain, not positive aggregate variance |
| Operating profit | `Revenue-COGS-Operating Expenses` | Simplified, excludes other accounting adjustments |
| 3M annualized run-rate | `AVERAGE(last 3 completed months)×12` | Scenario not forecast guarantee |

Business rules: use sums or counts at correct grain before calculating ratios; return a blank on a zero denominator; label whether money means revenue, GMV, profit, or scenario exposure. Each metric must have a date scope and owner.

## 4. Analytical hypotheses

1. Marketing’s gross overspend may reflect timing and campaign mix rather than avoidable waste.
2. Underspend can offset overspend in net variance but is not the same as risk exposure.
3. Revenue shifts and cost increases must be separated to explain margin change.

These are hypotheses to test against source records, **not causal findings established by this document**. Segment comparisons require checks for sample size, mix shift, selection bias, and measurement error.

## 5. Data model and transformation strategy

**Input layer:** original repository stores source CSV extracts and a Dashboard.pbix workbook.  
**Contract layer:** validate required columns, source granularity, appropriate date keys, null rates, valid categorical values and numeric domains.  
**Curated layer:** dimension attributes and fact metrics must retain unique business grain.  
**Semantic layer:** publish governed measures with clear date/segment context.  
**Consumption:** executive summary + diagnostic drilldown + recommendation/action register.

The independent platform under `../../enterprise_platform/` uses *new synthetic data* and its own reproducible schema. It is provided as a **reference implementation** of these techniques, not as an assertion that the original PBIX/TWBX reads those synthetic tables.

## 6. Analysis and interpretation

**Proposed diagnostic:** Review top-five account/department variance contributors with budget owners, annotate timing/accrual differences and assign corrective action owners.

**Scenario method and source reconciliation:** Original project model documents gross positive row-level variances of **$2,127,474.22**. Applying a hypothetical 25% reduction to that pool yields **$531,868.56 rounded** (source may round from $531,868.55). This is *one-time modeled exposure* unless recurrence and controllability are independently established.

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

No GL journal-level detail, actual approval workflows or documented seasonality decomposition. Revenue and finance figures are simulated case-study data, not public-company financial statements.

**Evidence:** Cross-check original Fact_BudgetActual totals, variance sign, Account and Department slicer effects, and Fact_RevenueCOGS monthly grain to avoid cross-join duplication.

## 10. Review checklist and remaining manual QA

- [ ] Remove unrelated cohort and user funnel SQL from finance project.
- [ ] Add row-grain bridge for unfavorable/favorable variance and rolling trend.
- [ ] Tie signed net variance to sum of positive and negative variance components.
- [ ] Validate the original proprietary Dashboard.pbix workbook with Power BI Desktop before claiming it is production-ready.
- [ ] Sign off any newly adopted DAX/SQL change with the KPI owner.
- [ ] Document exact visual screenshots and test outcomes once application validation is complete.

## 11. Portfolio interview talk track (STAR)

**Situation:** Budget vs actual trends require consistent sign convention, financial bridges and accountable department explanation.  
**Task:** Escalate explainable overspend and quantify controllable action without equating all variance with recoverable savings.  
**Action:** Defined KPI contracts, mapped raw/semantic grains, built segment comparisons, documented anomalies and scoped a business intervention.  
**Result:** A reproducible decision framework and quantifiable *scenario* model. No claimed employer outcome; explain what controlled test would be needed to measure realized impact.
