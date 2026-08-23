# Source Provenance

The upgrade is grounded in the public repository source files:
- `Fact_Web_Analytics.csv`: 10,950 rows, 2024-02-26 through 2026-02-24
- `Dim_ProductCategory.csv`: 5 category reference rows

Derived Date, Device, and Traffic Source dimensions are generated deterministically from the fact table.

The original repository also contains `Dashboard.pbix`. The execution environment used to assemble this ZIP could inspect its GitHub presence but could not retrieve the binary PBIX payload through the file-transfer layer. No fake PBIX file has been created.
