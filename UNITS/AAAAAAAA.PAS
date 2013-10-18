Uses IvGraph,IvCrt,IvSystem,IvString,IvKbd,IvMisc;
 Var B:byte;
     C:word;
     X,Y,R:word;
Begin
 UseBios:=True;
 VideoMode($5F);
 R:=383;
 B:=2;
 X:=511;
 Y:=383;
 Circle(X,Y,R,B);
repeat until KeyPresent;
 Circle(X,Y,R,Black);
FlushKbdBuff;

repeat until KeyPresent;
FlushKbdBuff;
 TextMode;
end.