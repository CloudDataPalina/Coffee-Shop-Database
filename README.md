# ☕️ Coffee Shop Database 
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![PostgreSQL 16](https://img.shields.io/badge/PostgreSQL-16-336791?logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Codespaces: ready](https://img.shields.io/badge/Codespaces-ready-24292e?logo=github)](https://docs.github.com/codespaces)
![status](https://img.shields.io/badge/status-passed-brightgreen)

### ✅ Project Status
This project is **functionally complete and tested**, but **open for future improvements and enhancements**.

Welcome! This is a mini-project showcasing relational modeling and cross-DB integrations:  
**ERD → DDL → data → views → CSV exports → import into MySQL and IBM Db2.**

**What’s inside the repository:**
- 🗺️ ERD & database schema: [`src/GeneratedScript.sql`](src/GeneratedScript.sql)
- 🐘 PostgreSQL demo data & views (incl. a materialized view): [`src/CoffeeData.sql`](src/CoffeeData.sql), [`src/views.sql`](src/views.sql)
- 🔁 CSV exports for external systems: [`data/`](data)
- 🐬 MySQL & 🟦 Db2 imports (with screenshots): [`images/`](images)
- 🧪 Sample analytical queries: [`src/demo_queries.sql`](src/demo_queries.sql)

---
## 🚀 One-command run (GitHub Codespaces)

No local setup, no passwords — Docker runs inside Codespaces.

```bash
git pull
chmod +x run_all.sh
./run_all.sh
```
Clean start (optional): recreate the container from scratch

```bash
./run_all.sh --reset
# manual equivalent: docker rm -f coffee_pg && ./run_all.sh

```
---

## 🧰 Skills & Tools
- **PostgreSQL 16** — tables, PK/FK, views, and a materialized view  
- **SQL (DDL/DML, PL/pgSQL)** — schema, demo data load, `REFRESH MATERIALIZED VIEW`  
- **CSV / COPY** — exporting views for integrations  
- **psql & pgAdmin 4** — administration, ERD (model built in pgAdmin)  
- **GitHub Codespaces** — reproducible run with no local setup  
- **MySQL** — CSV import (phpMyAdmin/CLI)  
- **IBM Db2 on Cloud** — Load Data import, optional DDL

---

## 🎯 Project Goal

Demonstrate the full lifecycle of building a relational database for a coffee shop chain and exchanging data across RDBMS:
- analyze sources and **identify entities/attributes**;
- normalize (incl. **2NF**), design **ERD**, define keys/relationships;
- generate **DDL** and load **demo data**;
- create **views** and a **materialized view** for operational/marketing needs;
- **export CSV** and import into **MySQL** and **IBM Db2**;
- ensure reproducibility with SQL scripts and clear screenshots.

Outcome: a portfolio-ready repository that anyone can use to spin up the schema, load data, and repeat integrations.

---

## Repository Structure

```
Coffee-Shop-Database/
├── data/
│ ├── staff_locations_view.csv                 ← CSV from a view for external systems (MySQL/Db2)
│ └── product_info_m-view.csv                  ← CSV from materialized view for marketing
│
├── docs/
│ └── README_RU.md                             ← Russian documentation (this project’s RU version)
│
├── images/
│ ├── 01_dataset_overview.png                  ← source tables/data overview
│ ├── 02_erd_relationships.png                 ← ERD: relationships (sales_detail↔sales_transaction, product↔product_type)
│ ├── 03_postgresql_staff_locations_view.png   ← staff_locations_view in pgAdmin
│ ├── 04_postgresql_product_info_m_view.png    ← materialized view in pgAdmin
│ ├── 05_mysql_staff_locations_table.png       ← table after CSV import in MySQL
│ ├── 06_mysql_product_info_table.png          ← product_info_m_view CSV preview in MySQL
│ ├── 07_db2_load_success.png                  ← successful Load Data in IBM Db2
│ └── 08_db2_staff_locations_table.png         ← table in Db2 after load
│
├── output/
│ ├── db2_staff_locations_ddl.sql              ← (opt.) Db2 DDL for STAFF_LOCATIONS
│ └── mysql_staff_locations.sql                ← (opt.) MySQL dump of staff_locations
│
├── src/
│ ├── GeneratedScript.sql                      ← DDL: tables & relationships (generated from pgAdmin ERD)
│ ├── CoffeeData.sql                           ← demo data (pg_dump)
│ ├── views.sql                                ← staff_locations_view + product_info_m_view
│ └── demo_queries.sql                         ← 3–5 sample SELECTs
│
├── run_all.sh                                 ← one-command bootstrap/run script
├── LICENSE
└── README.md                                  ← this file (EN)
```

---

### 🗺️ 1) What’s in the DB

Core tables *(see ERD →* [`images/02_erd_relationships.png`](images/02_erd_relationships.png)*)*:

- `product`, `product_type` — product catalog and types  
- `sales_transaction`, `sales_detail` — sales (header + line items)  
- `staff`, `sales_outlet`, `customer` — people, outlets, customers  

**Views:**

- `staff_locations_view` — a slim “employee → location” feed for external systems (MySQL/Db2)  
- `product_info_m_view` — **materialized view** with product + category (for analytics/marketing)

Validation screenshots:  
[`03_postgresql_staff_locations_view.png`](images/03_postgresql_staff_locations_view.png) • [`04_postgresql_product_info_m_view.png`](images/04_postgresql_product_info_m_view.png)

---

### 🐘 2) Quick Start (PostgreSQL)

**Requirements:** PostgreSQL 13+ and/or pgAdmin 4.

1. Create an empty DB (e.g., `coffee`).  
2. Apply DDL: [`src/GeneratedScript.sql`](src/GeneratedScript.sql) — creates tables & FKs.  
3. Load data: [`src/CoffeeData.sql`](src/CoffeeData.sql).  
4. Create views: [`src/views.sql`](src/views.sql).  
   If `product_info_m_view` was created `WITH NO DATA`, run:

   ```sql
   REFRESH MATERIALIZED VIEW public.product_info_m_view;
   ```
5. Quick checks:

   ```sql
   SELECT * FROM public.staff_locations_view LIMIT 10;
   SELECT * FROM public.product_info_m_view  LIMIT 10;
   ```
6. **Sample queries:** [`src/demo_queries.sql`](src/demo_queries.sql)
*(top products, sales by outlet, etc.).*

---

### 🔁 3) Exports & Integrations

**MySQL 🐬**

- **Quick path:** import [`data/staff_locations_view.csv`](data/staff_locations_view.csv)
  into table `staff_locations` *(phpMyAdmin → Import)*.
- **Alternative:** run the ready-made dump
  [`output/mysql_staff_locations.sql`](output/mysql_staff_locations.sql).

Screenshots:
[`05_mysql_staff_locations_table.png`](images/05_mysql_staff_locations_table.png) •
[`06_mysql_product_info_table.png`](images/06_mysql_product_info_table.png)

**IBM Db2 on Cloud 🟦**

- **Load Data** → source **My Computer** → file
  [`data/staff_locations_view.csv`](data/staff_locations_view.csv).
  Target: new table `STAFF_LOCATIONS`.
  Proof:
  [`07_db2_load_success.png`](images/07_db2_load_success.png) •
  [`08_db2_staff_locations_table.png`](images/08_db2_staff_locations_table.png)
- *(Optional)* pre-create the table with:
  [`output/db2_staff_locations_ddl.sql`](output/db2_staff_locations_ddl.sql).

---

### 💾 4) How `data/*.csv` were produced

- [`staff_locations_view.csv`](data/staff_locations_view.csv) — `SELECT` from `staff_locations_view`.
- [`product_info_m-view.csv`](data/product_info_m-view.csv) — export from `product_info_m_view`
  *(after `REFRESH MATERIALIZED VIEW`)*.

The `data/` folder contains import-ready CSVs so anyone can quickly repeat the MySQL/Db2 steps.

---

### 🖼️ 5) Screenshot Navigator

- [`01_dataset_overview.png`](images/01_dataset_overview.png) — overview of source tables/fields  
- [`02_erd_relationships.png`](images/02_erd_relationships.png) — ERD relationships  
- [`03_postgresql_staff_locations_view.png`](images/03_postgresql_staff_locations_view.png) — PostgreSQL: `staff_locations_view`  
- [`04_postgresql_product_info_m_view.png`](images/04_postgresql_product_info_m_view.png) — PostgreSQL: `product_info_m_view` (materialized)  
- [`05_mysql_staff_locations_table.png`](images/05_mysql_staff_locations_table.png) — MySQL: imported `staff_locations`  
- [`06_mysql_product_info_table.png`](images/06_mysql_product_info_table.png) — MySQL: `product_info_m_view` CSV preview  
- [`07_db2_load_success.png`](images/07_db2_load_success.png) — IBM Db2: successful **Load Data**  
- [`08_db2_staff_locations_table.png`](images/08_db2_staff_locations_table.png) — IBM Db2: `STAFF_LOCATIONS` table

---

### ♻️ 6) Repeatability & Notes

- Scripts in `src/` are self-contained: **DDL → data → views → demo queries**.  
- Exports in `data/` are synchronized with the views.  
- Filenames in `images/` reflect the step order — the repository reads “top to bottom.”

---

## ✅ Outcome

- A complete **relational model** (PK/FK, `1–N` relationships) and **ERD**.  
- Loaded **demo data** for reproducible examples.  
- Two views: `staff_locations_view` (operational) and `product_info_m_view` (materialized, analytical).  
- Ready-to-share **CSV** for external systems.  
- Verified **imports into MySQL and IBM Db2** (scripts + screenshots).  
- A set of **demo queries** for quick analytical checks.

---

### 📜 License

This project is released under the **MIT License** — see [`LICENSE`](LICENSE).  

***Enjoy and have a great data brew*** ☕️🙂

---

## 👩‍💻 Author

**Palina Krasiuk**  
Aspiring Cloud Data Engineer | ex-Senior Accountant  
[LinkedIn](https://www.linkedin.com/in/palina-krasiuk-954404372/) • [GitHub Portfolio](https://github.com/CloudDataPalina)


