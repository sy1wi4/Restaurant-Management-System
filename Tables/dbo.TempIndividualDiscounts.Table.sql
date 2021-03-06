USE [u_smarek]
GO
/****** Object:  Table [dbo].[TempIndividualDiscounts]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TempIndividualDiscounts](
	[DiscountID] [smallint] NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[MinTotalPrice] [money] NOT NULL,
	[Duration] [int] NOT NULL,
	[Discount] [real] NOT NULL,
 CONSTRAINT [PK_TempIndividualDiscounts] PRIMARY KEY CLUSTERED 
(
	[DiscountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TempIndividualDiscounts]  WITH CHECK ADD  CONSTRAINT [FK_TempIndividualDiscounts_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[TempIndividualDiscounts] CHECK CONSTRAINT [FK_TempIndividualDiscounts_Restaurants]
GO
ALTER TABLE [dbo].[TempIndividualDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_TempIndividualDiscounts] CHECK  (([Duration]>=(0)))
GO
ALTER TABLE [dbo].[TempIndividualDiscounts] CHECK CONSTRAINT [CK_TempIndividualDiscounts]
GO
ALTER TABLE [dbo].[TempIndividualDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_TempIndividualDiscounts_1] CHECK  (([Discount]>=(0) AND [Discount]<=(1)))
GO
ALTER TABLE [dbo].[TempIndividualDiscounts] CHECK CONSTRAINT [CK_TempIndividualDiscounts_1]
GO
ALTER TABLE [dbo].[TempIndividualDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_TempIndividualDiscounts_2] CHECK  (([MinTotalPrice]>=(0)))
GO
ALTER TABLE [dbo].[TempIndividualDiscounts] CHECK CONSTRAINT [CK_TempIndividualDiscounts_2]
GO
