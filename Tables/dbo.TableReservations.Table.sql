USE [u_smarek]
GO
/****** Object:  Table [dbo].[TableReservations]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableReservations](
	[TableID] [int] NOT NULL,
	[ReservationID] [int] NOT NULL,
	[SinceWhenReserved] [datetime] NOT NULL,
	[UntilWhenReserved] [datetime] NOT NULL,
	[CustomerNumber] [smallint] NOT NULL,
 CONSTRAINT [PK_TableReservations] PRIMARY KEY CLUSTERED 
(
	[TableID] ASC,
	[ReservationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TableReservations]  WITH CHECK ADD  CONSTRAINT [FK_TableReservations_CompanyReservations] FOREIGN KEY([ReservationID])
REFERENCES [dbo].[CompanyReservations] ([ReservationID])
GO
ALTER TABLE [dbo].[TableReservations] CHECK CONSTRAINT [FK_TableReservations_CompanyReservations]
GO
ALTER TABLE [dbo].[TableReservations]  WITH CHECK ADD  CONSTRAINT [FK_TableReservations_IndividualReservations] FOREIGN KEY([ReservationID])
REFERENCES [dbo].[IndividualReservations] ([ReservationID])
GO
ALTER TABLE [dbo].[TableReservations] CHECK CONSTRAINT [FK_TableReservations_IndividualReservations]
GO
ALTER TABLE [dbo].[TableReservations]  WITH CHECK ADD  CONSTRAINT [FK_TableReservations_Tables] FOREIGN KEY([TableID])
REFERENCES [dbo].[Tables] ([TableID])
GO
ALTER TABLE [dbo].[TableReservations] CHECK CONSTRAINT [FK_TableReservations_Tables]
GO
ALTER TABLE [dbo].[TableReservations]  WITH CHECK ADD  CONSTRAINT [CK_TableReservations] CHECK  (([SinceWhenReserved]<=[UntilWhenReserved]))
GO
ALTER TABLE [dbo].[TableReservations] CHECK CONSTRAINT [CK_TableReservations]
GO
