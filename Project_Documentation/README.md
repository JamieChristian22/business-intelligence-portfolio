# 🧠 Business Intelligence Project Documentation

[![Status](https://img.shields.io/badge/Status-Active-brightgreen)]()
[![Author](https://img.shields.io/badge/Author-Jamie%20Christian-blue)]()
[![Updated](https://img.shields.io/badge/Last%20Updated-Oct%202025-lightgrey)]()

This folder contains the **core documentation** for the Business Intelligence (BI) Performance Dashboard project — including stakeholder requirements, detailed system specifications, and the long-term BI strategy framework.

Each document follows **enterprise-grade formatting** aligned with industry best practices (Gartner BI lifecycle, Kimball dimensional modeling, and Microsoft BI standards).

---

## 📄 Document Index

| # | Document | Description |
|---|-----------|--------------|
| 1️⃣ | [**Stakeholder Requirements Document (SRD)**](./Stakeholder_Requirements_Document.md) | Captures stakeholder needs, business goals, KPIs, and success metrics prior to design. |
| 2️⃣ | [**Project Requirements Document (PRD)**](./Project_Requirements_Document.md) | Defines technical requirements, data model, ETL workflow, and acceptance criteria. |
| 3️⃣ | [**BI Strategy Document**](./BI_Strategy_Document.md) | Outlines enterprise data strategy, governance, roadmap, and continuous improvement plan. |

---

## 🧭 Document Relationships

```mermaid
flowchart LR
    A[Stakeholder Requirements Document] --> B[Project Requirements Document]
    B --> C[BI Strategy Document]
    B --> D[ERD & Data Model Artifacts]
    D --> E[Power BI Dashboards]
