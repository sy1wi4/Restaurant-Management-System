USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[AddNewIndividualCustomer]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddNewIndividualCustomer] (@restaurantID INT,@email NVARCHAR(50) ,@phone NVARCHAR(50), 
	@cityName NVARCHAR(50), @countryName NVARCHAR(50), @address NVARCHAR(50), @postalCode NVARCHAR(50), 
	@lastName NVARCHAR(50), @firstName NVARCHAR(50), @companyName NVARCHAR(50) = NULL)
AS 
	
	IF @companyName IS NOT NULL 
		DECLARE @companyID INT
		SET @companyID = (SELECT CompanyID FROM dbo.CompanyCustomers WHERE CompanyName = @companyName)
		IF @companyID IS NULL
			THROW 52000, 'Podana firma nie istnieje',1

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
	    @cityID,  
	    @address,
	    @postalCode  
	    )
	DECLARE @customerID INT 
	SET @customerID = @@IDENTITY

	
	SET IDENTITY_INSERT dbo.IndividualCustomers ON 

	INSERT INTO dbo.IndividualCustomers
	(
		CustomerID,
	    LastName,
	    FirstName,
	    CompanyID
	)
	VALUES
	(   @customerID,
		@lastName, 
	    @firstName,
	    @companyID   
	    )

	


	
GO
