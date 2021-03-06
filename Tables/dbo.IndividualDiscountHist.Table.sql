USE [u_smarek]
GO
/****** Object:  Table [dbo].[IndividualDiscountHist]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndividualDiscountHist](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[DiscountID] [smallint] NOT NULL,
	[Since] [date] NOT NULL,
	[Till] [date] NULL,
	[UseDate] [date] NULL,
 CONSTRAINT [PK_IndividualDiscountHist] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC,
	[DiscountID] ASC,
	[Since] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IndividualDiscountHist]  WITH CHECK ADD  CONSTRAINT [FK_IndividualDiscountHist_IndividualCustomers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[IndividualCustomers] ([CustomerID])
GO
ALTER TABLE [dbo].[IndividualDiscountHist] CHECK CONSTRAINT [FK_IndividualDiscountHist_IndividualCustomers]
GO
ALTER TABLE [dbo].[IndividualDiscountHist]  WITH CHECK ADD  CONSTRAINT [FK_IndividualDiscountHist_PermIndividualDiscounts] FOREIGN KEY([DiscountID])
REFERENCES [dbo].[PermIndividualDiscounts] ([DiscountID])
GO
ALTER TABLE [dbo].[IndividualDiscountHist] CHECK CONSTRAINT [FK_IndividualDiscountHist_PermIndividualDiscounts]
GO
ALTER TABLE [dbo].[IndividualDiscountHist]  WITH CHECK ADD  CONSTRAINT [FK_IndividualDiscountHist_TempIndividualDiscounts] FOREIGN KEY([DiscountID])
REFERENCES [dbo].[TempIndividualDiscounts] ([DiscountID])
GO
ALTER TABLE [dbo].[IndividualDiscountHist] CHECK CONSTRAINT [FK_IndividualDiscountHist_TempIndividualDiscounts]
GO
ALTER TABLE [dbo].[IndividualDiscountHist]  WITH CHECK ADD  CONSTRAINT [CK_IndividualDiscountHist] CHECK  (([Since]<=[UseDate] AND [UseDate]<=[Till]))
GO
ALTER TABLE [dbo].[IndividualDiscountHist] CHECK CONSTRAINT [CK_IndividualDiscountHist]
GO
