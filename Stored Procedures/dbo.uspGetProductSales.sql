SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		Val Skordin
-- Create date: 10/9/2016
-- Description:	Product Sales
-- Added comment for testing 7/16/2021
-- =============================================
CREATE PROCEDURE [dbo].[uspGetProductSales]	
	@ProductCategoryKey int=NULL,
	@SalesTerritoryGroup nvarchar(50)=NULL,
	@SalesTerritoryCountry nvarchar(50)=NULL,
	@SalesTerritoryRegion nvarchar(50)=NULL,
	@ModelName nvarchar(50)=NULL	
AS
BEGIN
	SET NOCOUNT ON;
SELECT  
        sale.ProductKey as ProductId,
		scat.EnglishProductSubcategoryName as ProductCategoryName,
		prod.ModelName,
		prod.EnglishProductName as ProductName,	
		prod.ProductSubcategoryKey as ProductCategoryKey,
		[SalesOrderNumber] as OrderNumber,       
	  dat.FullDateAlternateKey as OrderDate,
	  cust.LastName +', '+cust.FirstName as CustomerName,       
      [SalesAmount],
      [TaxAmt],
      [Freight] as ShippingCost, 
	  geo.City,
	  geo.StateProvinceCode as StateCode,
	  geo.StateProvinceName as StateName,
	  geo.PostalCode,
	  ter.SalesTerritoryCountry as Country,
	  ter.SalesTerritoryGroup as TerritoryGroup,
	  ter.SalesTerritoryRegion as TerritoryRegion
  FROM [dbo].[FactInternetSales] sale
  inner Join [dbo].[DimProduct] prod
  on sale.ProductKey=prod.ProductKey
  inner Join [dbo].[DimSalesTerritory] ter
  on sale.SalesTerritoryKey=ter.SalesTerritoryKey
  inner join dbo.DimDate dat
  on sale.OrderDateKey=dat.DateKey
  inner join dbo.DimCustomer cust
  on sale.CustomerKey=cust.CustomerKey
  inner join dbo.DimGeography geo
  on cust.GeographyKey=geo.GeographyKey
  inner join dbo.DimProductSubcategory scat
  on prod.ProductSubcategoryKey=scat.ProductSubcategoryKey
  where prod.ProductSubcategoryKey=IsNull(@ProductCategoryKey, prod.ProductSubcategoryKey)
  and ter.SalesTerritoryGroup=IsNull(@SalesTerritoryGroup, ter.SalesTerritoryGroup)
  and ter.SalesTerritoryCountry=IsNull(@SalesTerritoryCountry, ter.SalesTerritoryCountry)
  and ter.SalesTerritoryRegion=IsNull(@SalesTerritoryRegion, ter.SalesTerritoryRegion)
  and prod.ModelName=IsNull(@ModelName, prod.ModelName)
  order by ModelName, ProductName
END
GO
