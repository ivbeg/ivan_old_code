Unit Some;

interface

Uses Objects;

type
{$I Memlist.INC}

  PCommInfo = ^TCommInfo;
  TCommInfo = record
    Version   : Word;
    PSP_Seg   : Word;
    Shell_Num : Byte;
  end;

  PPrintSubmitPacket = ^TPrintSubmitPacket;
  TPrintSubmitPacket = record
    Level     : Byte;
    FileName  : PChar;
  end;

  TChar = ^PChar;

  PPrintQueue = ^TPrintQueue;
  TPrintQueue = record
    PrintQueue : array[0..99] of TChar;
  end;


  PDosPrint = ^TDosPrint;
  TDosPrint = object
    PrintPresent : Boolean;
    ErrorInfo    : Word;
    constructor Init;
    destructor Done; virtual;
    procedure Error(Code: word); virtual;
    function  SubmitFile(Name:PChar): Byte;
    procedure RemoveFilefromQueue(Name:PChar);
    procedure CancelAllFiles;
    procedure RestartPrintQueue;
    function  GetPrinterDevice:PDeviceHeader;
    function  FreezePrintQueue:PPrintQueue;
    function  GetPrintFilesCount(Queue: PPrintQueue): Byte;
  end;

  PCacheInfo = ^TCacheInfo;
  TCacheInfo = record
    Hits        : Longint;
    Misses      : Longint;
    DirtyCaches : Word;
  end;

  PCacheSizeInfo = ^TCacheSizeInfo;
  TCacheSizeInfo = record
    FullCacheElemSize : Word;
    CurrentSizeofElem : Word;
    OneElemSize       : Word;
    WindowsElements   : Word;
  end;


  PDBufferState = ^TDBufferState;
  TDBufferState = array[0..15] of byte;


  PElemsTable = ^TElemsTable;
  TElemsTable = record
    Offsetof             : Word;
    OffsetOfDirtyFlag    : Word;
    OffsOfLowHalvesArray : Word;
    OffsOfHighHalvesArray: Word;
    OffsetofCurrElemsNum : Word;
  end;


  PSmartdrv = ^TSmartdrv;
  TSmartdrv = object
    Present : Boolean;
    Version : Word;
    constructor Init;
    destructor Done;virtual;
    procedure Error(Code: word); virtual;
    procedure GetSmartdrvInfo(Info: PCacheInfo);
    procedure FlushBuffers;
    procedure ResetCache;
    function  GetStatus(Drive: Byte): Byte;
    procedure SetReadCache(Drive: Byte; R: Boolean);
    procedure SetWriteCache(Drive: Byte; W: Boolean);
    procedure GetCacheSize(Var CacheSize: TCacheSizeInfo);
    function  CheckDriveCacheable(Drive: Byte): Boolean;
    function  GetDeviceDriver(Drive: Byte): PDeviceHeader;
    function  GetDoubleBufferStatus(Drive: Byte): PDBufferState;
    function  GetElementStatusTable: PElemsTable;
    procedure SignalSeriousError;
  end;





function Get_NDOS_Version(Var CommInfo:TCommInfo): Boolean;
function Get_4DOS_Version(Var CommInfo:TCommInfo): Boolean;

function Get_DosNavigator_Present:Boolean;



implementation


const
  smrCheckInstall    = $0000;
  smrFlushBuffers    = $0001;
  smrResetCache      = $0002;
  smrGetStatus       = $0003;
  smrReadCache       = $0003;
  smrWriteCache      = $0003;
  smrGetCacheSize    = $0004;
  smrGetDBufferState = $0005;
  smrCheckDrive      = $0006;
  smrGetDevHeader    = $0007;
  smrGetElemsTable   = $000A;
  smrSignalError     = $1234;

constructor TSmartdrv.Init;assembler;
asm
  MOV   AX,4A10h
  MOV   BX,smrCheckInstall
  MOV   CX,0EBABh
  PUSH  BP
  INT   2Fh
  MOV   CX,BP
  POP   BP
  LES   DI,Self
  CMP   AX,0BABEh
  JE    @@001
  MOV  ES:[DI].TSmartdrv.Present,false
  MOV  ES:[DI].TSmartdrv.Version,0
  JMP  @@002
@@001:
  MOV  ES:[DI].TSmartdrv.Present,true
  MOV  ES:[DI].TSmartdrv.Version,CX
@@002:
end;


destructor TSmartdrv.Done;
begin
end;


procedure TSmartdrv.Error(Code: word);
begin
  RunError(211);
end;


