USE [PS]
GO
/****** Object:  UserDefinedFunction [dbo].[UDate]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDate] (@CLM varchar(3))
RETURNS INT
AS
BEGIN
DECLARE @A NVARCHAR(300)
SET @A = '
UPDATE dbo.Tally
SET '+@CLM+'_Comit = b.Comit,
	'+@CLM+'_Rse = b.Rse,
	'+@CLM+'_AllIn = b.AllIN,
	'+@CLM+'_Fold = b.Fold,
	'+@CLM+'_Award = b.Award,
	'+@CLM+'_Uncalled = b.Uncalled
FROM dbo.Tally a INNER JOIN dbo.TallyTemp b on a.HandID = b.HandID and a.TourneyID = b.TourneyID and
a.Seat = b.Seat'

exec sp_executesql @A

RETURN @@rowcount

END
GO
