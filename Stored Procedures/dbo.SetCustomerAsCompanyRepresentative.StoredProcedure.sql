USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[SetCustomerAsCompanyRepresentative]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SetCustomerAsCompanyRepresentative]
	@customerID INT,
	@companyID INT
AS
BEGIN
	IF (SELECT CustomerID FROM dbo.IndividualCustomers WHERE CustomerID = @customerID) IS NULL
	BEGIN
		;THROW 52000,'Najpierw dodaj reprezentanta firmy do klientów indywidualnych',1
	END
	ELSE IF (SELECT CompanyID FROM dbo.IndividualCustomers WHERE CustomerID = @customerID) IS NOT NULL
    BEGIN
		;THROW 52000,'Ten klient jest już reprezentantem innej firmy',1
	END
	ELSE
	BEGIN
		UPDATE dbo.IndividualCustomers SET CompanyID = @companyID
		WHERE CustomerID = @customerID
	END
END
GO
