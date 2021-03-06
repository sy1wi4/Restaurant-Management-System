USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[GivePermanentIndividualDiscount]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GivePermanentIndividualDiscount]
	@restaurantID INT,
	@customerID INT,
	@date DATETIME
AS
BEGIN
	IF ((SELECT [dbo].[IsCompanyCustomer](@customerID)) = 1)
	BEGIN
		;THROW 52000, 'Wymagany klient indywidualny, wprowadzono klienta-firmę',1
	END
	IF ((SELECT COUNT(*) FROM [dbo].[GetCurrentPermDiscountForIndividualCustomer](@restaurantID,@customerID,@date)) = 0)
	BEGIN
		DECLARE @givenDiscount SMALLINT
		SET @givenDiscount = (SELECT [dbo].[GetLowestPermanentIndividualDiscountInARestaurant](@restaurantID))
		DECLARE @minimalCost money
		SET @minimalCost = (SELECT MinOrderPrice FROM dbo.PermIndividualDiscounts WHERE DiscountID = @givenDiscount)
		DECLARE @ordersNumber INT
		SET @ordersNumber = (SELECT OrdersNumber FROM dbo.PermIndividualDiscounts WHERE DiscountID = @givenDiscount)
		DECLARE @pastOrdersCount INT
		SET @pastOrdersCount = (SELECT [dbo].[PastOrdersCountWithGivenPrice](@minimalCost, @customerID, '2017-01-01', @date))
		IF (@pastOrdersCount >= @ordersNumber)
		BEGIN
			SET IDENTITY_INSERT dbo.IndividualDiscountHist ON
			INSERT INTO dbo.IndividualDiscountHist
			(
				CustomerID,
				DiscountID,
				Since,
				Till,
				UseDate
			)
			VALUES
			(   @customerID,
				@givenDiscount,
				@date,
				NULL,
				NULL
			)
		END
		ELSE
		BEGIN
		;THROW 52000, 'Klient w tym momencie nie spełnia warunków do wystawienia rabatu',1
		END
	END
	ELSE
	BEGIN
		DECLARE @discountID SMALLINT
		SET @discountID = (SELECT DiscountID FROM [dbo].[GetCurrentPermDiscountForIndividualCustomer](@restaurantID,@customerID,@date))
		SET @minimalCost = (SELECT MinOrderPrice FROM [dbo].[GetCurrentPermDiscountForIndividualCustomer](@restaurantID,@customerID,@date))
		SET @ordersNumber = (SELECT OrdersNumber FROM [dbo].[GetCurrentPermDiscountForIndividualCustomer](@restaurantID,@customerID,@date))
		DECLARE @since DATETIME
		SET @since = (SELECT Since FROM [dbo].[GetCurrentPermDiscountForIndividualCustomer](@restaurantID, @customerID, @date))
		SET @pastOrdersCount = (SELECT [dbo].[PastOrdersCountWithGivenPrice](@minimalCost, @customerID, @since, @date))
		IF (@pastOrdersCount >= 2*@ordersNumber)
		BEGIN
		SET @givenDiscount = (SELECT [dbo].[GetHighestPermanentIndividualDiscountInARestaurant](@restaurantID))
		SET IDENTITY_INSERT dbo.IndividualDiscountHist ON
		INSERT INTO dbo.IndividualDiscountHist
		(
			CustomerID,
			DiscountID,
			Since,
			Till,
			UseDate
		)
		VALUES
		(   @customerID,
			@givenDiscount,
			@date,
			NULL,
			NULL
		)
		END
		ELSE
		BEGIN
		;THROW 52000, 'Klient posiada już rabat tego rodzaju i nie spełnia warunków do podniesienia jego wartości',1
		END
	END
END
GO
