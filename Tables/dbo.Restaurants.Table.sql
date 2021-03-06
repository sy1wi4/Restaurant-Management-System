USE [u_smarek]
GO
/****** Object:  Table [dbo].[Restaurants]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restaurants](
	[RestaurantID] [int] NOT NULL,
	[ManagerID] [int] NOT NULL,
	[RestaurantName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Restaurants] PRIMARY KEY CLUSTERED 
(
	[RestaurantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [RestaurantsNameUnique] UNIQUE NONCLUSTERED 
(
	[RestaurantName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Restaurants]  WITH CHECK ADD  CONSTRAINT [FK_Restaurants_Managers] FOREIGN KEY([ManagerID])
REFERENCES [dbo].[Managers] ([ManagerID])
GO
ALTER TABLE [dbo].[Restaurants] CHECK CONSTRAINT [FK_Restaurants_Managers]
GO
