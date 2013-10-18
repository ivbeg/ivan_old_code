Uses IvXms,IvHeap;

Var Handle:THeapHandle;
Begin
 Writeln(LongInt(AvailEMSPages) SHL 14);
 GetMemory(Handle,32768,EMS);
 Writeln(LongInt(AvailEMSPages) SHL 14);
 FreeMemory(Handle);
 Writeln(LongInt(AvailEMSPages) SHL 14);
end.