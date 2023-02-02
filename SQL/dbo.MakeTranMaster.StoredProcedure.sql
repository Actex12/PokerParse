USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[MakeTranMaster]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[MakeTranMaster]
as

DROP TABLE dbo.PTran
CREATE TABLE dbo.PTran
(ID int,
HandID nvarchar(255),
TourneyID nvarchar(255),
Player varchar(70),
Seat char(1),
PType char(3),
Amount decimal(15,2),
Final decimal(15,2),
Scrape nvarchar(255),
Button char(1),
Flp int,
Trn int,
Rvr int,
Mx int,
seg smallint)




DROP TABLE dbo.PTrans
CREATE TABLE dbo.PTrans
(PType char(3),
Descr varchar(50),
CMatch varchar(50),
CMatchSub varchar(50),
MatchLen smallint)

INSERT INTO dbo.PTrans (PType,Descr,CMatch,CMatchSub,MatchLen)
VALUES('001','PSB','%: posts small blind%',': posts small blind',0),
('002','PBB','%: posts big blind%',': posts big blind',0),
('003','RAZ','%: raises%',': raises',0),
('004','CLL','%: calls %',': calls',0),
('005','FLD','%: folds%',': folds',0),
('006','FLP','*** FLOP ***%','*** FLOP ***',0),
('007','BET','%: bets %',': bets',0),
('008','UCB','Uncalled bet (%','Uncalled bet (',0),
('009','SP ','% collected % from pot',' collected % from pot',0),
('010','TRN','*** TURN ***%','*** TURN ***',0),
('011','CHK','%: checks%',': checks',0),
('012','RVR','*** RIVER ***%','*** RIVER ***',0),
('013','SHW','%: shows /[%',': shows',0),
('014','SDN','*** SHOW DOWN ***','*** SHOW DOWN ***',0),
('015','TMO','% has timed out','has timed out',0),
('016','PAT','%: posts the ante %',': posts the ante',0),
('017','MUK','%: mucks hand%',': mucks hand',0),
('018','DSH','%: doesn''t show hand%',': doesn''t show hand',0),
('019','FTT','% finished the tournament%',' finished the tournament',0),
('020','CSP','% collected % from side pot%','collected % from side pot',0),
('021','CMP','% collected % from main pot%','collected % from main pot',0),
('022','PTX','% said, "%"%','said, "%"',0)

UPDATE dbo.PTrans
SET MatchLen = LEN(CMatchSub)


INSERT INTO dbo.PTran (ID,HandID,TourneyID,PType,Amount,Scrape)
SELECT   ID,HandID,TourneyID,b.PType,
 CAST(SUBSTRING(a.RawData,CHARINDEX(b.CMatchSub,a.RawData)+b.MatchLen+1,
LEN(a.RawData)- dbo.FindNum(a.RawData)-b.MatchLen - CHARINDEX(b.CMatchSub,a.RawData) +1) AS decimal) as Amount,
a.RawData as Scrape
FROM dbo.Import a INNER JOIN dbo.PTrans b on a.RawData like b.CMatch ESCAPE '/'
WHERE b.PType in( '001','002','004','007','016') 

INSERT INTO dbo.PTran (ID,HandID,TourneyID,PType,Amount,Scrape)
SELECT ID,HandID,TourneyID,b.PType,0 as Amount,a.RawData
FROM dbo.Import a INNER JOIN dbo.PTrans b on a.RawData like b.CMatch ESCAPE '/'
WHERE b.PType in( '005','006','010','011','012','013','014','015','017','018','019','022') 

DROP TABLE #A
SELECT ID,HandID,TourneyID,b.PType,0 as Amount,a.RawData,
SUBSTRING(a.RawData,CHARINDEX(b.CMatchSub,a.RawData)+b.MatchLen+1,
LEN(a.RawData)- dbo.FindNum(a.RawData)-b.MatchLen - CHARINDEX(b.CMatchSub,a.RawData) +1) as Bet
INTO #A
FROM dbo.Import a INNER JOIN dbo.PTrans b on a.RawData like b.CMatch ESCAPE '/'
WHERE b.PType in ('003')

