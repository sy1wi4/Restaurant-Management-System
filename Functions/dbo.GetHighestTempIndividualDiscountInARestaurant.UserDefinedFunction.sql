USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetHighestTempIndividualDiscountInARestaurant]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetHighestTempIndividualDiscountInARestaurant](@restaurantID INT)
	RETURNS SMALLINT
AS
BEGIN
	RETURN (SELECT TOP 1 DiscountID FROM dbo.TempIndividualDiscounts
			WHERE RestaurantID = @restaurantID
			ORDER BY Discount DESC)
END
GO
