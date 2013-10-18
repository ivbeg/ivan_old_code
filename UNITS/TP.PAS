Uses IvGraph,IvSystem,IvKbd,IvString,IvCrt,IvMisc;
Var X,Y:word;
Begin
 GraphMode;
 Ellipse(159,99,60,30,Magenta);
 Repeat until Keypresent;
 FlushKbdBuff;
 Ellipse(159,99,60,30,Black);
 Repeat until Keypresent;
 FlushKbdBuff;
 X:=60;
 Y:=60 ;
 Repeat
 Ellipse(X,Y,60,30,Magenta);
 Ellipse(X,Y,60,30,Random(255));
 Inc(X);
 Inc(Y);
 if X = 319 then X:=60;
 if Y = 199 then Y:=60;
 until Keypresent;
 FlushKbdBuff;

 TextMode;
end.