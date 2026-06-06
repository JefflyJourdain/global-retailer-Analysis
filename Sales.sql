DROP VIEW IF EXISTS currency;
GO
CREATE VIEW currency as
    SELECT top 15 * 
    from DimCurrency;
GO


DROP view IF EXISTS vwDimAccount;
GO
Create view vwDimAccount AS
    select Accountkey,accounttype,AccountDescription,Operator,Valuetype
    from DimAccount;
GO


drop view IF EXISTS vwFactFinance;
GO
create VIEW vwFactFinance AS 
    SELECT financekey,organizationkey,DepartmentGroupKey,ScenarioKey,AccountKey,Amount,date
    from FactFinance;
GO


drop view IF EXISTS vwDimCustomer;
GO
CREATE VIEW vwDimCustomer AS

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
create VIEW vwDimGeography AS 
    SELECT GeographyKey,City,StateProvinceName,EnglishCountryRegionName As region,SalesTerritoryKey
    from DimGeography;
GO
DROP view if exists vwDimProduct
GO 
CREATE VIEW vwDimProduct AS
    SELECT ProductKey,EnglishProductName as ProductName,ProductSubcategoryKey,SafetyStockLevel,ReorderPoint,[Status]
    from DimProduct
    where status = 'Current';
GO
drop view IF EXISTS vwfactinternetsales;
GO
create VIEW vwfactinternetsales AS
        
    SELECT ProductKey,CustomerKey,SalesOrderNumber,TotalProductCost,OrderQuantity,UnitPrice,ExtendedAmount,taxamt as TaxAmount,Freight,
    SalesTerritoryKey,OrderDate,DueDate,ShipDate
    from factinternetsales;
GO
drop view if EXISTS vwdimreseller;
GO
create VIEW vwdimreseller AS
    SELECT ResellerKey,GeographyKey,ResellerName,AnnualSales,AnnualRevenue,YearOpened
    from DimReseller;
GO
drop view if exists vwfactproductinventory;
GO
create VIEW vwfactproductinventory AS
    SELECT ProductKey,MovementDate,UnitCost,UnitsIn,UnitsOut,UnitsBalance
    from factproductinventory;
go
drop view if exists vwfactresellersales;
GO
create VIEW vwfactresellersales AS
    SELECT ProductKey,ResellerKey,SalesOrderNumber,TotalProductCost,OrderQuantity,UnitPrice,ExtendedAmount,taxamt as TaxAmount,Freight,
    SalesTerritoryKey,OrderDate,DueDate,ShipDate
    from factresellersales;