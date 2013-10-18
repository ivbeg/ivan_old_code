{$G+}
Unit IvDisk;

InterFace
Uses IvSystem;

Const
  DiskInt = $13;
  FloppyA = $00;
  FloppyB = $01;
  Hard0   = $80;
  Hard1   = $81;

Var   { **  Bios Floppy and Hard Disks Tables  ** }
    Hard0Bpt,
    Hard1Bpt    : BptRecP;
    FloppyTab   : PDiskParmsRec;

      { **  Disk Errors  ** }
    DiskStatus       : Byte;
    DiskErrProc      : Procedure;

    DiskIntPtr       : Pointer;
    LastDiskFunction,
    LastAccesedDisk  : Byte;

Procedure ResetHardDisk(Drive:byte);

Procedure ReInstallIvDisk;
Procedure ResetDisk(Drive:byte);
Function  GetDiskStatus(Drive:byte):byte;
{Procedure WriteSectors(Drive:byte;Cillinder:Word;Head,SSec,NSec:byte;Buffer:Pointer;Var Result:byte);
Procedure ReadSectors(Drive:byte;Cillinder:Word;Head,SSec,NSec:byte;Buffer:Pointer;Var Result:byte);
Procedure VerifySectors(Drive:byte;Cillinder:Word;Head,SSec,NSec:byte;Var Result:byte);}
Function  GetDiskType(Drive:byte):Byte;
Function  GetDiskChange(Drive:byte):Boolean;
Procedure SetFloppyFormatType(Drive,FormatType:byte);

Implementation

Procedure CallInt13;assembler;
 asm
  XOR  AX,AX
  MOV  ES,AX
  MOV  AL,DiskInt
  SHL  AX,1
  SHL  AX,1
  MOV  BX,AX
  MOV  AX,ES:[BX]
  MOV  WORD PTR [DiskIntPtr],AX
  MOV  AX,ES:[BX+2]
  MOV  WORD PTR [DiskIntPtr+2],AX
 end;

Procedure DiskIO;Assembler;
 asm
  MOV  LastDiskFunction,AH
  MOV  LastAccesedDisk,DL
  PUSHF
  CALL DiskIntPtr
  JNC  @@1
  MOV  DiskStatus,AH
  CALL DiskErrProc
  MOV  AX,0FFFFh
@@1:
 end;

Function  GetDiskType(Drive:byte):Byte;assembler;
 asm
  MOV  AH,15h
  MOV  DL,Drive
  CALL DiskIO
  MOV  AL,AH
 end;

Function GetDiskChange(Drive:Byte):Boolean;assembler;
 asm
  MOV  AH,16h
  MOV  DL,Drive
  MOV  LastDiskFunction,AH
  MOV  LastAccesedDisk,DL
  PUSHF
  CALL DiskIntPtr
  JNC  @1
  CMP  AH,6
  JE   @2
  MOV  DiskStatus,AH
  CALL DiskErrProc
  MOV  AX,$FFFF
  JMP  @3
@1:
  XOR  AL,AL
  JMP  @3
@2:
  MOV  AL,1
@3:
 end;

Procedure ResetHardDisk(Drive:byte);assembler;
 asm
  MOV  AH,10h
  MOV  DL,Drive
  CALL DiskIO
  MOV  DiskStatus,AH
 end;

Function  GetDiskStatus(Drive:byte):byte;assembler;
 asm
  MOV AH,01h
  MOV DL,Drive
  INT 13h
  MOV AL,AH
 end;

Procedure ResetDisk(Drive:byte);assembler;
  asm
   MOV  AH,00h
   MOV  DL,Drive
   CALL DiskIO
  end;


Procedure ReInstallIvDisk;
 Begin
  FloppyTab:=IntTable[$1E];
  Hard0Bpt :=IntTable[$41];
  Hard1Bpt :=IntTable[$46];
 end;

Procedure SetFloppyFormatType(Drive,FormatType:byte);assembler;
 asm
  MOV  AH,17h
  MOV  AL,FormatType
  MOV  DL,Drive
  CALL DiskIO
 end;


Begin
 CallInt13;
 DiskErrProc:=DoNone;
 ReInstallIvDisk;
end.
