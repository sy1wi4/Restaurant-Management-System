USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[FindOrInsertCity]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FindOrInsertCity]
	@cityName varchar(255),
	@countryName varchar(255),
	@cityID INT OUTPUT
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN FIND_CITY
			SET @cityID = NULL
			IF((@cityName IS NOT NULL AND @countryName IS NULL) OR (@cityName IS NULL AND @countryName IS NOT NULL))
				BEGIN
					;THROW 52000,'Nalezy podac nazwe miasta i nazwe kraju albo zadne z nich ',1;
				END
			IF(@cityName IS NOT NULL AND @countryName IS NOT NULL)
				BEGIN
					DECLARE @countryID INT
					EXEC FindOrInsertCountry @countryName, @countryID = @countryID OUT 
					SET @cityID = (SELECT TOP 1 cityID FROM Cities WHERE (CityName = @cityName AND CountryID = @countryID))
					IF(@cityID IS NULL)
						BEGIN
							INSERT INTO Cities(CityName,CountryID)VALUES(@cityName,@countryID);
							SET @cityID =@@IDENTITY;
						END
				END
		COMMIT TRAN FIND_CITY
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN FIND_CITY
		DECLARE @msg NVARCHAR(2048)='Bład wyszukiwania miasta:'+CHAR(13)+CHAR(10)+ ERROR_MESSAGE(); 
		THROW 52000,@msg,1;
	END CATCH 
END
GO
