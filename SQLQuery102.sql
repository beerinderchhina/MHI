USE [ClientBISDb]
GO
/****** Object:  StoredProcedure [dbo].[LMS_LoadSp]    Script Date: 4/10/2016 6:46:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[LMS_LoadSp]
AS
DECLARE
	@LATEST_MONTHEND int,
	@PROC_NAME varchar(30) = 'LMS_LoadSp',
	@STRT_DATE datetime =getdate(),
	@AUDIT_TEXT varchar(1000),
	@STEP int=1;
BEGIN

	SET NOCOUNT ON 
	
	exec LMS_AuditSp @STRT_DATE OUT,@STEP OUT,@PROC_NAME,'LMS load started!';

	--Call stored proc for staging load
	exec LMS_LoadStagingSp @LATEST_MONTHEND out;

	if @LATEST_MONTHEND is not null
	begin
		--Call stored proc for ClientDepositsTb load
		exec LMS_BuildDepositsSp @LATEST_MONTHEND; 
		--Call stored proc for ClientLCRTb load
		exec LMS_BuildLCRSp @LATEST_MONTHEND;
		--Call stored proc for LMSTimePeriod load
		exec LMS_BuildTPeriodSp @LATEST_MONTHEND;
		select @AUDIT_TEXT='LMS load completed successfully for monthend '+cast(@LATEST_MONTHEND as char(6));
	end
	else
	begin
		select @AUDIT_TEXT='LMS load completed with errors! Please check staging data.';
	end;

	exec LMS_AuditSp @STRT_DATE OUT,@STEP OUT,@PROC_NAME,@TEXT=@AUDIT_TEXT;
		
END
