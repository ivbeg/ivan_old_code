{$O+}
Unit NewDos;
Interface

Uses TSystem;

VAR
   DosVersion      : Word;
   DosResult       : TFunctionResult;
   SysVars         : PSysVars;
   IndosFlagPtr    : PByte;
   FileOpenMode,
   DosFlags        : Byte;

function DosReadChar(Echo: Boolean): Char;
function DosReadAuxChar: Char;
procedure DosWriteChar(OutChar: Char);
procedure DosWriteAuxChar(OutChar: Char);
procedure DosWritePrnChar(OutChar: Char);
function GetStdInStatus: Boolean;
procedure DosBufferedInput(Var Buffer: TDosBuffInputRec);
procedure DosWriteString(S: PString);



procedure DiskReset;
procedure SelectDrive(Drive: Byte);
function GetDefaultDrive: Byte;
procedure SetDiskTransferArea(NewDta: Pointer);
function GetDiskTransferArea: Pointer;
procedure GetDefDriveInfo(Var Info: TDriveInfo);
procedure GetDriveInfo(Drive: Byte; Var Info: TDriveInfo);
function GetDefDriveDPT: PDptRec;
function GetDriveDPT(Drive: Byte): PDptRec;
function GetBootDrive: Byte;
procedure GetFreeDiskSpace(Drive: Byte; Var Info: TDriveFreeInfo);
procedure ConvertBPBtoDPB(BPB: PBpbRec; Var DPT: TDptRec);
procedure DisableDrive(Drive: Byte);
procedure EnableDrive(Drive: Byte);



procedure GetTrueName(FilePath: PChar; Var Buffer: TDosCanonPath);
procedure CapitalizeChar(OutChar: Char);
procedure CapitalizeString(S: PString);
procedure CapitalizePChar(P: PChar);



procedure SetInterruptVector(Interrupt: Byte; NewVector: Pointer);
function GetInterruptVector(Interrupt: Byte): Pointer;
procedure SetSystemDate(Var Date: TDosDate);
procedure GetSystemDate(Var Date: TDosDate);
procedure SetSystemTime(Var Time: TDosTime);
procedure GetSystemTime(Var Time: TDosTime);
procedure SetVerifyFlag(Flag: Boolean);
function GetVerifyFlag: Boolean;
procedure SetExtBreakCheck(Flag: Boolean);
function GetExtBreakCheck: Boolean;
function GetSwitchar: Char;
procedure SetSwitchar(NewSwitch: Char);



procedure StayTSR(DosExitCode: Byte);
function GetExitCode: Word;
procedure SetPSP_Address(PSPSeg: Word);
function GetPSP_Address: Word;
procedure CreateChild_PSP(PSP_Seg,PSP_Size: Word);
function GetCurrentPSP: Word;


procedure CreateDirectory(Directory: PChar);
procedure RemoveDirectory(Directory: PChar);
procedure ChangeDirectory(Directory: PChar);
procedure GetCurrentDirectory(Drive: Byte; Var Directory: TDosPath);



procedure CreateFile(FileName: PChar; Attribute: Word; Var Handle: Word);
procedure OpenFile(FileName: PChar; Var Handle: Word);
procedure CloseFile(Handle: Word);
procedure ReadFile(Handle: Word;Var Buffer; Count: Word;Var Result: Word);
procedure WriteFile(Handle: Word;Var Buffer; Count: Word;Var Result: Word);
procedure DeleteFile(FileName: PChar);
procedure SeekFile(Handle: Word; SeekPos: Longint);
procedure SetFileAttribute(FileName: PChar; Attribute: Word);
function GetFileAttribute(FileName: PChar): Word;
function DuplicateHandle(Handle: Word): Word;
procedure ForceDuplicateHandle(InHandle,OutHandle: Word);
procedure RenameFile(InFileName,OutFileName: PChar);
function GetFileTime(Handle: Word): Word;
function GetFileDate(Handle: Word): Word;
procedure SetFileTimeDate(Handle,Time,Date: Word);
procedure CreateNewFile(FileName: PChar; Attribute: Byte; Var Handle: Word);
procedure CreateTempFile(FileName: PChar; Attribute: Byte; Var Handle: Word);
procedure LockFile(Handle: Word; StartOffset: Longint; LockSize: Longint);
procedure UnLockFile(Handle: Word; StartOffset: Longint; LockSize: Longint);
procedure SetHandlesCount(C: Word);
procedure CommitFile(Handle: Word);
procedure FflushFile(Handle: Word);



function AllocateMemory(BlockSize: Word): Word;
procedure ReleaseMemory(Segm: Word);
procedure ReallocateMemory(Segm: Word; BlockSize: Word);
function GetAllocationStrategy: Byte;
procedure SetAllocationStrategy(NewState: Byte);
function GetUMB_LinkState: Byte;
procedure SetUMB_LinkState(NewState: Byte);
function GetFreeHMAddr: Pointer;
function HMAMemAvail: Word;
function AllocateHMA(BlockSize: Word): Pointer;

function GetEnvCount(Segm: Word): Word;
function EnvPChar(Segm: Word; Index: Word): PChar;

Implementation

{$L NewDos.OBJ}

