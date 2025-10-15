# 📘 Project Requirements Document (PRD)

**Purpose:** Defines BI technical requirements, data models, transformations, and acceptance criteria.

---

## 🧾 Project Summary
| Item | Detail |
|------|--------|
| **Project Name** | BI Performance Dashboard |
| **Business Owner** | VP, Operations |
| **Technical Owner** | BI Developer |
| **Timeline** | Oct 2025 – Jan 2026 |
| **Tools** | Power BI, SQL, Python, Azure, Excel |

---

## 🧱 Functional Requirements
| ID | Requirement | Type | Priority | Acceptance Criteria |
|----|--------------|------|-----------|----------------------|
| FR-01 | Create unified sales dashboard with drill-down | Reporting | High | Dashboard reflects real-time metrics by region & product |
| FR-02 | Connect to SQL + Excel + API data sources | Integration | High | Connections refresh successfully without error |
| FR-03 | Apply role-based access control (RBAC) | Security | Medium | Only authorized users can view sensitive KPIs |
| FR-04 | Export dashboards as PDF | Usability | Low | Users can export KPI snapshots |

---

## ⚙️ Non-Functional Requirements
| ID | Category | Description | Priority |
|----|-----------|-------------|-----------|
| NFR-01 | Performance | Dashboard loads under 10 seconds | High |
| NFR-02 | Data Quality | Missing values <1% | High |
| NFR-03 | Availability | 99.5% uptime | High |
| NFR-04 | Security | Complies with data privacy policy | High |

---

## 🧩 Data Model Requirements
| Table | Source | Key Fields | Relationship | Purpose |
|--------|---------|-------------|---------------|----------|
| fact_sales | SQL Server | order_id, date_key, product_id | date_key → dim_date | Transaction-level metrics |
| dim_date | Power Query | date_key | N/A | Calendar intelligence |
| dim_product | Excel / CSV | product_id, category | product_id | Product metadata |
| dim_customer | CRM API | customer_id | customer_id | Customer demographics |

---

## 🔗 Integration & ETL Flow
| Step | Description | Tool |
|------|--------------|------|
| 1 | Extract raw data from SQL, Excel, API | Power Query |
| 2 | Clean, transform, and normalize datasets | Python / SQL |
| 3 | Load to Power BI data model | Power BI Desktop |
| 4 | Schedule automatic refreshes | Power BI Service |

---

## 🧪 Acceptance Criteria
| Test ID | Validation | Expected Outcome |
|----------|-------------|------------------|
| AC-01 | Validate KPI formulas | Matches finance-approved definitions |
| AC-02 | Validate data refresh | Refresh completes with no failure |
| AC-03 | Validate access controls | Only specific roles view sensitive KPIs |
| AC-04 | Validate visuals | Layout meets design and UX guidelines |
