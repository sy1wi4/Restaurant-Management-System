USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[PastOrdersCount]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PastOrdersCount] (@customerID INT, @since DATETIME, @until DATETIME)
	RETURNS INT
AS
BEGIN
	DECLARE @onSiteOrdersCount INT
		SET @onSiteOrdersCount =
			(SELECT COUNT(*)
				FROM Customers INNER JOIN dbo.IndividualReservations
				ON IndividualReservations.CustomerID = Customers.CustomerID
				INNER JOIN dbo.OnSiteOrders
				ON OnSiteOrders.OrderID = IndividualReservations.OrderID
				INNER JOIN dbo.OrderDetails
				ON OrderDetails.OrderID = OnSiteOrders.OrderID
				WHERE (Customers.CustomerID = @customerID AND dbo.OnSiteOrders.OrderDate >= @since
				AND dbo.OnSiteOrders.OrderDate < @until)
			)
		DECLARE @takeAwayOrdersCount INT
		SET @takeAwayOrdersCount =
			(SELECT COUNT(*)
				FROM Customers INNER JOIN dbo.TakeAwayOrders
				ON TakeAwayOrders.CustomerID = Customers.CustomerID
				INNER JOIN dbo.OrderDetails
				ON OrderDetails.OrderID = TakeAwayOrders.OrderID
				WHERE (Customers.CustomerID = @customerID AND dbo.TakeAwayOrders.OrderDate >= @since
				AND dbo.TakeAwayOrders.OrderDate < @until)
			)
		IF (@onSiteOrdersCount IS NOT null)
			IF (@takeAwayOrdersCount IS NOT NULL)
				RETURN (@onSiteOrdersCount + @takeAwayOrdersCount)
			ELSE RETURN @onSiteOrdersCount
		ELSE IF (@takeAwayOrdersCount IS NOT NULL)
			RETURN @takeAwayOrdersCount
		RETURN 0
END
GO
