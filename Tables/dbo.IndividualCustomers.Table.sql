USE [u_smarek]
GO
/****** Object:  Table [dbo].[IndividualCustomers]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndividualCustomers](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[CompanyID] [int] NULL,
 CONSTRAINT [PK_IndividualCustomers] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[IndividualCustomers]  WITH CHECK ADD  CONSTRAINT [FK_IndividualCustomers_CompanyCustomers] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[CompanyCustomers] ([CompanyID])
GO
ALTER TABLE [dbo].[IndividualCustomers] CHECK CONSTRAINT [FK_IndividualCustomers_CompanyCustomers]
GO
ALTER TABLE [dbo].[IndividualCustomers]  WITH CHECK ADD  CONSTRAINT [FK_IndividualCustomers_Customers] FOREIGN KEY([CustomerID])
REFERENCES [dbo].[Customers] ([CustomerID])
GO
ALTER TABLE [dbo].[IndividualCustomers] CHECK CONSTRAINT [FK_IndividualCustomers_Customers]
GO
