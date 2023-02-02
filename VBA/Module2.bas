
Sub Macro2()
Attribute Macro2.VB_Description = "3rd time is a charm"
Attribute Macro2.VB_ProcData.VB_Invoke_Func = " \n14"

'
' Macro2 Macro
' this macro loops through the file list and stacks all text files onto one sheet for export.
'
  Dim strng As String
   
  Dim cnt As Integer
  cnt = 0
  
  While cnt < 2
  
  
  strng = Sheets("Sheet4").Range("C2").Offset(cnt, 0).Value
  
   Sheets("FileImpt").Activate
   
'
    Application.CutCopyMode = False
    Application.CutCopyMode = False
    With ActiveSheet.QueryTables.Add(Connection:= _
        "TEXT;C:\Users\Andrew\OneDrive\Documents\Personal\Gaming\HH\Actex12\Actex12\" & strng, _
        Destination:=Range("$A$1000000").End(xlUp).Offset(3, 0))
'        .CommandType = 0
        .Name = "HH20181120 T2457182185 No Limit Hold'em 8,700 + 1,300.txt"
        .FieldNames = True
        .RowNumbers = False
        .FillAdjacentFormulas = False
        .PreserveFormatting = True
        .RefreshOnFileOpen = False
        .RefreshStyle = xlInsertDeleteCells
        .SavePassword = False
        .SaveData = True
        .AdjustColumnWidth = True
        .RefreshPeriod = 0
        .TextFilePromptOnRefresh = False
        .TextFilePlatform = 437
        .TextFileStartRow = 1
        .TextFileParseType = xlDelimited
        .TextFileTextQualifier = xlTextQualifierDoubleQuote
        .TextFileConsecutiveDelimiter = False
        .TextFileTabDelimiter = True
        .TextFileSemicolonDelimiter = False
        .TextFileCommaDelimiter = False
        .TextFileSpaceDelimiter = False
        .TextFileColumnDataTypes = Array(1, 1)
        .TextFileTrailingMinusNumbers = True
        .Refresh BackgroundQuery:=False
    End With
    
   ActiveSheet.Range(ActiveSheet.Range("a1000000").End(xlUp).Offset(0, 1), _
   ActiveSheet.Range("a1000000").End(xlUp).Offset(0, 1).End(xlUp).Offset(1, 0)) = strng
    
    
    
    
    cnt = cnt + 1
    Wend
    
    
    
End Sub
