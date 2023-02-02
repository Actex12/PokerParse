USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[execTally]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[execTally]
as

EXEC dbo.MakeTallyTable

EXEC dbo.TempT
EXEC dbo.TallyPlayer_ToFlop 1



EXEC dbo.UDate 'PF'

EXEC dbo.TempT

EXEC dbo.TallyPlayer_ToFlop 2


EXEC dbo.UDate 'PT'

EXEC dbo.TempT
EXEC dbo.TallyPlayer_ToFlop 3


EXEC dbo.UDate 'PR'

EXEC dbo.TempT
EXEC dbo.TallyPlayer_ToFlop 4


EXEC dbo.UDate 'Por'
EXEC dbo.TempT
GO
