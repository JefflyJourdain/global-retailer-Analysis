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

As we dive further into our analsysis, we notice that the drop in sales is concentrated in bikes subcategories, mountain & road bikes accounting for the vast majority of the drop in that month


```sql
WITH segment AS (
    SELECT 
         EnglishCountryRegionName AS region,
        DATENAME(month, CAST(fs.OrderDate AS DATE)) AS MonthName,
        ROUND(SUM(fs.ExtendedAmount), 2) AS Revenue,
        COUNT(DISTINCT fs.SalesOrderNumber) AS OrderCount
    FROM factinternetsales fs
    LEFT JOIN DimGeography dg ON dg.SalesTerritoryKey = fs.SalesTerritoryKey
    
    GROUP BY EnglishCountryRegionName, DATENAME(month, CAST(fs.OrderDate AS DATE))
),
baseline AS (
    SELECT 
        region,
        AVG(OrderCount) AS TypicalOrders,
        ROUND(AVG(Revenue), 2) AS TypicalRevenue
    FROM segment
    WHERE LOWER(MonthName) <> 'june'
    GROUP BY region
),
june AS (
    SELECT region, Revenue AS JuneRevenue, OrderCount AS JuneOrders
    FROM segment
    WHERE LOWER(MonthName) = 'june'
)
SELECT 
    j.region,
    j.JuneRevenue,
    j.JuneOrders,
    b.TypicalRevenue,
    b.TypicalOrders,
    ROUND(j.JuneRevenue - b.TypicalRevenue, 2) AS RevenueDeviation
FROM june j
JOIN baseline b ON j.region = b.region
ORDER BY ABS(j.JuneRevenue - b.TypicalRevenue) DESC;
```

As we deep further into our analysis we noticed that 2 regions, actually account for the majority of the revenue drop anomally  of the unexplained june drop. 

Executive Recommendation:

we strongly recommend the Sales Operations team audit reseller partnerships in the UK and France. The primary investigation points should be:

Contract Review: Were any large, recurring B2B wholesale contracts delayed, paused, or canceled in June?
Competitive Analysis: Did a competitor launch an aggressive regional promotion or undercut our wholesale pricing in Europe during this period?
Supply Chain Check: Were there specific logistical delays or stockouts at our European distribution centers that prevented resellers from placing orders?"

Business question #2   Financial Mechanics
Is the B2B vs. B2C margin gap primarily driven by wholesale pricing/discount structures, 
or is it driven by the specific product mix each channel sells?


```sql
SELECT englishproductname as product, 
    unitprice,
    productstandardcost,
    unitprice - productstandardcost AS profit_per_unit,
    COUNT(salesordernumber) Orders,
    sum(orderquantity) as Quantity,
    SUM(ExtendedAmount) as Revenue,
    SUM(ExtendedAmount) - SUM (totalproductcost) as Profit,
    SUM(DiscountAmount) as Discount,
    (SUM(ExtendedAmount ) - SUM (totalproductcost)) / SUM(ExtendedAmount ) AS Margin,
    SUM(TotalProductCost) as Cost,
    sum(DiscountAmount) / SUM(ExtendedAmount) * 100 AS disc_perc
FROM factinternetsales fi
LEFT JOIN DimProduct dp ON dp.ProductKey = fi.ProductKey
GROUP BY englishproductname,unitprice,productstandardcost
ORDER BY Revenue DESC

```


```sql
SELECT englishproductname as product, 
    unitprice,
    productstandardcost,
    unitprice - productstandardcost AS profit_per_unit,
    COUNT(salesordernumber) Orders,
    sum(orderquantity) as Quantity,
    SUM(ExtendedAmount) as Revenue,
    SUM(ExtendedAmount) - SUM (totalproductcost) as Profit,
    SUM(DiscountAmount) as Discount,
    (SUM(ExtendedAmount ) - SUM (totalproductcost)) / SUM(ExtendedAmount ) AS Margin,
    SUM(TotalProductCost) as Cost,
    sum(DiscountAmount) / SUM(ExtendedAmount) * 100 AS disc_perc

FROM factresellersales fr
LEFT JOIN DimProduct dp ON dp.ProductKey = fr.ProductKey
GROUP BY englishproductname,unitprice,productstandardcost
ORDER BY Revenue DESC

```

The products in b2b have the same cost per unit but a much lower unit price, This wholesale intrinsec  discount and not the promotional discount what's driving the gap in margin and profit between the two categories 
only 5 products had discount ratio to revenue above 30% and they didn't have signficant sales or revenue,most products dont have discount and the top 20 of products with the most revenue didn't have any discount at all except for one with a discount of 2%.

so promotional discount is not driving the margin gap, intrensic or wholesale discount is,
both channels are selling the same categories the most: bikes with road and mountain bike account for the most revenue so product mix is not driving the profit/margin gap wholesale discount is.

The margin gap is driven entirely by structural wholesale pricing (intrinsic discounting), not by promotional discounts or product mix. We can definitively rule out the other two factors:

