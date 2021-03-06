USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCurrentValidTempIndividualDiscounts]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetCurrentValidTempIndividualDiscounts](@restaurantID INT, @customerID INT, @date DATETIME)
	RETURNS TABLE
AS
RETURN (SELECT dbo.TempIndividualDiscounts.DiscountID, CustomerID, Since, Till, UseDate, MinTotalPrice, Duration, Discount
	FROM dbo.IndividualDiscountHist INNER JOIN dbo.TempIndividualDiscounts
	ON TempIndividualDiscounts.DiscountID = IndividualDiscountHist.DiscountID
	WHERE (RestaurantID = @restaurantID AND CustomerID = @customerID AND Till IS NOT NULL AND Since <= @date AND UseDate IS null)
	)
GO
