USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetTableReservations]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetTableReservations] (@days INT,@from DATE, @tableID INT)
	RETURNS TABLE
AS
	RETURN (SELECT * FROM dbo.TableReservationsView
		WHERE (TableID = @tableID AND (DATEDIFF(DAY, SinceWhenReserved, @from)) BETWEEN 0 AND @days))


GO
