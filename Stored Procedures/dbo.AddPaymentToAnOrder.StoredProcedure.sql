USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[AddPaymentToAnOrder]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddPaymentToAnOrder]
	@orderID INT,
	@isTakeAway BIT,
	@orderStatus CHAR OUTPUT
AS
BEGIN
	IF (@isTakeAway = 0)
	BEGIN
		UPDATE dbo.OnSiteOrders SET Status = 'P' WHERE OrderID = @orderID
	END
	ELSE
	BEGIN
		UPDATE dbo.TakeAwayOrders SET Status = 'P' WHERE OrderID = @orderID
	END
	SET @orderStatus = 'P'
END
GO
