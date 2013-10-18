Uses IvWindow,IvCrt,IvString,IvKbd,IvSystem,IvDos;
Var   DumpPtr:pointer;
Procedure MessageWindow(S:string);
Var Slen:byte absolute S;
    WindSize:byte;
    YPos:byte;
Begin
 if Slen = 0 then Exit;
 WindSize:=WindMax.X - WindMin.X;
 YPos:=(WindMax.Y - WindMin.Y) div 2;
 if Slen > (WindSize - 2) then Slen:=WindSize - 2;
 CursorOff;
 OpenWindow(WindMin.X+(WindSize div 2)-(Slen Div 2),YPos,WindMax.X- (WindSize div 2)+(Slen div 2)-1,Ypos,
  White,Blue,Double,'Message...');
  WriteStr(S);

 repeat
  WriteStr(Digit(Random(1000)));
 until KeyPresent;
 FlushKbdBuff;
 CloseWindow;
end;

begin
 CursorOff;
 MessageWindow('This Message Window was Made by Ivan Begtin.');
 MessageWindow('Not best,BUT(!) Fun.');
 CursorOn;
end.
