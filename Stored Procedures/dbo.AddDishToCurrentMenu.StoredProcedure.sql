USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[AddDishToCurrentMenu]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddDishToCurrentMenu] (
	@restaurantID INT, 
	@dishName NVARCHAR(50),
	@menuIn DATE = NULL
	)
AS
BEGIN 
	
	DECLARE @dishID INT
	SET @dishID = (SELECT DishID FROM dbo.Menu 
				   WHERE DishName = @dishName
				   AND RestaurantID = @restaurantID)
	
	IF @menuIn IS NULL 
		SET @menuIn = GETDATE()

	IF (@dishID IS NULL)
	BEGIN
		;THROW 52000, 
		'Podane danie nie znajduje się w bazie dań restauracji, wymagane jego wprowadzenie',1
	END

	IF EXISTS (
		SELECT * FROM dbo.GetMenuOfTheDay(@menuIn, @restaurantID)
		WHERE DishID = @dishID
		)
		BEGIN 
			; THROW 52000, 
			'Wprowadzone danie znajduje się już w menu restauracji', 1
		END 

	SET IDENTITY_INSERT dbo.MenuRegister ON 
	INSERT INTO dbo.MenuRegister
	(
	    DishID,
	    MenuIn,
	    MenuOut
	)
	VALUES
	(   @dishID,  
	    @menuIn, 
	    NULL 
	    )
	
END

									   
GO