procedure TSmartdrv.GetSmartdrvInfo(Info: PCacheInfo);assembler;
asm
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   AX,4A10h
  MOV   BX,smrCheckInstall
  MOV   CX,0EBABh
  PUSH  BP
  INT   2Fh
  POP   BP
  MOV   AX,DI
  LES   DI,[Info]
  MOV   WORD PTR ES:[DI],BX
  MOV   WORD PTR ES:[DI+2],DX
  MOV   WORD PTR ES:[DI+4],SI
  MOV   WORD PTR ES:[DI+6],AX
  MOV   WORD PTR ES:[DI+8],CX
  JMP   @@001
@@000:
  LES   DI,Info
  XOR   AX,AX
  MOV   CX,7
  REP   STOSW
@@001:
end;

procedure TSmartdrv.FlushBuffers;assembler;
asm
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   AX,4A10h
  MOV   BX,smrFlushBuffers
  INT   2Fh
@@000:
end;


procedure TSmartdrv.ResetCache;assembler;
asm
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   AX,4A10h
  MOV   BX,smrResetCache
  INT   2Fh
@@000:
end;


function  TSmartdrv.GetStatus(Drive: Byte) : Byte;assembler;
asm
  LES   DI,Self
  MOV   AL,0FFh
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   AX,4A10h
  MOV   BX,smrGetStatus
  INT   2Fh
  MOV   AL,DL
@@000:
end;




procedure TSmartdrv.SetReadCache(Drive: Byte; R: Boolean);assembler;
asm
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   DL,1
  CMP   R,false
  JE    @@001
  INC   DL
@@001:
  MOV   AL,Drive
  CBW
  MOV   BP,AX
  MOV   AX,4A10h
  MOV   BX,smrReadCache
  INT   2Fh
@@000:
end;


procedure TSmartdrv.SetWriteCache(Drive: Byte; W: Boolean);assembler;
asm
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   DL,1
  CMP   W,false
  JE    @@001
  INC   DL
@@001:
  MOV   AL,Drive
  CBW
  MOV   BP,AX
  MOV   AX,4A10h
  MOV   BX,smrWriteCache
  INT   2Fh
@@000:
end;

procedure TSmartdrv.GetCacheSize(Var CacheSize: TCacheSizeInfo);assembler;

asm
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@001
  MOV   AX,4A10h
  MOV   BX,smrGetCacheSize
  INT   2Fh
  LES   DI,CacheSize
  MOV   ES:[DI],AX
  MOV   ES:[DI+2],BX
  MOV   ES:[DI+4],CX
  MOV   ES:[DI+6],DX
  JMP   @@000
@@001:
  LES   DI,CacheSize
  XOR   AX,AX
  MOV   CX,4
  REP   STOSW
@@000:
end;


function  TSmartdrv.CheckDriveCacheable(Drive: Byte): Boolean;assembler;
asm
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   CL,Drive
  MOV   AX,4A10h
  MOV   BX,smrCheckDrive
  INT   2Fh
  SUB   AX,6
  JNZ   @@001
  JMP   @@000
@@001:
  MOV   AL,true
@@000:
end;



function  TSmartdrv.GetDeviceDriver(Drive: Byte): PDeviceHeader;assembler;
asm
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   AL,Drive
  CBW
  MOV   BP,AX
  MOV   AX,4A10h
  MOV   BX,smrGetDevHeader
  INT   2Fh
  MOV   DX,ES
  MOV   AX,DI
@@000:
end;


function  TSmartdrv.GetDoubleBufferStatus(Drive: Byte): PDBufferState; assembler;
asm
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   AL,Drive
  CBW
  MOV   BP,AX
  MOV   AX,4A10h
  MOV   BX,smrGetDBufferState
  INT   2Fh
  CMP   AX,0BABEh
  JE    @@001
  XOR   AX,AX
  XOR   DX,DX
  JMP   @@000
@@001:
  MOV   DX,ES
  MOV   AX,DI
@@000:
end;


function  TSmartdrv.GetElementStatusTable: PElemsTable;assembler;
asm
  XOR   AX,AX
  XOR   DX,DX
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   AX,4A10h
  MOV   BX,smrGetElemsTable
  INT   2Fh
  MOV   DX,ES
  MOV   AX,BX
@@000:
end;


procedure TSmartdrv.SignalSeriousError;assembler;
asm
  LES   DI,Self
  CMP   ES:[DI].TSmartdrv.Present,false
  JE    @@000
  MOV   AX,4A10h
  MOV   BX,smrSignalError
  INT   2Fh
@@000:
end;



const
  prnNoPrinter    = $FFFF;
  prnCheckInstall = $100;
  prnSubmitFile   = $101;
  prnRemoveFile   = $102;
  prnCancelAll    = $103;
  prnFreezeQueue  = $104;
  prnRestartQueue = $105;
  prnGetDevHeader = $106;


constructor TDosPrint.Init;assembler;
asm
  MOV  AX,prnCheckInstall
  INT  2Fh
  CMP  AL,0FFh
  JE   @@001
  MOV  AL,false
  JMP  @@002
