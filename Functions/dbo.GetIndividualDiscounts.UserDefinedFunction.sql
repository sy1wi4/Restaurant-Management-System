USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetIndividualDiscounts]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetIndividualDiscounts] (@customerID INT)
	RETURNS TABLE
AS
	RETURN(SELECT * FROM dbo.IndividualDiscountsView
	WHERE CustomerID = @customerID)
GO
