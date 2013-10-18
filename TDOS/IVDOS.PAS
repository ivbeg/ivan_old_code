Unit IvDos;

InterFace
Uses IvSystem,IvString;
Const
 StdAttr = 0;

Var       SysVars    : SysVarsRecP;
          ExecBlock  : ExecFileBlock absolute OvrCodeList;
          DosVer     : Word;
          DosResult  : Byte;
          OpenMode   : Byte;
          ReWriteF   : Boolean;

{** Standart Files Functions ** }
Procedure OpenFile(FileName:Pchar;Var Handle:word);
Procedure CreateFile(FileName:Pchar;Attr:word;Var Handle:word);
Procedure RenameFile(File1:Pchar;File2:Pchar);
{Procedure FindFirstFile(FileName:String;);
Procedure FindNextFile}
Procedure DeleteFIle(Name:Pchar);
Procedure SetFileAttr(Name:Pchar;Attr:word);
Function  GetFileAttr(Name:Pchar):word;
Procedure CloseFile(Handle:word);
Procedure FFlushFile(Handle:word);
Procedure SeekFile(Handle:word; SeekPos:Longint);
Procedure ReadFile(Handle:word;Var Buffer; Count:word; Var Result:word);
Procedure WriteFile(Handle:word;Var Buffer; Count:word; Var Result:word);
Procedure WriteStrInFile(Handle:word;S:string);
Procedure ReadFilePtr(Handle:word;Buffer:pointer; Count:word; Var Result:word);
Procedure WriteFilePtr(Handle:word;Buffer:pointer; Count:word; Var Result:word);
Procedure SetFileTimeDate(Handle,Time,Date:word);
Function  GetFileDate(Handle:word):word;
Function  GetFileTime(Handle:word):word;
Function  GetFileSize(Handle:word):LongInt;
Procedure SetFileSize(Handle:word;Size:longint);
Function  GetFilePos(Handle:word):LongInt;
Function  EOF(Handle:word):boolean;

{ ** Special Files Functions and Procedures ** }
Procedure SetHandlesCount(Num:word);
Procedure DupHandle(Handle:word; Var NewHandle:word);
Procedure ForceDupHandle(Handle1,Handle2:word);

{ ** Io Control Functions ** }
Function  GetHandleAttr(Handle:word):word;
Procedure SetHandleAttr(Handle:word;Attr:word);
Procedure IoReadBuff(Handle:word;Var Buff;Count:word; Var Result:word);
Procedure IoWriteBuff(Handle:word;Var Buff;Count:word; Var Result:word);
Procedure IoReadBuffPtr(Handle:word;Buff:pointer;Count:word; Var Result:word);
Procedure IoWriteBuffPtr(Handle:word;Buff:pointer;Count:word; Var Result:word);
Function  InPutStatus(Handle:word) :boolean;
Function  OutPutStatus(Handle:word):boolean;
Function  HandleRemote(Handle:word):boolean;


Procedure MakeDir(DirName:Pchar);
Procedure ChangeDir(DirName:Pchar);
Procedure RemDir(DirName:Pchar);
Function  CurrentDir(Drive:byte):Pchar;

Procedure DosBuffInput(Var Buffer:DosBufferInpRec);
Function  DosReadChar(Echo:boolean):Char;
Procedure DosWriteChar(Cha:char);
Procedure DosWriteStr(S:PString);
Procedure DosWritePrnChar(Cha:char);
Procedure DosWriteAuxChar(Cha:char);
Function  DosReadAuxChar:Char;

Procedure SetTime(Var Time:TimeRecord);
Procedure GetTime(Var Time:TimeRecord);
Procedure SetDate(Var Date:DateRecord);
Procedure GetDate(Var Date:DateRecord);

Procedure SetSwitchChar(Cha:char);
Function  GetSwitchChar:char;

Function  DiskFree(Drv:byte) :LongInt;
Function  DiskTotal(Drv:byte):LongInt;
Function  GetDriveDpt(Drive:byte):DptRecP;

