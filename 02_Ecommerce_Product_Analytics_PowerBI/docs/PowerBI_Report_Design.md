# Power BI Report Design

## Page 1 — Executive Overview
Cards: Revenue, Sessions, Orders, Conversion, AOV, Return Rate.
Visuals: monthly revenue trend, traffic-source revenue, device conversion, AOV by source.
Slicers: Date, Device, Traffic Source.

## Page 2 — Device Experience
Sessions, orders, conversion, revenue/session, AOV, weighted bounce, return rate by device.
Use a diagnostic matrix for Device × Traffic Source.

## Page 3 — Acquisition Quality
Revenue, orders, conversion, AOV, revenue/session, bounce and returns by source.
Rank sources by commercial quality—not sessions alone.

## Page 4 — Conversion Diagnostics
Observed Session → Order conversion, conversion gaps, high-volume/low-conversion segments, relative-lift scenario cards.

## Page 5 — Time Trends
Monthly/quarterly/yearly revenue, sessions, orders, conversion, AOV, YoY revenue and conversion changes.

## Interaction Standards
- Sync Date/Device/Source slicers.
- Use explicit measures.
- Mark Dim_Date as date table.
- Sort MonthName by Month.
- Use drillthrough from acquisition source to device detail.
- Add tooltip pages with conversion, AOV, bounce and return context.
