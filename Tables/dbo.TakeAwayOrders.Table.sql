USE [u_smarek]
GO
/****** Object:  Table [dbo].[TakeAwayOrders]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TakeAwayOrders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[ExecutionDate] [datetime] NOT NULL,
	[Status] [char](1) NOT NULL,
 CONSTRAINT [PK_TakeAwayOrders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TakeAwayOrders]  WITH CHECK ADD  CONSTRAINT [FK_TakeAwayOrders_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[TakeAwayOrders] CHECK CONSTRAINT [FK_TakeAwayOrders_Customers]
GO
ALTER TABLE [dbo].[TakeAwayOrders]  WITH CHECK ADD  CONSTRAINT [FK_TakeAwayOrders_Employees] FOREIGN KEY([EmployeeID])
REFERENCES [dbo].[Employees] ([EmployeeID])
GO
ALTER TABLE [dbo].[TakeAwayOrders] CHECK CONSTRAINT [FK_TakeAwayOrders_Employees]
GO
ALTER TABLE [dbo].[TakeAwayOrders]  WITH CHECK ADD  CONSTRAINT [CK_TakeAwayOrders] CHECK  (([Status]='N' OR [Status]='C' OR [Status]='P' OR [Status]='A'))
GO
ALTER TABLE [dbo].[TakeAwayOrders] CHECK CONSTRAINT [CK_TakeAwayOrders]
GO
ALTER TABLE [dbo].[TakeAwayOrders]  WITH CHECK ADD  CONSTRAINT [CK_TakeAwayOrders_1] CHECK  (([OrderDate]<=[ExecutionDate]))
GO
ALTER TABLE [dbo].[TakeAwayOrders] CHECK CONSTRAINT [CK_TakeAwayOrders_1]
GO
