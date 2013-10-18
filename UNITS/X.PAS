{$M 32768,90000,90000}
Uses IvWindow,IvCrt,IvKbd,IvString,IvMisc;
Var X:CharScan;


Begin
 TextChar:='°';
 OpenWindow(10,10,40,20,White,Magenta,Double,'First');
 ReadLimStr(9,TmpStr,' ',True);
 repeat
 Until KeyPresent;
 FlushKbdBuff;
 CloseWindow;
 OpenWindow(5,5,50,15,LightGrey,Blue,Double,'Second');
 ReadLimStr(9,TmpStr,' ',True);
 repeat
 Until KeyPresent;
 FlushKbdBuff;
 CloseWindow;
end.