function DosReadChar(Echo: Boolean): Char;External;
function DosReadAuxChar: Char;External;
procedure DosWriteChar(OutChar: Char);External;
procedure DosWriteAuxChar(OutChar: Char);External;
procedure DosWritePrnChar(OutChar: Char);External;
function GetStdInStatus: Boolean;External;
procedure DosBufferedInput(Var Buffer: TDosBuffInputRec);External;
procedure DosWriteString(S: PString);External;



procedure DiskReset;External;
procedure SelectDrive(Drive: Byte);External;
function GetDefaultDrive: Byte;External;
procedure SetDiskTransferArea(NewDta: Pointer);External;
function GetDiskTransferArea: Pointer;External;
procedure GetDefDriveInfo(Var Info: TDriveInfo);External;
procedure GetDriveInfo(Drive: Byte; Var Info: TDriveInfo);External;
function GetDefDriveDPT: PDptRec;External;
function GetDriveDPT(Drive: Byte): PDptRec;External;
function GetBootDrive: Byte;External;
procedure GetFreeDiskSpace(Drive: Byte; Var Info: TDriveFreeInfo);External;
procedure ConvertBPBtoDPB(BPB: PBpbRec; Var DPT: TDptRec);External;
procedure DisableDrive(Drive: Byte);External;
procedure EnableDrive(Drive: Byte);External;


procedure GetTrueName(FilePath: PChar; Var Buffer: TDosCanonPath);External;
procedure CapitalizeChar(OutChar: Char);External;
procedure CapitalizeString(S: PString);External;
procedure CapitalizePChar(P: PChar);External;



procedure SetInterruptVector(Interrupt: Byte; NewVector: Pointer);External;
function  GetInterruptVector(Interrupt: Byte): Pointer;External;
procedure SetSystemDate(Var Date: TDosDate);External;
procedure GetSystemDate(Var Date: TDosDate);External;
procedure SetSystemTime(Var Time: TDosTime);External;
procedure GetSystemTime(Var Time: TDosTime);External;
procedure SetVerifyFlag(Flag: Boolean);External;
function GetVerifyFlag: Boolean;External;
procedure SetExtBreakCheck(Flag: Boolean);External;
function GetExtBreakCheck: Boolean;External;
function GetSwitchar: Char;External;
procedure SetSwitchar(NewSwitch: Char);External;



procedure StayTSR(DosExitCode: Byte);External;
function GetExitCode: Word;External;
procedure SetPSP_Address(PSPSeg: Word);External;
function GetPSP_Address: Word;External;
procedure CreateChild_PSP(PSP_Seg,PSP_Size: Word);External;
function GetCurrentPSP: Word;External;


procedure CreateDirectory(Directory: PChar);External;
procedure RemoveDirectory(Directory: PChar);External;
procedure ChangeDirectory(Directory: PChar);External;
procedure GetCurrentDirectory(Drive: Byte; Var Directory: TDosPath);External;



procedure CreateFile(FileName: PChar; Attribute: Word; Var Handle: Word);External;
procedure OpenFile(FileName: PChar; Var Handle: Word);External;
procedure CloseFile(Handle: Word);External;
procedure ReadFile(Handle: Word;Var Buffer; Count: Word;Var Result: Word);External;
procedure WriteFile(Handle: Word;Var Buffer; Count: Word;Var Result: Word);External;
procedure DeleteFile(FileName: PChar);External;
procedure SeekFile(Handle: Word; SeekPos: Longint);External;
procedure SetFileAttribute(FileName: PChar; Attribute: Word);External;
function GetFileAttribute(FileName: PChar): Word;External;
function DuplicateHandle(Handle: Word): Word;External;
procedure ForceDuplicateHandle(InHandle,OutHandle: Word);External;
procedure RenameFile(InFileName,OutFileName: PChar);External;
function GetFileTime(Handle: Word): Word;External;
function GetFileDate(Handle: Word): Word;External;
procedure SetFileTimeDate(Handle,Time,Date: Word);External;
procedure CreateNewFile(FileName: PChar; Attribute: Byte; Var Handle: Word);External;
procedure CreateTempFile(FileName: PChar; Attribute: Byte; Var Handle: Word);External;
procedure LockFile(Handle: Word; StartOffset: Longint; LockSize: Longint);External;
procedure UnLockFile(Handle: Word; StartOffset: Longint; LockSize: Longint);External;
procedure SetHandlesCount(C: Word);External;
procedure CommitFile(Handle: Word);External;
procedure FflushFile(Handle: Word);External;



function AllocateMemory(BlockSize: Word): Word;External;
procedure ReleaseMemory(Segm: Word);External;
procedure ReallocateMemory(Segm: Word; BlockSize: Word);External;
function GetAllocationStrategy: Byte;External;
procedure SetAllocationStrategy(NewState: Byte);External;
function GetUMB_LinkState: Byte;External;
procedure SetUMB_LinkState(NewState: Byte);External;
function GetFreeHMAddr: Pointer;External;
function HMAMemAvail: Word;External;
function AllocateHMA(BlockSize: Word): Pointer;External;
function GetEnvCount(Segm: Word): Word;External;
function EnvPChar(Segm: Word; Index: Word): PChar;External;
procedure Init_DOS;External;


Begin
  Init_DOS;
  DosResult.ErrorProc:= DoNone;
End.