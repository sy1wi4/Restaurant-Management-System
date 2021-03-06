USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[AddNewCompanyCustomer]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddNewCompanyCustomer] (@restaurantID INT, @nip NVARCHAR(50), @companyName NVARCHAR(50),
	@email NVARCHAR(50) ,@phone NVARCHAR(50), @cityName NVARCHAR(50), @countryName NVARCHAR(50),
	@address NVARCHAR(50), @postalCode NVARCHAR(50))
AS 
	DECLARE @cityID INT;
	EXEC dbo.FindOrInsertCity @cityName,    
	                          @countryName, 
	                          @cityID = @cityID OUTPUT
	
	INSERT INTO dbo.Customers
	(
	    RestaurantID,
	    Email,
	    Phone,
	    CityID,
	    Address,
	    PostalCode
	)
	VALUES
	(   @restaurantID, 
	    @email, 
	    @phone,
	    @cityID,   -- CityID - int
	    @address, 
	    @postalCode 
	    )
	DECLARE @companyID INT 
	SET @companyID = @@IDENTITY

	SET IDENTITY_INSERT dbo.CompanyCustomers ON 

	INSERT INTO dbo.CompanyCustomers
	(
		CompanyID,
	    CompanyName,
	    NIP
	)
	VALUES
	(   @companyID,
		@companyName,
		@nip
	    )

	
GO
