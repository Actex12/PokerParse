USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[TempT]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[TempT]
as

DROP TABLE dbo.TallyTemp
SELECT a.HandID, a.TourneyID, a.Seat,a.Button
INTO dbo.TallyTemp
FROM dbo.PTran a
WHERE NOT(Seat is null)
GROUP BY a.HandID,a.TourneyID,a.Seat,a.Button
ORDER BY 1

ALTER TABLE dbo.TallyTemp
ADD Running decimal(10,2),
Comit decimal(10,2),
Ante decimal(10,2),
Rse decimal (10,2),
AllIN bit DEFAULT 0,
Fold bit DEFAULT 0,
Award decimal(10,2),
Uncalled decimal(10,2)
GO
