USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[SeatIndex]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[SeatIndex]
as
--This procedure puts players in their seats

DROP TABLE #A
SELECT RawHandID,HandID,TourneyID,Min(ID) as MD,COUNT(*) AS CNT
INTO #A
FROM dbo.Import
WHERE RawData like 'Seat__:%'
GROUP BY RawHandID,HandID,TourneyID
ORDER BY 2 ASC



DROP TABLE #B
SELECT a.HandID,a.RawHandID, a.TourneyID,a.RawData, SUBSTRING(a.RawData,6,1) as Seat,LEN(RawData) as Lenth, CHARINDEX('(',REVERSE(RawData)) as Paren,
CHARINDEX('spihc ni',REVERSE(RawData)) as endg, LEN(RawData) -CHARINDEX('(',REVERSE(RawData)) as FParen,
LEN(RawData) - CHARINDEX('spihc ni',REVERSE(RawData)) as Fendg,
LEN(RawData) -CHARINDEX(')',REVERSE(RawData)) as FParen2,
REVERSE(RawData) as rev
INTO #B
FROM dbo.Import a INNER JOIN #A b on a.HandID = b.HandID and a.TourneyID = b.TourneyID
and a.ID BETWEEN b.MD and b.MD + b.CNT/2 - 1



DROP TABLE #C
SELECT RawHandID,HandID,TourneyID,RawData,Seat,SUBSTRING(RawData,9,FParen - 9) as Player,SUBSTRING(RawData,Fparen+2,Fendg - Fparen-9)as StartingStack
INTO #C
FROM #B


DROP TABLE dbo.PlayerSeat
SELECT *
INTO dbo.PlayerSeat
FROM #C


DECLARE @PROC nvarchar(255)
DECLARE @CNT smallint
DECLARE @CNTt char(1)
SET @CNT = 1
WHILE @CNT <=9
BEGIN
SET @CNTt = CAST(@CNT as char(1))
SET @PROC = '
UPDATE dbo.PokerMaster
SET Seat'+@CNTt +' = b.Player,
	S'+@CNTt+'SS = CAST(b.StartingStack AS INT)
FROM dbo.PokerMaster a INNER JOIN #C b on a.RawData = b.RawHandID
and b.Seat = '+@CNTt 

PRINT @PROC
EXEC sp_executesql @PROC
SET @CNT = @CNT + 1

END 





GO
