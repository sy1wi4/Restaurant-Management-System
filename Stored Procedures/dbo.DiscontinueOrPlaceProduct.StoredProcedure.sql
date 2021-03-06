USE [u_smarek]
GO
/****** Object:  StoredProcedure [dbo].[DiscontinueOrPlaceProduct]    Script Date: 25.03.2021 12:38:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DiscontinueOrPlaceProduct]
	@productID INT,
	@discontinue BIT --1 - discontinue the product, 0 - place the product back
AS
BEGIN
	IF (@discontinue = 1)
	BEGIN
		UPDATE dbo.Products SET Discontinued = 1 WHERE ProductID = @productID
	END
	ELSE
	BEGIN
		UPDATE dbo.Products SET Discontinued = 0 WHERE ProductID = @productID
	END
END
GO
