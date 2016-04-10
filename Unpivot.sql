SELECT [GFCID]
      ,[GFCID_NAME]
      ,[ACCOUNT_NUMBER]
      ,[SUB_SECTOR]
      ,[FACTORY_COUNTRY]
      ,[FACTORY_REGION]
      ,[MIS_COUNTRY]
      ,[MIS_REGION]
      ,[Original Currency]
      ,[DEPOSIT_TYPE]
      ,u.dayofMont
	  ,u.Balance

	  into #tmpDepOct
  FROM [BBDWDB].[dbo].[DepositsTb] a

  unpivot
  (
   Balance
   for dayofMont in (d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16,d17,d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,d31)
   ) u
  where month =102015

  Select * from #tmpDepOct where dayofMont= 'd31'
  Update #tmpDepOct
  Set dayofMont='2015-10-31'
  where dayofMont= 'd31'

  SELECT TOP 1000 [GFCID]
      ,[GFCID_NAME]
      ,[ACCOUNT_NUMBER]
      ,[DEPOSIT_DATE]
      ,[AVAIL_BAL]
      ,[AVAIL_BAL_USD]
      ,[SUB_SECTOR]
      ,[FACTORY_COUNTRY]
      ,[FACTORY_REGION]
      ,[MIS_COUNTRY]
      ,[MIS_REGION]
      ,[ORIG_CNCY]
      ,[DEPOSIT_TYPE]
  FROM [ClientBISDb].[dbo].[LMS_Deposits_LoadTb]


  INSERT INTO [ClientBISDb].[dbo].[LMS_Deposits_LoadTb]
  Select right('0000000000' +a.[GFCID], 10) as GFCID,
  CASE WHEN b.CompanyN is null then a.GFCId_Name ELSE b.companyN END as [GFCID_NAME],
  a.ACCOUNT_NUMBER,
  dayofMont,
  Balance,
  Balance,
  SUB_SECTOR,
  FACTORY_COUNTRY,
  FACTORY_REGION,
  MIS_COUNTRY,
  MIS_REGION,
  [Original Currency],
  DEPOSIT_TYPE  
  
    from #tmpDepOct a
  Left Join ClientBISDb..CISCompanySnapshotTb b
  on right('0000000000' + a.[GFCID], 10) = b.GFCID



  --Select right('0000000000' +[GFCID], 10)
  --from #tmpDepOct 

  --EXCEPT 
  --Select GFCID from ClientBISDb..CISCompanySnapshotTb
  --Left Join ClientBISDb..CISCompany b
  --on right('0000000000' + a.[GFCID], 10) = b.GFCID

  Select right('0000000000' +[GFCID], 10)
  from #tmpDepOct 
  EXCEPT
  Select top 1 * from ClientBISDb..CISCompanySnapshotTb

  Select * from #tmpDepOct