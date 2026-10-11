> **Scope: separately generated enterprise demonstration.** This earlier case study uses generated demo marts and scenario estimates. For the actual uploaded model integration, see [ORIGINAL_INTEGRATION.md](ORIGINAL_INTEGRATION.md).

# Marketplace Seller Health & GMV Concentration — BI Case Study

**Stakeholders:** Marketplace Operations Director, Seller Success Manager  
**Stack:** Power BI, SQL, dimensional analytics, KPI validation, Python QA  
**Portfolio status:** original workbook exists in linked GitHub source; proprietary visuals and workbook internals **not independently validated** in this upgrade.  
**Upgrade status:** reviewed analytical specifications and executable standalone demo marts included.

## 1. Business context and decision

**Problem:** A small set of sellers may create disproportionate gross merchandise value exposure while fulfillment and return metrics vary by segment.

**Specific decision:** Identify sellers disproportionately influencing marketplace GMV and prioritize operational performance interventions.

**Scope:** Order fact row (seller key, category, fulfillment, return, cancellation and rating); seller and date dimensions where defined.

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
| GMV | `SUM(GMV)` | Gross order GMV, not take-rate revenue |
| Top N share | `Top-N seller GMV / all seller GMV` | Threshold/rank scope must be explicit |
| Return rate | `SUM(Returned)/COUNT(order rows)` | Denominator applies to order rows in supplied schema |
| Cancellation rate | `SUM(Cancelled)/COUNT(order rows)` | Separate from returns |
| Weighted rating | `SUM(Rating×Units)/SUM(Units)` | Weight by units if justified; compare unweighted |

Business rules: use sums or counts at correct grain before calculating ratios; return a blank on a zero denominator; label whether money means revenue, GMV, profit, or scenario exposure. Each metric must have a date scope and owner.

## 4. Analytical hypotheses

1. Top sellers account for a disproportionate share of order GMV.
2. Fulfillment modes have different return/cancellation patterns after category mix adjustment.
3. A small group of high-GMV sellers with return issues warrants a focused seller-success intervention.

These are hypotheses to test against source records, **not causal findings established by this document**. Segment comparisons require checks for sample size, mix shift, selection bias, and measurement error.

## 5. Data model and transformation strategy

**Input layer:** original repository stores source CSV extracts and a Dashboard.pbix workbook.  
**Contract layer:** validate required columns, source granularity, appropriate date keys, null rates, valid categorical values and numeric domains.  
**Curated layer:** dimension attributes and fact metrics must retain unique business grain.  
**Semantic layer:** publish governed measures with clear date/segment context.  
**Consumption:** executive summary + diagnostic drilldown + recommendation/action register.

The independent platform under `../../enterprise_platform/` uses *new synthetic data* and its own reproducible schema. It is provided as a **reference implementation** of these techniques, not as an assertion that the original PBIX/TWBX reads those synthetic tables.

## 6. Analysis and interpretation

**Proposed diagnostic:** Launch seller scorecards with agreed support thresholds and tier-based risk reviews; evaluate concentration changes after support interventions.

**Scenario method and source reconciliation:** The original `docs/Business_Impact_Model.md` documents top-10 GMV **$3,575,099.21**. A hypothetical **10% decline in this top-10 pool** implies **$357,509.92 gross merchandise value exposure**, not a confirmed lost platform revenue figure. Reconcile period and scope before publishing.

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

GMV is not profit or platform revenue. The dataset lacks true seller onboarding timestamps and platform fee take rates; customer conversion funnels and real signup cohort retention cannot be claimed.

**Evidence:** Validate seller ranking with stable tie-breaking, confirm SUM(GMV) at order grain and compare returned versus cancelled flags in fact data.

## 10. Review checklist and remaining manual QA

- [ ] Remove template SQL querying missing `user_activity` and `funnel_data` tables.
- [ ] Make source SQL consistent with real fact/dimension names and documented PostgreSQL dialect.
- [ ] Define data owner and category-adjustment caveat for fulfillment comparison.
- [ ] Validate the original proprietary Dashboard.pbix workbook with Power BI Desktop before claiming it is production-ready.
- [ ] Sign off any newly adopted DAX/SQL change with the KPI owner.
- [ ] Document exact visual screenshots and test outcomes once application validation is complete.

## 11. Portfolio interview talk track (STAR)

**Situation:** A small set of sellers may create disproportionate gross merchandise value exposure while fulfillment and return metrics vary by segment.  
**Task:** Identify sellers disproportionately influencing marketplace GMV and prioritize operational performance interventions.  
**Action:** Defined KPI contracts, mapped raw/semantic grains, built segment comparisons, documented anomalies and scoped a business intervention.  
**Result:** A reproducible decision framework and quantifiable *scenario* model. No claimed employer outcome; explain what controlled test would be needed to measure realized impact.
