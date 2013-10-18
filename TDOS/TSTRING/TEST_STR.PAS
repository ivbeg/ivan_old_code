PROGRAM  TEST_TSTRING;

Uses
  TStrings, TKeyb;

Var
  TestString: String;

function LowCaseString (_String: String) : String;
Var
   Counter: System.Byte;
   TempString: String;
Begin
  TempString:= '';
  Counter:= 0;
  TempString[Counter]:= _String[Counter];
  if System.Byte(_String[0]) <> 0 then
   for Counter:=1 to System.Byte(_String[0]) do
    TempString[Counter]:= Russian_LowCase(_String[Counter]);

  LowCaseString:= TempString;
End;



Begin
  Write ('Input string: ');
  Readln (TestString);
  Writeln ('LowCase string: ', LowCaseString (TestString));
  repeat until KeyPresent;
End.
