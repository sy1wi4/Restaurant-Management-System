USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[PastOrdersValue]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PastOrdersValue](@customerID int, @date datetime)
	RETURNS money
AS
BEGIN
	DECLARE @onSiteOrdersValue INT
	SET @onSiteOrdersValue =
			(SELECT SUM(UnitPrice * Quantity)
			FROM Customers INNER JOIN dbo.IndividualReservations
			ON IndividualReservations.CustomerID = Customers.CustomerID
			INNER JOIN dbo.OnSiteOrders
			ON OnSiteOrders.OrderID = IndividualReservations.OrderID
			INNER JOIN dbo.OrderDetails
			ON OrderDetails.OrderID = OnSiteOrders.OrderID
			WHERE (Customers.CustomerID = @customerID AND dbo.OnSiteOrders.OrderDate <= @date
			AND dbo.OnSiteOrders.Status != 'A')
			)
	
	DECLARE @takeAwayOrdersValue INT
	SET @takeAwayOrdersValue = 
			(SELECT SUM(UnitPrice * Quantity)
			FROM dbo.Customers INNER JOIN dbo.TakeAwayOrders
			ON TakeAwayOrders.CustomerID = Customers.CustomerID
			INNER JOIN dbo.OrderDetails
			ON OrderDetails.OrderID = TakeAwayOrders.OrderID
			WHERE (Customers.CustomerID = @customerID AND dbo.TakeAwayOrders.OrderDate <= @date
			AND TakeAwayOrders.Status != 'A')
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
