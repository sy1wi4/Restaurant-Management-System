USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[PastCompanyOrdersCountWithinBillingPeriod]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PastCompanyOrdersCountWithinBillingPeriod](@companyID INT, @since DATETIME, @billingPeriod INT)
	RETURNS INT
AS
BEGIN
	DECLARE @onSiteOrdersCount INT
	SET @onSiteOrdersCount = (SELECT COUNT(*)
			FROM OnSiteOrders
			WHERE (OnSiteOrders.CustomerID = @companyID 
			AND dbo.OnSiteOrders.OrderDate >= @since
			AND dbo.OnSiteOrders.OrderDate <= DATEADD(DAY, @billingPeriod, @since)
			AND dbo.OnSiteOrders.Status != 'A'))

	DECLARE @takeAwayOrdersCount INT
	SET @takeAwayOrdersCount = (SELECT COUNT(*)
			FROM dbo.TakeAwayOrders
			WHERE (dbo.TakeAwayOrders.CustomerID = @companyID 
			AND dbo.TakeAwayOrders.OrderDate >= @since
			AND dbo.TakeAwayOrders.OrderDate <= DATEADD(DAY, @billingPeriod, @since)
			AND dbo.TakeAwayOrders.Status != 'A'))

	IF (@onSiteOrdersCount IS NOT null)
	BEGIN
		IF (@takeAwayOrdersCount IS NOT NULL)
		BEGIN
			RETURN (@onSiteOrdersCount + @takeAwayOrdersCount)
		END
		ELSE 
		BEGIN
			RETURN @onSiteOrdersCount
		END
	END
	ELSE IF (@takeAwayOrdersCount IS NOT NULL)
	BEGIN
		RETURN @takeAwayOrdersCount
	END
	RETURN 0
END
GO