Procedure DosReadSector(Drv:byte;Packet:ControlPacket);
Procedure DosWriteSector(Drv:byte;Packet:ControlPacket);
Function  DrvFixed(Drv:byte):boolean;
Function  GetCurrentDrive:byte;
Procedure SetCurrentDrive(B:byte);
Function  GetBootDrive:byte;
Procedure FlushDiskBuff;
Function  GetDtaAddr:pointer;
Procedure SetDtaAddr(Pt:pointer);
Function  GetBreakFlag:boolean;
Function  DosVarsTab:pointer;
Function  CheckKbd:boolean;
Procedure GetDosVersion;
Function  GetVerifyFlag:boolean;
Procedure SetVerifyFlag(B:boolean);
Procedure SetBreakFlag(B:boolean);
Procedure DisableDrive(Drive:byte);
Procedure EnableDrive(Drive:byte);

Procedure SetIntVector(I:byte; P:pointer);
Function  GetIntVector(I:byte):pointer;

{ ** Memory Control Functions ** }
Function  FreeHMAAddr:Pointer;
Function  HMAMemAvail:Word;
Function  AllocateHMA(Size:Word):pointer;

Function  AllocateMemory(Size:word):word;
Procedure FreeMemory(Se:word);
Procedure ReSizeMemory(Se:word; Size:word);
Function  DosMaxMem:Longint;
Procedure SetAllocStrat(Alloc:byte);
Function  GetAllocStrat:byte;
Procedure SetUmbLinkState(State:Boolean);
Function  GetUmbLinkState:boolean;

Procedure Keep(ExitCode:byte);
Function  GetExitCode:byte;

Procedure Exec(FileName:Pchar; CommLine:CommStr);
Procedure FullExec(FileName:Pchar; CommLine:CommStr);
Function  EnvString(Address:Pointer;Env:string):Pchar;

Function  HostEnvir:pointer;

Implementation

Var OldSS,OldSP:word;

{$L DOSINTER.OBJ}
Procedure DosError;near;External;

{$L PROCESS.OBJ}
Function  GetExitCode:byte;External;
Procedure Keep(ExitCode:byte);External;

{$L DOSMEM.OBJ}
Function  AllocateMemory(Size:word):word;External;
Procedure FreeMemory(Se:word);External;
Procedure ReSizeMemory(Se:word; Size:word);External;
Function  DosMaxMem:Longint;External;
Procedure SetAllocStrat(Alloc:byte);External;
Function  GetAllocStrat:byte;External;
Procedure SetUmbLinkState(State:boolean);External;
Function  GetUmbLinkState:boolean;External;

{$L DOSDISK.OBJ}
Function  DiskFree(Drv:byte) :LongInt;External;
Function  DiskTotal(Drv:byte):LongInt;External;
Procedure DosReadSector(Drv:byte;Packet:ControlPacket);External;
Procedure DosWriteSector(Drv:byte;Packet:ControlPacket);External;
Function  GetCurrentDrive:byte;External;
Procedure SetCurrentDrive(B:byte);External;
Function  GetBootDrive:byte;External;
Procedure FlushDiskBuff;External;
Procedure DisableDrive(Drive:byte);External;
Procedure EnableDrive(Drive:byte);External;

{$L DOSINOUT.OBJ}
Procedure DosBuffInput(Var Buffer:DosBufferInpRec);External;
Function  DosReadChar(Echo:boolean):Char;External;
Procedure DosWriteChar(Cha:char);External;
Procedure DosWriteStr(S:PString);External;
Procedure DosWritePrnChar(Cha:char);External;
Procedure DosWriteAuxChar(Cha:char);External;
Function  DosReadAuxChar:Char;External;

{$L DOSSOME.OBJ}
Procedure SetIntVector(I:byte; P:pointer);External;
Function  GetIntVector(I:byte):pointer;External;
Function  CheckKbd:boolean;External;
Procedure GetDosVersion;External;
Function  GetVerifyFlag:boolean;External;
Procedure SetVerifyFlag(B:boolean);External;
Procedure SetBreakFlag(B:boolean);External;
Function  GetDtaAddr:pointer;External;
Procedure SetDtaAddr(Pt:pointer);External;
Function  GetBreakFlag:boolean;External;
Procedure SetTime(Var Time:TimeRecord);External;
Procedure GetTime(Var Time:TimeRecord);External;
Procedure SetDate(Var Date:DateRecord);External;
Procedure GetDate(Var Date:DateRecord);External;
Procedure SetSwitchChar(Cha:char);External;
Function  GetSwitchChar:char;External;


