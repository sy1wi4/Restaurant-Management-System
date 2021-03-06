USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[FindOrInsertCountry]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FindOrInsertCountry]
	@countryName VARCHAR(255),
	@countryID INT OUTPUT
AS
BEGIN
BEGIN TRY
	BEGIN TRAN FIND_COUNTRY
		SET @countryID = (SELECT CountryID FROM dbo.Countries
						WHERE CountryName = @countryName)
		IF (@countryID IS NULL)
		BEGIN
			INSERT INTO Countries(CountryName)
			VALUES (@countryName);
			SET @countryID = @@IDENTITY;
		END
	COMMIT TRAN FIND_COUNTRY
END TRY
BEGIN CATCH
	ROLLBACK TRAN FIND_COUNTRY
	DECLARE @msg NVARCHAR(2048) = 'Błąd wyszukiwania kraju: ' +
	CHAR(13) + CHAR(10) + ERROR_MESSAGE();
	THROW 52000, @msg, 1;
END CATCH
END
GO
