USE [PS]
GO
/****** Object:  UserDefinedFunction [dbo].[FindNum]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[FindNum] (@a varchar(200))
RETURNS INT
AS
BEGIN
DECLARE @b varchar(200)
SET @b = REVERSE(TRIM(@a))
DECLARE @c SMALLINT
SET @c = 1
WHILE NOT(SUBSTRING(@b,@c,1) BETWEEN '0' AND '9')
BEGIN
SET @c = @c + 1
IF @c > 50
BREAK
ELSE 
CONTINUE
END
RETURN @c
END
GO
