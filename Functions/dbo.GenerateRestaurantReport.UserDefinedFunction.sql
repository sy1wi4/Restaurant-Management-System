USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GenerateRestaurantReport]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GenerateRestaurantReport](
	@restaurantID INT, 
	@from DATE,
	@to DATE 
	)
RETURNS @report TABLE(
	 field NVARCHAR(100),
	 field_value NVARCHAR(100)
	 )
AS 
BEGIN 
	DECLARE @restaurantName NVARCHAR(50)
	SET @restaurantName = (
		SELECT RestaurantName FROM dbo.Restaurants
		WHERE RestaurantID = @restaurantID
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Restaurant name',
	    @restaurantName
	    )

	DECLARE @tables INT
	SET @tables = (
		SELECT COUNT(*) FROM dbo.Tables
		WHERE RestaurantID = @restaurantID
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Tables number',
	    @tables
	    )

	DECLARE @seatsNumber INT 
	SET @seatsNumber = (
		SELECT SUM(SeatsNumber) FROM dbo.Tables
		WHERE RestaurantID = @restaurantID
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Total seats number',
	    @seatsNumber
	    )

	DECLARE @menuDishes INT 
	SET @menuDishes = (
		SELECT COUNT(DISTINCT DishName) FROM dbo.MenuRegister
		INNER JOIN dbo.Menu 
		ON Menu.DishID = MenuRegister.DishID
		WHERE RestaurantID = @restaurantID AND (MenuIn BETWEEN @from AND @to)
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Dishes number',
		@menuDishes
	    )
	
	DECLARE @oSordersNumber INT 
	SET @oSordersNumber = (
		SELECT COUNT(*) FROM dbo.Customers
		INNER JOIN dbo.OnSiteOrders
		ON OnSiteOrders.CustomerID = Customers.CustomerID
		WHERE RestaurantID = @restaurantID
		AND ExecutionDate BETWEEN @from AND @to 
		)
	DECLARE @tAOrdersNumber INT 
	SET @tAOrdersNumber = (
		SELECT COUNT(*) FROM dbo.Customers
		INNER JOIN dbo.TakeAwayOrders
		ON TakeAwayOrders.CustomerID = Customers.CustomerID
		WHERE RestaurantID = @restaurantID
		AND ExecutionDate BETWEEN @from AND @to 
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Total orders number',
	    @tAOrdersNumber + @oSordersNumber
	    )
	
	DECLARE @tAOrdersMoney MONEY 
	SET @tAOrdersMoney = (
		SELECT SUM(UnitPrice*Quantity) FROM dbo.Customers
		INNER JOIN dbo.TakeAwayOrders
		ON TakeAwayOrders.CustomerID = Customers.CustomerID
		INNER JOIN dbo.OrderDetails
		ON OrderDetails.OrderID = TakeAwayOrders.OrderID
		WHERE RestaurantID = @restaurantID
		AND ExecutionDate BETWEEN @from AND @to
		)
	IF @tAOrdersMoney IS NULL 
		SET @tAOrdersMoney = 0


	DECLARE @oSOrdersMoney MONEY
	SET @oSOrdersMoney = (
		SELECT SUM(Quantity*UnitPrice) FROM dbo.Customers
		INNER JOIN dbo.OnSiteOrders
		ON OnSiteOrders.CustomerID = Customers.CustomerID
		INNER JOIN dbo.OrderDetails
		ON OrderDetails.OrderID = OnSiteOrders.OrderID
		WHERE RestaurantID = @restaurantID
		AND ExecutionDate BETWEEN @from AND @to
		)

	IF @oSOrdersMoney IS NULL 
		SET @oSOrdersMoney = 0

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Total orders money',
		@tAOrdersMoney + @oSOrdersMoney
	    )


	DECLARE @grantedIndDiscounts INT
	SET @grantedIndDiscounts = (
		SELECT COUNT(*) FROM dbo.IndividualDiscountHist
		INNER JOIN dbo.Customers
		ON Customers.CustomerID = IndividualDiscountHist.CustomerID
		WHERE RestaurantID = @restaurantID
		AND Since BETWEEN @from AND @to 
		)
	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(  'Granted individual discouts',
	    @grantedIndDiscounts
	    )


	DECLARE @grantedCompDiscounts INT
	SET @grantedCompDiscounts = (
		SELECT COUNT(*) FROM dbo.CompanyDiscountHist
		INNER JOIN dbo.Customers
		ON Customers.CustomerID = dbo.CompanyDiscountHist.CustomerID
		WHERE RestaurantID = @restaurantID
		AND Since BETWEEN @from AND @to 
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(  'Granted company discouts',
	    @grantedCompDiscounts
	    )

	RETURN 
END 
GO
