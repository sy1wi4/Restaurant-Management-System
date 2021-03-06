USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[MakeIndividualReservation]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MakeIndividualReservation]
	@restaurantID INT,
	@customerID INT,
	@from DATETIME,
	@paymentOption BIT, --1 - payment straight away, before finalizing the reservation; 0 - payment after finalizing the reservation
	@orderDate DATETIME,
	@minOrderValue MONEY OUTPUT
AS
BEGIN
	BEGIN TRAN Make_Individual_Reservation
		BEGIN TRY
			DECLARE @ordersCount INT
			SET @ordersCount = (SELECT [dbo].[PastOrdersCount] (@customerID,'2017-01-01', @orderDate))
			IF (@ordersCount >=5)
			BEGIN
				SET @minOrderValue = 50
			END
			ELSE
			BEGIN
				SET @minOrderValue = 200
			END
			SET IDENTITY_INSERT dbo.IndividualReservations ON;
			DECLARE @reservationID INT
			SET @reservationID = ((SELECT TOP 1 ReservationID FROM dbo.IndividualReservations ORDER BY ReservationID DESC) + 2)
			EXECUTE dbo.AddOnSiteOrder @restaurantID, @customerID, @orderDate, @from, @paymentOption, NULL
			DECLARE @orderID INT
			SET @orderID = (SELECT TOP 1 OrderID FROM dbo.OnSiteOrders WHERE CustomerID = @customerID AND OrderDate = @orderDate AND ExecutionDate = @from ORDER BY OrderID DESC)
			INSERT INTO dbo.IndividualReservations
			(
				ReservationID,
				OrderID,
				CustomerID
			)
			VALUES
			(   
				@reservationID,
				@orderID, -- OrderID - int
				@customerID  -- CustomerID - int
			 )
		COMMIT TRAN Make_Individual_Reservation
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN Make_Individual_Reservation
			DECLARE @msg VARCHAR(250)
			SET @msg = 'Błąd w dodawaniu rezerwacji. Error message: ' + ERROR_MESSAGE()
			;THROW 52000, @msg,1
		END CATCH
	RETURN @minOrderValue
END
GO
