<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:F97316,100:7C3AED&height=210&section=header&text=E-Commerce%20Customer%20Churn%20Analysis&fontSize=36&fontColor=ffffff&desc=SQL%20%7C%20MySQL%20%7C%20Customer%20Analytics&descAlignY=66" alt="E-Commerce Customer Churn Analysis banner" />

![SQL](https://img.shields.io/badge/Language-SQL-2563EB?logo=databricks&logoColor=white)
![MySQL](https://img.shields.io/badge/Database-MySQL-F97316?logo=mysql&logoColor=white)
![Domain](https://img.shields.io/badge/Domain-E--Commerce-7C3AED)
![Focus](https://img.shields.io/badge/Focus-Customer%20Churn-DB2777)
![EDA](https://img.shields.io/badge/Analysis-EDA%20%26%20Joins-0D9488)
![License](https://img.shields.io/badge/license-MIT-16A34A)

**Finding out why customers leave, and where the friction is.**

👉 **[Read the project documentation (PDF)](./ECommerce_Customer_Churn_Analysis_Project_Documentation.pdf)**

</div>

---

## 📌 Executive Summary

In e-commerce, understanding why customers leave is key to staying profitable and keeping long-term relationships. Retaining existing customers costs far less than acquiring new ones.

This project explores transactional and behavioural data from the `ecomm` database to look at churn patterns, find where the service causes friction, and suggest where retention efforts should go.

---

## 🧾 Project at a Glance

| | |
|---|---|
| 👩‍💻 **Author** | Ansania Salam |
| 🛒 **Domain** | E-Commerce / Customer Analytics |
| 🗄️ **Database** | MySQL / RDBMS (`ecomm` database) |
| 🔧 **Core work** | Data Cleaning · Feature Engineering · Exploratory Data Analysis (EDA) · Relational Joins |

---

## 🗺️ Project Flow

```mermaid
flowchart LR
    A["📥 Raw Data<br/>ecomm database"] --> B["🧹 Data Cleaning<br/>missing values, outliers"]
    B --> C["⚙️ Transformation<br/>renaming, new features"]
    C --> D["📊 Exploration<br/>churn, complaints, returns"]
    D --> E["💡 Insights<br/>for retention"]

    style A fill:#FED7AA,stroke:#EA580C,color:#431407
    style B fill:#FEF08A,stroke:#CA8A04,color:#422006
    style C fill:#BBF7D0,stroke:#16A34A,color:#052E16
    style D fill:#BFDBFE,stroke:#2563EB,color:#172554
    style E fill:#DDD6FE,stroke:#7C3AED,color:#2E1065
```

---

## 📂 Repository Structure

| File | What's inside |
|------|---------------|
| 📝 [01_ecomm_data.sql](./01_ecomm_data.sql) | Database creation, raw data insertion, missing value imputation, outlier handling and schema changes |
| 🔎 [02_ecomm_data_exploration.sql](./02_ecomm_d
