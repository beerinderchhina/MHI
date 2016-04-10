USE [ClientBISDb]
GO

/****** Object:  Table [dbo].[LMS_AuditTb]    Script Date: 4/10/2016 6:46:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[LMS_AuditTb](
	[PROC_NAME] [varchar](30) NULL,
	[STEP] [int] NULL,
	[STG_DATETIME] [datetime] NULL,
	[DURATION] [int] NULL,
	[AUDIT_TEXT] [varchar](1000) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


