Program Test;

Uses IvXms,IvDos,IvString;

Const
  gcwSourceHandle = 0;
  P : PChar = 'XMS.DAT';
  BlockSize = 60000;

Var
  FileHandle: Word;
  Result    : Word;

Procedure XMS_ErrorControl;Far;
begin
 Writeln('Function: ',HexB(LastXMSFunction));
 Writeln('Error   : ',HexB(XMSError));
 Halt;
end;

begin
 XMSErrorProc:=XMS_ErrorControl;
 MoveEMBUsers(gcwSourceHandle,$E8990,0000,LongInt(Ptr($A000,$0000)),BlockSize);
 CreateFile(P,StdAttr,FileHandle);
 WriteFilePtr(FileHandle,Ptr($A000,$0000),BlockSize,Result);
 CloseFile(FileHandle);
end.