USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[ParseIDs]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[ParseIDs]
as

DROP TABLE #A
SELECT RawHandID
INTO #A
FROM dbo.Import
WHERE LEFT(RawHandID,2) = 'Po'
GROUP BY RawHandID


DROP TABLE #B
SELECT RawHandID,CHARINDEX('Hand #',RawHandID)+6 as a,CHARINDEX('Tournament #',RawHandID)+12 as b,CHARINDEX(',',RawHandID) as c, CHARINDEX('Hold''em',RawHandID) as d,CHARINDEX('-',RawHandID) as e,
CHARINDEX(') -',RawHandID) as f, LEN(RawHandID) as g
INTO #B
FROM #A

SELECT *
FROM #B
ORDER BY f ASC
INSERT INTO dbo.PokerMaster(HandID,TourneyID,BuyIn,Lvl ,Dt,RawData)
SELECT SUBSTRING(RawHandID, a, b-a-14) AS HandNum,SUBSTRING(RawHandID,b,c-b) as TourneyNum,SUBSTRING(RawHandID,c+1, d-c-1) as BuyIn,SUBSTRING(RawHandID,e+1,f-e) as Lvl,
SUBSTRING(RawHandID,f+3,g-f) as dt,RawHandID
FROM #B



ALTER TABLE dbo.Import
ADD HandID nvarchar(255),
           TourneyID nvarchar(225)



UPDATE  dbo.Import
SET HandID = b.HandID,
	TourneyID = b.TourneyID,
	RawData = TRIM(a.RawData)
FROM dbo.Import a INNER JOIN dbo.PokerMaster b on a.RawHandID = b.RawData




GO
