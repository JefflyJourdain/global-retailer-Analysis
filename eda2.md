```sql
SELECT EnglishProductSubcategoryName, SUM (ExtendedAmount - taxamt - Freight - totalproductcost) AS net_profit 
FROM factinternetsales as fi
LEFT JOIN dimproduct AS dp on fi.ProductKey = dp.ProductKey
LEFT JOIN dimproductsubcategory on dp.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
group by EnglishProductSubcategoryName
```

business question : 
Are taxes and freight costs quietly eroding our profit margins, and does this impact our B2C (Internet) channel more than our B2B (Reseller) channel?


```sql
SELECT EnglishProductSubcategoryName, SUM (ExtendedAmount - taxamt - Freight - totalproductcost) AS net_profit 
FROM factresellersales as fr
LEFT JOIN dimproduct AS dp on fr.ProductKey = dp.ProductKey
LEFT JOIN dimproductsubcategory on dp.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
group by EnglishProductSubcategoryName
```


```sql
SELECT
    'B2B' AS Channel,
    SUM(ExtendedAmount) AS Revenue,
    SUM(TotalProductCost) AS COGS,
    SUM(ExtendedAmount) - SUM(TotalProductCost) AS Gross_Margin_Dollars,
    SUM(TaxAmt) AS Taxes,
    SUM(Freight) AS Freight,
    SUM(TaxAmt) + SUM(Freight) AS Tax_Freight_Dollars,
    ROUND(100.0 * (SUM(ExtendedAmount) - SUM(TotalProductCost)) / SUM(ExtendedAmount), 2) AS Gross_Margin_Pct,
    ROUND(100.0 * (SUM(TaxAmt) + SUM(Freight)) / SUM(ExtendedAmount), 2) AS Tax_Freight_Pct_of_Revenue,
    ROUND((SUM(ExtendedAmount) - SUM(TotalProductCost)) / (SUM(TaxAmt) + SUM(Freight)), 2) AS Margin_Cushion_Ratio
FROM FactResellerSales
UNION ALL
SELECT
    'B2C' AS Channel,
    SUM(ExtendedAmount) AS Revenue,
    SUM(TotalProductCost) AS COGS,
    SUM(ExtendedAmount) - SUM(TotalProductCost) AS Gross_Margin_Dollars,
    SUM(TaxAmt) AS Taxes,
    SUM(Freight) AS Freight,
    SUM(TaxAmt) + SUM(Freight) AS Tax_Freight_Dollars,
    ROUND(100.0 * (SUM(ExtendedAmount) - SUM(TotalProductCost)) / SUM(ExtendedAmount), 2) AS Gross_Margin_Pct,
    ROUND(100.0 * (SUM(TaxAmt) + SUM(Freight)) / SUM(ExtendedAmount), 2) AS Tax_Freight_Pct_of_Revenue,
    ROUND((SUM(ExtendedAmount) - SUM(TotalProductCost)) / (SUM(TaxAmt) + SUM(Freight)), 2) AS Margin_Cushion_Ratio
FROM FactInternetSales;
```


```sql
SELECT TOP 20
    ProductKey,
    OrderQuantity,
    UnitPrice,
    ExtendedAmount,
    ProductStandardCost,
    TotalProductCost,
    ROUND(100.0 * TotalProductCost / ExtendedAmount, 2) AS Cost_Pct
FROM FactResellerSales
ORDER BY NEWID();
```


```sql
Which product categories are at the highest risk of stockouts or overstocking based on their sales velocity compared to their current inventory levels?"
```


```sql
SELECT 
    (SELECT MIN(DateKey) FROM FactProductInventory) AS Inv_MinDate,
    (SELECT MAX(DateKey) FROM FactProductInventory) AS Inv_MaxDate,
    (SELECT COUNT(DISTINCT DateKey) FROM FactProductInventory) AS Inv_DistinctDates,
    (SELECT MIN(OrderDateKey) FROM FactInternetSales) AS Sales_MinDate,
    (SELECT MAX(OrderDateKey) FROM FactInternetSales) AS Sales_MaxDate;
```


```sql
WITH DailySales AS (
    -- 1. Combine B2C and B2B sales
    SELECT ProductKey, OrderDateKey AS DateKey, SUM(OrderQuantity) AS UnitsSold
    FROM FactInternetSales
    GROUP BY ProductKey, OrderDateKey
    
    UNION ALL
    
    SELECT ProductKey, OrderDateKey AS DateKey, SUM(OrderQuantity) AS UnitsSold
    FROM FactResellerSales
    GROUP BY ProductKey, OrderDateKey
),
SalesVelocity AS (
    -- 2. Calculate Average Daily Velocity purely through math (No DATEADD needed)
    -- Total Units Sold / Number of Active Selling Days
    SELECT 
        ProductKey,
        SUM(UnitsSold) * 1.0 / COUNT(DISTINCT DateKey) AS AvgDailyVelocity
    FROM DailySales
    GROUP BY ProductKey
),
LatestInventory AS (
    -- 3. Get the final stock balance for each product
    SELECT 
        ProductKey,
        UnitsBalance,
        ROW_NUMBER() OVER(PARTITION BY ProductKey ORDER BY DateKey DESC) as rn
    FROM FactProductInventory
)
-- 4. Bring it all together
SELECT
    sub.EnglishProductSubcategoryName AS Subcategory,
    COUNT(DISTINCT li.ProductKey) AS ProductCount,
    ROUND(AVG(li.UnitsBalance), 0) AS Avg_Units_In_Stock,
    
    -- Average out the velocity across all products in the subcategory
    ROUND(AVG(COALESCE(sv.AvgDailyVelocity, 0)), 2) AS Avg_Daily_Velocity,
    
    -- Calculate Days of Inventory (DOI)
    CASE 
        WHEN AVG(COALESCE(sv.AvgDailyVelocity, 0)) = 0 THEN 9999.0 
        ELSE ROUND(AVG(li.UnitsBalance) / AVG(COALESCE(sv.AvgDailyVelocity, 0)), 1) 
    END AS Avg_Days_Of_Inventory
FROM LatestInventory li
JOIN DimProduct p ON li.ProductKey = p.ProductKey
JOIN DimProductSubcategory sub ON p.ProductSubcategoryKey = sub.ProductSubcategoryKey
LEFT JOIN SalesVelocity sv ON li.ProductKey = sv.ProductKey
WHERE li.rn = 1 
GROUP BY sub.EnglishProductSubcategoryName
ORDER BY Avg_Days_Of_Inventory DESC;
```


Which product categories are at the highest risk of stockouts or overstocking based on their sales velocity compared to their current inventory levels?

Tires and Tubes carries ~84 days of inventory at current sales pace — a carrying-cost risk — while fast-moving accessory subcategories like Gloves and Caps show less than a day of runway, indicating imminent stockout risk.


