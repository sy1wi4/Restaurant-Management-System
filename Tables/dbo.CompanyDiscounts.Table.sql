USE [u_smarek]
GO
/****** Object:  Table [dbo].[CompanyDiscounts]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyDiscounts](
	[DiscountID] [smallint] NOT NULL,
	[RestaurantID] [int] NOT NULL,
	[Orders] [int] NOT NULL,
	[BillingPeriod] [int] NOT NULL,
	[TotalPrice] [money] NOT NULL,
	[Discount] [real] NOT NULL,
	[MaxDiscount] [real] NOT NULL,
 CONSTRAINT [PK_CompanyDiscounts] PRIMARY KEY CLUSTERED 
(
	[DiscountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyDiscounts]  WITH CHECK ADD  CONSTRAINT [FK_CompanyDiscounts_Restaurants] FOREIGN KEY([RestaurantID])
REFERENCES [dbo].[Restaurants] ([RestaurantID])
GO
ALTER TABLE [dbo].[CompanyDiscounts] CHECK CONSTRAINT [FK_CompanyDiscounts_Restaurants]
GO
ALTER TABLE [dbo].[CompanyDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_CompanyDiscounts] CHECK  (([Orders]>(0)))
GO
ALTER TABLE [dbo].[CompanyDiscounts] CHECK CONSTRAINT [CK_CompanyDiscounts]
GO
ALTER TABLE [dbo].[CompanyDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_CompanyDiscounts_1] CHECK  (([BillingPeriod]>(0)))
GO
ALTER TABLE [dbo].[CompanyDiscounts] CHECK CONSTRAINT [CK_CompanyDiscounts_1]
GO
ALTER TABLE [dbo].[CompanyDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_CompanyDiscounts_2] CHECK  (([Discount]>(0) AND [Discount]<(1)))
GO
ALTER TABLE [dbo].[CompanyDiscounts] CHECK CONSTRAINT [CK_CompanyDiscounts_2]
GO
ALTER TABLE [dbo].[CompanyDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_CompanyDiscounts_3] CHECK  (([MaxDiscount]>(0) AND [MaxDiscount]<(1)))
GO
ALTER TABLE [dbo].[CompanyDiscounts] CHECK CONSTRAINT [CK_CompanyDiscounts_3]
GO
ALTER TABLE [dbo].[CompanyDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_CompanyDiscounts_4] CHECK  (([TotalPrice]>(0)))
GO
ALTER TABLE [dbo].[CompanyDiscounts] CHECK CONSTRAINT [CK_CompanyDiscounts_4]
GO
ALTER TABLE [dbo].[CompanyDiscounts]  WITH CHECK ADD  CONSTRAINT [CK_CompanyDiscounts_5] CHECK  (([MaxDiscount]>=[Discount]))
GO
ALTER TABLE [dbo].[CompanyDiscounts] CHECK CONSTRAINT [CK_CompanyDiscounts_5]
GO
