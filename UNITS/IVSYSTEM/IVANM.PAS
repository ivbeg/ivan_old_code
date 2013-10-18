
{$L IVSYSTEM.OBJ}
Procedure FillWord(Count:word;W:word;P:pointer);Far;External;
Procedure Swap(Size:word;P1,P2:pointer);Far;External;
Var Ivan,Ivan1:string[9];
Begin
 Ivan:='Ivan';
 Ivan1:='Ivan1';
 Swap(Sizeof(Ivan1),Addr(Ivan),Addr(Ivan1));
 Writeln(Ivan);
 Writeln(Ivan1);
{ FillWord(2048,$0700,Ptr($B800,0));}
end.