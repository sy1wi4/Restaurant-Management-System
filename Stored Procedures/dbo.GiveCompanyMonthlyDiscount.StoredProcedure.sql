USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[GiveCompanyMonthlyDiscount]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GiveCompanyMonthlyDiscount]
	@restaurantID INT,
	@companyID INT,
	@date DATETIME
AS
BEGIN
	IF ((SELECT COUNT(*) FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date)) = 1)
	BEGIN
		DECLARE @discountToContinue SMALLINT
		SET @discountToContinue = (SELECT DiscountID FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date))
		DECLARE @billingPeriod INT
		SET @billingPeriod = (SELECT BillingPeriod FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date))
		DECLARE @lastDate DATETIME
		SET @lastDate = (SELECT Since FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date))
		DECLARE @ordersValueWithinBillingPeriod MONEY
		SET @ordersValueWithinBillingPeriod = (SELECT [dbo].[PastCompanyOrdersValueWithinBillingPeriod](@companyID, @lastDate, @billingPeriod))
		DECLARE @ordersCountWithinBillingPeriod INT
		SET @ordersCountWithinBillingPeriod = (SELECT [dbo].[PastCompanyOrdersCountWithinBillingPeriod](@companyID, @lastDate, @billingPeriod))
		DECLARE @requiredOrdersValue MONEY
		SET @requiredOrdersValue = (SELECT TotalPrice FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date))
		DECLARE @requiredOrdersCount INT
		SET @requiredOrdersCount = (SELECT Orders FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date))

		IF ((DATEADD(DAY, @billingPeriod, @lastDate) < @date) OR (@ordersCountWithinBillingPeriod < @requiredOrdersCount) OR (@ordersValueWithinBillingPeriod < @requiredOrdersValue))
		BEGIN
			DECLARE @discountToGive SMALLINT
			SET @discountToGive = (SELECT TOP 1 DiscountID FROM dbo.CompanyDiscounts WHERE RestaurantID = @restaurantID AND BillingPeriod = @billingPeriod ORDER BY Discount ASC)
			SET @requiredOrdersValue = (SELECT TotalPrice FROM dbo.CompanyDiscounts WHERE DiscountID = @discountToGive)
			SET @requiredOrdersCount = (SELECT Orders FROM dbo.CompanyDiscounts WHERE DiscountID = @discountToGive)
			SET @ordersValueWithinBillingPeriod = (SELECT [dbo].[PastCompanyOrdersValueWithinBillingPeriod](@companyID, DATEADD(DAY, -1*@billingPeriod, @date), @billingPeriod))
			SET @ordersCountWithinBillingPeriod = (SELECT [dbo].[PastCompanyOrdersCountWithinBillingPeriod](@companyID, DATEADD(DAY, -1*@billingPeriod, @date), @billingPeriod))
			IF (@ordersCountWithinBillingPeriod >= @requiredOrdersCount AND @ordersValueWithinBillingPeriod >= @requiredOrdersValue)
			BEGIN
				DECLARE @discount REAL
				SET @discount = (SELECT Discount FROM dbo.CompanyDiscounts WHERE DiscountID = @discountToGive)
				SET IDENTITY_INSERT dbo.CompanyDiscountHist ON;
				INSERT INTO dbo.CompanyDiscountHist
				(
					CustomerID,
					DiscountID,
					Since,
					TotalDiscount
				)
				VALUES
				(   @companyID,
					@discountToGive,
					@date,
					@discount
					)
			END
			ELSE 
			BEGIN
				;THROW 52000, 'Klient nie spełnił wymagań ciągłości zamówień, jego rabat został anulowany. Nie spełnia również wymagań do przyznania nowego rabatu za ostatni okres rozliczeniowy',1
			END
		END
		ELSE
		BEGIN
			SET @ordersValueWithinBillingPeriod = (SELECT [dbo].[PastCompanyOrdersValueWithinBillingPeriod](@companyID, @lastDate, @billingPeriod))
			SET @ordersCountWithinBillingPeriod = (SELECT [dbo].[PastCompanyOrdersCountWithinBillingPeriod](@companyID, @lastDate, @billingPeriod))
			SET @requiredOrdersValue = (SELECT TotalPrice FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date))
			SET @requiredOrdersCount = (SELECT Orders FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date))
			DECLARE @maxDiscount REAL
			SET @maxDiscount = (SELECT MaxDiscount FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date))
			IF (@ordersValueWithinBillingPeriod >= @requiredOrdersValue AND @ordersCountWithinBillingPeriod >= @requiredOrdersCount)
			BEGIN
				DECLARE @discountUpdate REAL
				SET @discountUpdate = ((SELECT TotalDiscount FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date)) 
										+ (SELECT Discount FROM [dbo].[GetCompanyLatestMonthlyDiscount](@restaurantID, @companyID, @date)))
				IF (@discountUpdate <= @maxDiscount)
				BEGIN
					INSERT INTO dbo.CompanyDiscountHist
					(
						CustomerID,
						DiscountID,
						Since,
						TotalDiscount
					)
					VALUES
					(   @companyID,
						@discountToContinue,
						@date,
						@discountUpdate
						)
				END
				ELSE
				BEGIN
					;THROW 52000, 'Klient spełnił wymagania ciągłości zamówień. Rabat nie ulega zmianom, ponieważ osiągnięto rabat maksymalny',1
				END
			END
		END
	END
	ELSE
	BEGIN
		SET @discountToGive = (SELECT TOP 1 DiscountID FROM dbo.CompanyDiscounts WHERE RestaurantID = @restaurantID AND BillingPeriod = @billingPeriod ORDER BY Discount ASC)
		SET @requiredOrdersValue = (SELECT TotalPrice FROM dbo.CompanyDiscounts WHERE DiscountID = @discountToGive)
		SET @requiredOrdersCount = (SELECT Orders FROM dbo.CompanyDiscounts WHERE DiscountID = @discountToGive)
		SET @ordersValueWithinBillingPeriod = (SELECT [dbo].[PastCompanyOrdersValueWithinBillingPeriod](@companyID, DATEADD(DAY, -1*@billingPeriod, @date), @billingPeriod))
		SET @ordersCountWithinBillingPeriod = (SELECT [dbo].[PastCompanyOrdersCountWithinBillingPeriod](@companyID, DATEADD(DAY, -1*@billingPeriod, @date), @billingPeriod))
		IF (@ordersCountWithinBillingPeriod >= @requiredOrdersCount AND @ordersValueWithinBillingPeriod >= @requiredOrdersValue)
		BEGIN
			SET @discount = (SELECT Discount FROM dbo.CompanyDiscounts WHERE DiscountID = @discountToGive)
			SET IDENTITY_INSERT dbo.CompanyDiscountHist ON;
			INSERT INTO dbo.CompanyDiscountHist
			(
				CustomerID,
				DiscountID,
				Since,
				TotalDiscount
			)
			VALUES
			(   @companyID,
				@discountToGive,
				@date,
				@discount
				)
		END
		ELSE
		BEGIN
			;THROW 52000, 'Klient nie posiadał do tej pory rabatu firmowego i nie spełnia aktualnie wymagań do jego przyznania.',1
		END
	END
END
		
GO