Function  FreeHMAAddr:Pointer;assembler;
 asm
  MOV   AX,4A01h
  INT   2Fh
  MOV   AX,DI
  MOV   DX,ES
 end;


Function  HMAMemAvail:Word;assembler;
 asm
  MOV   AX,4A01h
  INT   2Fh
  MOV   AX,BX
 end;

Function  AllocateHMA(Size:Word):pointer;assembler;
 asm
  MOV   AX,4A02h
  MOV   BX,Size
  INT   2Fh
  MOV   AX,DI
  MOV   DX,ES
 end;

Function  GetDriveDpt(Drive:byte):DptRecP;
Var
 CurrDpt:DptRecP;
 C:byte;
 Begin
  Error:=13;
  if Drive >SysVars^.MaxDrives then Exit;
  Error:=0;
  CurrDpt:=SysVars^.FirstDpt;
  C:=0;
  GetDriveDpt:=CurrDpt;
  if Drive=0 then  Exit;
  repeat
  CurrDpt:=CurrDpt^.NextDpt;
  Inc(C);
  until C = Drive;
  GetDriveDpt:=CurrDpt;
 end;

Function  EnvString(Address:Pointer;Env:string):Pchar;
Var Found:boolean;
    P:pointer;
 Begin
  Env:=StrUpp(Env);
  P:=SearchString(Address,MemW[Seg(Address^)-1:3]*16,Env);
  if P <> nil then
   Begin
     if Char(Mem[Seg(P^):Ofs(P^)+byte(Env[0])]) = '=' then
     P:=AddPtr(P,byte(Env[0])+1) else P:=nil;
   end;
  EnvString:=P;
 end;

Procedure FullExec(FileName:Pchar; CommLine:CommStr);
Var
  OldHeapEnd,
  NewHeapEnd:word;
Begin
 NewHeapEnd:=Seg(HeapPtr^)-PrefixSeg;
 OldHeapEnd:=Seg(HeapEnd^)-PrefixSeg;
 ReSizeMemory(PrefixSeg,NewHeapEnd);
 Exec(FileName,CommLine);
 ReSizeMemory(PrefixSeg,OldHeapEnd);
end;

Procedure Exec(FileName:Pchar; CommLine:CommStr);
Var OldSS,OldSP:word;
    Error:byte absolute Err;
 Begin
  ExecBlock.CommTail:=@CommLine;
  asm
   mov  bx,Seg  ExecBlock
   mov  es,bx
   mov  bx,Offset  ExecBlock
   lds  dx,FileName
   cli
   mov  OldSS,ss
   mov  OldSP,sp
   sti
   mov  ax,4b00h
   int  21h
   mov  ax,Seg @Data
   mov  ds,ax
   cli
   mov  ss,OldSS
   mov  sp,OldSP
   sti
   jc   @1
   mov  Error,0
   JMP  @2
@1:
   mov  Error,al
@2:
  end;
 end;

Function DosVarsTab:pointer;
Var Se,Ofe:word;
 begin
  asm
   mov  ah,52h
   int  21h
   mov  Se,es
   mov  Ofe,bx
  end;
  DosVarsTab:=Ptr(Se,Ofe-8);
 end;

Procedure InstallIvDos;
 Begin
  SysVars:=DosVarsTab;
 end;

Function  DrvFixed(Drv:byte):boolean;assembler;
Var Error:byte Absolute Err;
 asm
  mov  ax,4409h
  mov  bl,Drv
  int  21h
  jc   @1
  mov  Error,0
  jmp  @2
@1:
  mov  Error,al
@2:
 end;

Function  HostEnvir:pointer;
Var CommEnvP:PspRecP;
 Begin
  CommEnvP:=Ptr(PspAddr^.PrgOwnerSeg,0);
  HostEnvir:=Ptr(CommEnvP^.PrgEnvSeg,0);
 end;

{$L DOSDIRS.OBJ}
Procedure MakeDir(DirName:Pchar);external;
Procedure ChangeDir(DirName:Pchar);external;
Procedure RemDir(DirName:Pchar);external;

