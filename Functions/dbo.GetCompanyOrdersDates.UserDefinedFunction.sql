USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCompanyOrdersDates]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetCompanyOrdersDates] (@companyID INT)
	RETURNS TABLE
AS
	RETURN (SELECT * FROM dbo.CompanyOnSiteOrdersDatesView
	WHERE CompanyID = @companyID
	UNION
	SELECT * FROM dbo.CompanyTakeAwayOrdersDatesView
	WHERE CompanyID = @companyID)

GO
