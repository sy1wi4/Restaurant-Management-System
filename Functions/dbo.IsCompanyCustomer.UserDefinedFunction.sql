USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[IsCompanyCustomer]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IsCompanyCustomer](@customerID INT)
	RETURNS BIT
AS
BEGIN
	IF ((SELECT CustomerID FROM Customers WHERE (CustomerID IN (SELECT CompanyID FROM dbo.CompanyCustomers)
		AND CustomerID = @customerID)) = @customerID)
		RETURN 1
	RETURN 0
END
GO
