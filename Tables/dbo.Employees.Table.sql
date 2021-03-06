USE [u_smarek]
GO
/****** Object:  Table [dbo].[Employees]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[EmployeeID] [int] NOT NULL,
	[ManagerID] [int] NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](50) NOT NULL,
	[CityID] [int] NOT NULL,
	[PostalCode] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Phone] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Employees] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Cities] FOREIGN KEY([CityID])
REFERENCES [dbo].[Cities] ([CityID])
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_Cities]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Managers] FOREIGN KEY([ManagerID])
REFERENCES [dbo].[Managers] ([ManagerID])
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_Managers]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [CK_Employees_Email] CHECK  (([Email] like '%@%.%'))
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [CK_Employees_Email]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [CK_Employees_Phone] CHECK  ((isnumeric([Phone])=(1)))
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [CK_Employees_Phone]
GO
ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [CK_Employees_PostalCode] CHECK  (([PostalCode] like '[0-9][0-9]-[0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [CK_Employees_PostalCode]
GO
