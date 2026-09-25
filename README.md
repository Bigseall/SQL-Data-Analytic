# SQL Data Analytic And Customer Dashboard

## 📌 Project Overview

This project analyzes sales and customer data from the AdventureWorks database using SQL Server.
The goal is to explore sales performance, customer purchasing behavior, product performance, and customer segmentation through SQL-based analysis.
The project focuses on transforming raw transactional data into meaningful business metrics that can support sales and customer-related decisions.

---

## 🎯 Business Questions

This project answers the following business questions:

### Sales Analysis

* What is the total revenue generated each month?
* How does monthly revenue change compared with the previous month?
* What are the yearly sales trends?
* What is the running total of sales over time?
* How does yearly sales performance compare with the average?

### Product Analysis

* Which product categories generate the highest total sales?
* What percentage of total sales does each category contribute?
* How are products segmented based on their total revenue?
* Which products are classified as High-Value, Mid-Value, and Low-Value?

### Customer Analysis

* How much revenue does each customer generate?
* How many orders does each customer place?
* What is the average order value?
* How much does each customer spend per month?
* How long has each customer been active?
* How can customers be segmented based on revenue and customer lifespan?

---

## 📊 Customer Segmentation

B2C customers are segmented into five groups based on customer lifespan and total revenue.

| Customer Rank | Condition                                |
| ------------- | ---------------------------------------- |
| Platinum      | At least 12 months and spending > 10,000 |
| Gold          | At least 12 months and spending > 5,000  |
| Silver        | At least 12 months and spending > 1,000  |
| Bronze        | At least 12 months and spending <= 1,000 |
| New Customer  | Lifespan < 12 months                     |

---

## 📈 Product Segmentation

Products are categorized based on total revenue:

| Product Tier |    Revenue |
| ------------ | ---------: |
| High Value   | >= 650,000 |
| Mid Value    | >= 120,000 |
| Low Value    |  < 120,000 |

---

## 🧮 Key Metrics

The analysis includes the following metrics:

* **Monthly Revenue**
* **Month-over-Month (MoM) Growth**
* **Yearly Revenue**
* **Running Total Sales**
* **Moving Average**
* **Category Sales Contribution**
* **Product Revenue**
* **Total Customer Revenue**
* **Total Orders**
* **Average Order Value**
* **Average Monthly Spend**
* **Customer Lifespan**
* **Customer Rank**

---

## 🛠️ SQL Skills Demonstrated

This project demonstrates the use of:

* CTEs (`WITH`)
* `JOIN`
* `GROUP BY`
* Aggregate Functions

  * `SUM()`
  * `COUNT()`
  * `AVG()`
  * `MIN()`
  * `MAX()`
* Window Functions

  * `LAG()`
  * `SUM() OVER()`
  * `AVG() OVER()`
* `CASE WHEN`
* Date Functions

  * `YEAR()`
  * `DATEDIFF()`
  * `DATETRUNC()`
* Data aggregation
* Customer segmentation
* Revenue analysis
* SQL Views
* Business-oriented SQL analysis

---

## 👤 Customer Summary View

A SQL View was created to provide a reusable customer-level summary:

`Sales.vCustomerSummaryReport`

The view contains:

* Customer ID
* Full Name
* Country
* Customer Rank
* Total Revenue
* Total Orders
* Average Order Value
* Average Monthly Spend
* First Order Date
* Last Order Date
* Customer Lifespan

This view can be used as a foundation for further customer analysis or dashboard development.

---

## 📊 Power BI Dashboard
<img width="1054" height="592" alt="picdash" src="https://github.com/user-attachments/assets/b43a248b-e21e-40fa-a984-cd77b29cc21e" />

A Power BI dashboard was built on top of `Sales.vCustomerSummaryReport` 
to visualize customer segmentation and revenue insights.

**Includes:**
- KPI cards: Total Revenue, Total Orders, Total Customers, Avg Lifespan
- Customer distribution by rank (Platinum / Gold / Silver / Bronze / 
  New Customer / One Time Purchased)
- Revenue by country
- New customers trend by month
- Customer detail table with drill-down

---

## 🛠️ Tools & Environment
* **Database Engine:** SQL Server (AdventureWorks2025)
* **Language:** T-SQL (Transact-SQL)
* **IDE:** SQL Server Management Studio (SSMS)

---
