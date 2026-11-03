"""Read-only KPI, data-quality and source-parity tests for BI case studies."""
from __future__ import annotations
import csv
import json
import re
import sqlite3
import tempfile
import unittest
from html.parser import HTMLParser
from pathlib import Path
from unittest.mock import patch
import tools.validate_bi as validator
import pandas as pd
from tools.validate_bi import (ROOT,PROJECTS,keys_unique,foreign,bounded,
                               check_published,nonzero,fail)

class DataContracts(unittest.TestCase):
    def test_duplicate_raw_csv_headers_are_rejected_before_pandas_mangling(self):
        with tempfile.TemporaryDirectory() as tmp:
            source = Path(tmp) / "example" / "data" / "Fact_Example.csv"
            source.parent.mkdir(parents=True)
            source.write_text("CustomerID,CustomerID\\n1,2\\n", encoding="utf-8")
            with patch.object(validator, "ROOT", Path(tmp)):
                with self.assertRaisesRegex(ValueError, "duplicate"):
                    validator.data("example", "Fact_Example")

    def test_signed_profit_accepted_but_nonfinite_profit_rejected(self):
        bounded(pd.DataFrame({"Profit": [-12.5, 0.0]}), "Profit", low=-float("inf"))
        with self.assertRaisesRegex(ValueError, "nonfinite"):
            bounded(pd.DataFrame({"Profit": [float("inf")]}), "Profit", low=-float("inf"))

    def test_duplicate_dimension_keys_are_rejected(self):
        f=pd.DataFrame({"ID":[1,1],"Label":["one","two"]})
        with self.assertRaisesRegex(ValueError,"unique"):
            keys_unique(f,"ID","example")
    def test_orphan_fact_keys_are_rejected(self):
        fact=pd.DataFrame({"ID":[1,9]});dim=pd.DataFrame({"ID":[1,2]})
        with self.assertRaisesRegex(ValueError,"orphan"):
            foreign(fact,"ID",dim,"example")
    def test_nonfinite_and_negative_values_rejected(self):
        for x in [-1,float("nan"),float("inf")]:
            with self.subTest(x=str(x)):
                with self.assertRaises(ValueError):
                    bounded(pd.DataFrame({"Revenue":[x]}),"Revenue")
    def test_percentage_bounds_rejected(self):
        with self.assertRaisesRegex(ValueError,"outside"):
            bounded(pd.DataFrame({"BounceRate":[1.01]}),"BounceRate",0,1)
    def test_zero_denominator_rejected(self):
        with self.assertRaisesRegex(ValueError,"zero denominator"):
            nonzero(1,0,"revenue per session")
    def test_wrong_published_kpi_rejected(self):
        name=PROJECTS[0]
        with self.assertRaisesRegex(ValueError,"published"):
            check_published(name,{"Total Revenue":0})
    def test_each_sql_schema_parses_without_running_admin_scripts(self):
        for p in PROJECTS:
            with self.subTest(project=p):
                source=(ROOT/p/"sql/schema.sql").read_text(encoding="utf-8")
                conn=sqlite3.connect(":memory:")
                try:
                    conn.execute("PRAGMA foreign_keys=ON")
                    conn.executescript(source)
                    tables=conn.execute("SELECT name FROM sqlite_master WHERE type='table'").fetchall()
                    self.assertGreaterEqual(len(tables),1)
                finally:
                    conn.close()

SOURCE={
"01_Sales_Performance_Dashboard_PowerBI":"docs/Regional_Performance.csv",
"02_Ecommerce_Product_Analytics_PowerBI":"docs/Monthly_Performance.csv",
"03_Amazon_Marketplace_Analytics_PowerBI":"docs/Monthly_Performance.csv",
"04_FPNA_Executive_Analytics_PowerBI":"docs/Monthly_Financial_Performance.csv",
"05_StreamFlow_SaaS_Product_Analytics_Tableau":"docs/Monthly_Product_Health.csv",
}
HTML=ROOT/"demo/bi-evidence-explorer.html"

class Audit(HTMLParser):
    def __init__(self):
        super().__init__();self.ids=set();self.labels=set();self.external=[]
    def handle_starttag(self,tag,attrs):
        props=dict(attrs)
        if "id" in props:
            if props["id"] in self.ids:raise AssertionError("Duplicate DOM ID")
            self.ids.add(props["id"])
        if tag=="label" and "for" in props:self.labels.add(props["for"])
        if tag=="script" and "src" in props:self.external.append(props["src"])

class InteractiveExplorerTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.html=HTML.read_text(encoding="utf-8")
        m=re.search(r'<script id="evidence" type="application/json">(.*?)</script>',cls.html,re.DOTALL)
        if not m:raise AssertionError("Missing embedded BI source")
        cls.payload=json.loads(m.group(1))

    def test_all_kpis_and_breakdowns_match_canonical_csvs_exactly(self):
        values=self.payload["projects"]
        self.assertEqual(len(values),5)
        for p in values:
            with self.subTest(project=p["id"]):
                for field,path in (("kpis","docs/KPI_Validation_Results.csv"),("series",SOURCE[p["id"]])):
                    with (ROOT/p["id"]/path).open(encoding="utf-8-sig",newline="") as fh:
                        expected=list(csv.DictReader(fh))
                    self.assertEqual(p[field],expected)
                self.assertEqual(p["series_csv"],SOURCE[p["id"]])

    def test_counts_and_source_disclosure(self):
        self.assertEqual([len(x["kpis"]) for x in self.payload["projects"]],[7,9,9,11,18])
        self.assertEqual([len(x["series"]) for x in self.payload["projects"]],[4,25,25,24,13])
        self.assertIn("synthetic",self.payload["source"].lower())
        self.assertIn("not rendered or validated",self.html)

    def test_offline_labels_and_safe_rendering(self):
        audit=Audit();audit.feed(self.html)
        self.assertTrue({"project","measure","filter"}.issubset(audit.ids))
        self.assertTrue({"project","measure","filter"}.issubset(audit.labels))
        self.assertIn('aria-live="polite"',self.html)
        self.assertIn("textContent",self.html)
        self.assertIn("replaceChildren",self.html)
        self.assertNotIn("innerHTML",self.html)
        self.assertNotIn("fetch(",self.html)
        self.assertEqual(audit.external,[])
