USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[AddOnSiteOrder]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddOnSiteOrder]
	@restaurantID INT,
	@customerID INT,
	@orderDate DATETIME,
	@forWhen DATETIME,
	@paymentOption BIT, --1 - payment straight away; 0 - payment to be confirmed later
	@orderID INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET IDENTITY_INSERT dbo.OnSiteOrders OFF;
	DECLARE @designateEmployee INT
	SET @designateEmployee = (SELECT TOP 1 EmployeeID FROM dbo.Employees INNER JOIN dbo.Managers
								ON Managers.ManagerID = Employees.ManagerID
								INNER JOIN dbo.Restaurants ON Restaurants.ManagerID = Managers.ManagerID
								WHERE RestaurantID = @restaurantID)
	IF (@paymentOption = 1)
	BEGIN
	INSERT INTO dbo.OnSiteOrders
	(
	    CustomerID,
	    EmployeeID,
	    OrderDate,
	    ExecutionDate,
	    Status
	)
	VALUES
	(   
		@customerID,
	    @designateEmployee,
	    @orderDate,
	    @forWhen,
	    'P'
	    )
	SET @orderID = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
			INSERT INTO dbo.OnSiteOrders
		(
			CustomerID,
			EmployeeID,
			OrderDate,
			ExecutionDate,
			Status
		)
		VALUES
		(   
			@customerID,
			@designateEmployee,
			@orderDate,
			@forWhen,
			'N'
			)
	SET @orderID = SCOPE_IDENTITY()
	END
END
GO
