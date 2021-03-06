USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetHighestPermanentIndividualDiscountInARestaurant]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetHighestPermanentIndividualDiscountInARestaurant](@restaurantID INT)
	RETURNS SMALLINT
AS
BEGIN
	RETURN (SELECT TOP 1 DiscountID FROM dbo.PermIndividualDiscounts
								WHERE RestaurantID = @restaurantID
								ORDER BY Discount DESC)
END
GO
