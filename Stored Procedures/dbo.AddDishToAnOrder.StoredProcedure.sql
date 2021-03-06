USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[AddDishToAnOrder]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDishToAnOrder]
	@dishName NVARCHAR(50),
	@quantity SMALLINT,
	@orderID INT,
	@restaurantID INT,
	@currentDate DATE
AS
BEGIN
	DECLARE @dishID INT
	SET @dishID = (SELECT DishID FROM dbo.GetMenuOfTheDay(@currentDate, @restaurantID)
						WHERE DishName = @dishName)
	DECLARE @unitPrice MONEY
	SET @unitPrice = (SELECT Price FROM dbo.GetMenuOfTheDay(@currentDate, @restaurantID)
						WHERE DishName = @dishName)
	BEGIN TRY
		INSERT INTO dbo.OrderDetails
		(
			OrderID,
			DishID,
			Quantity,
			UnitPrice
		)
		VALUES
		(   @orderID,   -- OrderID - int
			@dishID,   -- DishID - int
			@quantity,   -- Quantity - smallint
			@unitPrice -- UnitPrice - money
			)
	END TRY
	BEGIN CATCH
		DECLARE @msg VARCHAR(250)
		SET @msg = 'Nie udało się dodać dania do zamówienia. Error message: ' + ERROR_MESSAGE()
		;THROW 52000,@msg,1
	END CATCH
END
GO
