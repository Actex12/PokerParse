USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[UpdateEndStack]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[UpdateEndStack]
as
/*
SELECT HandID,TourneyID,SUM(CASE WHEN PType in ('001','002','004','007','016') THEN
-Amount
WHEN PType = '003' THEN -Final
WHEN PType in ('008','009','020','021') THEN Amount
ELSE 0 END) AS Ttl
FROM dbo.PTran
GROUP BY HandID,TourneyID

SELECT *
FROM dbo.Import
WHERE HandID = '193564602926'

DROP TABLE #A
SELECT HandID,TourneyID,MAX(CASE WHEN PType = '006' THEN ID ELSE 0 END) AS Flp,
MAX(CASE WHEN PType = '010' THEN ID ELSE 0 END) AS TRN,
MAX(CASE WHEN PType = '012' THEN ID ELSE 0 END) AS RVR
INTO #A
FROM dbo.PTran
GROUP BY HandID,TourneyID

SELECT *
INTO #B
FROM #A
WHERE Flp = 0

SELECT a.HandID, a.TourneyID, a.Seat,a.Button
INTO #C
FROM dbo.PTran a INNER JOIN #B b ON a.HandID = b.HandID and a.TourneyID = b.TourneyID
GROUP BY a.HandID,a.TourneyID,a.Seat,a.Button
ORDER BY 1

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



        









SELECT TOP 10 *
FROM dbo.PokerMaster






DROP TABLE #B
SELECT a.HandID,a.TourneyID,a.Player, MAX(CASE WHEN a.ID < Flp or Flp = 0 THEN 
CASE WHEN a.PType in ('001','002','004') THEN a.Amount
WHEN a.PType = '003' THEN a.Final ELSE 0 END
ELSE 0 END) AS Preflp,

MAX(CASE WHEN (a.ID BETWEEN b.Flp and b.TRN )or (b.Flp <> 0 and b.TRN = 0 AND a.ID > b.FLP ) THEN
CASE WHEN a.PType in ('007','004') THEN a.Amount
WHEN a.PType = '003' THEN a.Final ELSE 0 END ELSE 0 END) AS FLP,

MAX(CASE WHEN (a.ID BETWEEN b.TRN AND b.RVR )OR (b.TRN <> 0 AND b.Rvr = 0 AND a.ID > b.TRN)THEN
CASE WHEN a.PType in ('007','004') THEN a.Amount
WHEN a.PType = '003' THEN a.Final ELSE 0 END ELSE 0 END) AS TRN,

MAX(CASE WHEN a.ID > b.RVR AND b.RVR <> 0  THEN
CASE WHEN a.PType in ('007','004') THEN a.Amount
WHEN a.PType = '003' THEN a.Final ELSE 0 END ELSE 0 END) AS RVR,

SUM(CASE WHEN a.PType = '016' THEN a.Amount ELSE 0 END) AS Ante,
SUM(CASE WHEN a.PType in ('008','009','020','021') THEN a.Amount ELSE 0 END) AS Gain

INTO #B
FROM dbo.PTran a INNER JOIN #A b ON a.HandID = b.HandID and a.TourneyID = b.TourneyID
GROUP BY a.HandID,a.TourneyID,a.Player


SELECT HandID,TourneyID,SUM(Gain - Ante - RVR - TRN - FLP - PreFLP) as ttl
FROM #B
GROUP BY HandID,TourneyID

SELECT *
FROM dbo.Import
WHERE HandID = '193563762005'


SELECT *
FROM dbo.PTRan
WHERE HandID = '193563713416'
ORDER BY 1

SELECT *
FROM #B
WHERE HandID = '193563713416'

SELECT *
FROM #A
WHERE HandID = '193563762005'
*/
GO
