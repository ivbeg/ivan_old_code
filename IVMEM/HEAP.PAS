{$M 16384,0,0}
Uses IvHeap,IvDos;
Var Handle:THeapHandle;
Function MaxUMBMem:Word;
 Begin
  SetUmbLInkState(True);
  MaxUMBMem:=IvDos.DosMaxMem;
  SetUmbLInkState(False);
 end;

 Begin
  Writeln(DosMaxMem);
  IvHeap.GetMemory(Handle,40000,MCB);
  Writeln(DosMaxMem);
  IvHeap.FreeMemory(Handle);
  Writeln(DosMaxMem);
 end.