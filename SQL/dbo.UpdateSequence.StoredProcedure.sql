USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[UpdateSequence]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[UpdateSequence]
as
-- this procedure updates the sequence number

  DECLARE @int int
  SET @int = 0
  UPDATE dbo.PokerMaster
  SET SequenceNumber = @int,
	  @int = @int +1
FROM dbo.PokerMaster




GO
