Uses Crt,IvSystem,IvKbd;
Var
 S:string[20];
Begin
 S:='Current Time: ';
 Writeln(S,BiosArea.Timer);
 Delay(200);
 Writeln(S,BiosArea.Timer);
 Write('Press any Key..');
 Repeat until KeyPresent;
 Writeln;
 Writeln(S,BiosArea.Timer);
 asm
  mov  ah,86h
  mov  cx,200
  int  15h
 end;
 Writeln(S,BiosArea.Timer);
 Writeln('Test End.');
end.