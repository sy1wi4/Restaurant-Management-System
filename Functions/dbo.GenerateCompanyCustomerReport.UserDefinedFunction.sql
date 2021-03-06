USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GenerateCompanyCustomerReport]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GenerateCompanyCustomerReport](
	@customerID INT, 
	@from DATE,
	@to DATE 
	)

RETURNS @report TABLE(
	 field NVARCHAR(100),
	 field_value NVARCHAR(50)
	 )
AS 
BEGIN 
	DECLARE @companyName NVARCHAR(50)
	SET @companyName = (
		SELECT CompanyName FROM dbo.CompanyCustomers
		WHERE CompanyID = @customerID
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Company Name',
	    @companyName
	    )

	

	DECLARE @orders INT
	SET @orders = (
		SELECT COUNT(*) FROM dbo.OnSiteOrders
		WHERE CustomerID = @customerID
		AND ExecutionDate BETWEEN @from AND @to
		AND Status NOT LIKE 'A'
		)

	DECLARE @tOrders INT 
	SET @tOrders = (
		SELECT COUNT(*) FROM dbo.TakeAwayOrders
		WHERE CustomerID = @customerID
		AND ExecutionDate BETWEEN @from AND @to
		AND Status NOT LIKE 'A'
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Executed orders number',
	    @orders + @tOrders
	    )

	DECLARE @cancelledOrders INT
	SET @cancelledOrders = (
		SELECT COUNT(*) FROM dbo.OnSiteOrders
		WHERE CustomerID = @customerID
		AND ExecutionDate BETWEEN @from AND @to
		AND Status LIKE 'A'
		)
	IF @cancelledOrders IS NULL 
		SET @cancelledOrders = 0

	DECLARE @cancelledTOrders INT
	SET @cancelledOrders = (
		SELECT COUNT(*) FROM dbo.TakeAwayOrders
		WHERE CustomerID = @customerID
		AND ExecutionDate BETWEEN @from AND @to
		AND Status LIKE 'A'
		)
	IF @cancelledTOrders IS NULL 
		SET @cancelledTOrders = 0

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Cancelled orders',
	    @cancelledOrders + @cancelledTOrders
	    )

	DECLARE @reservations INT
	SET @reservations = (
	SELECT COUNT(*) FROM dbo.CompanyReservations
		INNER JOIN dbo.TableReservations
		ON TableReservations.ReservationID = CompanyReservations.ReservationID
		WHERE CompanyID = @customerID
		AND SinceWhenReserved BETWEEN @from AND @to
		)
	INSERT @report
	(
	field,
	field_value
	)
	VALUES
	( 'Reservations number',
		@reservations
	)



	DECLARE @ordersValue MONEY  
	SET @ordersValue = (
		SELECT SUM(Quantity*UnitPrice) FROM dbo.OnSiteOrders
		INNER JOIN dbo.OrderDetails
		ON OrderDetails.OrderID = OnSiteOrders.OrderID
		INNER JOIN dbo.Menu
		ON Menu.DishID = OrderDetails.DishID
		WHERE CustomerID = @customerID
		AND Status NOT LIKE 'A'
		AND ExecutionDate BETWEEN @from AND @to
		)

	IF @ordersValue IS NULL 
		SET @ordersValue = 0

	DECLARE @ordersTValue MONEY  
	SET @ordersTValue = (
		SELECT SUM(Quantity*UnitPrice) FROM dbo.OnSiteOrders
		INNER JOIN dbo.OrderDetails
		ON OrderDetails.OrderID = OnSiteOrders.OrderID
		INNER JOIN dbo.Menu
		ON Menu.DishID = OrderDetails.DishID
		WHERE CustomerID = @customerID
		AND Status NOT LIKE 'A'
		AND ExecutionDate BETWEEN @from AND @to
		)

	IF @ordersTValue IS NULL 
		SET @ordersTValue = 0

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Total orders value',
	    @ordersValue + @ordersTValue
	    )

	DECLARE @grantedDiscounts INT
		SET @grantedDiscounts = (
		SELECT COUNT(*) FROM dbo.CompanyDiscountHist
		WHERE CustomerID = @customerID
		AND Since BETWEEN @from AND @to
		)

	INSERT @report
	(
	field,
	field_value
	)
	VALUES
	( 'Granted discounts',
		@grantedDiscounts
	)

	RETURN 

END 

	




GO
