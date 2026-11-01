# Business Intelligence portfolio: read-only KPI and source validation

## Reviewer starting point

[Open the standalone interactive BI Evidence Explorer](../demo/bi-evidence-explorer.html) by downloading/opening the HTML locally. It compares five individual *simulated* business case studies. Use the project selector, choose a numeric breakdown, and search the KPIs; every value comes from committed CSV artifacts, not external data.

The dashboard displays *existing* published KPI values; it does not re-render or inspect the proprietary Power BI `.pbix` or Tableau `.twbx` files. The separate Python source audit independently recomputes **selected KPIs** from original fact tables and compares them to the published KPI CSVs with tolerance for float arithmetic. It does not overwrite published values.

## Reproduce independently

Run from the repository root using Python 3.11 or 3.12:

```bash
python -m pip install -r requirements-ci.txt
python -m tools.validate_bi --output reports/bi-validation.json
python -m unittest discover -s tests -p 'test_*.py' -v
```

The tests validate five distinct BI projects:

| Case study | Source grain and high-value checks |
|---|---|
| Sales Performance | Fact records joined to Date/Region/Channel/Product dimensions; leads/deals bounds; revenue, profit, conversion and average deal size |
| Ecommerce Product | Date × device × source; dimension coverage; sessions/orders/returns limits; weighted bounce and conversion |
| Amazon Marketplace | Seller/date/category/fulfillment coverage; GMV, returned/cancelled flags, weighted rating and Top-10 seller share |
| FP&A Executive | Budget/actual by month × department × account; row-level variance and rounded variance percent; revenue/COGS and profit, margin and positive overspend |
| StreamFlow SaaS | Customer/plan/event key coverage; recorded churn, customer/plan consistency, active customers and MRR/ARR as of last recorded event |

The complete `docs/KPI_Validation_Results.csv` files have additional metrics (especially SaaS: retention and churn variants). The report explicitly gives the number of KPIs **not** independently checked in this phase. A successful pipeline must never claim all metrics are correct unless their calculations were actually rerun. The source audit does not execute the existing case-study Python scripts that overwrite their published KPI CSVs, nor does it claim a native Power BI/Tableau dashboard was programmatically rendered.

## Integrity and provenance controls

`tools/validate_bi.py` fails on broken star-schema keys, invalid values and impossible domain relations. The generated `reports/bi-validation.json` is uploaded to [GitHub Actions](../.github/workflows/validate-bi.yml), with source-specific calculated/published comparisons and fact grain notes. It is an **offline source audit**, not production business intelligence validation.

`tests/test_bi_evidence.py` checks negative cases, SQLite parsing of five schema definitions, and exact field-by-field parity between the published CSVs and the HTML explorer. Source-backed charts keep each project's units and time periods separate, and never combine project results as a single financial entity.

CI runs pandas and NumPy at pinned versions, Python 3.11 and 3.12, plus a full-history Gitleaks credential scan with a checksum-verified binary. The whole Git history is scanned; no cloud credentials are needed. Nothing writes to the protected `main` branch. Record the actual GitHub Actions run outcome before claiming it passed.

## Research, impact and visual limitations

All five projects are simulated portfolio scenarios. Descriptions such as proposed conversion lifts, projected incremental revenue or cost savings are modeled *opportunities*, not actual verified company impact. Historical periods and source granularity differ between projects; don't compare without defining matching units and denominators.

Next improvements: validate the remaining published KPI formulas and advanced SQL with a compatible SQL engine; measure DAX/Power BI/TWBX calculation parity using native BI tooling; add aggregate breakdown-to-fact reconciliations; test dashboards with keyboard and screen readers; and document sample generation, period completeness and data freshness. Manual browser review is not replaced by static HTML assertions.
