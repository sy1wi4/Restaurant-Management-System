USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GenerateReciptWithIndividualTemporalDiscount]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GenerateReciptWithIndividualTemporalDiscount](@restaurantID INT, @customerID INT, @orderID INT, @currentDate DATETIME)
RETURNS @receipt TABLE
(
param_name VARCHAR(250),
param_val VARCHAR(250)
)
AS
BEGIN
	DECLARE @discountID SMALLINT
	DECLARE @discountValue REAL
	SET @discountID = (SELECT TOP 1 DiscountID FROM [dbo].[GetCurrentValidTempIndividualDiscounts](@restaurantID, @customerID, @currentDate))
	SET @discountValue = (SELECT TOP 1 Discount FROM [dbo].[GetCurrentValidTempIndividualDiscounts](@restaurantID, @customerID, @currentDate))
	DECLARE @restaurantName VARCHAR(50)
	SET @restaurantName = (SELECT RestaurantName FROM dbo.Restaurants WHERE RestaurantID = @restaurantID)
	INSERT @receipt
	(
		param_name,
		param_val
	)
	VALUES
	(   'Restaurant name:', -- param_name - varchar(250)
		@restaurantName  -- param_val - varchar(250)
		)
	INSERT @receipt
	(
		param_name,
		param_val
	)
	VALUES
	(   'CustomerID:', -- param_name - varchar(250)
		@customerID  -- param_val - varchar(250)
		)
		INSERT @receipt
	(
		param_name,
		param_val
	)
	VALUES
	(   'Current date:', -- param_name - varchar(250)
		@currentDate -- param_val - varchar(250)
		)
		INSERT @receipt
	(
		param_name,
		param_val
	)
	VALUES
	(   'Receipt for order number: ', -- param_name - varchar(250)
		@orderID  -- param_val - varchar(250)
	)

	INSERT @receipt
	(
		param_name,
		param_val
	)
	VALUES
	(   'Temporal discount value: ', -- param_name - varchar(250)
		@discountValue  -- param_val - varchar(250)
	)

	DECLARE @normalPricetoPay MONEY
	SET @normalPriceToPay = (SELECT dbo.GetOrderValue(@orderID))
	DECLARE @priceAfterDiscount MONEY
	SET @priceAfterDiscount = @normalPricetoPay * (1-@discountValue)

	INSERT @receipt
	(
		param_name,
		param_val
	)
	VALUES
	(   'Price to pay without discount: ', -- param_name - varchar(250)
		@normalPricetoPay  -- param_val - varchar(250)
		)

	INSERT @receipt
	(
		param_name,
		param_val
	)
	VALUES
	(   'Price to pay after discount use: ', -- param_name - varchar(250)
		@priceAfterDiscount  -- param_val - varchar(250)
		)

	INSERT @receipt
	(
		param_name,
		param_val
	)
	VALUES
	(   CONCAT('Temporal discount number ',@discountID,' used ',@currentDate), -- param_name - varchar(250)
		'STATUS: USED'  -- param_val - varchar(250)
	)
	RETURN
END
GO