1. Product Mix is Identical: Both channels are heavily concentrated in the same high-value categories. Road Bikes and Mountain Bikes drive the vast majority of revenue in both B2B and B2C. The products themselves are not the differentiator.
2. Promotional Discounts are a Non-Factor: Line-item promotional discounts are virtually non-existent in the B2B channel. Only 5 products had a discount ratio above 30%, and they generated insignificant revenue. Furthermore, the Top 20 highest-revenue B2B products had absolutely zero promotional discounts applied (with one minor exception at 2%).
3. The Root Cause: Intrinsic Wholesale Pricing: The gap is structural. B2B products carry the exact same unit cost as B2C products, but are sold at a significantly lower baseline unit price. This intrinsic wholesale discount inherently compresses B2B gross margins from the moment the order is placed, before any taxes or freight are even calculated.


Business Context:
This confirms that the B2B margin squeeze is not a result of "bad deals" or aggressive sales discounting, but rather the intended design of our wholesale pricing model. Because the baseline B2B margin is already structurally thin, it leaves the channel highly vulnerable to external operational costs—explaining why freight and taxes (as noted in the dashboard) so easily erode B2B profitability compared to the buffered B2C channel.




Did a few large orders artificially inflate June metrics?


```sql
with orders as (
    SELECT  DATENAME(MONTH, CAST(orderdate as date)) as MONTH,
    DATEPART(month, orderdate) as month_num,
     COUNT(distinct SalesOrderNumber) AS Order_num,
    
     SUM(orderquantity) as quantity,
     sum(ExtendedAmount) as revenue
FROM factresellersales 
GROUP BY DATENAME(MONTH, CAST(orderdate as date)),DATEPART(month, orderdate)
)

select Month, Order_num,
    (nullif(Order_num,0) - lag(nullif(Order_num,0),1) OVER(ORDER BY month_num )) * 100
    / lag(nullif(Order_num,0),1) OVER(ORDER BY month_num )  as orders_change,
    
    ROUND(revenue,2) as revenue,
    ROUND( revenue / nullif(Order_num,0),2) as AOV,
     CAST(ROUND((revenue / Order_num - LAG(revenue / Order_num) OVER(order by month_num )),2) * 100 / 
    ROUND(LAG(revenue / Order_num) OVER(order by month_num ),2) as int) as aov_change
from orders
ORDER BY month_num



```

Initial Theory: We investigated whether the June revenue collapse was masked by a small number of massive B2B orders, which would have resulted in a drop in order volume but a spike in Average Order Value (AOV).

Finding:
This hypothesis is false. June did not experience an AOV spike. As shown in the table below, B2B order volume plummeted by 65 MoM, and AOV simultaneously dropped by 25 MoM (from $2,231 in May to $1,668 in June).

Business Context:
This AOV drop perfectly aligns with our earlier geographic and product findings. The missing June revenue was heavily concentrated in high-ticket Mountain and Road Bikes in the UK and France. Because we lost these high-value transactions, the remaining June orders naturally skewed toward lower-priced items, pulling the overall AOV down alongside the volume.

Q6 (Gold/VIP revenue concentration)


```sql
with tiers as (SELECT fi.customerkey,
    sum(extendedamount) as revenue,
            CASE 
                WHEN SUM(ExtendedAmount) > PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sum(ExtendedAmount)) over() THEN 'VIP'
                WHEN SUM(ExtendedAmount) >= PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY sum(ExtendedAmount)) over() THEN 'GOLD'
                WHEN SUM(ExtendedAmount) >= PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sum(ExtendedAmount)) over() THEN 'SILVER'
                ELSE 'Base'
                END AS Tier
from factinternetsales fi
group by fi.customerkey)

select Tier, 
    count(customerkey) as customers,
    round(count(customerkey) * 100.0 / sum(count(customerkey)) OVER (),2) as Perc_of_total,
    round(sum(revenue),2) as revenue,
    ROUND ((sum(revenue) * 100) / sum(sum(revenue)) over(),2) as revenue_perc
     
from tiers
group by Tier
```

i did this equal-frequency segmentation: query to determine the revenue and customer segmentation of our dataset 


```sql
with tiers as (SELECT fi.ResellerKey,
    sum(extendedamount) as revenue,
            CASE 
                WHEN SUM(ExtendedAmount) > PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY sum(ExtendedAmount)) over() THEN 'VIP'
                WHEN SUM(ExtendedAmount) >= PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY sum(ExtendedAmount)) over() THEN 'GOLD'
                WHEN SUM(ExtendedAmount) >= PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sum(ExtendedAmount)) over() THEN 'SILVER'
                ELSE 'Base'
                END AS Tier
from factresellersales fi
group by fi.ResellerKey)

select Tier, 
    count(ResellerKey) as customers,
    round(count(ResellerKey) * 100.0 / sum(count(ResellerKey)) OVER (),2) as Perc_of_total,
    round(sum(revenue),2) as revenue,
    ROUND ((sum(revenue) * 100) / sum(sum(revenue)) over(),2) as revenue_perc
     
from tiers
group by Tier
```
