USE [u_smarek]
GO
/****** Object:  Table [dbo].[CompanyReservations]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyReservations](
	[ReservationID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NULL,
	[CompanyID] [int] NOT NULL,
 CONSTRAINT [PK_Reservations] PRIMARY KEY CLUSTERED 
(
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyReservations]  WITH CHECK ADD  CONSTRAINT [FK_CompanyReservations_Customers] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[CompanyReservations] CHECK CONSTRAINT [FK_CompanyReservations_Customers]
GO
