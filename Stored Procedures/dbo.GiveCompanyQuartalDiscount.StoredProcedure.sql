USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[GiveCompanyQuartalDiscount]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GiveCompanyQuartalDiscount]
	@restaurantID INT,
	@companyID INT,
	@date DATETIME
AS
BEGIN
	IF ((SELECT COUNT(*) FROM [dbo].[GetCompanyLatestQuartalDiscount](@restaurantID, @companyID, @date)) = 1)
	BEGIN
		DECLARE @quartal INT
		SET @quartal = (SELECT BillingPeriod FROM [dbo].[GetCompanyLatestQuartalDiscount](@restaurantID, @companyID, @date))
		DECLARE @since DATETIME
		SET @since = (SELECT Since FROM [dbo].[GetCompanyLatestQuartalDiscount](@restaurantID, @companyID, @date))
		IF (DATEDIFF(DAY, @since, @date) < @quartal)
		BEGIN
			;THROW 52000,'Nie można aktualnie przyznać rabatu kwartalnego. Od przyznania ostatniego rabatu kwartalnego minęło mniej niż kwartał',1
		END
	END
	ELSE
	BEGIN
		DECLARE @priceRequirementToMeet MONEY
		SET @quartal = 90
		SET @priceRequirementToMeet = (SELECT TotalPrice FROM dbo.CompanyDiscounts WHERE RestaurantID = @restaurantID AND BillingPeriod = @quartal)
		DECLARE @discountToGive REAL
		SET @discountToGive = (SELECT Discount FROM dbo.CompanyDiscounts WHERE RestaurantID = @restaurantID AND BillingPeriod = @quartal)
		DECLARE @givenDiscountID SMALLINT
		SET @givenDiscountID = (SELECT DiscountID FROM dbo.CompanyDiscounts WHERE RestaurantID = @restaurantID AND BillingPeriod = @quartal)
		DECLARE @quartalOrdersValue MONEY
		SET @quartalOrdersValue = (SELECT [dbo].[PastOrdersValueSinceTill](@companyID, DATEADD(DAY,-91,@date), @date))
		IF (@quartalOrdersValue >= @priceRequirementToMeet)
		BEGIN
			BEGIN TRY
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
					@givenDiscountID,         -- DiscountID - smallint
				    @date, -- Since - date
				    @discountToGive        -- TotalDiscount - real
				    )
			END TRY
			BEGIN CATCH
				DECLARE @msg VARCHAR(250)
				SET @msg = 'Wstawianie rabatu nie powiodło się. Error message: ' + ERROR_MESSAGE()
				;THROW 52000,@msg,1
			END CATCH
		END
		ELSE
		BEGIN
			;THROW 52000,'Klient nie spełnił wymagań, które pozwoliłyby przyznać mu rabat kwartalny',1
		END
	END
END
GO
