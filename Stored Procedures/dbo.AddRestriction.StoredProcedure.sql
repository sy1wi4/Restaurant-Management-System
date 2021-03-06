USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[AddRestriction]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddRestriction]
	@tableID INT,
	@from DATETIME,
	@till DATETIME,
	@seatsAvailable INT
AS
BEGIN
	BEGIN TRY
	IF NOT EXISTS (SELECT TableID FROM Tables WHERE TableID = @tableID)
	BEGIN
		;THROW 52000,'Stolik nie istnieje',1
	END
	IF (@seatsAvailable < 0 AND @seatsAvailable < (SELECT SeatsNumber FROM Tables WHERE TableID = @tableID))
	BEGIN
		;THROW 52000,'Wprowadzono złą liczbę miejsc',1
	END
	INSERT INTO dbo.CovidRestrictions
	(
	    TableID,
	    Since,
	    Until,
	    SeatsAvailable
	)
	VALUES
	(   @tableID,         -- TableID - int
	    @from, -- Since - datetime
	    @till, -- Until - datetime
	    @seatsAvailable         -- SeatsAvailable - smallint
	    )
	END TRY
	BEGIN CATCH
		DECLARE @msg VARCHAR(250)
		SET @msg = 'Nie udało się dodać restrykcji. Error message: ' + ERROR_MESSAGE()
		;THROW 52000, @msg,1
	END CATCH
END
GO
