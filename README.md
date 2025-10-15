# 📊 Business Intelligence Portfolio — Jamie Christian  

[![License](https://img.shields.io/github/license/JamieChristian22/business-intelligence-portfolio?style=flat-square)](LICENSE)  
[![GitHub stars](https://img.shields.io/github/stars/JamieChristian22/business-intelligence-portfolio?style=flat-square)](https://github.com/JamieChristian22/business-intelligence-portfolio/stargazers)  
[![Last Commit](https://img.shields.io/github/last-commit/JamieChristian22/business-intelligence-portfolio?style=flat-square)](https://github.com/JamieChristian22/business-intelligence-portfolio/commits/main)  

---

## 🚀 Project Overview

This repository is my **Business Intelligence (BI) showcase** — a comprehensive demonstration of end-to-end data modeling, analytics, and reporting using SQL and DAX. The goal is to show how I can ingest raw data, transform it, model it in a star schema, build KPI logic, and integrate with BI tools.

**Key Focus Areas:**
- SQL pipelines to clean, transform, and model data  
- DAX and Power BI / Power Query logic for metrics, KPIs, and visuals  
- Modular design with separate folders for data, SQL, and snippets  
- Clear documentation and reproducibility for professional presentation  

---

## 📁 Repository Structure

| Folder / File | Purpose |
|----------------|----------|
| `data/` | Raw, interim, and processed datasets with documentation |
| `data/sql/` or `02_SQL_Queries/` | SQL scripts for staging, transformations, modeling, and testing |
| `README_Snippets/` | DAX formulas, Power Query M snippets, and calculation references |
| `DAX_Measures.md` | Key DAX measures used in dashboards |
| `Project_Documentation/` | BI design docs, ERDs, architecture diagrams |
| `Data Visualization/` | Dashboard exports and PNG visuals |
| `README.md` | This top-level repository overview |

---

## 📈 Sample Dashboard Example

Here’s a dashboard visual from the **Minnesota Interstate Traffic Volume** project:

![Minnesota Interstate Traffic Volume](https://github.com/JamieChristian22/business-intelligence-portfolio/blob/main/Data%20Visualization/Minnesota%20Interstate%20Traffic%20Volume.png?raw=true)

This visualization showcases traffic trends and volume metrics across interstates — combining data modeling, time-series analysis, and UI-level dashboarding.

---

## 🧰 Tools & Technologies

| Category | Tools / Languages |
|-----------|-------------------|
| Database / ETL | PostgreSQL, SQLite, Power Query |
| Data Visualization | Power BI, Tableau (optional) |
| Modeling / Analytics | SQL, DAX, Excel |
| Documentation | Markdown, Lucidchart, Draw.io |
| Version Control | Git, GitHub |

---

## 🧩 Data Modeling Workflow

1. Load and store raw data in `data/raw/`  
2. Clean and transform using SQL (`staging` and `clean` layers)  
3. Build fact and dimension tables (`mart` layer)  
4. Define KPIs and measures in DAX / Power BI  
5. Assemble dashboards and visuals  
6. Document all workflows in README and Markdown files  

---

## ✅ Best Practices

- Maintain consistent naming conventions: `stg_`, `cln_`, `dim_`, `fact_`  
- SQL scripts prefixed numerically for proper order (`00_`, `10_`, `20_`)  
- Each major folder includes a descriptive `README.md`  
- Dashboards documented with KPIs and metric logic  
- Use synthetic/anonymized data for public sharing  

---

## 👤 About the Author

**Jamie Christian** — Business Intelligence / Data Analyst  
💼 Certified in SQL, Power BI, and Data Analytics (Google & IBM programs).  
🎯 Passionate about turning raw data into actionable insights through analytics, modeling, and visualization.  

🔗 [LinkedIn Profile](https://www.linkedin.com/in/jamiechristiananalytics)  
🔗 [GitHub Portfolio](https://github.com/JamieChristian22)  

---

## 📄 License & Acknowledgments

This project is licensed under the [MIT License](LICENSE).  
Thanks to the open-source BI and analytics community for tools and inspiration.  
