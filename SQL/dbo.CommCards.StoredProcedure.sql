USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[CommCards]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[CommCards]
as

--This procedure updates the community cards to the master table

SELECT HandID,TourneyID,RawData,
SUBSTRING(RawData,15,1) as FC1R,
SUBSTRING(RawData,16,1) as FC1S,
SUBSTRING(RawData,18,1) as FC2R,
SUBSTRING(RawData,19,1) as FC2S,
SUBSTRING(RawData,21,1) as FC3R,
SUBSTRING(RawData,22,1) as FC3S
INTO #A
FROM dbo.Import
WHERE RawData like '*** FLOP ***%'

SELECT HandID,TourneyID,RawData,SUBSTRING(RawData,26,1) as TCR,
SUBSTRING(RawData,27,1) as TCS
INTO #B
FROM dbo.Import
WHERE RawData like '*** TURN ***%'

SELECT HandID,TourneyID,RawData,SUBSTRING(RawData,30,1) as RCR,
SUBSTRING(RawData,31,1) as RCS
INTO #C
FROM dbo.Import
WHERE RawData like '*** RIVER ***%'

UPDATE dbo.PokerMaster
SET FC1R = b.FC1R,
	FC1S = b.FC1S,
	FC2R = b.FC2R,
	FC2S = b.FC2S,
	FC3R = b.FC3R,
	FC3S = b.FC3S,
	TCR = c.TCR,
	TCS = c.TCS,
	RCR = d.RCR,
	RCS = d.RCS
FROM dbo.PokerMaster a LEFT OUTER JOIN #A b on a.HandID = b.HandID and a.TourneyID = b.TourneyID 
LEFT OUTER JOIN #B c ON a.HandID = c.HandID and a.TourneyID = c.TourneyID
LEFT OUTER JOIN #C d ON a.HandID = d.HandID and a.TourneyID = d.TourneyID

GO
