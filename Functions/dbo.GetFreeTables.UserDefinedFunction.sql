USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetFreeTables]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetFreeTables] (@restaurantID INT, @from DATETIME, @to DATETIME)
	RETURNS TABLE
AS
	RETURN (SELECT TableID, SeatsNumber FROM dbo.Tables
				WHERE RestaurantID = @restaurantID  AND TableID NOT IN  
					(SELECT TableID FROM dbo.TableReservations
						WHERE (@from BETWEEN SinceWhenReserved AND UntilWhenReserved)
						OR  (@to BETWEEN SinceWhenReserved AND UntilWhenReserved)))
GO
