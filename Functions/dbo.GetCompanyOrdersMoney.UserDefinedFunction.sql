USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCompanyOrdersMoney]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetCompanyOrdersMoney] (@companyID INT)
	RETURNS TABLE
AS 
	RETURN (SELECT * FROM dbo.CompanyOnSiteOrdersMoneyView
	WHERE CompanyID = @companyID
	UNION
	SELECT * FROM dbo.CompanyTakeAwayOrdersMoneyView 
	WHERE CompanyID = @companyID)
GO
