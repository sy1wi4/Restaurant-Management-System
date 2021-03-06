USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[GiveTemporalIndividualDiscount]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GiveTemporalIndividualDiscount]
	@restaurantID INT,
	@customerID INT,
	@date DATETIME,
	@givenDiscountID SMALLINT OUTPUT
AS
BEGIN
	IF ((SELECT COUNT(*) FROM [dbo].[GetCurrentValidTempIndividualDiscounts](@restaurantID, @customerID,@date)) = 0)
	BEGIN
		DECLARE @pastOrdersValue MONEY
		SET @pastOrdersValue = (SELECT [dbo].[PastOrdersValue](@customerID, @date))
		DECLARE @discountToGive1 SMALLINT
		SET @discountToGive1 = (SELECT [dbo].[GetLowestTempIndividualDiscountInARestaurant](@restaurantID))
		DECLARE @requiredPastOrdersValue1 MONEY
		SET @requiredPastOrdersValue1 = (SELECT MinTotalPrice FROM dbo.TempIndividualDiscounts WHERE DiscountID = @discountToGive1)
		DECLARE @discountToGive2 SMALLINT
		SET @discountToGive2 = (SELECT [dbo].[GetHighestTempIndividualDiscountInARestaurant](@restaurantID))
		DECLARE @requiredPastOrdersValue2 MONEY
		SET @requiredPastOrdersValue2 = (SELECT MinTotalPrice FROM dbo.TempIndividualDiscounts WHERE DiscountID = @discountToGive2)
		IF (@pastOrdersValue >= @requiredPastOrdersValue1 AND @pastOrdersValue < @requiredPastOrdersValue2)
		BEGIN
			DECLARE @duration INT
			SET @duration = (SELECT Duration FROM dbo.TempIndividualDiscounts WHERE DiscountID = @discountToGive1)
			SET IDENTITY_INSERT dbo.IndividualDiscountHist ON;
			INSERT INTO dbo.IndividualDiscountHist
			(
			    CustomerID,
				DiscountID,
			    Since,
			    Till,
			    UseDate
			)
			VALUES
			(   
				@customerID,
				@discountToGive1,
			    @date,
			    DATEADD(DAY,@duration,@date),
			    NULL
			    )
			SET @givenDiscountID = @discountToGive1
		END
		ELSE IF (@pastOrdersValue >= @requiredPastOrdersValue2)
		BEGIN
			BEGIN TRY
				SET @duration = (SELECT Duration FROM dbo.TempIndividualDiscounts WHERE DiscountID = @discountToGive2)
				SET IDENTITY_INSERT dbo.IndividualDiscountHist ON;
				INSERT INTO dbo.IndividualDiscountHist
				(
					CustomerID,
					DiscountID,
					Since,
					Till,
					UseDate
				)
				VALUES
				(   
					@customerID,
					@discountToGive2,
					@date,
					DATEADD(DAY,@duration,@date),
					NULL
					)
				SET @givenDiscountID = @discountToGive2
			END TRY
			BEGIN CATCH
				DECLARE @msg VARCHAR(250)
				SET @msg = 'Błąd wstawiania rabatu do rejestru. Error message: ' + ERROR_MESSAGE()
				;THROW 52000,@msg,1
			END CATCH
		END
		ELSE
		BEGIN
			;THROW 52000, 'Ten klient obecnie nie spełnia wymagań do przyznania rabatu czasowego',1
		END
	END
	ELSE
	BEGIN
		SET @discountToGive2 = (SELECT [dbo].[GetHighestTempIndividualDiscountInARestaurant](@restaurantID))
		SET @requiredPastOrdersValue2 = (SELECT MinTotalPrice FROM dbo.TempIndividualDiscounts WHERE DiscountID = @discountToGive2)
		SET @pastOrdersValue = (SELECT [dbo].[PastOrdersValue](@customerID, @date))
		IF (@pastOrdersValue >= @requiredPastOrdersValue2)
		BEGIN
			BEGIN TRY
				SET @duration = (SELECT Duration FROM dbo.TempIndividualDiscounts WHERE DiscountID = @discountToGive2)
				SET IDENTITY_INSERT dbo.IndividualDiscountHist ON;
				INSERT INTO dbo.IndividualDiscountHist
				(
					CustomerID,
					DiscountID,
					Since,
					Till,
					UseDate
				)
				VALUES
				(   
					@customerID,
					@discountToGive2,
					@date,
					DATEADD(DAY,@duration,@date),
					NULL
					)
				SET @givenDiscountID = @discountToGive2
			END TRY
			BEGIN CATCH
				SET @msg = 'Błąd wstawiania nowego rabatu do rejestru. Error message: ' + ERROR_MESSAGE()
				;THROW 52000,@msg,1
			END CATCH
		END
		ELSE
		BEGIN
			;THROW 52000, 'Ten klient obecnie nie spełnia wymagań do przyznania nowego rabatu czasowego',1
			SET @givenDiscountID = NULL
		END
	END
END

		
			

GO
