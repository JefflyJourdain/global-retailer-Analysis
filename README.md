# 🚴 AdventureWorks Global Bike Retail — Executive Analytics Report

> **Status:** ✅ Completed

## Background & Business Context
AdventureWorks, a global manufacturing company, is facing challenges in making data-driven decisions due to a lack of structured financial reporting and performance tracking. Without a clear view of key financial metrics such as sales, revenue, and profit, the company struggles to assess regional performance, identify product-level trends, and recognize high-value products. This lack of visibility hinders strategic planning and operational efficiency.

To support strategic decision-making, historical sales data (2011–2014) was analyzed across B2C (Internet) and B2B (Reseller) channels utilizing advanced analytical frameworks.

---

## 📋 Table of Contents
- [Project Overview](#project-overview)
- [Key Findings & Strategic Insights](#key-findings--strategic-insights)
- [Dashboard Overview](#dashboard-overview)
- [Strategic Recommendations](#strategic-recommendations)
- [Tech Stack & Dataset](#tech-stack--dataset)
- [Project Structure](#project-structure)

---

## Project Overview

This project analyzes sales performance for a global bicycle retailer, exploring revenue trends, channel profitability, and supply chain risks. The goal is to deliver a 3-page executive dashboard that enables decision-makers to monitor KPIs and identify actionable business risks.

### 📊 Analytical Frameworks Applied
Rather than simply reporting top-line metrics, this project applies specific operational frameworks to isolate business drivers:

* **Mix Shift & Variance Analysis (PVM Decomposition):** Isolating whether the B2B vs. B2C margin gap is driven by Pricing (wholesale discount structures) or Mix (channels buying different product categories).
* **Channel & Route-to-Market Analytics:** Evaluating B2B vs. B2C not just as revenue streams, but as distinct business models with different cost structures and operational risks.
* **Customer & Account Profitability (Pareto & Cost-to-Serve):** Moving from a "revenue-centric" view of customers to a "value-centric" view, identifying the vital few who drive the bulk of the bottom line.
* **Product & Category Analytics:** Identifying "Cash Cows" vs. volume-drivers to assess revenue concentration risk.

---

## 🔍 Key Findings & Strategic Insights

> _Detailed SQL queries, baseline calculations, and statistical proofs for these findings are documented in the `analysis.md` file._

### 1. Mix Shift & Variance Analysis: The B2B Margin Squeeze
* **Framework Applied:** Price/Volume/Mix (PVM) Decomposition
* **Insight:** The B2B channel operates with structurally thinner margins than B2C. Through PVM analysis, we definitively ruled out Product Mix as the culprit (both channels sell primarily Road and Mountain bikes). Instead, the gap is entirely driven by Pricing Structure—specifically, intrinsic wholesale pricing. B2B products carry the same unit cost but a significantly lower baseline selling price. Because this baseline margin is intentionally thin, operational costs (freight and taxes) easily erode what little profit remains.

### 2. Channel Mix Analysis: The 2013 Anomaly Isolation
* **Framework Applied:** Channel P&L Modeling & Root Cause Isolation
* **Insight:** In FY2013, B2B revenue plummeted by -52.68% in June against a highly stable baseline. We ruled out B2C issues and catalog-wide product shifts (all 26 subcategories dropped). The root cause was isolated geographically: France fell to 13% of typical order volume, and the UK to 30%. This points away from macroeconomic demand drops and directly toward an account-specific failure (e.g., a paused major contract or regional logistical halt) in Europe.

### 3. Customer Profitability: Extreme Revenue Concentration
* **Framework Applied:** Pareto Principle (80/20) & Account Segmentation
* **Insight:** The business is highly dependent on a tiny fraction of its customer base.
  * **B2C:** The top 25% of consumers (VIP tier) generate 75.6% of revenue. The bottom 50% contribute less than 2%.
  * **B2B:** The top 25% of resellers account for 74.7% of wholesale revenue. The bottom 50% of reseller accounts provide a mere 4.5%. This indicates a massive "long tail" of low-value accounts that likely cost more to serve than they generate.

### 4. Product Analytics: Volume vs. Value Disconnect
* **Framework Applied:** Product Margin Matrix
* **Insight:** High transaction volume does not equate to high value. Accessories (Water Bottles, Tire Tubes) dominate order counts but contribute marginally to the bottom line. Mountain and Road bikes represent the true "Cash Cows" of the organization, driving the vast majority of absolute profit despite lower transaction frequencies.

---

## 📈 Dashboard Overview

_Global filters for Region, Category, and Year are applied across all pages._

### Page 1: Executive Overview & Anomaly Tracking
High-level summary of overall business performance, revenue trends, and product mix. Macro-level P&L tracking with embedded isolation of the June 2013 B2B revenue collapse.

<img width="495" height="263" alt="Executive Overview" src="https://github.com/user-attachments/assets/2f4d8335-8952-4fc9-bbbe-2f70d11158e9" />

**Key Insights:**
* **Accessories dominate order volume:** Products like Water Bottles, Patch Kits, and Tire Tubes are the most frequently ordered items in the B2C channel.
* **Bikes drive absolute revenue and profit:** Despite lower order volumes, Mountain-200 and Road-150 series bikes account for the top positions in both revenue and profit rankings.
* **Strong revenue–profit correlation:** The top 10 products by revenue and profit are nearly identical, suggesting consistent, healthy margins across the high-value product line.

### Page 2: Channel Economics & Margin Erosion
Deep dive into B2B vs. B2C performance, visualizing the hidden impact of operational costs and intrinsic wholesale pricing on net profitability.

<img width="486" height="256" alt="Channel Breakdown" src="https://github.com/user-attachments/assets/a99aa475-748b-49c3-aed4-945304444135" />

**Key Insights:**
* **B2B margins are structurally squeezed by freight and taxes:** Transaction-level analysis reveals many reseller sales are priced at or below standard product cost (a wholesale pricing strategy). Consequently, taxes and freight erode what little product margin exists.
* **B2C retains a healthy operational buffer:** The B2C channel’s higher retail markups provide a margin buffer that is nearly four times larger than its tax and freight costs.
* **B2B AOV is significantly higher:** The average B2B order value ($1,330.67) is almost **3× the B2C AOV** ($486.09), reflecting bulk purchasing behavior, though it comes with the aforementioned margin trade-offs.

### Page 3: Customer Value Concentration & Pareto Segmentation
Deep dive into customer acquisition, ordering behavior, quartile-based ranking of resellers, and demographic value drivers across the B2C channel.

<img width="490" height="258" alt="Customers & Orders" src="https://github.com/user-attachments/assets/e41b964b-159e-4f4c-accb-9895c43858fb" />

**Key Insights:**
* **Customer Mix & Retention:** The dashboard tracks the split between New vs. Returning customers. _[Note: Fill in specific finding here, e.g., "Returning customers make up X% of orders but drive a disproportionately higher share of revenue due to higher AOV."]_
* **AOV & Revenue Tiering:** B2C revenue tiering reveals how order value is distributed among shoppers. Tracking AOV trends alongside this tiering shows whether growth is coming from occasional high-spenders or a broad base of lower-tier transactions.
* **Occupation-Driven Demand:** Customer occupation distribution highlights which professional demographics are engaging with the brand most frequently, providing a clear target audience for future marketing spend.

---

## 🎯 Strategic Recommendations
Based on the applied frameworks, the following actions are recommended to optimize profitability and operational efficiency:

| Priority | Action | Owner | Expected Impact | Metric to Track |
| :--- | :--- | :--- | :--- | :--- |
| **P0** | **Conduct UK/France Reseller Audit:** Investigate the exact cause of the near-total cessation of B2B orders in June 2013 (paused contracts vs. competitor loss). | Sales Ops / B2B Mgmt | Recovery of lost high-value wholesale revenue in EMEA. | EMEA B2B Monthly Order Volume & Revenue |
| **P1** | **B2B Cost-to-Serve Review:** Audit the bottom 50% of B2B resellers generating <5% of revenue. Determine if account management costs exceed their margin contribution. | Finance / Account Mgmt | Reduced operational overhead; reallocation of sales resources to VIP accounts. | Cost-to-Serve ratio per reseller tier |
| **P1** | **Shift B2C Marketing Spend:** Pivot acquisition budget away from broad "Base" tier customers. Focus on retention programs and upselling for the top 25% "VIP" tier. | Marketing / CX | Higher ROI on marketing spend; increased Customer Lifetime Value (LTV). | VIP tier retention rate & B2C AOV |
| **P2** | **Review B2B Freight Terms:** Given that freight severely erodes already-thin wholesale margins, renegotiate minimum order quantities (MOQs) or freight split terms with low-tier resellers. | Supply Chain / Finance | Protection of B2B net margins on lower-volume accounts. | B2B Net Margin % post-freight |

---

## 🛠 Tech Stack & Dataset

| Tool | Purpose |
|------|---------|
| **SQL Server (T-SQL)** | Advanced EDA, PVM variance logic, NTILE segmentation, view creation |
| **Jupyter Notebook** | EDA query documentation (`Eda.ipynb`) |
| **Power BI** | Interactive executive dashboard & DAX logic |
| **Markdown** | Structured narrative documentation of analytical frameworks |

**Source Data:** A Microsoft-provided fictional dataset
* **Fact Tables:** `FactInternetSales` (60,398 rows), `FactResellerSales` (60,855 rows),
* **Date Range:** December 2010 – november 2014 
* **Total Transaction Records:** ~120,000 across B2B & B2C channels

---

## 📁 Project Structure

```text
├── README.md            # Executive summary & framework documentation
├── analysis.md          # Deep-dive SQL queries, outputs, and statistical proofs
├── sql/
│   ├── main_query.sql   # SQL view definitions (data layer for Power BI)
│   └── views.sql        # Semantic layer (Star Schema views for Power BI)
├── Eda.ipynb            # Exploratory Data Analysis in SQL notebook
├── assets/
│   ├── page1.png        # Dashboard screenshots
│   ├── page2.png
│   └── page3.png
└── Analytics.pbix       # Power BI dashboard file
