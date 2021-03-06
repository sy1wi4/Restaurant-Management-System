USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GenerateIndividualCustomerReport]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GenerateIndividualCustomerReport](
	@customerID INT, 
	@from DATE,
	@to DATE 
	)
RETURNS @report TABLE(
	 field NVARCHAR(100),
	 field_value NVARCHAR(100)
	 )
AS 
BEGIN 
	DECLARE @firstName NVARCHAR(50)
	SET @firstName = (
		SELECT FirstName FROM dbo.IndividualCustomers
		WHERE CustomerID = @customerID
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'First Name', 
	    @firstName  
	    )

	DECLARE @lastName NVARCHAR(50)
	SET @lastName = (
		SELECT LastName FROM dbo.IndividualCustomers
		WHERE CustomerID = @customerID
		)
	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Last Name', 
	    @lastName  
	    )

	DECLARE @totalOnSiteOrders INT
	SET @totalOnSiteOrders = (
		SELECT count(*) FROM dbo.OnSiteOrders
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
	(   'Executed on site orders', 
	    @totalOnSiteOrders 
	    )


	DECLARE @cancelledOSOrders INT 
	SET @cancelledOSOrders = (
		SELECT count(*) FROM dbo.OnSiteOrders
		WHERE CustomerID = @customerID 
		AND ExecutionDate BETWEEN @from AND @to 
		AND Status LIKE 'A'
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Cancelled on site orders', 
	    @cancelledOSOrders
	    )

	DECLARE @totalOSOrdersValue MONEY

	SET @totalOSOrdersValue = (
		SELECT SUM(Quantity*UnitPrice) FROM dbo.OnSiteOrders
		INNER JOIN dbo.OrderDetails
		ON OrderDetails.OrderID = OnSiteOrders.OrderID
		INNER JOIN dbo.Menu
		ON Menu.DishID = OrderDetails.DishID
		WHERE CustomerID = @customerID
		AND Status NOT LIKE 'A'
		AND ExecutionDate BETWEEN @from AND @to 
		)

	IF @totalOSOrdersValue IS NULL 
		SET @totalOSOrdersValue = 0

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Total on site orders value',
	    @totalOSOrdersValue  
	    )

	DECLARE @totalTakeAwayOrders INT 
	SET @totalTakeAwayOrders = (
		SELECT count(*) FROM dbo.TakeAwayOrders
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
	(   'Executed take away orders', 
	    @totalTakeAwayOrders
	    )

	DECLARE @cancelledTAOrders INT 
	SET @cancelledTAOrders = (
		SELECT count(*) FROM dbo.TakeAwayOrders
		WHERE CustomerID = @customerID
		AND ExecutionDate BETWEEN @from AND @to 
		AND Status LIKE 'A' 
		)
	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Cancelled take away orders', 
	    @cancelledTAOrders
	    )

	DECLARE @totalTAOrdersValue MONEY
	SET @totalTAOrdersValue = (
		SELECT SUM(Quantity*UnitPrice) FROM dbo.TakeAwayOrders
		INNER JOIN dbo.OrderDetails
		ON OrderDetails.OrderID = TakeAwayOrders.OrderID
		INNER JOIN dbo.Menu
		ON Menu.DishID = OrderDetails.DishID
		WHERE CustomerID = @customerID
		AND Status NOT LIKE 'A'
		AND ExecutionDate BETWEEN @from AND @to
	)

	IF @totalTAOrdersValue IS NULL 
		SET @totalTAOrdersValue = 0

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Total take away orders value', 
	    @totalTAOrdersValue 
	    )

	DECLARE @reservations INT
	SET @reservations = (
		SELECT COUNT(*) FROM dbo.IndividualReservations
		INNER JOIN dbo.TableReservations
		ON TableReservations.ReservationID = IndividualReservations.ReservationID
		WHERE CustomerID = @customerID
		AND SinceWhenReserved BETWEEN @from AND @to 
		)
	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Reservations number', 
	    @reservations
	    )


	DECLARE @grantedDiscounts INT 
	SET @grantedDiscounts  = (
		SELECT COUNT(*) FROM dbo.IndividualDiscountHist
		WHERE CustomerID = @customerID
		AND Since BETWEEN @from AND @to 
		)

	INSERT @report
	(
	    field,
	    field_value
	)
	VALUES
	(   'Granted discounts', 
	    @grantedDiscounts
	    )

	RETURN
END 




	

GO
