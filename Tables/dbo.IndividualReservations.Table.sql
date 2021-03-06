USE [u_smarek]
GO
/****** Object:  Table [dbo].[IndividualReservations]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndividualReservations](
	[ReservationID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[CustomerID] [int] NOT NULL,
 CONSTRAINT [PK_IndividualReservations] PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IndividualReservations]  WITH CHECK ADD  CONSTRAINT [FK_IndividualReservations_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[IndividualReservations] CHECK CONSTRAINT [FK_IndividualReservations_Customers]
GO
ALTER TABLE [dbo].[IndividualReservations]  WITH CHECK ADD  CONSTRAINT [FK_IndividualReservations_OnSiteOrders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[OnSiteOrders] ([OrderID])
GO
ALTER TABLE [dbo].[IndividualReservations] CHECK CONSTRAINT [FK_IndividualReservations_OnSiteOrders]
GO
