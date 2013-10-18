Uses IvXMS,IvString;

Const
csFunction    = 'Function: ';
csError       = 'Error   : ';
csAllocate    = 'Allocating ';
csXMS         = 'XMS';
csEMS         = 'EMS';
csRelease     = 'Releasing ';
csPoints      = '... ';
csPages       = ' Pages';
csKBytes      = ' KBytes';
csHandle      = 'Handle: ';
csSpace       = '  ';
cw128         = 5;
cw500         = 500;

Var
 Handle:THandle;



Procedure GetXMSError;Far;
 Begin
  Writeln;
  Writeln(csFunction,HexB(LastXMSFunction));
  Writeln(csError,HexB(XMSError));
  Halt(0);
 end;

Procedure GetEMSError;Far;
 Begin
  Writeln;
  Writeln('EMS Error Detected: ');
  Writeln(csFunction,HexB(LastEMSFunction));
  Writeln(csError,HexB(EMSError));
  Halt(0);
 end;

Begin
 ReleaseEMS(5);
 ReleaseEMS(6);
 EMSErrorProc:=GetEmsError;
 XMSErrorProc:=GetEmsError;
 Write(csAllocate,csEMS,csPoints,128,csPages,csSpace);
 Handle:=AllocateEMS(cw128);
 Writeln(csHandle,Handle);
 Write(csRelease,csEMS,csPoints,128,csPages,csSpace); Writeln(csHandle,Handle);
 ReleaseEMS(Handle);
 
 Write(csAllocate,csEMS,csPoints,500,csPages,csSpace);
 Handle:=AllocateEMS(cw500);
 Writeln(csHandle,Handle);
 Write(csRelease,csEMS,csPoints,500,csPages,csSpace); Writeln(csHandle,Handle);
 ReleaseEMS(Handle);
end.