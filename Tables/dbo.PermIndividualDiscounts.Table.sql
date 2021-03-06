USE [u_smarek]
GO
/****** Object:  Table [dbo].[PermIndividualDiscounts]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PermIndividualDiscounts](
	[DiscountID] [smallint] IDENTITY(1,1) NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[OrdersNumber] [int] NOT NULL,
	[MinOrderPrice] [money] NOT NULL,
	[Discount] [real] NOT NULL,
 CONSTRAINT [PK_PermIndividualDiscounts] PRIMARY KEY CLUSTERED 
(
	[DiscountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PermIndividualDiscounts]  WITH CHECK ADD  CONSTRAINT [FK_PermIndividualDiscounts_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[PermIndividualDiscounts] CHECK CONSTRAINT [FK_PermIndividualDiscounts_Restaurants]
GO
ALTER TABLE [dbo].[PermIndividualDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_PermIndividualDiscounts] CHECK  (([OrdersNumber]>=(0)))
GO
ALTER TABLE [dbo].[PermIndividualDiscounts] CHECK CONSTRAINT [CK_PermIndividualDiscounts]
GO
ALTER TABLE [dbo].[PermIndividualDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_PermIndividualDiscounts_1] CHECK  (([Discount]>=(0) AND [Discount]<=(1)))
GO
ALTER TABLE [dbo].[PermIndividualDiscounts] CHECK CONSTRAINT [CK_PermIndividualDiscounts_1]
GO
ALTER TABLE [dbo].[PermIndividualDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_PermIndividualDiscounts_2] CHECK  (([MinOrderPrice]>=(0)))
GO
ALTER TABLE [dbo].[PermIndividualDiscounts] CHECK CONSTRAINT [CK_PermIndividualDiscounts_2]
GO
