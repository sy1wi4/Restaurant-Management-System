USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[AddNewDish]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddNewDish] (@dishName NVARCHAR(50), @restaurantID INT, @categoryName NVARCHAR(50), 
							 @catDescription NTEXT, @price MONEY, @dishID INT OUTPUT)
AS
BEGIN 
	DECLARE @categoryID INT 
	EXEC dbo.FindOrInsertCategory 
			@categoryName, 
			@catDescription, 
			@categoryID = @categoryID OUTPUT 
	INSERT INTO dbo.Menu
	(
	    DishName,
	    RestaurantID,
	    CategoryID,
	    Price
	)
	VALUES
	(
	    @dishName, 
	    @restaurantID,  
	    @categoryID,  
	    @price 
	    )
	SET @dishID = @@IDENTITY
END
	
	
GO
