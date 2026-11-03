"""Synthetic edge fixtures for the independent month-level ecommerce diagnostics."""
import unittest

import pandas as pd

from tools.ecommerce_trends import summarize_ecommerce


def rows():
    return pd.DataFrame([
        {"Date": "2025-01-03", "Device": "Mobile", "TrafficSource": "Organic",
         "Sessions": 100, "Orders": 10, "Revenue": 1000, "Returns": 1, "BounceRate": .20},
        {"Date": "2025-01-04", "Device": "Desktop", "TrafficSource": "Email",
         "Sessions": 10, "Orders": 2, "Revenue": 100, "Returns": 0, "BounceRate": .80},
        {"Date": "2025-02-02", "Device": "Mobile", "TrafficSource": "Paid",
         "Sessions": 200, "Orders": 20, "Revenue": 2000, "Returns": 2, "BounceRate": .40},
        {"Date": "2025-04-02", "Device": "Desktop", "TrafficSource": "Paid",
         "Sessions": 50, "Orders": 0, "Revenue": 0, "Returns": 0, "BounceRate": .10},
    ])


class EcommerceMonthlyTests(unittest.TestCase):
    def test_sum_then_divide_not_unweighted_row_average(self):
        periods = summarize_ecommerce(rows())
        self.assertEqual([x["month"] for x in periods],
                         ["2025-01", "2025-02", "2025-04"])
        self.assertEqual(periods[0]["sessions"], 110)
        self.assertEqual(periods[0]["orders"], 12)
        self.assertAlmostEqual(periods[0]["conversion_rate"], 12 / 110)
        self.assertAlmostEqual(periods[0]["weighted_bounce_rate"], (100*.2+10*.8)/110)
        self.assertAlmostEqual(periods[0]["return_rate"], 1/12)

    def test_month_over_month_change_only_for_adjacent_months(self):
        jan, feb, apr = summarize_ecommerce(rows())
        self.assertIsNone(jan["revenue_mom_change"])
        self.assertTrue(feb["contiguous_with_previous_month"])
        self.assertAlmostEqual(feb["revenue_mom_change"], (2000-1100)/1100)
        self.assertFalse(apr["contiguous_with_previous_month"])
        self.assertIsNone(apr["revenue_mom_change"])

    def test_zero_denominators_return_null_not_infinite_metrics(self):
        frame = rows().iloc[[0]].copy()
        frame.loc[:, ["Sessions", "Orders", "Returns", "Revenue"]] = 0
        result = summarize_ecommerce(frame)[0]
        for field in ("conversion_rate", "return_rate", "weighted_bounce_rate",
                      "revenue_per_session", "revenue_mom_change"):
            self.assertIsNone(result[field])

    def test_funnel_and_invalid_numeric_values_are_rejected(self):
        for name, invalid in (("Orders", 999), ("Returns", 999),
                              ("Sessions", -1), ("BounceRate", 1.1),
                              ("Revenue", float("inf")), ("Orders", 1.25)):
            with self.subTest(field=name, invalid=invalid):
                frame = rows().copy()
                frame.loc[0, name] = invalid
                with self.assertRaises(ValueError):
                    summarize_ecommerce(frame)

    def test_invalid_dates_or_schema_are_rejected(self):
        frame = rows()
        frame.loc[0, "Date"] = "not-a-date"
        with self.assertRaisesRegex(ValueError, "Date"):
            summarize_ecommerce(frame)
        with self.assertRaises(ValueError):
            summarize_ecommerce(rows().drop(columns=["Sessions"]))


if __name__ == "__main__":
    unittest.main()
