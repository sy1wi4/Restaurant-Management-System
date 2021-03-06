USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCurrentPermDiscountForIndividualCustomer]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--For given: restaurantID, individual customer ID and date, returns current permanent discount
--based on customer's history of discounts 

CREATE FUNCTION [dbo].[GetCurrentPermDiscountForIndividualCustomer](@restaurantID INT, @customerID INT, @date DATETIME)
	RETURNS TABLE
AS
	RETURN (SELECT TOP 1 dbo.PermIndividualDiscounts.RestaurantID, CustomerID, dbo.IndividualDiscountHist.DiscountID, 
	Since, OrdersNumber, MinOrderPrice, Discount, Till, UseDate
	FROM dbo.PermIndividualDiscounts INNER JOIN dbo.IndividualDiscountHist
	ON IndividualDiscountHist.DiscountID = PermIndividualDiscounts.DiscountID
	WHERE (RestaurantID = @restaurantID AND CustomerID = @customerID
		AND Till IS NULL AND Since <= @date)
	GROUP BY dbo.PermIndividualDiscounts.RestaurantID, CustomerID, dbo.IndividualDiscountHist.DiscountID, 
	Since, OrdersNumber, MinOrderPrice, Discount, Till, UseDate
	ORDER BY Since DESC)
GO
