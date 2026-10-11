> **Scope: separately generated enterprise demonstration.** This earlier case study uses generated demo marts and scenario estimates. For the actual uploaded model integration, see [ORIGINAL_INTEGRATION.md](ORIGINAL_INTEGRATION.md).

# Ecommerce Conversion & Product Growth — BI Case Study

**Stakeholders:** Head of Digital Product, Ecommerce Growth Lead  
**Stack:** Power BI, SQL, dimensional analytics, KPI validation, Python QA  
**Portfolio status:** original workbook exists in linked GitHub source; proprietary visuals and workbook internals **not independently validated** in this upgrade.  
**Upgrade status:** reviewed analytical specifications and executable standalone demo marts included.

## 1. Business context and decision

**Problem:** Mobile generates meaningful traffic but converts at a different rate from desktop; stakeholders need defensible conversion, traffic quality and AOV comparisons.

**Specific decision:** Prioritize device-specific conversion work based on measured revenue opportunity and source quality.

**Scope:** In original source: reported daily Device × TrafficSource aggregates (sessions, orders, revenue and bounce); NOT individual user paths.

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
| Orders per session | `SUM(Orders)/SUM(Sessions)` | Session-based proxy; not unique-user conversion |
| Average order value | `SUM(Revenue)/SUM(Orders)` | Revenue per order |
| Weighted bounce rate | `SUM(BounceRate×Sessions)/SUM(Sessions)` | Weighted fraction |
| Return rate | `SUM(Returns)/SUM(Orders)` | Order-based, verify returns definition |
| Revenue per session | `SUM(Revenue)/SUM(Sessions)` | Business contribution per session |

Business rules: use sums or counts at correct grain before calculating ratios; return a blank on a zero denominator; label whether money means revenue, GMV, profit, or scenario exposure. Each metric must have a date scope and owner.

## 4. Analytical hypotheses

1. Mobile has worse orders per session due to UX friction, traffic mix or intent differences.
2. Email can have high AOV but low total traffic and limited scale.
3. Changing source mix can shift aggregate conversion even if within-device conversion remains stable.

These are hypotheses to test against source records, **not causal findings established by this document**. Segment comparisons require checks for sample size, mix shift, selection bias, and measurement error.

## 5. Data model and transformation strategy

**Input layer:** original repository stores source CSV extracts and a Dashboard.pbix workbook.  
**Contract layer:** validate required columns, source granularity, appropriate date keys, null rates, valid categorical values and numeric domains.  
**Curated layer:** dimension attributes and fact metrics must retain unique business grain.  
**Semantic layer:** publish governed measures with clear date/segment context.  
**Consumption:** executive summary + diagnostic drilldown + recommendation/action register.

The independent platform under `../../enterprise_platform/` uses *new synthetic data* and its own reproducible schema. It is provided as a **reference implementation** of these techniques, not as an assertion that the original PBIX/TWBX reads those synthetic tables.

## 6. Analysis and interpretation

**Proposed diagnostic:** Instrument actual add-to-cart and checkout stage events, run mobile-first A/B test, and set guardrails for sample ratio mismatch and return rate.

**Scenario method and source reconciliation:** Source-documented mobile baseline has **1,839,613 sessions**, **40,845 orders**, **2.2203% conversion** and **$79.85 AOV**. A **5% relative lift in orders** with sessions/AOV constant implies about **$163,068.97 incremental revenue** over the measured baseline period (not automatically quarterly). Document seasonality, margin and refunds not modeled.

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

Original source has only daily aggregate sessions/orders; intermediate cart and checkout events, identity stitching, retention cohorts and true customer-level funnel paths cannot be reconstructed. The new enterprise demo has separate synthetic stage fields that must not be attributed to original data.

**Evidence:** Recalculate conversions from sums of orders and sessions, validate bounce as weighted, and inspect source grain before claiming cart or checkout stages exist.

## 10. Review checklist and remaining manual QA

- [ ] Remove unsupported intermediate-stage and cohort claims from original project analytics.
- [ ] Repair invalid `ALLSELECTED` DAX filter usage in source file and paste corrected measure into PBIX.
- [ ] Add date source range and relative-vs-absolute lift labels to impact cards.
- [ ] Validate the original proprietary Dashboard.pbix workbook with Power BI Desktop before claiming it is production-ready.
- [ ] Sign off any newly adopted DAX/SQL change with the KPI owner.
- [ ] Document exact visual screenshots and test outcomes once application validation is complete.

## 11. Portfolio interview talk track (STAR)

**Situation:** Mobile generates meaningful traffic but converts at a different rate from desktop; stakeholders need defensible conversion, traffic quality and AOV comparisons.  
**Task:** Prioritize device-specific conversion work based on measured revenue opportunity and source quality.  
**Action:** Defined KPI contracts, mapped raw/semantic grains, built segment comparisons, documented anomalies and scoped a business intervention.  
**Result:** A reproducible decision framework and quantifiable *scenario* model. No claimed employer outcome; explain what controlled test would be needed to measure realized impact.
