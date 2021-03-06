USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[MakeCompanyReservationAsIndividualCustome]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MakeCompanyReservationAsIndividualCustome]
	@restaurantID INT,
	@customerID INT,
	@companyID INT,
	@from DATETIME,
	@till DATETIME,
	@guestsNumber SMALLINT,
	@givenTableID INT OUTPUT
AS
BEGIN
	IF (SELECT CustomerID FROM dbo.IndividualCustomers WHERE CustomerID = @customerID) IS NULL
	BEGIN
		;THROW 52000,'Dodaj najpierw reprezentanta firmy do klientów indywidualnych',1
	END
	ELSE IF (SELECT CompanyID FROM dbo.IndividualCustomers WHERE CustomerID = @customerID) IS NULL
	BEGIN
		;THROW 52000, 'Ten klient nie jest reprezentantem żadnej firmy',1
	END
	ELSE IF (SELECT CompanyID FROM dbo.IndividualCustomers WHERE CustomerID = @customerID) != @companyID
	BEGIN
		;THROW 52000, 'Ten klient nie jest reprezentantem innej niż podana firmy',1
	END
	ELSE
	BEGIN
		BEGIN TRY
			INSERT INTO dbo.CompanyReservations
			(
			    OrderID,
			    CompanyID
			)
			VALUES
			(   NULL, -- OrderID - int
			    @customerID  -- CompanyID - int
			    )
		END TRY
		BEGIN CATCH
			DECLARE	@msg VARCHAR(250)
			SET @msg = 'Dodawanie rezerwacji nie powiodło się. Error message: ' + ERROR_MESSAGE()
			;THROW 52000, @msg,1
		END CATCH
		BEGIN
			DECLARE @reservationID INT
			SET @reservationID = SCOPE_IDENTITY()
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
			DELETE FROM dbo.CompanyReservations WHERE ReservationID = @reservationID
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
				SET @msg = 'Rezerwacja stolika nie powiodła się. Error message: ' + ERROR_MESSAGE()
				;THROW 52000,@msg,1
			END CATCH
		END
    END
END
	
GO
