USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[UseIndividualTemporalDiscount]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UseIndividualTemporalDiscount]
	@restaurantID INT,
	@customerID INT,
	@currentDate DATETIME
AS
BEGIN
	DECLARE @discountID SMALLINT
	SET @discountID = (SELECT TOP 1 DiscountID FROM [dbo].[GetCurrentValidTempIndividualDiscounts](@restaurantID, @customerID, @currentDate))
	UPDATE dbo.IndividualDiscountHist SET UseDate = @currentDate
	WHERE DiscountID IN (SELECT TOP 1 DiscountID FROM [dbo].[GetCurrentValidTempIndividualDiscounts](@restaurantID, @customerID, @currentDate))
END
GO
