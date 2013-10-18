Uses TGraph, IvKbd, TSystem;

var
   S:String;

Begin
  SetLogicPage(3);
 With BiosArea DO
  Begin
   FillBox(0,0,MaxColumns Div 2,MaxRows,Attrib(Blue,DarkGrey));
   FillBox(MaxColumns Div 2,0,MaxColumns,MaxRows,Attrib(Cyan,Magenta));
  end;
  S:= 'Test String';
  WriteStrXY(10, 12, Addr(S), Attrib(Blue, DarkGrey));
  S:= 'Second Test string';
  WriteStrXY(60, 12, Addr(S), Attrib(Blue, LightGrey));
  repeat until KeyPresent;
  SetVideoPage(3);
  repeat until KeyPresent;
  SetVideoPage(0);

  Writeln(VideoBiosType);
End.