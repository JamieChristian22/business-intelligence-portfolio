"""Recompute month-level ecommerce decision metrics from underlying session facts.

Run: python -m tools.ecommerce_trends --output reports/ecommerce-trends.json
The source dataset is simulated; trend changes are descriptive, not causal.
"""
from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np
import pandas as pd

from .validate_bi import PROJECTS, ROOT, data


def summarize_ecommerce(facts: pd.DataFrame) -> list[dict]:
    """Aggregate ratios using source numerators/denominators, never average rates."""
    columns = {"Date", "Device", "TrafficSource", "Sessions", "Orders",
               "Revenue", "Returns", "BounceRate"}
    if not columns.issubset(facts.columns) or facts.empty:
        raise ValueError("Ecommerce fact table is empty or missing required columns")
    dates = pd.to_datetime(facts["Date"], format="%Y-%m-%d", errors="coerce")
    if dates.isna().any():
        raise ValueError("Invalid ecommerce Date values")
    checked = facts.copy()
    for name in ("Sessions", "Orders", "Revenue", "Returns", "BounceRate"):
        x = pd.to_numeric(checked[name], errors="coerce")
        if x.isna().any() or not np.isfinite(x.to_numpy()).all() or (x < 0).any():
            raise ValueError(f"Invalid or negative ecommerce metric: {name}")
        checked[name] = x
    if (checked["BounceRate"] > 1).any():
        raise ValueError("BounceRate must be between zero and one")
    if (checked["Orders"] > checked["Sessions"]).any() or (checked["Returns"] > checked["Orders"]).any():
        raise ValueError("Ecommerce orders, sessions, and returns violate the funnel contract")
    if ((checked["Sessions"] % 1 != 0) | (checked["Orders"] % 1 != 0)
            | (checked["Returns"] % 1 != 0)).any():
        raise ValueError("Session, order, and return counts must be whole numbers")

    checked["period"] = dates.dt.to_period("M")
    checked["bounce_sessions"] = checked["BounceRate"] * checked["Sessions"]
    totals = checked.groupby("period", sort=True).agg(
        sessions=("Sessions", "sum"),
        orders=("Orders", "sum"),
        revenue=("Revenue", "sum"),
        returns=("Returns", "sum"),
        bounce_sessions=("bounce_sessions", "sum"),
    )
    series = []
    previous = None
    for period, values in totals.iterrows():
        sessions, orders = int(values.sessions), int(values.orders)
        revenue, returns = float(values.revenue), int(values.returns)
        contiguous = bool(previous is not None and period.ordinal == previous["ordinal"] + 1)
        series.append({
            "month": str(period),
            "sessions": sessions,
            "orders": orders,
            "revenue": round(revenue, 2),
            "returns": returns,
            "conversion_rate": orders / sessions if sessions else None,
            "return_rate": returns / orders if orders else None,
            "revenue_per_session": revenue / sessions if sessions else None,
            "weighted_bounce_rate": float(values.bounce_sessions) / sessions if sessions else None,
            "contiguous_with_previous_month": contiguous,
            "revenue_mom_change": (
                (revenue - previous["revenue"]) / previous["revenue"]
                if contiguous and previous["revenue"] else None
            ),
        })
        previous = {"ordinal": period.ordinal, "revenue": revenue}
    return series


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, default=ROOT / "reports/ecommerce-trends.json")
    args = parser.parse_args()
    name = PROJECTS[1]
    series = summarize_ecommerce(data(name, "Fact_Web_Analytics"))
    output = {
        "project": name,
        "source": f"{name}/data/Fact_Web_Analytics.csv",
        "data_kind": "simulated portfolio data",
        "aggregation": "weighted by sessions; non-contiguous months do not receive a monthly comparison",
        "monthly": series,
        "period_count": len(series),
        "limit": "Descriptive trends only. No causal attribution or production claims.",
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(output, indent=2, allow_nan=False) + "\n", encoding="utf-8")
    print(f"Computed {len(series)} monthly ecommerce periods from source fact rows")


if __name__ == "__main__":
    main()
