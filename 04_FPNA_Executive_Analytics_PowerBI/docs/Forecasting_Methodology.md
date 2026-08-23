# Forecasting Methodology

## Method
The upgraded project uses a 3-month rolling average as a simple run-rate forecast.

For each month:
- Expense Run Rate = average of current + prior two months actual expense × 12
- Revenue Run Rate = average of current + prior two months revenue × 12
- COGS Run Rate = average of current + prior two months COGS × 12
- Forecast Operating Profit = Revenue Run Rate - COGS Run Rate - Expense Run Rate

## Why this method
It is transparent, reproducible, and appropriate for a portfolio demonstration without inventing business drivers that are absent from the dataset.

## Limitation
This is not a driver-based forecast. A real corporate forecast would add headcount plans, unit volumes, pricing, contract timing, pipeline, seasonality, and management adjustments.
