#!/usr/bin/env python3
"""Browser smoke for the offline five-project business intelligence explorer."""
from pathlib import Path
from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "reports"


def expect(condition, message):
    if not condition:
        raise AssertionError(message)


def main():
    OUT.mkdir(exist_ok=True)
    errors = []
    with sync_playwright() as pw:
        browser = pw.chromium.launch(headless=True)
        page = browser.new_page(viewport={"width": 1280, "height": 850})
        page.on("pageerror", lambda error: errors.append(str(error)))
        page.route("http://**/*", lambda route: route.abort())
        page.route("https://**/*", lambda route: route.abort())
        page.goto((ROOT / "demo/bi-evidence-explorer.html").as_uri())
        expect(page.locator("#project option").count() == 5, "Five projects not shown")
        expect(page.locator("#kpis .kpi").count() == 7, "Sales KPI values not rendered")
        expect(page.locator("#chart .bar-row").count() > 0, "First source chart empty")
        page.select_option("#project", index=1)
        expect(page.locator("#kpis .kpi").count() == 9, "Ecommerce project switch failed")
        page.fill("#filter", "UNMATCHED-KPI-TEST")
        expect(page.get_by_text("No matching metrics.").count() == 1,
               "No-results KPI state missing")
        page.fill("#filter", "")
        page.select_option("#measure", index=1)
        expect(page.locator("#chart .bar-row").count() > 0, "Metric switching failed")
        page.locator("#project").focus()
        page.keyboard.press("Tab")
        expect(page.evaluate("document.activeElement.id") == "measure",
               "Keyboard control order invalid")
        page.screenshot(path=str(OUT / "bi-desktop.png"), full_page=True)
        page.set_viewport_size({"width": 390, "height": 844})
        expect(not page.evaluate(
            "document.documentElement.scrollWidth > window.innerWidth + 2"
        ), "Mobile horizontal overflow")
        page.screenshot(path=str(OUT / "bi-mobile.png"), full_page=True)
        expect(not errors, "Browser JS errors: " + "; ".join(errors))
        browser.close()
    print("PASS: BI explorer project/metric/filter controls and mobile layout")


if __name__ == "__main__":
    main()
