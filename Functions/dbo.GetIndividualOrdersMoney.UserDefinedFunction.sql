USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetIndividualOrdersMoney]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetIndividualOrdersMoney] (@individualID INT)
	RETURNS TABLE
AS
	RETURN (SELECT * FROM dbo.IndividualOnSiteOrdersMoneyView
		WHERE CustomerID = @individualID
		UNION
		SELECT * FROM dbo.IndividualTakeAwayOrdersMoneyView
		WHERE CustomerID = @individualID)
GO
