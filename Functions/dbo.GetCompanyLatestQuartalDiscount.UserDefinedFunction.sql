USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCompanyLatestQuartalDiscount]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetCompanyLatestQuartalDiscount](@restaurantID INT, @companyID INT, @since DATETIME)
	RETURNS TABLE
AS
	RETURN (SELECT TOP 1 dbo.CompanyDiscountHist.DiscountID, BillingPeriod, TotalPrice, Discount, Since
	FROM dbo.CompanyDiscounts INNER JOIN dbo.CompanyDiscountHist ON CompanyDiscountHist.DiscountID = CompanyDiscounts.DiscountID
	WHERE RestaurantID = @restaurantID AND customerID = @companyID AND Since >= @since
	ORDER BY since DESC)
GO
