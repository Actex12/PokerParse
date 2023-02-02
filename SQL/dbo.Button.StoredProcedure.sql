USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[Button]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[Button]
as

--this procedure assigns the button to poker master.

DROP TABLE #A
SELECT  HandID,MIN(ID) AS MD
INTO #A
FROM dbo.Import
GROUP BY HandID
ORDER BY 1

SELECT SUBSTRING(a.RawData,CHARINDEX('#',a.RawData)+1,1) as seat, a.RawData,b.*
INTO #B
FROM dbo.Import a INNER JOIN #A b ON a.HandID = b.HandID and a.ID = b.MD +1

UPDATE dbo.PokerMaster
SET Button = b.Seat
FROM dbo.PokerMaster a INNER JOIN #B b ON a.RawData = b.HandID


GO
