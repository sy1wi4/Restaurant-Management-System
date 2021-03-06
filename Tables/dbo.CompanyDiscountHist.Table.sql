USE [u_smarek]
GO
/****** Object:  Table [dbo].[CompanyDiscountHist]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyDiscountHist](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[DiscountID] [smallint] NOT NULL,
	[Since] [date] NOT NULL,
	[TotalDiscount] [real] NOT NULL,
 CONSTRAINT [PK_CompanyDiscountHist] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC,
	[DiscountID] ASC,
	[Since] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyDiscountHist]  WITH CHECK ADD  CONSTRAINT [FK_CompanyDiscountHist_CompanyCustomers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[CompanyCustomers] ([CompanyID])
GO
ALTER TABLE [dbo].[CompanyDiscountHist] CHECK CONSTRAINT [FK_CompanyDiscountHist_CompanyCustomers]
GO
ALTER TABLE [dbo].[CompanyDiscountHist]  WITH CHECK ADD  CONSTRAINT [FK_CompanyDiscountHist_CompanyDiscounts] FOREIGN KEY([DiscountID])
REFERENCES [dbo].[CompanyDiscounts] ([DiscountID])
GO
ALTER TABLE [dbo].[CompanyDiscountHist] CHECK CONSTRAINT [FK_CompanyDiscountHist_CompanyDiscounts]
GO
ALTER TABLE [dbo].[CompanyDiscountHist]  WITH CHECK ADD  CONSTRAINT [CK_CompanyDiscountHist] CHECK  (([TotalDiscount]>=(0) AND [TotalDiscount]<=(1)))
GO
ALTER TABLE [dbo].[CompanyDiscountHist] CHECK CONSTRAINT [CK_CompanyDiscountHist]
GO
