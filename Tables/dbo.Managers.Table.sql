USE [u_smarek]
GO
/****** Object:  Table [dbo].[Managers]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Managers](
	[ManagerID] [int] NOT NULL,
	[Firstname] [nvarchar](50) NOT NULL,
	[Lastname] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[CityID] [int] NOT NULL,
	[PostalCode] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Managers] PRIMARY KEY CLUSTERED 
(
	[ManagerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Managers]  WITH CHECK ADD  CONSTRAINT [FK_Managers_Cities] FOREIGN KEY([CityID])
REFERENCES [dbo].[Cities] ([CityID])
GO
ALTER TABLE [dbo].[Managers] CHECK CONSTRAINT [FK_Managers_Cities]
GO
ALTER TABLE [dbo].[Managers]  WITH CHECK ADD  CONSTRAINT [CK_Managers_Email] CHECK  (([Email] like '%@%.%'))
GO
ALTER TABLE [dbo].[Managers] CHECK CONSTRAINT [CK_Managers_Email]
GO
ALTER TABLE [dbo].[Managers]  WITH CHECK ADD  CONSTRAINT [CK_Managers_Phone] CHECK  ((isnumeric([Phone])=(1)))
GO
ALTER TABLE [dbo].[Managers] CHECK CONSTRAINT [CK_Managers_Phone]
GO
ALTER TABLE [dbo].[Managers]  WITH CHECK ADD  CONSTRAINT [CK_Managers_PostalCode] CHECK  (([PostalCode] like '[0-9][0-9]-[0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Managers] CHECK CONSTRAINT [CK_Managers_PostalCode]
GO
