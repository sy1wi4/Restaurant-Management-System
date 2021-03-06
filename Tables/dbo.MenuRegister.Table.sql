USE [u_smarek]
GO
/****** Object:  Table [dbo].[MenuRegister]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuRegister](
	[DishID] [int] IDENTITY(1,1) NOT NULL,
	[MenuIn] [date] NOT NULL,
	[MenuOut] [date] NULL,
 CONSTRAINT [PK_MenuRegister] PRIMARY KEY CLUSTERED 
(
	[DishID] ASC,
	[MenuIn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MenuRegister]  WITH CHECK ADD  CONSTRAINT [FK_MenuRegister_Menu] FOREIGN KEY([DishID])
REFERENCES [dbo].[Menu] ([DishID])
GO
ALTER TABLE [dbo].[MenuRegister] CHECK CONSTRAINT [FK_MenuRegister_Menu]
GO
ALTER TABLE [dbo].[MenuRegister]  WITH CHECK ADD  CONSTRAINT [CK_MenuRegister] CHECK  (([MenuIn]<=[MenuOut]))
GO
ALTER TABLE [dbo].[MenuRegister] CHECK CONSTRAINT [CK_MenuRegister]
GO
