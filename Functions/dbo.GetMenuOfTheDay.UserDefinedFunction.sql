USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetMenuOfTheDay]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetMenuOfTheDay](@day DATE, @restaurantID INT)
	RETURNS TABLE 
AS
	RETURN (SELECT DishID, DishName, Price, MenuIn, MenuOut FROM 
				(SELECT DishID, DishName, Price, MenuIn, MenuOut,
					ROW_NUMBER() OVER (PARTITION BY DishName ORDER BY DishID) AS row_no
					FROM dbo.MenuView
					WHERE (RestaurantID = @restaurantID 
						AND MenuIn <= @day
						AND (MenuOut IS NULL OR MenuOut >= @day))) AS a
				WHERE a.row_no = 1)
    
GO
