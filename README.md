# 🛒 E-Commerce Customer Churn Analysis

[![SQL](https://img.shields.io/badge/Language-SQL-blue.svg)](https://en.wikipedia.org/wiki/SQL)
[![Database](https://img.shields.io/badge/Database-MySQL-orange.svg)](https://www.mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📌 Executive Summary

In the highly competitive e-commerce sector, understanding customer attrition is critical for maintaining profitability and long-term customer relationships[cite: 3]. Retaining existing customers is significantly more cost-effective than acquiring new ones[cite: 3]. 

This project explores historical transactional and behavioral data from the `ecomm` database to investigate churn patterns, identify operational friction points, and provide actionable insights for targeted customer retention strategies[cite: 3].

---

## 👨‍💻 Project Information

* **Author:** Ansania Salam[cite: 3]
* **Domain:** E-Commerce / Customer Analytics[cite: 3]
* **Database Management System:** MySQL / RDBMS[cite: 3]
* **Core Analytics:** Data Cleaning, Feature Engineering, Exploratory Data Analysis (EDA), Relational Joins[cite: 3]

---

## 📂 Repository Structure
### 🔗 File Links

* [01_ecomm_data.sql](./01_ecomm_data.sql) — Database creation, raw data insertion, missing value imputation, outlier handling, and schema transformations[cite: 3].
* [02_ecomm_data_exploration.sql](./02_ecomm_data_exploration.sql) — Exploratory queries, behavioral metrics, returns logging, and relational joins[cite: 3].
* [Project Documentation (PDF)](./docs/ECommerce_Customer_Churn_Analysis_Documentation.pdf) — Complete project overview and analytical details.

---

## 🛠️ Implementation Workflow

### 1. Data Cleaning 🧹
* **Missing Value Imputation:**
  * Imputed missing values using rounded means for continuous variables (`WarehouseToHome`, `HourSpendOnApp`, `OrderAmountHikeFromlastYear`, and `DaySinceLastOrder`)[cite: 3].
  * Imputed missing values using mode for discrete variables (`Tenure`, `CouponUsed`, and `OrderCount`)[cite: 3].
* **Outlier Removal:** Removed records with `WarehouseToHome` distance values greater than 100 km[cite: 3].
* **Categorical Standardization:** 
  * Replaced `"Phone"` and `"Mobile"` with `"Mobile Phone"` in login device and category columns[cite: 3, 4].
  * Standardized payment modes: replaced `"COD"` with `"Cash on Delivery"` and `"CC"` with `"Credit Card"`[cite: 3, 4].

### 2. Data Transformation ⚙️
* **Column Renaming:** Standardized `PreferedOrderCat` to `PreferredOrderCat` and `HourSpendOnApp` to `HoursSpentOnApp`[cite: 4].
* **Feature Engineering:**
  * Created `ComplaintReceived` (`"Yes"` / `"No"`) from the binary `Complain` flag[cite: 4].
  * Created `ChurnStatus` (`"Churned"` / `"Active"`) from the binary `Churn` flag[cite: 4].
* **Schema Optimization:** Dropped redundant legacy columns `Churn` and `Complain`[cite: 4].

### 3. Data Exploration & Analytical Findings 📊
* **Attrition Baseline:** Evaluated customer breakdown between churned and active users[cite: 4].
* **Service Friction:** Quantified the exact percentage of churned customers who registered prior complaints[cite: 4].
* **Category Breakdown:** Identified high-risk product categories (e.g., *Laptop & Accessory*, *Mobile Phone*) across city tiers and demographics[cite: 4].
* **Warehouse Proximity Analysis:** Segmented distance from warehouse to customer homes (`Very Close Distance` $\le$ 5 km to `Far Distance` > 15 km) and analyzed churn distribution across each category[cite: 4].
* **Post-Purchase Analysis:** Integrated `customer_returns` data with customer profiles to identify return patterns among churned and complaining customers[cite: 4].

---

## 🚀 Getting Started

### Prerequisites
* MySQL Server 8.0+ or MySQL Workbench installed.

### Execution Steps
1. Clone the repository:
   ```bash
   git clone [https://github.com/AnsaniaSalam/ecommerce-customer-churn-analysis.git](https://github.com/AnsaniaSalam/ecommerce-customer-churn-analysis.git)
   cd ecommerce-customer-churn-analysis
   mysql -u root -p < 01_ecomm_data.sql
   mysql -u root -p < 02_ecomm_data_exploration.sql
