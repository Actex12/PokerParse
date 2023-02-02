USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[TallyPlayer_ToFlop]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[TallyPlayer_ToFlop] (@a smallint)
as
--This proc sorts the amount of bet by player, commit and allin or fold status



DECLARE @HandID varchar(200),@TourneyID varchar(100), 
@Seat char(1), @ID INT,@Amount decimal(10,2),@Final decimal(10,2),@PType char(3),@Button char(1),
@Scrape nvarchar(250)

DECLARE HND CURSOR 
FOR 
SELECT ID,HandID,TourneyID, Seat, Button,PType,Amount,Final,Scrape
FROM dbo.PTran  
WHERE Seg = @a
ORDER BY 1

OPEN HND
FETCH NEXT FROM HND INTO @ID,@HandID,@TourneyID,@Seat,@Button,@PType,@Amount,@Final,@Scrape

WHILE @@FETCH_STATUS = 0
BEGIN

IF @PType in ('001','002') -- post blinds
BEGIN
UPDATE dbo.TallyTemp
SET Running = @Amount
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF  @PType = '003' -- raise
BEGIN
UPDATE dbo.TallyTemp
SET Running = @Final,
	Rse = @Amount
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END


IF @PType = '004' -- call
BEGIN
UPDATE dbo.TallyTemp
SET Running = @Amount + ISNULL(Running,0)
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF @PType = '016' -- ante
BEGIN
UPDATE dbo.TallyTemp
SET Ante = @Amount
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat

END

IF @PType = '005'-- fold
BEGIN
UPDATE dbo.TallyTemp
SET Comit = ISNULL(Running,0),
	Fold = 1,
	Allin = 0
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF @PType = '008'-- uncalled bet
BEGIN
UPDATE dbo.TallyTemp
SET Uncalled = @Amount,
	Fold = 0
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF @Scrape like '%and is all-in'
BEGIN
UPDATE dbo.TallyTemp
SET AllIn = 1,
	Fold = 0
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF @PType in ('020','021','009')--collected from pot
BEGIN
UPDATE dbo.TallyTemp
SET Comit = Running - ISNULL(Uncalled,0),
	Award = @Amount + ISNULL(Award,0)
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF @PType in( '010','006','012','014') --turn, flop, river,showdown
BEGIN
UPDATE dbo.TallyTemp
SET Comit = isnull(Running,0) - isnull(uncalled,0)
WHERE HandID = @HandID and TourneyID = @TourneyID 
END

IF @PType = '007' -- bet
BEGIN
UPDATE dbo.TallyTemp
SET Running = @Amount
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END


FETCH NEXT FROM HND INTO @ID,@HandID,@TourneyID,@Seat,@Button,@PType,@Amount,@Final,@Scrape

END;
CLOSE HND;
DEALLOCATE HND;


GO
