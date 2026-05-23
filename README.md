# 🚴 Global Bike Retail — Executive Analytics Dashboard

> **Status:** 🚧 In Progress — 2 of 4 dashboard pages completed

A end-to-end data analytics project built on a global bike retail dataset. The project combines **SQL Server** for data exploration and modelling with **Power BI** for executive-level reporting, covering both B2C (internet) and B2B (reseller) sales channels across multiple countries and product categories.

---

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Tech Stack](#tech-stack)
- [Dataset](#dataset)
- [SQL — Data Exploration & Views](#sql--data-exploration--views)
- [Power BI Dashboard](#power-bi-dashboard)
- [Key Findings](#key-findings)
- [Project Structure](#project-structure)
- [Roadmap](#roadmap)

---

## Project Overview

This project analyzes sales performance for a global bicycle retailer, exploring revenue trends, profitability, customer behaviour, and operational metrics. The goal is to deliver a 4-page executive dashboard that enables decision-makers to monitor KPIs, compare sales channels, and identify top-performing products and regions.

**Business Questions addressed:**
- How is overall revenue, profit, and margin trending over time?
- How do B2B (reseller) and B2C (internet) channels compare in margin and average order value?
- Which products drive the most volume vs. the most profit?
- How does performance vary across regions and product categories?

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| **SQL Server** | Data exploration, EDA, view creation |
| **Power BI** | Interactive executive dashboard |
| **T-SQL / Jupyter Notebook** | EDA queries and findings documentation |

---

## Dataset

The source is an **AdventureWorksDW**-style data warehouse with a star schema containing **30 tables** (fact + dimension tables).

| Fact Table | Description | Row Count |
|---|---|---|
| `FactInternetSales` | B2C / direct online sales | 60,398 |
| `FactResellerSales` | B2B / reseller channel sales | 60,855 |
| `FactFinance` | Financial and accounting data | — |
| `FactProductInventory` | Inventory movement | — |

**Date range covered:** December 2010 – January 2014

**Total transaction records:** ~120,000 across both sales channels

---

## SQL — Data Exploration & Views

### Exploratory Data Analysis (`Eda.ipynb`)

EDA was performed in a SQL Jupyter notebook to understand the shape and scope of the data before building the dashboard. Key steps included:

- Counting total tables in the database (30 base tables)
- Validating row counts across both fact tables
- Determining the date range of available data
- Calculating Average Order Value (AOV) per channel
- Ranking top 10 products by order volume, revenue, and profit

### SQL Views (`main_query.sql`)

Clean, reusable views were created to abstract raw table complexity and serve as the data layer for Power BI:

| View | Source Table | Purpose |
|------|-------------|---------|
| `vwDimCustomer` | `DimCustomer` | Customer profile with full name and income |
| `vwDimGeography` | `DimGeography` | City, state, country, and territory |
| `vwDimProduct` | `DimProduct` | Current active products only (`Status = 'Current'`) |
| `vwDimAccount` | `DimAccount` | Account types and descriptions |
| `vwDimReseller` | `DimReseller` | Reseller info with annual sales and revenue |
| `vwFactInternetSales` | `FactInternetSales` | B2C sales transactions |
| `vwFactResellerSales` | `FactResellerSales` | B2B reseller sales transactions |
| `vwFactFinance` | `FactFinance` | Finance fact with key foreign keys and amount |
| `vwFactProductInventory` | `FactProductInventory` | Inventory movement (units in/out/balance) |
| `currency` | `DimCurrency` | Top 15 currencies reference |

---

## Power BI Dashboard

The dashboard is structured into **4 pages**. Filters for **Region**, **Category**, and **Year** are available on all pages.

### ✅ Page 1 — Overview

High-level executive summary of overall business performance.

**KPI Cards:**
- Revenue: **$53.24M** *(▼ 4.6% vs Prior Month | ▼ 38.4% vs Prior Year)*
- COGS: **$46.68M** *(▲ 8.9% vs Prior Month)*
- Orders: **168.58K** *(▼ 3.7% vs Prior Month)*
- Profit: **$6.56M** *(▼ 5.1% vs Prior Month)*
- Margin: **12.32%** *(▲ 7.3% vs Prior Year)*

**Visuals:**
- Operating Profit Over Time (COGS, Total Revenue, Margin trend by month)
- Revenue by Month (bar chart)
- Top Products by Revenue and Profit (table)
- Revenue by Region (treemap — US, Australia, UK, Canada, Germany, France)
- Orders by Category (Accessories 53K, Clothing 45K, Bikes 44K, Components 27K)

---

### ✅ Page 2 — Channel Breakdown

Deep dive into B2B vs B2C performance.

**KPI Cards:**
- B2B Margin: **36.10%** | B2C Margin: **62.60%**
- B2B AOV: **$141.80** | B2C AOV: **$19.83**

**Visuals:**
- Revenue By Channel (pie chart — B2B vs B2C split)
- B2C and B2B Revenue by Month (combo bar chart)
- B2B Orders Trending (line chart)
- B2C Orders Trending (line chart)
- Top 3 Resellers (filterable by region, category, year)

---

### 🔄 Page 3 — Orders & Customers *(In Progress)*

Planned analysis of customer demographics, order patterns, and geographic distribution.

---

### 🔄 Page 4 — Operation Analysis *(In Progress)*

Planned review of inventory movement, logistics, and operational efficiency.

---

## Key Findings

From the SQL EDA:

- **Accessories dominate order volume** — products like Water Bottles, Patch Kits, and Tire Tubes are the most frequently ordered items in the B2C channel.
- **Bikes drive revenue and profit** — despite lower order volumes, Mountain-200 and Road-150 series bikes account for the top positions in both revenue and profit rankings.
- **Strong revenue–profit correlation** — the top 10 products by revenue and profit are nearly identical, suggesting consistent margins across the high-value product line.
- **B2B AOV is significantly higher** — the average B2B order value ($1,330.67) is almost **3× the B2C AOV** ($486.09), as expected for a wholesale/reseller channel.
- **Balanced channel volume** — B2C and B2B transaction counts are nearly equal (~60K each), but the channels differ significantly in margin profile (B2C 62.6% vs B2B 36.1%).

---

## Project Structure

```
├── main_query.sql       # SQL view definitions (data layer for Power BI)
├── Eda.ipynb            # Exploratory Data Analysis in SQL notebook
├── Analytics.pbix       # Power BI dashboard file (4-page report)
└── README.md
```

---

## Roadmap

- [x] Database exploration and EDA
- [x] SQL views for Power BI data layer
- [x] Overview page (Page 1)
- [x] Channel Breakdown page (Page 2)
- [ ] Orders & Customers page (Page 3)
- [ ] Operation Analysis page (Page 4)
- [ ] Final review and publish

---

*Dataset based on AdventureWorksDW. Built with SQL Server and Power BI.*