Function  CurrentDir(Drive:byte):Pchar;
Var Drv:byte;
 Begin
 CurrentDir:=nil;
 if Drive > SysVars^.MaxDrives then
  Err.Error:=12                else
 Begin
  If Drive = 0 then
    Drv:=GetCurrentDrive
               else
    Drv:=Drive-1;
  CurrentDir:=Addr(SysVars^.CurrDirAddr^[Drv].Directory);
 end;
end;

{$L FILES.OBJ}

Procedure OpenFile(FileName:Pchar;Var Handle:word);External;
Procedure CreateFile(FileName:Pchar;Attr:word;Var Handle:word);External;
Procedure RenameFile(File1:Pchar;File2:Pchar);External;
{Procedure FindFile
Procedure FindNextFile}
Procedure DeleteFIle(Name:Pchar);External;
Procedure SetFileAttr(Name:Pchar;Attr:word);External;
Function  GetFileAttr(Name:Pchar):word;External;
Procedure CloseFile(Handle:word);External;
Procedure FFlushFile(Handle:word);External;
Procedure SeekFile(Handle:word; SeekPos:Longint);External;
Procedure ReadFile(Handle:word;Var Buffer; Count:word; Var Result:word);External;
Procedure WriteFile(Handle:word;Var Buffer; Count:word; Var Result:word);External;
Procedure ReadFilePtr(Handle:word;Buffer:pointer; Count:word; Var Result:word);External;
Procedure WriteFilePtr(Handle:word;Buffer:pointer; Count:word; Var Result:word);External;
Procedure SetFileTimeDate(Handle,Time,Date:word);External;
Function  GetFileDate(Handle:word):word;External;
Function  GetFileTime(Handle:word):word;External;

{ ** Special Files Functions and Procedures ** }
Procedure SetHandlesCount(Num:word);External;
Procedure DupHandle(Handle:word; Var NewHandle:word);External;
Procedure ForceDupHandle(Handle1,Handle2:word);External;

{ ** Io Control Functions ** }
Function  GetHandleAttr(Handle:word):word;External;
Procedure SetHandleAttr(Handle:word;Attr:word);External;
Procedure IoReadBuff(Handle:word;Var Buff;Count:word; Var Result:word);External;
Procedure IoWriteBuff(Handle:word;Var Buff;Count:word; Var Result:word);External;
Procedure IoReadBuffPtr(Handle:word;Buff:pointer;Count:word; Var Result:word);External;
Procedure IoWriteBuffPtr(Handle:word;Buff:pointer;Count:word; Var Result:word);External;
Function  InPutStatus(Handle:word) :boolean;External;
Function  OutPutStatus(Handle:word):boolean;External;
Function  HandleRemote(Handle:word):boolean;External;

Procedure SetFileSize(Handle:word;Size:longint);
 Var W:word;
  Begin
   W:=Handle;
   if W > SysVars^.FirstSft^.FilesNum+1 then
    SysVars^.FirstSft^.NextSft^.Files[W-1-SysVars^.FirstSft^.FilesNum].FileSize:=Size
                                            else
    SysVars^.FirstSft^.Files[W-1].FileSize:=Size;
  end;

Function  GetFileSize(Handle:word):Longint;
Var W:word;
 Begin
  W:=Handle;
  if W > SysVars^.FirstSft^.FilesNum+1 then
   GetFileSize:=SysVars^.FirstSft^.NextSft^.Files[W-1-SysVars^.FirstSft^.FilesNum].FileSize
                                            else
   GetFileSize:=SysVars^.FirstSft^.Files[W-1].FileSize;
 end;

Function  GetFilePos(Handle:word):LongInt;
Var W:word;
 Begin
  W:=Handle;
  if W > SysVars^.FirstSft^.FilesNum+1 then
   GetFilePos:=SysVars^.FirstSft^.NextSft^.Files[W-1-SysVars^.FirstSft^.FilesNum].FilePos
                                            else
   GetFilePos:=SysVars^.FirstSft^.Files[W-1].FilePos;
 end;

Procedure WriteStrInFile(Handle:word;S:string);
Var Nw:word;
 Begin
  WriteFilePtr(Handle,Addr(S[1]),Byte(S[0]),Nw);
 end;

Function  EOF(Handle:word):boolean;
 Begin
  EOF:=(GetFileSize(Handle) = GetFilePos(Handle));
 end;


Begin
 OpenMode:=2;
 ReWriteF:=True;
 GetDosVersion;
 InstallIvDos;
end.

