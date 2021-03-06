USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[ConfirmOrAnullIndividualReservationAsAnEmployee]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ConfirmOrAnullIndividualReservationAsAnEmployee]
	@restaurantID INT,
	@reservationID INT,
	@requiredOrderValue MONEY,
	@from DATETIME,
	@till DATETIME,
	@guestsNumber SMALLINT,
	@givenTableID INT OUTPUT
AS
BEGIN
	DECLARE @customerID INT
	SET @customerID = (SELECT CustomerID FROM dbo.IndividualReservations WHERE ReservationID = @reservationID)
	DECLARE @orderID INT
	SET @orderID = (SELECT TOP 1 OrderID FROM dbo.IndividualReservations WHERE ReservationID = @reservationID)
	DECLARE @actualOrderValue MONEY
	SET @actualOrderValue = (SELECT SUM(Quantity * UnitPrice) FROM dbo.OrderDetails 
	WHERE OrderID = @orderID)
	IF (@actualOrderValue < @requiredOrderValue)
	BEGIN
		DELETE FROM dbo.IndividualReservations WHERE ReservationID = @reservationID
		EXEC AnullOrderAsAnEmployee @orderID, 0, NULL
		;THROW 52000,'Rezerwacja klienta jest za kwotę niższą niż wymagana. Rezerwacja ta została anulowana',1
	END
	ELSE
	BEGIN
		DECLARE @designatedTable INT
		SET @designatedTable = 0
		DECLARE @tableID INT
		DECLARE @seatsNumber SMALLINT
		DECLARE @seatsAvailable SMALLINT
		DECLARE @Since DATETIME
		DECLARE @Until DATETIME
		DECLARE myCursor CURSOR FOR 
		SELECT TableID, SeatsNumber, SeatsAvailable, Since, Until FROM dbo.GetFreeTablesWithCorrespondingCovidRestrictions(@restaurantID, @guestsNumber, @from, @till)
		ORDER BY SeatsNumber
		OPEN myCursor
		FETCH NEXT FROM myCursor INTO @tableID, @seatsNumber, @seatsAvailable, @Since, @Until
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF ((@from NOT BETWEEN @Since AND @Until) AND (@till NOT BETWEEN @Since AND @Until))
			BEGIN
				SET @designatedTable = @tableID
				BREAK
			END
			ELSE IF (@seatsAvailable >= @guestsNumber)
			BEGIN
				SET @designatedTable = @tableID
				BREAK
			END
			FETCH NEXT FROM myCursor INTO @tableID, @seatsNumber, @seatsAvailable, @Since, @Until
		END
		PRINT @designatedTable
		SET @givenTableID = @designatedTable
		CLOSE myCursor
		DEALLOCATE myCursor
	END

	IF (@designatedTable = 0)
	BEGIN
		DELETE FROM dbo.IndividualReservations WHERE ReservationID = @reservationID
		EXEC AnullOrderAsAnEmployee @orderID, 0, NULL
		;THROW 52000,'Brak wolnych stolików na dany termin. Rezerewacja została anulowana',1
	END
	ELSE
	BEGIN
		BEGIN TRY
			INSERT INTO dbo.TableReservations
			(
			    TableID,
			    ReservationID,
			    SinceWhenReserved,
			    UntilWhenReserved,
			    CustomerNumber
			)
			VALUES
			(   @designatedTable,         -- TableID - int
			    @reservationID,         -- ReservationID - int
			    @from, -- SinceWhenReserved - datetime
			    @till, -- UntilWhenReserved - datetime
			    @guestsNumber          -- CustomerNumber - smallint
			    )
		END TRY
		BEGIN CATCH
			DECLARE @msg NVARCHAR(250)
			SET @msg = 'Rezerwacja stolika nie powiodła się. Error message: ' + ERROR_MESSAGE()
			;THROW 52000,@msg,1
		END CATCH
    END
END
GO
