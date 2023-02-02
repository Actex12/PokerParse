USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[Cards]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[Cards]
as

--This procedure places the shown cards in the master table for players
DROP TABLE #A
SELECT HandID,TourneyID, SUBSTRING(RawData,19,1)as HC1R,SUBSTRING(RawData,20,1) as HC1S,SUBSTRING(RawData,22,1) as HC2R,SUBSTRING(RawData,23,1) as HC2S
INTO #A
FROM dbo.Import
WHERE RawData like 'Dealt to Actex12%'

DROP TABLE #B
SELECT HandID,TourneyID,SUBSTRING(RawData,CHARINDEX(': shows',RawData)+8,7) as crds,RawData,LEFT(RawData,CHARINDEX(': shows',RawData)-1) as Plr
INTO #B
FROM dbo.Import
WHERE RawData like '%: shows%'



DROP TABLE #D
SELECT a.HandID,a.TourneyID, SUBSTRING(crds,2,1) as HC1R,SUBSTRING(crds,3,1) as HC1S,
CASE WHEN LEN(crds) > 4 THEN SUBSTRING(crds,5,1) 
ELSE '' END as HC2R,
CASE WHEN LEN(crds) > 4 THEN SUBSTRING(crds,6,1) 
ELSE '' END  as HC2S, LEN(crds) as lenc,b.Seat,b.Player
INTO #D
FROM #B a INNER JOIN dbo.PlayerSeat b on a.HandID = b.HandID and a.TourneyID = b.TourneyID and a.Plr = b.Player
WHERE a.Plr <> 'Actex12'

INSERT INTO #D (HandID,TourneyID,HC1R,HC1S,HC2R,HC2S,Seat)
SELECT a.HandID,a.TourneyID, a.HC1R,a.HC1S,a.HC2R,a.HC2S,b.Seat
FROM #A a INNER JOIN dbo.PlayerSeat b on a.HandID = b.HandID and a.TourneyID = b.TourneyID and b.Player = 'Actex12'





DECLARE @HandID varchar(200),@TourneyID varchar(100), @Seat char(1), @PROC NVARCHAR(500),@1R CHAR(1),@1S CHAR(1),@2R CHAR(1),@2S CHAR(1)

DECLARE HND CURSOR 
FOR 
SELECT  a.HandID,a.TourneyID, a.Seat, a.HC1R, a.HC1S, a.HC2R, a.HC2S
FROM #D a

OPEN HND
FETCH NEXT FROM HND INTO @HandID,@TourneyID,@Seat,@1R,@1S,@2R,@2S

WHILE @@FETCH_STATUS = 0
BEGIN

SET @PROC = 
'UPDATE dbo.PokerMaster
SET HCS' + @Seat + 'C1R ='''+ @1R+''',
	HCS' + @Seat + 'C1S ='''+ @1S+''',
	HCS' + @Seat + 'C2R ='''+ @2R+''',
	HCS' + @Seat + 'C2S ='''+ @2S+'''
FROM dbo.PokerMaster
WHERE HandID ='''+ @HandID +''' and TourneyID = '''+@TourneyID+''''

exec sp_executesql @PROC

FETCH NEXT FROM HND INTO @HandID,@TourneyID,@Seat,@1R,@1S,@2R,@2S

END;
CLOSE HND;
DEALLOCATE HND;



        


GO
