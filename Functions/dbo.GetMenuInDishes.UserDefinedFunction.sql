USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetMenuInDishes]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetMenuInDishes] (@days INT, @from DATE, @restaurantID INT)
	RETURNS TABLE
AS
	RETURN (SELECT * FROM dbo.MenuView
			WHERE (RestaurantID = @restaurantID 
			AND (DATEDIFF(DAY, MenuIn, @from) BETWEEN 0 AND @days)))
GO
