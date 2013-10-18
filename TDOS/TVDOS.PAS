Unit TvDos;

Interface
{$I dostypes.INC}

type
{  FileControl = object
    Handle : Word;
    constructor Init();
    destructor Done;
  end;}

  TChar = ^PChar;

  PPrintSubmitPacket = ^TPrintSubmitPacket;
  TPrintSubmitPacket = record
    Level     : Byte;
    FileName  : PChar;
  end;

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
    function  GetPrinterDevice: PCharDeviceHeader;
    function  FreezePrintQueue: PPrintQueue;
    function  GetPrintFilesCount(Queue: PPrintQueue): Byte;
  end;



Implementation

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


function  TDosPrint.GetPrinterDevice: PCharDeviceHeader;assembler;
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


function  TDosPrint.FreezePrintQueue: PPrintQueue;assembler;
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
  RunError(Code);
end;



Begin


End.