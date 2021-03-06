USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GenerateInvoice]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GenerateInvoice] (@orderID INT, @companyID INT, @isTakeAway BIT)
RETURNS @invoice TABLE
(
	param_name VARCHAR(50),
	param_val MONEY
)
AS
BEGIN
	DECLARE @restaurantID INT
	SET @restaurantID = (SELECT RestaurantID FROM dbo.Customers WHERE CustomerID = @companyID)
	DECLARE @restaurantName VARCHAR(50)
	SET @restaurantName = (SELECT RestaurantName FROM dbo.Restaurants WHERE RestaurantID = @restaurantID)
	INSERT @invoice
	(
	    param_name,
	    param_val
	)
	VALUES
	(   CONCAT('Restaurant Name: ', @restaurantName),  -- param_name - varchar(50)
	    NULL -- param_val - money
	    )
	DECLARE @companyName VARCHAR(250)
	SET @companyName = (SELECT CompanyName FROM dbo.CompanyCustomers WHERE CompanyID = @companyID)
	INSERT @invoice
	(
	    param_name,
	    param_val
	)
	VALUES
	(   CONCAT('Company Name: ', @companyName),  -- param_name - varchar(50)
	    NULL -- param_val - money
	    )
	DECLARE @NIP VARCHAR(50)
	SET @NIP = (SELECT NIP FROM dbo.CompanyCustomers WHERE CompanyID = @companyID)
	INSERT @invoice
	(
	    param_name,
	    param_val
	)
	VALUES
	(   CONCAT('NIP: ', @NIP),  -- param_name - varchar(50)
	    NULL -- param_val - money
	    )
	DECLARE @address VARCHAR(50)
	SET @address = (SELECT Address FROM Customers WHERE CustomerID = @companyID)
	INSERT @invoice
	(
	    param_name,
	    param_val
	)
	VALUES
	(   CONCAT('Company Address: ', @address),  -- param_name - varchar(50)
	    NULL -- param_val - money
	    )
	DECLARE @email VARCHAR(50)
	SET @email = (SELECT Email FROM dbo.Customers WHERE CustomerID = @companyID)
	INSERT @invoice
	(
	    param_name,
	    param_val
	)
	VALUES
	(   CONCAT('Company email: ', @email),  -- param_name - varchar(50)
	    NULL -- param_val - money
	    )
	IF (@isTakeAway = 0)
	BEGIN
		DECLARE @orderDate DATETIME
		SET @orderDate = (SELECT OrderDate FROM dbo.OnSiteOrders WHERE OrderID = @orderID)
		DECLARE @executionDate DATETIME
		SET @executionDate = (SELECT ExecutionDate FROM dbo.OnSiteOrders WHERE OrderID = @orderID)
		INSERT @invoice
		(
		    param_name,
		    param_val
		)
		VALUES
		(   CONCAT('Order date: ', @orderDate),  -- param_name - varchar(50)
		    NULL -- param_val - money
		    )
		INSERT @invoice
		(
		    param_name,
		    param_val
		)
		VALUES
		(   CONCAT('Execution date: ',@executionDate),  -- param_name - varchar(50)
		    NULL -- param_val - money
		    )
	END
	ELSE
	BEGIN
		SET @orderDate = (SELECT OrderDate FROM dbo.TakeAwayOrders WHERE OrderID = @orderID)
		SET @executionDate = (SELECT ExecutionDate FROM dbo.TakeAwayOrders WHERE OrderID = @orderID)
		INSERT @invoice
		(
		    param_name,
		    param_val
		)
		VALUES
		(   CONCAT('Order date: ', @orderDate),  -- param_name - varchar(50)
		    NULL -- param_val - money
		    )
		INSERT @invoice
		(
		    param_name,
		    param_val
		)
		VALUES
		(   CONCAT('Execution date: ',@executionDate),  -- param_name - varchar(50)
		    NULL -- param_val - money
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
		INSERT @invoice
		(
		    param_name,
		    param_val
		)
		VALUES
		(   CONCAT('Dish: ', @dishName, ' Quantity: ', @quantity),  -- param_name - varchar(50)
		    (@quantity * @unitPrice) -- param_val - money
		    )
		FETCH NEXT FROM CUR INTO @dishID, @quantity, @unitPrice
	END
	CLOSE CUR
	DEALLOCATE CUR
	DECLARE @totalOrderValue MONEY
	SET @totalOrderValue = (SELECT dbo.GetOrderValue(@orderID))
	INSERT @invoice
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Total order value: ',  -- param_name - varchar(50)
	    @totalOrderValue -- param_val - money
	    )
	RETURN
END
GO
