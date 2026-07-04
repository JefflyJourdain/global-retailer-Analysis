

DROP view IF EXISTS DimAccount;
GO
Create view DimAccount AS
    select Accountkey,accounttype,AccountDescription,Operator,Valuetype
    from DimAccount;
GO

drop view IF EXISTS DimCustomer;
GO
CREATE VIEW DimCustomer AS

    WITH TierWindow AS (
        
        SELECT CustomerKey,

            CASE 
                WHEN SUM(ExtendedAmount) > PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY sum(ExtendedAmount)) over() THEN 'VIP'
                WHEN SUM(ExtendedAmount) >= PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY sum(ExtendedAmount)) over() THEN 'GOLD'
                WHEN SUM(ExtendedAmount) >= PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sum(ExtendedAmount)) over() THEN 'SILVER'
                WHEN SUM(ExtendedAmount) < PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY sum(ExtendedAmount)) over() THEN 'BASE'
                ELSE 'STANDARD'
                END AS Tier
        from FactInternetSales
        group by customerkey)
    
SELECT DimCustomer.CustomerKey,geographykey,concat(firstname, ' ', middlename, ' ', lastname) as CustomerName,
        birthdate,yearlyincome,Tier
from DimCustomer
left JOIN TierWindow on DimCustomer.CustomerKey = TierWindow.CustomerKey;

GO
drop view IF EXISTS vwDimGeography;
GO
create VIEW DimGeography AS 
    SELECT GeographyKey,City,StateProvinceName,EnglishCountryRegionName As region,SalesTerritoryKey
    from DimGeography;
GO
DROP view if exists DimProduct
GO 
CREATE VIEW DimProduct AS
    SELECT ProductKey,EnglishProductName as ProductName,ProductSubcategoryKey,SafetyStockLevel,ReorderPoint,[Status]
    from DimProduct
    where status = 'Current';
GO
drop view IF EXISTS factinternetsales;
GO
create VIEW factinternetsales AS
        
    SELECT ProductKey,CustomerKey,SalesOrderNumber,TotalProductCost,OrderQuantity,UnitPrice,ExtendedAmount,taxamt as TaxAmount,Freight,
    SalesTerritoryKey,OrderDate,DueDate,ShipDate
    from factinternetsales;
GO
drop view if EXISTS dimreseller;
GO
create VIEW dimreseller AS
    SELECT ResellerKey,GeographyKey,ResellerName,AnnualSales,AnnualRevenue,YearOpened
    from DimReseller;
GO
drop view if exists factproductinventory;
GO
create VIEW factproductinventory AS
    SELECT ProductKey,MovementDate,UnitCost,UnitsIn,UnitsOut,UnitsBalance
    from factproductinventory;
go
drop view if exists factresellersales;
GO
create VIEW factresellersales AS
    SELECT ProductKey,ResellerKey,SalesOrderNumber,TotalProductCost,OrderQuantity,UnitPrice,ExtendedAmount,taxamt as TaxAmount,Freight,
    SalesTerritoryKey,OrderDate,DueDate,ShipDate
    from factresellersales;