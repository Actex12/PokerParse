USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[Blinds]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Blinds]
as

--This procedure updates the blinds and ante with values in poker master

UPDATE dbo.PokerMaster
SET SB = CAST(SUBSTRING(Lvl,CHARINDEX('(',Lvl)+1,CHARINDEX('/',Lvl)-CHARINDEX('(',Lvl)-1) AS INT),
    BB = CAST(SUBSTRING(Lvl,CHARINDEX('/',Lvl)+1,CHARINDEX(')',Lvl)-CHARINDEX('/',Lvl)-1) AS INT)



DROP TABLE #A
SELECT HandID,TourneyID, SUBSTRING(RawData,CHARINDEX(': posts the ante',RawData)+17,10) as ante
INTO #A
FROM dbo.Import
WHERE RawData like '%: posts the ante%' AND NOT(RawData like '%and is all-in%')
GROUP BY HandID,TourneyID,SUBSTRING(RawData,CHARINDEX(': posts the ante',RawData)+17,10)



UPDATE dbo.PokerMaster
SET Ante = CAST(b.ante AS INT)
FROM dbo.PokerMaster a LEFT OUTER JOIN #A b on a.HandID = b.HandID and a.TourneyID = b.TourneyID

GO
