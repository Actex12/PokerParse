USE [PS]
GO
/****** Object:  StoredProcedure [dbo].[MakeMasterTable]    Script Date: 2/1/2023 12:14:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[MakeMasterTable]
as

CREATE TABLE dbo.PokerMaster (
HandID nvarchar(255),
TourneyID nvarchar(255),
Lvl nvarchar(255),
BuyIn nvarchar(255),
Dt nvarchar(255),
RawData nvarchar(255),
SequenceNumber Smallint,
Seat1 nvarchar(50),
Seat2 nvarchar(50),
Seat3 nvarchar(50),
Seat4 nvarchar(50),
Seat5 nvarchar(50),
Seat6 nvarchar(50),
Seat7 nvarchar(50),
Seat8 nvarchar(50),
Seat9 nvarchar(50),

Button char(1),

 HCS1C1R char(1),
HCS1C1S char(1),
HCS1C2R char(1),
HCS1C2S char(1),

HCS2C1R char(1),
HCS2C1S char(1),
HCS2C2R char(1),
HCS2C2S char(1),

HCS3C1R char(1),
HCS3C1S char(1),
HCS3C2R char(1),
HCS3C2S char(1),

HCS4C1R char(1),
HCS4C1S char(1),
HCS4C2R char(1),
HCS4C2S char(1),

HCS5C1R char(1),
HCS5C1S char(1),
HCS5C2R char(1),
HCS5C2S char(1),

HCS6C1R char(1),
HCS6C1S char(1),
HCS6C2R char(1),
HCS6C2S char(1),


HCS7C1R char(1),
HCS7C1S char(1),
HCS7C2R char(1),
HCS7C2S char(1),

HCS8C1R char(1),
HCS8C1S char(1),
HCS8C2R char(1),
HCS8C2S char(1),

HCS9C1R char(1),
HCS9C1S char(1),
HCS9C2R char(1),
HCS9C2S char(1),

FC1R char(1),
FC1S char(1),
FC2R char(1),
FC2S char(1),
FC3R char(1),
FC3S char(1),


TCR char(1),
TCS char(1),

RCR char(1),
RCS char(1),

SB DECIMAL(12,2),

BB decimal(12,2),
Ante decimal(12,2),

S1SS decimal(15,2),
S1ES decimal(15,2),
S2SS decimal(15,2),
S2ES decimal(15,2),
S3SS decimal(15,2),
S3ES decimal(15,2),
S4SS decimal(15,2),
S4ES decimal(15,2),
S5SS decimal(15,2),
S5ES decimal(15,2),
S6SS decimal(15,2),
S6ES decimal(15,2),
S7SS decimal(15,2),
S7ES decimal(15,2),
S8SS decimal(15,2),
S8ES decimal(15,2),
S9SS decimal(15,2),
S9ES decimal(15,2),


Rake decimal(4,2),
GTD decimal(4,2),
GameType char(10),
 Game varchar(120)
)






GO
