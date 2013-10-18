Uses IvGraph,IvSystem,IvKbd;

Const
 S1 : String[60] = ('This Program is the demonstration of My Unit IVGRAPH.');
 S2 : String[60] = ('This Strings were writed by "WriteStrXY" procedure.');
 S3 : String[60] = ('This Strings were writed by "PlaneWriteXY" procedure.');
Begin
 UseBios:=false;
 ClrScr;
 FillBox(10,5,70,20,Attrib(Yellow,Magenta));
 CursorOff;
 WriteStrXY(10,10,Attrib(Cyan,DarkGrey),Addr(S1));
 WriteStrXY(10,11,Brown,Addr(S2));
 WriteCenter(12,Blue,'This String was writed by "WriteCenter" procedure');
 Repeat Until KeyPresent;
 PlaneWriteXY(10,13,Addr(S3));
 CursorOn;
end.