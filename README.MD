
# 🎵 Chinook Data Warehouse - ODI ETL Solution

> **University Project** - BUT SD (Bachelor Universitaire de Technologie - Statistique et Informatique Décisionnelle)

A complete data warehouse implementation transforming the Chinook music database into a star schema for business intelligence using Oracle Data Integrator. Developed as part of the Statistics and Business Intelligence curriculum.

## 🎓 Academic Context

**Course:** Data Warehousing & ETL Processes  
**Program:** BUT SD - Statistics and Business Intelligence  
**University:** Bachelor Universitaire de Technologie  
**Focus:** Real-world ETL pipeline development and dimensional modeling

## 🚀 Quick Overview

- **Source:** Chinook OLTP Database
- **ETL Tool:** Oracle Data Integrator (ODI)
- **Target:** Star Schema Data Warehouse
- **Business Value:** Music sales analytics and customer insights

## 📊 Data Model

### Star Schema Design
```
fact_invoice_line (Grain: per invoice line item)
├── dim_customer      (Customer details)
├── dim_employee      (Sales representatives)  
├── dim_track         (Music tracks with artist/album)
├── dim_date          (Time dimensions)
└── bridge_playlist   (Playlist-track relationships)
```

## 🛠️ ODI Components

### Packages
- `LOAD_DIMENSIONS` - Dimension table loading
- `LOAD_FACT_TABLES` - Fact table ETL processes  
- `DAILY_ETL_FLOW` - Complete daily execution workflow

### Key Interfaces
- `INT_DIM_CUSTOMER` - Customer dimension mapping
- `INT_DIM_TRACK` - Track dimension with artist/album data
- `INT_FACT_SALES` - Sales fact table transformations

## 📈 Business Insights

This solution enables:
- Sales performance by artist and genre
- Customer purchasing behavior analysis  
- Employee sales performance tracking
- Geographic sales distribution

## 🗂️ Project Structure

```
📁 odi-workflows/     # ODI package and interface exports
📁 sql-scripts/       # DDL and sample queries  
📁 documentation/     # Architecture and design docs
📁 results/          # Sample outputs and dashboards
```

## 🚀 Getting Started

1. Import ODI artifacts into your ODI workspace
2. Execute `sql-scripts/ddl-schema.sql` to create target tables
3. Run packages in sequence: Dimensions → Facts
4. Use sample queries for validation and analysis

## 💡 Skills Demonstrated

- Oracle Data Integrator (ODI) development
- Star schema dimensional modeling
- ETL workflow orchestration
- Data quality and validation
- Business intelligence solutions

---

*Academic project showcasing real-world ETL development - part of the BUT SD Statistics and Business Intelligence program.*
```
