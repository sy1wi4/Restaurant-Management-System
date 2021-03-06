USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[CheckIfHalfPositionsChanged]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[CheckIfHalfPositionsChanged](@day DATE, @restaurantID INT)
	RETURNS NVARCHAR(100)
AS
BEGIN 
	DECLARE @all INT
	SELECT @all = COUNT(*) FROM GetMenuOfTheDay(@day, @restaurantID)
	DECLARE @changed INT 
	SELECT @changed = COUNT(CASE WHEN DATEDIFF(DAY, MenuIn, @day) BETWEEN 0 AND 14  THEN 1 ELSE NULL END) 
		FROM GetMenuOfTheDay(@day, @restaurantID)
	IF @changed >= CAST(@all AS FLOAT)/2
	BEGIN 
		RETURN  
		'OK, co najmniej połowa pozycji menu została zmieniona min 2 tygodnie temu'
	END 
	RETURN 'Więcej niż połowa pozycji nie została zmieniona w ciągu ostatnich 2 tygodni, zmień Menu!'	 
END
GO
