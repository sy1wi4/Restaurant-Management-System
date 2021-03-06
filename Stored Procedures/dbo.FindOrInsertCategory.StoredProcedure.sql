USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[FindOrInsertCategory]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FindOrInsertCategory]
	@categoryName VARCHAR(255),
	@description NTEXT,
	@categoryID INT OUTPUT
AS
BEGIN
BEGIN TRY
	BEGIN TRAN FIND_CATEGORY
		SET @categoryID = (SELECT CategoryID FROM dbo.Categories
						WHERE CategoryName = @categoryName)
		IF (@categoryID IS NULL)
		BEGIN
			INSERT INTO Categories(CategoryName, Description)
			VALUES (@categoryName, @description);
			SET @categoryID = @@IDENTITY;
		END
	COMMIT TRAN FIND_CATEGORY
END TRY
BEGIN CATCH
	ROLLBACK TRAN FIND_CATEGORY
	DECLARE @msg NVARCHAR(2048) = 'Błąd wyszukiwania kategorii: ' +
	CHAR(13) + CHAR(10) + ERROR_MESSAGE();
	THROW 52000, @msg, 1;
END CATCH
END
GO
