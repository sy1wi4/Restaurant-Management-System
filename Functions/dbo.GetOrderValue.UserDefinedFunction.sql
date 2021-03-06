USE [u_smarek]
GO
/****** Object:  UserDefinedFunction [dbo].[GetOrderValue]    Script Date: 25.03.2021 12:39:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetOrderValue](@orderID INT)
	RETURNS MONEY
AS
BEGIN
	RETURN (SELECT SUM(Quantity * UnitPrice) FROM OrderDetails WHERE OrderID = @orderID)
END
GO
