USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetIndividualOrdersDates]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetIndividualOrdersDates] (@individualID INT)
	RETURNS TABLE
AS
	RETURN (SELECT * FROM dbo.IndividualOnSiteOrdersDatesView
		WHERE CustomerID = @individualID
		UNION
		SELECT * FROM dbo.IndividualTakeAwayOrdersDatesView
		WHERE CustomerID = @individualID)
GO