INSERT INTO dbo.PTran (ID,HandID,TourneyID,PType,Amount,Final,Scrape)
SELECT ID,HandID,TourneyID,PType,
CAST(LEFT(Bet,CHARINDEX('to',Bet)-2) AS decimal) as initial,
CAST(SUBSTRING(Bet,CHARINDEX('to',Bet)+3,LEN(Bet)-CHARINDEX('to',Bet))AS decimal) as final,
RawData
FROM #A

INSERT INTO dbo.PTran (ID,HandID,TourneyID,PType,Amount,Scrape)
SELECT ID,HandID,TourneyID,b.PType,
SUBSTRING(RawData,CHARINDEX('(',RawData)+1,CHARINDEX(')',RawData)-CHARINDEX('(',RawData)-1),
RawData
FROM dbo.Import a INNER JOIN dbo.PTrans b on a.RawData like b.CMatch ESCAPE '/'
WHERE b.PType in ('008')



INSERT INTO dbo.PTran (ID,HandID,TourneyID,PType,Amount,Scrape)
SELECT ID,HandID,TourneyID,b.PType,
SUBSTRING(RawData,CHARINDEX('collected',RawData)+10,LEN(RawData) - CHARINDEX('collected',RawData)-18) as Amt,
RawData
FROM dbo.Import a INNER JOIN dbo.PTrans b on a.RawData like b.CMatch ESCAPE '/'
WHERE b.PType in ('009')


INSERT INTO dbo.PTran (ID,HandID,TourneyID,PType,Amount,Scrape)
SELECT ID,HandID,TourneyID,b.PType,
SUBSTRING(RawData,CHARINDEX('collected',RawData)+10,CHARINDEX('from side pot',RawData) - CHARINDEX('collected',RawData)-10)
as Amt,
RawData
FROM dbo.Import a INNER JOIN dbo.PTrans b on a.RawData like b.CMatch ESCAPE '/'
WHERE b.PType in ('020')


INSERT INTO dbo.PTran (ID,HandID,TourneyID,PType,Amount,Scrape)
SELECT ID,HandID,TourneyID,b.PType,
SUBSTRING(RawData,CHARINDEX('collected',RawData)+10,CHARINDEX('from main pot',RawData) - CHARINDEX('collected',RawData)-10)
as Amt,
RawData
FROM dbo.Import a INNER JOIN dbo.PTrans b on a.RawData like b.CMatch ESCAPE '/'
WHERE b.PType in ('021')


UPDATE dbo.PTran
SET Player = b.Player,
	Seat = b.Seat
FROM dbo.PTran a INNER JOIN dbo.PlayerSeat b on a.HandID = b.HandID and a.TourneyID = b.TourneyID
and a.Scrape like '%'+b.Player+'%'


UPDATE dbo.PTran
SET Button = b.Button
FROM dbo.PTran a INNER JOIN dbo.PokerMaster b on a.HandID = b.HandID and a.TourneyID = b.TourneyID

DROP TABLE #Z
SELECT HandID,TourneyID,MAX(CASE WHEN PType = '006' THEN ID ELSE 0 END) AS Flp,
MAX(CASE WHEN PType = '010' THEN ID ELSE 0 END) AS TRN,
MAX(CASE WHEN PType = '012' THEN ID ELSE 0 END) AS RVR,
MAX(ID) AS MID
INTO #Z
FROM dbo.PTran
GROUP BY HandID,TourneyID


UPDATE dbo.PTran
SET Flp = b.Flp,
Trn = b.TRN,
Rvr = b.RVR,
Mx = b.MID
FROM dbo.PTran a INNER JOIN #Z b ON a.HandID = b.HandID and a.TourneyID = b.TourneyID



UPDATE dbo.PTran
SET Seg = CASE WHEN  ID BETWEEN 0 AND Flp OR Flp = 0 THEN 1
WHEN Flp <> 0 and ((ID > Flp and ID <=Trn)  or (ID> Flp and Trn = 0)) THEN 2
WHEN Trn <> 0 and ((ID > Trn and ID <=Rvr) or (ID > Trn and Rvr = 0)) THEN 3
WHEN Rvr <> 0  and ID > Rvr THEN 4 ELSE 5 END
FROM dbo.PTran


GO
