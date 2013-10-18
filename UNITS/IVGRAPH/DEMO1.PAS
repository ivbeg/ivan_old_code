{$M 32768,10000,10000}
Uses IvGraph,IvSystem,IvKbd;

Procedure CenterPlainWrite(Y:byte;St:string);
 Begin
  With BiosArea DO
  PlaneWriteXY((MaxColumns - Byte(St[0])) div 2,Y,Addr(St));
 end;

Procedure FastWrite(St:string);
 Begin
  WriteStr(Addr(St),TextAttr);
 end;

Const
 StrSize = 52;

Type
 Str48 = String[StrSize];

Const
 S1 : Str48 = ('This Program is the demonstration of My Unit IVGRAPH.');
 S2 : Str48 = ('This Strings were writed by "WriteStrXY" procedure.');
 S3 : Str48 = ('This Strings were writed by "PlaneWriteXY" procedure.');
 S4 : Str48 = ('This Strings were writed by "WriteCenter" procedure.');
 S5 : Str48 = ('Virtual Page 2 now active.');
 S6 : Str48 = ('This text was created before Page activating.');

Var
 SaveAttr:byte;

Begin
 SaveAttr:=TextAttr;
 FastWrite('CreatingPages...');
 UseBios:=False;
 SetLogicPage(1);
  ClrScr;
 CursorOff;
 With BiosArea DO
  Begin
   FillBox(0,0,MaxColumns Div 2,MaxStrings,Attrib(Blue,DarkGrey));
   FillBox(MaxColumns Div 2,0,MaxColumns,MaxStrings,Attrib(Cyan,Magenta));
  end;
  CenterPlainWrite(0,S1);
  CenterPlainWrite(1,S3);
  WriteCenter(2,Attrib(White,Brown),S4);
  WriteStrXY(0,7,Attrib(Yellow,LightGrey),Addr(S2));
  SetLogicPage(2);
  ClrScr;
 With BiosArea DO
  Begin
   FillBox(0,0,MaxColumns,MaxStrings div 2,Attrib(Blue,DarkGrey));
   FillBox(0,MaxStrings div 2,MaxColumns,MaxStrings,Attrib(Cyan,Magenta));
  end;
  WriteCenter(4,Attrib(Green,LightBlue),S5);
  WriteCenter(5,Attrib(Cyan,Yellow),S6);
  repeat Until keypresent;
  SetVideoPage(1);
  repeat Until keypresent;
  TextColor(Green);
  TextBackGround(Blue);
  ClrScr;
  repeat Until keypresent;
  SetVideoPage(2);
  repeat Until keypresent;
  TextColor(Green);
  TextBackGround(DarkGrey);
  ClrScr;
  TextAttr:=SaveAttr;
  repeat Until keypresent;
  CursorOn;
  SetVideoPage(0);
  EndL;
end.