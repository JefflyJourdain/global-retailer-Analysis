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
    SELECT financekey,organizationkey,DepartmentGroupKey,ScenarioKey,AccountKey,Amount
    from FactFinance;
GO
drop view IF EXISTS vwDimCustomer;
GO
create VIEW vwDimCustomer AS
    SELECT CustomerKey,geographykey,concat(firstname, ' ', middlename, ' ', lastname) as CustomerName,
        birthdate,yearlyincome
    from DimCustomer;
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