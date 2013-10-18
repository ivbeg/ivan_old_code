Uses IvHMA,IvString,IvDos;

Const
 csResult   = 'Result: ';
 csAllocate = 'Allocating...';
 csRelease  = 'Releasing...';
 csFreeHMA  = 'Free HMA: ';
Var
    P,P2:pointer;
Begin
 Writeln(HexPtr(FreeHMAAddr));
 Writeln(HMAMemAvail);
  InitIvHMA;
  Writeln(csFreeHMA,GetAllFreeHMA);
  P:=IvHMA.AllocateHMA(100);
  Writeln(csAllocate);
  Writeln(HexPtr(P));
  Writeln(IvHMA.PHMABlockID(P)^.Size);
  Writeln(csResult,IvHMA.HMAResult);
  P2:=IvHMA.AllocateHMA(49);
  Writeln(HexPtr(P2));
  Writeln(IvHMA.PHMABlockID(P2)^.Size);
  Writeln(csResult,IvHMA.HMAResult);
  Writeln(csFreeHMA,GetAllFreeHMA);
  IvHMA.ReleaseHMA(P);
  Writeln(csRelease);
  Writeln(IvHMA.HMAResult);
  P:=IvHMA.AllocateHMA(15);
  Writeln(HexPtr(P));
  Writeln(IvHMA.PHMABlockID(P)^.Size);
  Writeln(csResult,IvHMA.HMAResult);
  Writeln(csFreeHMA,GetAllFreeHMA);
  IvHMA.ReleaseHMA(P);
  Writeln(csRelease);
  Writeln(csResult,IvHMA.HMAResult);
  IvHMA.ReleaseHMA(P2);
  Writeln(csRelease);
  Writeln(csResult,IvHMA.HMAResult);
  DoneIvHMA;
end.