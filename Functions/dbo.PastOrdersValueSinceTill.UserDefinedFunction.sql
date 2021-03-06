USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[PastOrdersValueSinceTill]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PastOrdersValueSinceTill](@customerID int, @since DATETIME, @till DATETIME)
	RETURNS money
AS
BEGIN
	DECLARE @onSiteOrdersValue INT
	SET @onSiteOrdersValue =
			(SELECT SUM(UnitPrice * Quantity)
			FROM dbo.OnSiteOrders INNER JOIN dbo.OrderDetails
			ON OrderDetails.OrderID = OnSiteOrders.OrderID
			WHERE (dbo.OnSiteOrders.CustomerID = @customerID
			AND dbo.OnSiteOrders.OrderDate >= @since AND dbo.OnSiteOrders.OrderDate <= @till
			AND dbo.OnSiteOrders.Status != 'A')
			)
	
	DECLARE @takeAwayOrdersValue INT
	SET @takeAwayOrdersValue = 
			(SELECT SUM(UnitPrice * Quantity)
			FROM dbo.TakeAwayOrders INNER JOIN dbo.OrderDetails
			ON OrderDetails.OrderID = TakeAwayOrders.OrderID
			WHERE (dbo.TakeAwayOrders.CustomerID = @customerID
			AND dbo.TakeAwayOrders.OrderDate >= @since AND dbo.TakeAwayOrders.OrderDate <= @till
			AND dbo.TakeAwayOrders.Status != 'A')
			)
	IF (@onSiteOrdersValue IS NOT null)
		IF (@takeAwayOrdersValue IS NOT NULL)
		RETURN (@onSiteOrdersValue + @takeAwayOrdersValue)
		ELSE RETURN @onSiteOrdersValue
	ELSE IF (@takeAwayOrdersValue IS NOT NULL)
		RETURN @takeAwayOrdersValue
	RETURN 0
END
GO
