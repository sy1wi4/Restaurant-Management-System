USE [u_smarek]
GO
/****** Object:  Table [dbo].[CovidRestrictions]    Script Date: 25.03.2021 12:37:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CovidRestrictions](
	[TableID] [int] NOT NULL,
	[Since] [datetime] NOT NULL,
	[Until] [datetime] NOT NULL,
	[SeatsAvailable] [smallint] NOT NULL,
 CONSTRAINT [PK_CovidRestrictions] PRIMARY KEY CLUSTERED 
(
	[TableID] ASC,
	[Since] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CovidRestrictions]  WITH CHECK ADD  CONSTRAINT [FK_CovidRestrictions_Tables] FOREIGN KEY([TableID])
REFERENCES [dbo].[Tables] ([TableID])
GO
ALTER TABLE [dbo].[CovidRestrictions] CHECK CONSTRAINT [FK_CovidRestrictions_Tables]
GO
ALTER TABLE [dbo].[CovidRestrictions]  WITH CHECK ADD  CONSTRAINT [CK_CovidRestrictions] CHECK  (([SeatsAvailable]>=(0)))
GO
ALTER TABLE [dbo].[CovidRestrictions] CHECK CONSTRAINT [CK_CovidRestrictions]
GO
ALTER TABLE [dbo].[CovidRestrictions]  WITH CHECK ADD  CONSTRAINT [CK_CovidRestrictions_1] CHECK  (([Since]<=[Until]))
GO
ALTER TABLE [dbo].[CovidRestrictions] CHECK CONSTRAINT [CK_CovidRestrictions_1]
GO
