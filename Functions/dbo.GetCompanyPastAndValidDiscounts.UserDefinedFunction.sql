USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCompanyPastAndValidDiscounts]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetCompanyPastAndValidDiscounts](@restaurantID INT, @companyID INT)
	RETURNS TABLE
AS
	RETURN (SELECT dbo.CompanyDiscounts.DiscountID, Since, 
			TotalDiscount, Orders, BillingPeriod, TotalPrice,Discount, MaxDiscount
			FROM dbo.CompanyDiscountHist INNER JOIN dbo.CompanyDiscounts
			ON CompanyDiscounts.DiscountID = CompanyDiscountHist.DiscountID
			WHERE (RestaurantID = @restaurantID AND CustomerID = @companyID))
GO
