

# 🚴 Global Bike Retail — Executive Analytics Dashboard

> **Status:** ✅ Completed | **Live Report:** [View Power BI Dashboard](#insert-your-power-bi-service-link-here) | **Download:** [`Analytics.pbix`](#insert-link-to-pbix-file-here)

An end-to-end data analytics project built on a global bike retail dataset. The project combines **SQL Server** for data exploration and modeling with **Power BI** for executive-level reporting, covering both B2C (internet) and B2B (reseller) sales channels across multiple countries and product categories.

---

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Tech Stack & Dataset](#tech-stack--dataset)
- [SQL Data Layer](#sql-data-layer)
- [Dashboard & Key Findings](#dashboard--key-findings)
- [Project Structure](#project-structure)

---

## Project Overview

This project analyzes sales performance for a global bicycle retailer, exploring revenue trends, channel profitability, and supply chain risks. The goal is to deliver a 3-page executive dashboard that enables decision-makers to monitor KPIs and identify actionable business risks.

**Core Business Questions Addressed:**
1. How is overall revenue, profit, and margin trending over time, and which products drive volume vs. profit?
2. Are taxes and freight costs quietly eroding our profit margins, and does this impact our B2B channel more than B2C?
3. Which product categories are at the highest risk of stockouts or overstocking based on sales velocity?

---

## Tech Stack & Dataset

| Tool | Purpose |
|------|---------|
| **SQL Server (T-SQL)** | Data exploration, EDA, view creation |
| **Jupyter Notebook** | EDA query documentation |
| **Power BI** | Interactive executive dashboard & DAX logic |

**Source Data:** A Microsoft provided fictional dataset
*   **Fact Tables:** `FactInternetSales` (60,398 rows), `FactResellerSales` (60,855 rows), `FactProductInventory`
*   **Date Range:** December 2010 – January 2014 
*   **Total Transaction Records:** ~120,000 across B2B & B2C channels

---

## SQL Data Layer

Clean, reusable SQL views were created to abstract raw table complexity and serve as the exact data layer for Power BI. EDA was conducted in a Jupyter notebook prior to dashboard development.

**Dimension Views:** `vwDimCustomer`, `vwDimGeography`, `vwDimProduct` (filtered to current active products only), `vwDimReseller`, `vwDimAccount`, `currency`

**Fact Views:** `vwFactInternetSales`, `vwFactResellerSales`, `vwFactFinance`, `vwFactProductInventory`

---

## Dashboard & Key Findings

*Global filters for Region, Category, and Year are applied across all pages.*

### Page 1: Executive Overview
High-level summary of overall business performance, revenue trends, and product mix.

<img width="495" height="263" alt="{018F25B0-89B0-449A-B666-84A83363DB2A}" src="https://github.com/user-attachments/assets/2f4d8335-8952-4fc9-bbbe-2f70d11158e9" />


**Key Insights:**
* **Accessories dominate order volume** — products like Water Bottles, Patch Kits, and Tire Tubes are the most frequently ordered items in the B2C channel.
* **Bikes drive absolute revenue and profit** — despite lower order volumes, Mountain-200 and Road-150 series bikes account for the top positions in both revenue and profit rankings.
* **Strong revenue–profit correlation** — the top 10 products by revenue and profit are nearly identical, suggesting consistent, healthy margins across the high-value product line.

### Page 2: Channel Breakdown & Margin Erosion
Deep dive into B2B vs. B2C performance, focusing on the hidden impact of operational costs on net profitability.

<img width="486" height="256" alt="{B91668D8-C640-4E1B-A7F7-0AD1AF506BFF}" src="https://github.com/user-attachments/assets/a99aa475-748b-49c3-aed4-945304444135" />


**Key Insights:**
* **B2B margins are structurally squeezed by freight and taxes.** Transaction-level analysis reveals many reseller sales are priced at or below standard product cost (a wholesale pricing strategy). Consequently, taxes and freight erode what little product margin exists.
* **B2C retains a healthy operational buffer.** The B2C channel’s higher retail markups provide a margin buffer that is nearly four times larger than its tax and freight costs.
* **B2B AOV is significantly higher** — the average B2B order value ($1,330.67) is almost **3× the B2C AOV** ($486.09), reflecting bulk purchasing behavior, though it comes with the aforementioned margin trade-offs.

### Page 3: Customers & orders insights
Deep dive into customer acquisition, ordering behavior, and demographic value drivers across the B2C channel.

<img width="490" height="258" alt="{D7E9A757-E444-4FC9-9778-F65EAED6F9FB}" src="https://github.com/user-attachments/assets/e41b964b-159e-4f4c-accb-9895c43858fb" />

Key Insights:

Customer Mix & Retention: The dashboard tracks the split between New vs. Returning customers. (Note: Fill in your specific finding here based on the visual—for example: "Returning customers make up X% of orders but drive a disproportionately higher share of revenue due to higher AOV.")
AOV & Revenue Tiering: B2C revenue tiering reveals how order value is distributed among shoppers. Tracking AOV trends alongside this tiering shows whether growth is coming from occasional high-spenders or a broad base of lower-tier transactions.
Occupation-Driven Demand: Customer occupation distribution highlights which professional demographics are engaging with the brand most frequently, providing a clear target audience for future marketing spend.

---

## Project Structure

```text
├── main_query.sql       # SQL view definitions (data layer for Power BI)
├── Eda.ipynb            # Exploratory Data Analysis in SQL notebook
├── Analytics.pbix       # Power BI dashboard file
└── README.md            # Project documentation
```

---

*Dataset based on publicly available data. Built with SQL Server and Power BI.*

***
