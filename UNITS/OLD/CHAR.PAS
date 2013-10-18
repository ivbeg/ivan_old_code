{$X+}
Uses IvGraph,Crt,Strings;
var Strin:string[79];
    C:integer;
    X:integer;
Procedure DispStr(Stringa:string;Attr:byte);
 begin
  X:=100;
 for C:= 1 to Length(Strin) do
  begin
   bDispChar(Strin[C],Attr,1,0);
   GotoXY(WhereX+1,WhereY);
   Sound(X);
   Delay(40);
   NoSound;
   X:=X+100;
 end;
 end;
begin
 if ParamStr(1) = '' then
  begin
  Writeln('Usage Char  [string]');
   Halt;
  end;
 Strin:=ParamStr(1);
 DispStr(Strin,Gyan);
{ X:=100;
 for C:= 1 to Length(Strin) do
  begin
   bDispChar(Strin[C],0,1,0);
   GotoXY(WhereX+1,WhereY);
   Sound(X);
   Delay(40);
   NoSound;
   X:=X+10;}
end.