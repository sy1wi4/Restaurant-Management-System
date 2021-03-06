USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[MakeCompanyReservation]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MakeCompanyReservation]
	@restaurantID INT,
	@companyID INT,
	@from DATETIME,
	@till DATETIME,
	@guestsNumber SMALLINT,
	@givenTableID INT OUTPUT
AS
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

	IF (@designatedTable = 0)
	BEGIN
		;THROW 52000,'Brak wolnych stolików na dany termin. Nie można zrealizować rezerwacji',1
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
			(   NULL,
			    @companyID
			    )
		END TRY
		BEGIN CATCH
			DECLARE @msg NVARCHAR(250)
			SET @msg = 'Nie udało się dokonać rezerwacji' + ERROR_MESSAGE()
			;THROW 52000,@msg,1
		END CATCH
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
			    SCOPE_IDENTITY(),         -- ReservationID - int
			    @from, -- SinceWhenReserved - datetime
			    @till, -- UntilWhenReserved - datetime
			    @guestsNumber          -- CustomerNumber - smallint
			    )
		END TRY
		BEGIN CATCH
			SET @msg = 'Rezerwacja stolika nie powiodła się' + ERROR_MESSAGE()
			;THROW 52000,@msg,1
		END CATCH
    END
END
GO
