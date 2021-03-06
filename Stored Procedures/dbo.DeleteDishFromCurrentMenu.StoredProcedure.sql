USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[DeleteDishFromCurrentMenu]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeleteDishFromCurrentMenu] (
	@restaurantID INT, 
	@dishName NVARCHAR(50),
	@menuOut date = NULL
	)
AS 
BEGIN
	DECLARE @dishID INT
		SET @dishID = (SELECT TOP 1 DishID FROM dbo.Menu 
					   WHERE DishName = @dishName
					   AND RestaurantID = @restaurantID)
	
		IF @menuOut IS NULL
			SET @menuOut = GETDATE()

		IF (@dishID IS NULL)
		BEGIN
			;THROW 52000, 'Podane danie nie znajduje się w menu restauracji',1
		END

		UPDATE dbo.MenuRegister
		SET MenuOut = @menuOut
		WHERE DishID = @dishID
		AND (MenuOut IS NULL)
END 


GO
