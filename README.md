<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:F97316,100:7C3AED&height=210&section=header&text=E-Commerce%20Customer%20Churn%20Analysis&fontSize=36&fontColor=ffffff&desc=SQL%20%7C%20MySQL%20%7C%20Customer%20Analytics&descAlignY=66" alt="E-Commerce Customer Churn Analysis banner" />

![SQL](https://img.shields.io/badge/Language-SQL-2563EB?logo=databricks&logoColor=white)
![MySQL](https://img.shields.io/badge/Database-MySQL-F97316?logo=mysql&logoColor=white)
![Domain](https://img.shields.io/badge/Domain-E--Commerce-7C3AED)
![Focus](https://img.shields.io/badge/Focus-Customer%20Churn-DB2777)
![EDA](https://img.shields.io/badge/Analysis-EDA%20%26%20Joins-0D9488)
![License](https://img.shields.io/badge/license-MIT-16A34A)

**Finding out why customers leave, and where the friction is.**

👉 **[Read the project documentation (PDF)](./docs/ECommerce_Customer_Churn_Analysis_Project_Documentation.pdf)**

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
| 🔎 [02_ecomm_data_exploration.sql](./02_ecomm_data_exploration.sql) | Exploratory queries, behaviour metrics, returns logging and relational joins |
| 📄 [Project Documentation (PDF)](./docs/ECommerce_Customer_Churn_Analysis_Project_Documentation.pdf) | Complete project overview and analysis details |

---

## 🛠️ Implementation Workflow

### 1. Data Cleaning 🧹

**Missing value imputation**

| Method | Columns |
|--------|---------|
| Rounded mean (continuous) | `WarehouseToHome`, `HourSpendOnApp`, `OrderAmountHikeFromlastYear`, `DaySinceLastOrder` |
| Mode (discrete) | `Tenure`, `CouponUsed`, `OrderCount` |

**Outlier removal:** records with a `WarehouseToHome` distance greater than 100 km were removed.

**Categorical standardisation**

| Original value | Standardised to |
|----------------|-----------------|
| `Phone`, `Mobile` | `Mobile Phone` (login device and category columns) |
| `COD` | `Cash on Delivery` |
| `CC` | `Credit Card` |

### 2. Data Transformation ⚙️

| Task | What was done |
|------|---------------|
| **Column renaming** | `PreferedOrderCat` → `PreferredOrderCat`, `HourSpendOnApp` → `HoursSpentOnApp` |
| **New feature** | `ComplaintReceived` (`Yes` / `No`) created from the binary `Complain` flag |
| **New feature** | `ChurnStatus` (`Churned` / `Active`) created from the binary `Churn` flag |
| **Schema clean-up** | Dropped the old `Churn` and `Complain` columns |

### 3. Data Exploration & Analytical Findings 📊

| Area | What was looked at |
|------|--------------------|
| 📉 **Attrition baseline** | Breakdown of churned and active customers |
| 😟 **Service friction** | Percentage of churned customers who had registered a complaint |
| 🛍️ **Category breakdown** | High-risk product categories (for example *Laptop & Accessory* and *Mobile Phone*) across city tiers and demographics |
| 🚚 **Warehouse distance** | Customers grouped from `Very Close Distance` (5 km or less) to `Far Distance` (over 15 km), with churn checked in each group |
| 🔁 **Post-purchase behaviour** | `customer_returns` joined with customer profiles to see return patterns among churned and complaining customers |

---

## 🎯 Skills Shown in This Project

| Area | What it covers |
|------|----------------|
| **Data cleaning** | Imputation with mean and mode, outlier removal, standardising categories |
| **Feature engineering** | Turning binary flags into readable status columns |
| **SQL analysis** | Aggregation, grouping, segmentation and relational joins |
| **Business thinking** | Linking churn to complaints, product categories, distance and returns |

---

## 🚀 Getting Started

**You need:** MySQL Server 8.0+ or MySQL Workbench.

```bash
git clone https://github.com/AnsaniaSalam/ecommerce-customer-churn-analysis.git
cd ecommerce-customer-churn-analysis
mysql -u root -p < 01_ecomm_data.sql
mysql -u root -p < 02_ecomm_data_exploration.sql
```

Run the files in this order. The first one builds and cleans the data, and the second one explores it.

---

## 👤 Author

**Ansania Salam**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Ansania%20Salam-0A66C2?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ansania-salam)
[![GitHub](https://img.shields.io/badge/GitHub-AnsaniaSalam-181717?logo=github&logoColor=white)](https://github.com/AnsaniaSalam)

---

## ⚖️ License

This project is licensed under the **MIT License**. See the [LICENSE](./LICENSE) file for details.

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:7C3AED,100:F97316&height=100&section=footer" alt="footer" />
