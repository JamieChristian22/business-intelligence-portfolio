# Source Provenance

This upgrade uses the actual public GitHub project source files:
- `Dim_Customer.csv`: **9,500 rows**
- `Dim_Plan.csv`: **3 rows**
- `Fact_Daily_Events.csv`: **805,200 rows**

GitHub also lists the packaged Tableau workbook `Dashboard.twbx` in the project root. The generated upgrade package does not fabricate or replace that binary workbook; preserve the repository's existing workbook when merging this folder.
