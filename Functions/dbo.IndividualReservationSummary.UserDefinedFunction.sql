USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[IndividualReservationSummary]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[IndividualReservationSummary](@reservationID INT, @customerID INT, @reserevedFor DATETIME)
RETURNS @summary TABLE
(
	param_name VARCHAR(250),
	param_val VARCHAR(250)
)
AS
BEGIN
	DECLARE @restaurantID INT
	SET @restaurantID = (SELECT RestaurantID FROM dbo.TableReservations INNER JOIN dbo.Tables
	ON Tables.TableID = TableReservations.TableID
	WHERE ReservationID = @reservationID AND SinceWhenReserved = @reserevedFor)
	DECLARE @restaurantName VARCHAR(50)
	SET @restaurantName = (SELECT RestaurantName FROM dbo.Restaurants WHERE RestaurantID = @restaurantID)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Restaurant Name: ',
	    @restaurantName
	    )
	DECLARE @customerLastname VARCHAR(50)
	SET @customerLastname  = (SELECT LastName FROM dbo.IndividualCustomers WHERE CustomerID = @customerID)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Lastname: ',
	    @customerLastname
	    )

	DECLARE @customerFirstName VARCHAR(50)
	SET @customerFirstName = (SELECT FirstName FROM dbo.IndividualCustomers WHERE CustomerID = @customerID)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Firstname: ', 
	    @customerFirstName
	    )
	DECLARE @email VARCHAR(50)
	SET @email = (SELECT Email FROM dbo.Customers WHERE CustomerID = @customerID)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Email: ',
	    @email
	    )
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Reservation number: ',
	    @reservationID
	    )
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Reservation status: ',
	    'Confirmed'
	    )

	DECLARE @till DATETIME
	SET @till = (SELECT UntilWhenReserved FROM dbo.TableReservations WHERE ReservationID = @reservationID AND SinceWhenReserved = @reserevedFor)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Reservation time: ',
	    CONCAT(@reserevedFor,' - ',@till)
	    )
	DECLARE @tableID INT
	SET @tableID = (SELECT TableID FROM dbo.TableReservations WHERE ReservationID = @reservationID AND SinceWhenReserved = @reserevedFor)
	DECLARE @guestsNumber INT
	SET @guestsNumber = (SELECT CustomerNumber FROM dbo.TableReservations WHERE ReservationID = @reservationID AND SinceWhenReserved = @reserevedFor)
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Table number: ',
	    @tableID
	    )
	INSERT @summary
	(
	    param_name,
	    param_val
	)
	VALUES
	(   'Maximum guest number: ',
	    @guestsNumber
	    )
	RETURN
END

	
	
GO
