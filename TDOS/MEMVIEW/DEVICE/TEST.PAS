Uses TSystem;
Var
   Address: Pointer;
   L: Longint;
Begin
   Address:= Ptr($C000, 0000);
   L:=PRomInfoRec(Address)^.Size_512 * 512;
  Writeln(L);
End.