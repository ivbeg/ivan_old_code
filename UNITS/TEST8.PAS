Uses IvSystem,IvString,IvCrt,IvGraph;
Const
 C:array[0..1] of String[5] = ('Text','Graph');
Begin
  DosOutPut:=True;
  WriteStr('Current Mode: '+ HexB(BiosArea.CurrentMode)+'h');EndL;
  WriteStr('Mode Type   : '+ C[Byte(IsGraphMode)]);EndL;
  WriteStr('Max Columns : '+ Digit(BiosArea.MaxColumns));EndL;
  WriteStr('Max Strings : '+ Digit(BiosArea.MaxStrings+1));EndL;
  WriteStr('Letter High : '+ Digit(BiosArea.LetterHigh));EndL;
  WriteStr('Video Buffer: '+ Digit(BiosArea.VideoBuffSize));EndL;
  WriteStr('Video Page  : '+ Digit(BiosArea.CurrentPage));EndL;
  WriteStr('Page Offset : '+ Digit(BiosArea.PageAddr));EndL;
  WriteStr('Scan  Lines : '+ Digit(TotalScanLines));EndL;
end.
