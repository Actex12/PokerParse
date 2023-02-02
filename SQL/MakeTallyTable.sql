USE [PS]
GO

/****** Object:  StoredProcedure [dbo].[MakeTallyTable]    Script Date: 2/1/2023 11:56:38 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC  [dbo].[MakeTallyTable]
as

DROP TABLE dbo.Tally
CREATE TABLE dbo.Tally
(HandID nvarchar(50),
TourneyID nvarchar(50),
Seat char(1),
Player nvarchar(200),
Button char(1),
Ante decimal(10,2),
Flp_ID int,
Trn_ID int,
Rvr_ID int,
End_ID int,

PF_Running decimal(10,2),
PF_Comit decimal(10,2),
PF_Rse decimal (10,2),
PF_AllIN bit DEFAULT 0,
PF_Fold bit DEFAULT 0,
PF_Award decimal(10,2),
PF_Uncalled decimal(10,2),

PT_Running decimal(10,2),
PT_Comit decimal(10,2),
PT_Rse decimal (10,2),
PT_AllIN bit DEFAULT 0,
PT_Fold bit DEFAULT 0,
PT_Award decimal(10,2),
PT_Uncalled decimal(10,2),


PR_Running decimal(10,2),
PR_Comit decimal(10,2),
PR_Rse decimal (10,2),
PR_AllIN bit DEFAULT 0,
PR_Fold bit DEFAULT 0,
PR_Award decimal(10,2),
PR_Uncalled decimal(10,2),


PoR_Running decimal(10,2),
PoR_Comit decimal(10,2),
PoR_Rse decimal (10,2),
PoR_AllIN bit DEFAULT 0,
PoR_Fold bit DEFAULT 0,
PoR_Award decimal(10,2),
PoR_Uncalled decimal(10,2))

INSERT INTO dbo.Tally (HandID,TourneyID,Seat,Player,Button)
SELECT HandID,TourneyID,Seat,Player,Button
FROM dbo.PTran
WHERE NOT(Seat is null)
GROUP BY HandID,TourneyID,Seat,Player,Button

DROP TABLE #A
SELECT HandID,TourneyID,MAX(CASE WHEN PType = '006' THEN ID ELSE 0 END) AS Flp,
MAX(CASE WHEN PType = '010' THEN ID ELSE 0 END) AS TRN,
MAX(CASE WHEN PType = '012' THEN ID ELSE 0 END) AS RVR,
MAX(ID) AS MID
INTO #A
FROM dbo.PTran
GROUP BY HandID,TourneyID

UPDATE dbo.Tally
SET Flp_ID = b.Flp,
Trn_ID = b.TRN,
Rvr_ID = b.RVR,
End_ID = b.MID
FROM dbo.Tally a INNER JOIN #A b ON a.HandID = b.HandID and a.TourneyID = b.TourneyID

UPDATE dbo.Tally
SET Ante = b.Amount
FROM dbo.Tally a INNER JOIN dbo.PTran b on a.HandID = b.HandID and a.TourneyID = b.TourneyID and
a.Seat = b.Seat and b.PType = '016'
GO

