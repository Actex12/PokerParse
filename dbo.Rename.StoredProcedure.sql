USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[Rename]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Rename]
as

DROP TABLE dbo.Import
SELECT CAST(ID AS INT) AS ID,HandID,RawData,FileNm
INTO dbo.Import
FROM dbo.[20220517]


GO
