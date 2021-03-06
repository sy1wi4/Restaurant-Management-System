USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDishesWhichCanBePlacedInMenu]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetDishesWhichCanBePlacedInMenu] (
	@day DATE,
	@restaurantID INT
	)
	RETURNS TABLE
AS
RETURN SELECT DISTINCT DishName FROM dbo.Menu
	WHERE RestaurantID = @restaurantID AND 
		DishName NOT IN (
		-- te, ktore sa w aktualnym menu
		SELECT DishName FROM dbo.GetMenuOfTheDay(@day,@restaurantID)
		)
		AND DishName NOT IN (
			-- te, ktore nie byly zdjete z menu przez ostatni miesiac 
			-- (czyli, te ktorych nie bylo w menu wcale lub zostay zdjete co najmniej miesiac temu
			SELECT m.DishName FROM menu m
			INNER JOIN dbo.MenuRegister mr
			ON mr.DishID = m.DishID
			WHERE mr.menuout IS NOT NULL AND 
			(DATEDIFF(MONTH, mr.menuout, @day) BETWEEN 0 AND 1) AND
			m.RestaurantID = @restaurantID
			)

	


GO
