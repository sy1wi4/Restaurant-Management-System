USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetFreeTablesWithCorrespondingCovidRestrictions]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetFreeTablesWithCorrespondingCovidRestrictions](@restaurantID INT, @guestsNumber SMALLINT, @from DATETIME, @until DATETIME)
	RETURNS TABLE
RETURN (SELECT Tables.TableID, SeatsNumber, SeatsAvailable, Since, Until FROM dbo.Tables INNER JOIN dbo.CovidRestrictions
		ON CovidRestrictions.TableID = Tables.TableID
		WHERE (RestaurantID = @restaurantID  AND SeatsNumber >= @guestsNumber AND Tables.TableID NOT IN  
		(SELECT TableID FROM dbo.TableReservations
		WHERE (@from BETWEEN SinceWhenReserved AND UntilWhenReserved)
		OR (@until BETWEEN SinceWhenReserved AND UntilWhenReserved)))
		)
GO