@@001:
  MOV  AL,true
@@002:
  LES  DI,Self
  MOV  ES:[DI].TDosPrint.PrintPresent,AL
end;

destructor TDosPrint.Done;
begin
end;

function  TDosPrint.SubmitFile(Name:PChar): Byte;assembler;
Var
  SubmitPacket: TPrintSubmitPacket;
asm
  LES   DI,Self
  MOV   AX,prnNoPrinter
  CMP   ES:[DI].TDosPrint.PrintPresent,false
  JE    @@001
  MOV   AX,WORD PTR [Name]
  MOV   WORD PTR [SubmitPacket].FileName,AX
  MOV   AX,WORD PTR [Name+2]
  MOV   WORD PTR [SubmitPacket].[FileName+2],AX
  MOV   WORD PTR [SubmitPacket].Level,0
  PUSH  DS
  MOV   DX,SEG SubmitPacket
  MOV   DS,DX
  MOV   DX,OFFSET SubmitPacket
  MOV   AX,prnSubmitFile
  INT   2Fh
  POP   DS
  JNC   @@000
@@001:
  MOV   ES:[DI].TDosPrint.ErrorInfo,AX
  CALL  DWORD PTR ES:[DI+9]
@@000:
end;


procedure TDosPrint.RemoveFilefromQueue(Name:PChar);assembler;
asm
  LES   DI,Self
  MOV   AX,prnNoPrinter
  CMP   ES:[DI].TDosPrint.PrintPresent,false
  JE    @@001
  PUSH  DS
  LDS   DX,Name
  MOV   AX,prnRemoveFile
  INT   2Fh
  POP   DS
  JNC   @@000
@@001:
  MOV   ES:[DI].TDosPrint.ErrorInfo,AX
  CALL  DWORD PTR ES:[DI+9]
@@000:
end;


procedure TDosPrint.CancelAllFiles;assembler;
asm
  LES   DI,Self
  MOV   AX,prnNoPrinter
  CMP   ES:[DI].TDosPrint.PrintPresent,false
  JE    @@001
  MOV   AX,prnCancelAll
  INT   2Fh
  JNC   @@000
@@001:
  MOV   ES:[DI].TDosPrint.ErrorInfo,AX
  CALL  DWORD PTR ES:[DI+9]
@@000:
end;


procedure TDosPrint.RestartPrintQueue;assembler;
asm
  LES   DI,Self
  MOV   AX,prnNoPrinter
  CMP   ES:[DI].TDosPrint.PrintPresent,false
  JE    @@001
  MOV   AX,prnRestartQueue
  INT   2Fh
  JNC   @@000
@@001:
  MOV   ES:[DI].TDosPrint.ErrorInfo,AX
  CALL  DWORD PTR ES:[DI+9]
@@000:
end;


function  TDosPrint.GetPrinterDevice:PDeviceHeader;assembler;
asm
  LES   DI,Self
  MOV   AX,prnNoPrinter
  CMP   ES:[DI].TDosPrint.PrintPresent,false
  JE    @@001
  PUSH  DS
  MOV   AX,prnGetDevHeader
  INT   2Fh
  MOV   DX,DS
  POP   DS
  JNC   @@000
  MOV   AX,SI
  JMP   @@003
@@001:
  MOV   ES:[DI].TDosPrint.ErrorInfo,AX
  CALL  DWORD PTR ES:[DI+9]
@@000:
  XOR   AX,AX
  XOR   DX,DX
@@003:
end;


function  TDosPrint.FreezePrintQueue:PPrintQueue;assembler;
asm
  LES   DI,Self
  MOV   AX,prnNoPrinter
  CMP   ES:[DI].TDosPrint.PrintPresent,false
  JE    @@001
  MOV   AX,prnFreezeQueue
  PUSH  DS
  INT   2Fh
  MOV   DX,DS
  POP   DS
  JC    @@001
  MOV   AX,SI
  JMP   @@000
@@001:
  MOV   ES:[DI].TDosPrint.ErrorInfo,AX
  CALL  DWORD PTR ES:[DI+9]
@@000:
end;


function  TDosPrint.GetPrintFilesCount(Queue: PPrintQueue): Byte;
const
 csZero = '';
var
  Count : Byte;
begin
  Count:=0;
  repeat
   Inc(Count);
  until (Count = 99) or (PChar(Addr(Queue^.PrintQueue[Count]))[0] = #0);
end;

procedure TDosPrint.Error;
begin
  RunError(211);
end;


{$L Some.OBJ}

function Get_NDOS_Version(Var CommInfo:TCommInfo): Boolean;External;
function Get_4DOS_Version(Var CommInfo:TCommInfo): Boolean;External;

function Get_DosNavigator_Present:Boolean;External;


begin
end.
