Uses IvXms,IvHeap;

Var Handle:THeapHandle;
Begin
 Writeln(LongInt(GetFreeXMS) SHL 10);
 GetMemory(Handle,32768,XMS);
 Writeln(LongInt(GetFreeXMS) SHL 10);
 FreeMemory(Handle);
 Writeln(LongInt(GetFreeXMS) SHL 10);
end.