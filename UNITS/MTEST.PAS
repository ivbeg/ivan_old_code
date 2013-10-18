Uses IvMouse,IvSystem,IvString;

const
 YesNo   : Array[Boolean] of String[3] = ('NO','YES');

Function ByteToBCDStr(B:byte):Str5;
 Begin
  ByteToBCDStr:=Digit(B shr 4)+'.'+Digit(B and 4);
 end;

begin
 Writeln('Mouse Present: ',YesNo[MousePresent]);
 Writeln('Mouse Version: ',Hi(MouseVersion),ByteToBCDStr(Lo(MouseVersion)));
end.