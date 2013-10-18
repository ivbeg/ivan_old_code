USES NewDos,IvString,ShowTERR, TDisk, TSystem;

{$I DosError.INC}
{$I DosFuncs.INC}
{$I DiskErro.INC}
{$I OsTypes.INC}

FUNCTION WordToBCDStr(W:word): TStr8;
BEGIN
  WordToBCDStr:=Digit(Hi(W))+'.'+Digit(Lo(W));
END;


CONST
  gcsError      = 'Error: ';


PROCEDURE CheckDosErrors;Far;
BEGIN
  Writeln('Dos ' + gcsError, HexW(DosResult.Result)+'h'+ ' (',DosErrors[DosResult.Result],')');
  Halt;
END;

PROCEDURE CheckDiskErrors;Far;
BEGIN
  Writeln('Disk ' + gcsError, HexW(DiskResult.Result)+'h'+ ' (',DiskErrorMessage(DiskResult.Result),')');
  Halt;
END;



VAR
   FileHandle : Word;
   Buffer     : TMbrRec;
   Result     : Word;


PROCEDURE WriteMBR;
VAR
   C: Byte;
BEGIN
 IF (Buffer.Signature <> ROM_Sign) THEN Writeln('This is not MBR.')
 ELSE BEGIN
        FOR C:=1 TO 4 DO Writeln(C,' - '+ Get_OSType(Buffer.Partitions[C].OSIndicator));
      END;
END;


BEGIN
  DiskResult.ErrorProc:=CheckDiskErrors;
  ReadFromDisk(1, 0, 1,0, Hard0, Buffer);
  WriteMBR;
  ReadFromDisk(1, 0, 1,0, Hard1, Buffer);
  WriteMBR;
END.