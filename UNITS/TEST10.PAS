Uses IvDisk,IvString;

Const
 DiskTypes : Array[0..3] of String[40] = ('Drive Not Present',
                                          'Change Line Not Support Floppy Drive',
                                          'Change Line Support Floppy Drive',
                                          'Hard Disk');

{$I DiskFunc.INC}


{$I DiskErro.INC}
Procedure DiskError;far;
 Begin
  Writeln('Function : ',HexB(LastDiskFunction)+'h'+' - '+DiskFunctions[LastDiskFunction]);
  Writeln('For Drive: ',HexB(LastAccesedDisk)+'h');
  Writeln('Error    : ',DiskErrorMessage(DiskStatus));
  Writeln('Halting...');
  Halt(0);
 end;

Begin
 DiskErrProc:=DiskError;
 Writeln(DiskTypes[GetDiskType(FloppyA)]);
 Writeln(DiskTypes[GetDiskType(FloppyB)]);
 Writeln(DiskTypes[GetDiskType(Hard0)]);
 Writeln(DiskTypes[GetDiskType(Hard1)]);
 Writeln(GetDiskChange(5));
end.