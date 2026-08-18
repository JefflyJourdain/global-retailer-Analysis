Business Question #1: Margin/Revenue anomally
What drove the anomalous swings in June (margin/revenue collapse followed by an AOV spike), and was this driven by a sudden shift in channel mix or category demand?



```sql
with monthly as (
SELECT DATENAME (month, CAST(orderdate as DATE)) AS Month, 
    DATEPART(MONTH,orderdate) as month_num,
    round(sum(ExtendedAmount),2) as Revenue,
    SUM(ExtendedAmount) - SUM (totalproductcost) as Profit,
    (SUM(ExtendedAmount ) - SUM (totalproductcost)) / SUM(ExtendedAmount ) AS Margin
FROM FactInternetSales
GROUP BY DATEPART(MONTH,orderdate),DATENAME (month, CAST(orderdate as DATE))

)

SELECT Month,Revenue, 
    ROUND((revenue - lag (revenue, 1) OVER (ORDER BY month_num)) / 
    lag (revenue, 1) OVER (ORDER BY month_num) * 100,2) AS MoM_Revenue
from monthly
ORDER BY month_num
```


    (12 rows affected)
    
    Month     | Revenue   | MoM_Revenue
    ----------+-----------+------------
    January   | 42464.61  | NULL       
    February  | 34479.15  | -18.8      
    March     | 44131.69  | 28         
    April     | 60123.42  | 36.24      
    May       | 66601.78  | 10.78      
    June      | 72611.31  | 9.02       
    July      | 101458.07 | 39.73      
    August    | 71331.39  | -29.69     
    September | 58265.88  | -18.32     
    October   | 80042.06  | 37.37      
    November  | 68296.15  | -14.67     
    December  | 87089.06  | 27.52      
    (12 rows)
    
    Total execution time: 00:00:00.190


As we dive into our analysis we confirm the sudden drop collapse of revenue in june,is not present in our B2C channel so it  should be concentrated in the Reseller channel(B2B) and not our B2C channel.


```sql
with monthly as (
SELECT DATENAME (month, CAST(orderdate as DATE)) AS Month, 
    DATEPART(MONTH,orderdate) as month_num,
    round(sum(ExtendedAmount),2) as Revenue,
    SUM(ExtendedAmount) - SUM (totalproductcost) as Profit,
    (SUM(ExtendedAmount ) - SUM (totalproductcost)) / SUM(ExtendedAmount ) AS Margin
FROM factresellersales
GROUP BY DATEPART(MONTH,orderdate),DATENAME (month, CAST(orderdate as DATE))

)

SELECT Month,Revenue, 
    ROUND((revenue - lag (revenue, 1) OVER (ORDER BY month_num)) / 
    lag (revenue, 1) OVER (ORDER BY month_num) * 100,2) AS MoM_Revenue
from monthly
ORDER BY month_num
```


    (12 rows affected)
    
    Month     | Revenue   | MoM_Revenue
    ----------+-----------+------------
    January   | 225289.38 | NULL       
    February  | 207087.78 | -8.08      
    March     | 168056.08 | -18.85     
    April     | 137318.55 | -18.29     
    May       | 278950.32 | 103.14     
    June      | 71741.48  | -74.28     
    July      | 123067.5  | 71.54      
    August    | 178305.23 | 44.88      
    September | 114748.16 | -35.65     
    October   | 166962.33 | 45.5       
    November  | 196300.93 | 17.57      
    December  | 142031.81 | -27.65     
    (12 rows)
    
    Total execution time: 00:00:00.193



```sql
WITH segment AS (
    SELECT 
        EnglishProductSubcategoryName AS Category,
        DATENAME(month, CAST(fs.OrderDate AS DATE)) AS MonthName,
        ROUND(SUM(fs.ExtendedAmount), 2) AS Revenue,
        COUNT(DISTINCT fs.SalesOrderNumber) AS OrderCount
    FROM FactResellerSales fs
    LEFT JOIN DimProduct dp ON dp.ProductKey = fs.ProductKey
    LEFT JOIN DimProductSubcategory dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
    GROUP BY EnglishProductSubcategoryName, DATENAME(month, CAST(fs.OrderDate AS DATE))
),
baseline AS (
    SELECT 
        Category,
        AVG(OrderCount) AS TypicalOrders,
        ROUND(AVG(Revenue), 2) AS TypicalRevenue
    FROM segment
    WHERE LOWER(MonthName) <> 'june'
    GROUP BY Category
),
june AS (
    SELECT Category, Revenue AS JuneRevenue, OrderCount AS JuneOrders
    FROM segment
    WHERE LOWER(MonthName) = 'june'
)
SELECT 
    j.Category,
    j.JuneRevenue,
    j.JuneOrders,
    b.TypicalRevenue,
    b.TypicalOrders,
    ROUND(j.JuneRevenue - b.TypicalRevenue, 2) AS RevenueDeviation
FROM june j
JOIN baseline b ON j.Category = b.Category
ORDER BY ABS(j.JuneRevenue - b.TypicalRevenue) DESC;
```


    (16 rows affected)
    
    Category        | JuneRevenue | JuneOrders | TypicalRevenue | TypicalOrders | RevenueDeviation
    ----------------+-------------+------------+----------------+---------------+-----------------
    Mountain Bikes  | 17184.01    | 4          | 54139.54       | 14            | -36955.53       
    Road Bikes      | 37120.74    | 10         | 62338.88       | 21            | -25218.14       
    Touring Bikes   | 7179.59     | 4          | 26182.01       | 8             | -19002.42       
    Mountain Frames | 1495.9      | 3          | 12275.87       | 9             | -10779.97       
    Road Frames     | 2359.04     | 2          | 8838.14        | 10            | -6479.1         
    Touring Frames  | 3011.73     | 1          | 4033.53        | 3             | -1021.8         
    Jerseys         | 443.17      | 4          | 1430.82        | 8             | -987.65         
    Wheels          | 735.72      | 2          | 1535.34        | 4             | -799.62         
    Helmets         | 184.1       | 3          | 672.72         | 5             | -488.62         
    Tights          | 224.97      | 1          | 520.64         | 2             | -295.67         
    Bike Racks      | 288         | 1          | 528            | 1             | -240            
    Handlebars      | 209.4       | 2          | 421.48         | 4             | -212.08         
    Gloves          | 306.12      | 6          | 492.37         | 5             | -186.25         
    Saddles         | 243.76      | 2          | 209.41         | 2             | 34.35           
    Caps            | 59.33       | 2          | 70.2           | 3             | -10.87          
    Shorts          | 695.89      | 5          | 690.3          | 2             | 5.59            
    (16 rows)
    
    Total execution time: 00:00:00.382


As we dive further into our analsysis, we notice that the drop in sales is concentrated in bikes subcategories, mountain & road bikes accounting for the vast majority of the drop 
