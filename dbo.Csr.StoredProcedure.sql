USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[Csr]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Csr]
as

DECLARE @HandID varchar(200),@TourneyID varchar(100), 
@Seat char(1), @ID INT,@Amount decimal(10,2),@Final decimal(10,2),@PType char(3),@Button char(1),
@Scrape nvarchar(250)

DECLARE HND CURSOR 
FOR 
SELECT  a.ID,a.HandID,a.TourneyID, a.Seat, a.Button,a.PType,a.Amount,a.Final,a.Scrape
FROM dbo.PTran a INNER JOIN dbo.Temp b ON a.HandID = b.HandID and a.TourneyID = b.TourneyID
and a.ID <= b.Flp
ORDER BY 1

OPEN HND
FETCH NEXT FROM HND INTO @ID,@HandID,@TourneyID,@Seat,@Button,@PType,@Amount,@Final,@Scrape

WHILE @@FETCH_STATUS = 0
BEGIN

IF @PType in ('001','002')
BEGIN
UPDATE dbo.Tally
SET Running = @Amount
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF  @PType = '003'
BEGIN
UPDATE dbo.Tally
SET Running = @Final,
	Rse = @Amount
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END


IF @PType = '004'
BEGIN
UPDATE dbo.Tally
SET Running = @Amount + ISNULL(Running,0)
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF @PType = '016'
BEGIN
UPDATE dbo.Tally
SET Ante = @Amount
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat

END

IF @PType = '005'
BEGIN
UPDATE dbo.Tally
SET Comit = ISNULL(Running,0),
	Fold = 1,
	Allin = 0
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF @PType = '008'
BEGIN
UPDATE dbo.Tally
SET Uncalled = @Amount,
	Fold = 0
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF @Scrape like '%and is all-in'
BEGIN
UPDATE dbo.Tally
SET AllIn = 1,
	Fold = 0
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF @PType = '009'
BEGIN
UPDATE dbo.Tally
SET Comit = Running - ISNULL(Uncalled,0),
	Award = @Amount
WHERE HandID = @HandID and TourneyID = @TourneyID and Seat = @Seat
END

IF @PType = '006'
BEGIN
UPDATE dbo.Tally
SET Comit = isnull(Running,0) - isnull(uncalled,0)
WHERE HandID = @HandID and TourneyID = @TourneyID 
END

FETCH NEXT FROM HND INTO @ID,@HandID,@TourneyID,@Seat,@Button,@PType,@Amount,@Final,@Scrape

END;
CLOSE HND;
DEALLOCATE HND;
GO
