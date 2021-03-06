USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[PastCompanyOrdersValueWithinBillingPeriod]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PastCompanyOrdersValueWithinBillingPeriod](@companyID INT, @since DATETIME, @billingPeriod INT)
	RETURNS INT
AS
BEGIN
	DECLARE @onSiteOrdersValue MONEY
	SET @onSiteOrdersValue = (SELECT SUM(UnitPrice * Quantity)
			FROM OnSiteOrders
			INNER JOIN dbo.OrderDetails
			ON OrderDetails.OrderID = OnSiteOrders.OrderID
			WHERE (OnSiteOrders.CustomerID = @companyID 
			AND dbo.OnSiteOrders.OrderDate >= @since
			AND dbo.OnSiteOrders.OrderDate <= DATEADD(DAY, @billingPeriod, @since)
			AND dbo.OnSiteOrders.Status != 'A'))

	DECLARE @takeAwayOrdersValue MONEY
	SET @takeAwayOrdersValue = (SELECT SUM(UnitPrice * Quantity)
			FROM TakeAwayOrders
			INNER JOIN dbo.OrderDetails
			ON OrderDetails.OrderID = dbo.TakeAwayOrders.OrderID
			WHERE (dbo.TakeAwayOrders.CustomerID = @companyID
			AND dbo.TakeAwayOrders.OrderDate >= @since 
			AND dbo.TakeAwayOrders.OrderDate <= DATEADD(DAY, @billingPeriod, @since)
			AND dbo.TakeAwayOrders.Status != 'A'))
	IF (@onSiteOrdersValue IS NOT null)
	BEGIN
		IF (@takeAwayOrdersValue IS NOT NULL)
		BEGIN
			RETURN (@onSiteOrdersValue + @takeAwayOrdersValue)
		END
		ELSE 
		BEGIN
			RETURN @onSiteOrdersValue
		END
	END
	ELSE IF (@takeAwayOrdersValue IS NOT NULL)
	BEGIN
		RETURN @takeAwayOrdersValue
	END
	RETURN 0
END
GO
