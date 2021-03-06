USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[OrderSummary]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[OrderSummary](@orderID INT, @customerID INT, @isTakeAway BIT)
RETURNS @summary TABLE
(
	param_name VARCHAR(250),
	param_val VARCHAR(250)
)
AS
BEGIN
	DECLARE @restaurantID INT
	SET @restaurantID = (SELECT RestaurantID FROM dbo.Customers WHERE CustomerID = @customerID)
	DECLARE @restaurantName VARCHAR(50)
	SET @restaurantName = (SELECT RestaurantName FROM dbo.Restaurants WHERE RestaurantID = @restaurantID)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Restaurant Name: ',
	    @restaurantName
	    )
	DECLARE @customerLastname VARCHAR(50)
	SET @customerLastname  = (SELECT LastName FROM dbo.IndividualCustomers WHERE CustomerID = @customerID)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Lastname: ',
	    @customerLastname
	    )
	DECLARE @customerFirstName VARCHAR(50)
	SET @customerFirstName = (SELECT FirstName FROM dbo.IndividualCustomers WHERE CustomerID = @customerID)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Firstname: ', 
	    @customerFirstName
	    )
	DECLARE @address VARCHAR(50)
	SET @address = (SELECT Address FROM Customers WHERE CustomerID = @customerID)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Address:',
	    @address
	    )
	DECLARE @email VARCHAR(50)
	SET @email = (SELECT Email FROM dbo.Customers WHERE CustomerID = @customerID)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Email: ',
	    @email
	    )

	IF (@isTakeAway = 0)
	BEGIN
		DECLARE @orderDate DATETIME
		SET @orderDate = (SELECT OrderDate FROM dbo.OnSiteOrders WHERE OrderID = @orderID)
		DECLARE @executionDate DATETIME
		SET @executionDate = (SELECT ExecutionDate FROM dbo.OnSiteOrders WHERE OrderID = @orderID)
		INSERT @summary
		(
		    param_name,
		    param_val
		)
		VALUES
		(   'Order date: ',
		    @orderDate
		    )
		INSERT @summary
		(
		    param_name,
		    param_val
		)
		VALUES
		(   'Execution date: ',
		    @executionDate
		    )
	END
	ELSE
	BEGIN
		SET @orderDate = (SELECT OrderDate FROM dbo.TakeAwayOrders WHERE OrderID = @orderID)
		SET @executionDate = (SELECT ExecutionDate FROM dbo.TakeAwayOrders WHERE OrderID = @orderID)
		INSERT @summary
		(
		    param_name,
		    param_val
		)
		VALUES
		(   'Order date: ',
		    @orderDate
		    )
		INSERT @summary
		(
		    param_name,
		    param_val
		)
		VALUES
		(   'Execution date: ',
		    @executionDate
		    )
	END
	DECLARE @dishID INT
	DECLARE @quantity INT
	DECLARE @unitPrice MONEY
	DECLARE @dishName VARCHAR(50)
	DECLARE CUR CURSOR FOR
	SELECT DishID, Quantity, UnitPrice FROM dbo.OrderDetails
	WHERE OrderID = @orderID
	GROUP BY DishID, Quantity, UnitPrice
	OPEN CUR
	FETCH NEXT FROM CUR INTO @dishID, @quantity, @unitPrice
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @dishName = (SELECT DishName FROM Menu WHERE DishID = @dishID)
		INSERT @summary
		(
		    param_name,
		    param_val
		)
		VALUES
		(   CONCAT('Dish: ', @dishName, ' x Quantity: ', @quantity),
		    CONCAT(@quantity,' x ', @unitPrice,' zł')
		    )
		FETCH NEXT FROM CUR INTO @dishID, @quantity, @unitPrice
	END
	CLOSE CUR
	DEALLOCATE CUR
	DECLARE @totalOrderValue MONEY
	SET @totalOrderValue = (SELECT dbo.GetOrderValue(@orderID))
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Total order value: ',
	    CONCAT(@totalOrderValue,' zł')
	    )
	RETURN
END
GO
