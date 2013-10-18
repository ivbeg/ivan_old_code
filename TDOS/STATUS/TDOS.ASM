include ASMMACRO.INC



DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA

   EXTRN    DosResult                : TFunctionResult
   EXTRN    DosVersion               : WORD
   EXTRN    InDosFlagPtr             : DWORD
   EXTRN    SysVars                  : DWORD
   EXTRN    FileOpenMode             : BYTE
   EXTRN    PrefixSeg                : WORD
   EXTRN    DosFlags                 : BYTE


SysvarsShift                       EQU  18h



int21h_DiskReset                   EQU  0Dh
int21h_SelectDrive                 EQU  0Eh
int21h_GetDefaultDrive             EQU  19h
int21h_SetDiskTransferArea         EQU  1Ah
int21h_GetDriveInfo                EQU  1Ch
int21h_SetInterruptVector          EQU  25h
int21h_GetSystemDate               EQU  2Ah
int21h_SetSystemDate               EQU  2Bh
int21h_GetSystemTime               EQU  2Ch
int21h_SetSystemTime               EQU  2Dh
int21h_SetVerifyFlag               EQU  2Eh
int21h_GetDiskTransferArea         EQU  2Fh
int21h_GetDosVersion               EQU  30h
int21h_StayTSR                     EQU  31h
int21h_GetDriveDPT                 EQU  32h
int21h_GetExtBreakCheck            EQU  3300h
int21h_SetExtBreakCheck            EQU  3301h
int21h_GetBootDrive                EQU  3305h
int21h_GetTrueVersion              EQU  3306h
int21h_GetIndosFlagPtr             EQU  34h
int21h_GetInterruptVector          EQU  35h
int21h_GetFreeDiskSpace            EQU  36h
int21h_GetSwitchChar               EQU  3700h
int21h_SetSwitchChar               EQU  3701h
int21h_GetCountryInfo              EQU  38h

int21h_CreateDirectory             EQU  39h
int21h_RemoveDirectory             EQU  3Ah
int21h_ChangeDirectory             EQU  3Bh

int21h_CreateFile                  EQU  3Ch
int21h_OpenFile                    EQU  3Dh
int21h_CloseFile                   EQU  3Eh
int21h_ReadFile                    EQU  3Fh
int21h_WriteFile                   EQU  40h
int21h_DeleteFile                  EQU  41h
int21h_SeekFile                    EQU  42h
int21h_GetFileAttributes           EQU  4300h
int21h_SetFileAttributes           EQU  4301h
int21h_DuplicateHandle             EQU  45h
int21h_ForceDuplicateHandle        EQU  46h
int21h_GetCurrentDirectory         EQU  47h

int21h_AllocateMemory              EQU  48h
int21h_FreeMemory                  EQU  49h
int21h_ReallocateMemory            EQU  4Ah

int21h_ExecProgram                 EQU  4B00h
int21h_LoadProgram                 EQU  4B01h
int21h_ExecOverlay                 EQU  4B02h
int21h_SetExecutionState           EQU  4B05h
int21h_Exit                        EQU  4Ch
int21h_GetProgramExitCode          EQU  4Dh
int21h_FindFirstFile               EQU  4Eh
int21h_FindNextFile                EQU  4Fh
int21h_SetPSP_Address              EQU  50h
int21h_GetPSP_Address              EQU  51h
int21h_GetSysvarsPtr               EQU  52h
int21h_ConvertBPBtoDPB             EQU  53h
int21h_GetVerifyFlag               EQU  54h
int21h_CreateChild_PSP             EQU  55h
int21h_RenameFile                  EQU  56h
int21h_GetFileDate                 EQU  5700h
int21h_GetFileTime                 EQU  5700h
int21h_SetFileTimeDate             EQU  5700h
int21h_GetAllocationStrategy       EQU  5800h
int21h_SetAllocationStrategy       EQU  5801h
int21h_GetUMBLinkState             EQU  5802h
int21h_SetUMBLinkState             EQU  5803h
int21h_GetExtErrorInfo             EQU  59h
int21h_CreateTempFile              EQU  5Ah
int21h_CreateNewFile               EQU  5Bh
int21h_LockFile                    EQU  5C00h
int21h_UnlockFile                  EQU  5C01h
int21h_EnableDrive                 EQU  5F07h
int21h_DisableDrive                EQU  5F08h
int21h_GetTrueName                 EQU  60h
int21h_GetCurrentPSP               EQU  62h

int21h_GetExtCountryInfo           EQU  65h
int21h_CapitalizeChar              EQU  6520h
int21h_CapitalizeString            EQU  6521h
int21h_CapitalizePChar             EQU  6522h
int21h_GetGlobalCodePage           EQU  6601h
int21h_SetGlobalCodePage           EQU  6602h

int21h_SetHandlesCount             EQU  67h
int21h_FflushFile                  EQU  68h
int21h_CommitFile                  EQU  6Ah
int21h_ExtOpenCreate               EQU  6C00h

int21h_FindFirstROMProg            EQU  6Dh
int21h_FindNextROMProg             EQU  6Eh
int21h_GetROMScanStartAddr         EQU  6F00h
int21h_SetROMScanStartAddr         EQU  6F01h
int21h_GetExlRegionList            EQU  6F02h
int21h_SetExlRegionList            EQU  6F03h


int2Fh_AllocateHMA                 EQU  4A01h
int2Fh_GetFreeHMA                  EQU  4A02h


int_DosInterrupt                   EQU  21h

dos_error_InvalidParameter         EQU  0100h
dos_error_NoError                  EQU  0000h

psp_EnvPtr                         EQU  2Ch



DATA  ENDS



CODE  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE, DS:DATA

      PUBLIC  DiskReset, SelectDrive
      PUBLIC  GetDefaultDrive, SetDiskTransferArea
      PUBLIC  GetDriveInfo, SetInterruptVector

      PUBLIC  GetSystemDate, SetSystemDate
      PUBLIC  GetSystemTime, SetSystemTime

      PUBLIC  SetVerifyFlag, GetDiskTransferArea
      PUBLIC  GetDosVersion, StayTSR
      PUBLIC  GetDriveDPT, GetExtBreakCheck
      PUBLIC  SetExtBreakCheck, GetBootDrive

      PUBLIC  GetIndosFlagPtr, GetInterruptVector, GetFreeDiskSpace
      PUBLIC  GetSwitchChar, SetSwitchChar
      PUBLIC  CreateDirectory, ChangeDirectory, RemoveDirectory

      PUBLIC  CreateFile, OpenFile, CloseFile
      PUBLIC  ReadFile, WriteFile
      PUBLIC  DeleteFile ,SeekFile,
      PUBLIC  GetFileAttributes, SetFileAttributes
      PUBLIC  DuplicateHandle, ForceDuplicateHandle
      PUBLIC  GetCurrentDirectory

      PUBLIC  AllocateMemory, ReleaseMemory, ReallocateMemory

      PUBLIC  GetProgramExitCode
      PUBLIC  SetPSP_Address, GetPSP_Address
      PUBLIC  GetSysVarsPtr, ConvertBPBtoDPB
      PUBLIC  GetVerifyFlag, CreateChild_PSP
      PUBLIC  RenameFile, GetFileDate, GetFileTime
      PUBLIC  SetFileTimeDate

      PUBLIC  GetAllocationStrategy, SetAllocationStrategy
      PUBLIC  GetUMB_LinkState, SetUMB_LinkState

      PUBLIC  CreateNewFile, UnlockFile, LockFile
      PUBLIC  DisableDrive, EnableDrive
      PUBLIC  GetTrueName, GetCurrentPSP
      PUBLIC  CapitalizeChar,CapitalizeString, CapitalizePChar
      PUBLIC  SetHandlesCount, CommitFile, FflushFile

      PUBLIC  GetFreeHMA_Addr, HMA_MemAvail
      PUBLIC  AllocateHMA
      PUBLIC  GetEnvCount, EnvPChar

      .386


Dos_IO  PROC NEAR
   PUSH      GS
   macro_SetDATA_GS
   MOV       BYTE PTR GS:[DosResult].Interrupt, int_DosInterrupt
   MOV       DWORD PTR GS:[DosResult].CalledAddr, 00000h
   MOV       WORD PTR GS:[DosResult].Result, dos_error_NoError
   MOV       WORD PTR GS:[DosResult].Function, AX
   INT       21h
   POP       GS
   RET
Dos_IO  ENDP


Dos_3_IO  PROC NEAR
   PUSH      GS
   macro_SetDATA_GS
   MOV       BYTE PTR GS:[DosResult].Interrupt, int_DosInterrupt
   MOV       DWORD PTR GS:[DosResult].CalledAddr, 00000h
   MOV       WORD PTR GS:[DosResult].Result, dos_error_NoError
   MOV       WORD PTR GS:[DosResult].Function, AX
   INT       21h
   POP       GS
   macro_SetDATA_GS
   JNC       @@Dos_3_IO_NoErrors
   MOV       WORD PTR GS:[DosResult].Result, AX
   CALL      DWORD PTR GS:[DosResult].ErrorProc
@@Dos_3_IO_NoErrors:
   RET
Dos_3_IO  ENDP


Dos_1_IO  PROC NEAR
   PUSH      GS
   macro_SetDATA_GS
   MOV       BYTE PTR GS:[DosResult].Interrupt, int_DosInterrupt
   MOV       DWORD PTR GS:[DosResult].CalledAddr, 00000h
   MOV       WORD PTR GS:[DosResult].Result, dos_error_NoError
   MOV       WORD PTR GS:[DosResult].Function, AX
   INT       21h
   POP       GS
   macro_SetDATA_GS
   OR        AL, AL
   JZ        @@Dos_1_IO_NoErrors
   MOV       WORD PTR GS:[DosResult].Result, dos_error_InvalidParameter
   CALL      DWORD PTR GS:[DosResult].ErrorProc
@@Dos_1_IO_NoErrors:
   RET
Dos_1_IO  ENDP




DiskReset  PROC FAR
   MOV       AH, int21h_DiskReset
   CALL      Dos_IO
   RET
DiskReset  ENDP


SelectDrive  PROC FAR
  Drive        EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_SelectDrive
   MOV       DL, Drive
   CALL      Dos_IO
   RET       2
SelectDrive  ENDP


GetDefaultDrive  PROC FAR
   MOV       AH, int21h_GetDefaultDrive
   CALL      Dos_IO
   RET
GetDefaultDrive  ENDP


SetDiskTransferArea  PROC FAR
  NewDTA       EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, int21h_SetDiskTransferArea
   LDS       DX, NewDTA
   CALL      Dos_IO
   POP       DS
   RET       4
SetDiskTransferArea  ENDP


GetDriveInfo  PROC FAR
  Drive        EQU  (BYTE  PTR SS:[BX+8])
  Info         EQU  (DWORD PTR SS:[BX+8])
   macro_StackFrame BX
   MOV       AH, int21h_GetDriveInfo
   MOV       AL, Drive
   CALL      Dos_IO
   LES       DI, Info
   MOV       WORD PTR ES:[DI], DX
   MOV       WORD PTR ES:[DI+2], CX
   MOV       BYTE PTR ES:[DI+3], AL
   MOV       AL, BYTE PTR DS:[BX]
   MOV       BYTE PTR ES:[DI+4], AL
   RET       6
GetDriveInfo  ENDP


SetInterruptVector  PROC FAR
  _Interrupt   EQU  (BYTE  PTR SS:[BX+8])
  NewVector    EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, int21h_SetInterruptVector
   MOV       AL, _Interrupt
   LDS       DX, NewVector
   CALL      Dos_IO
   POP       DS
   RET       6
SetInterruptVector  ENDP


GetSystemDate  PROC FAR
  Date         EQU  (DWORD PTR SS:[BX+4])
   MOV       AH, int21h_GetSystemDate
   CALL      Dos_IO
   macro_StackFrame BX
   LES       DI, Date
   MOV       ES:[DI], CX
   MOV       ES:[DI+2], DX
   RET       4
GetSystemDate  ENDP


SetSystemDate  PROC FAR
  Date         EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   LES       DI, Date
   MOV       CX, ES:[DI]
   MOV       DX, ES:[DI+2]
   MOV       AH, int21h_SetSystemDate
   CALL      Dos_1_IO
   RET       4
SetSystemDate  ENDP


GetSystemTime  PROC FAR
  Time         EQU  (DWORD PTR SS:[BX+4])
   MOV       AH, int21h_GetSystemTime
   CALL      Dos_IO
   macro_StackFrame BX
   LES       DI, Time
   MOV       ES:[DI], CX
   MOV       ES:[DI+2], DX
   RET       4
GetSystemTime  ENDP


SetSystemTime  PROC FAR
  Time         EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   LES       DI, Time
   MOV       CX, ES:[DI]
   MOV       DX, ES:[DI+2]
   MOV       AH, int21h_SetSystemTime
   CALL      Dos_1_IO
   RET       4
SetSystemTime  ENDP


SetVerifyFlag  PROC FAR
  Flag         EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_SetVerifyFlag
   MOV       AL, Flag
   CALL      Dos_IO
   RET       2
SetVerifyFlag  ENDP


GetDiskTransferArea  PROC FAR
   MOV       AX, int21h_GetDiskTransferArea
   CALL      Dos_IO
   MOV       DX, ES
   MOV       AX, BX
   RET
GetDiskTransferArea  ENDP


GetDosVersion  PROC NEAR
   MOV       AH, int21h_GetDosVersion
   CALL      Dos_IO
   XCHG      AH, AL
   MOV       [DosVersion], AX
   RET
GetDosVersion  ENDP


StayTSR  PROC FAR
  DosExitCode  EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, PrefixSeg
   MOV       ES, AX
   MOV       DX, WORD PTR ES:[02h]
   SUB       DX, AX
   MOV       AH, int21h_StayTSR
   MOV       AL, DosExitCode
   CALL      Dos_IO
   RET       2
StayTSR  ENDP


GetDriveDPT  PROC FAR
  Drive        EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, int21h_GetDriveDPT
   MOV       DL, Drive
   CALL      Dos_1_IO
   MOV       DX, DS
   MOV       AX, BX
   POP       DS
   RET       2
GetDriveDPT  ENDP


GetExtBreakCheck  PROC FAR
   MOV       AX, int21h_GetExtBreakCheck
   CALL      Dos_IO
   RET
GetExtBreakCheck  ENDP


SetExtBreakCheck  PROC FAR
  Flag         EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int21h_SetExtBreakCheck
   MOV       DL, Flag
   CALL      Dos_IO
   RET       2
SetExtBreakCheck  ENDP


GetBootDrive  PROC FAR
   MOV       AX, int21h_GetBootDrive
   CALL      Dos_IO
   MOV       AL, DL
   RET
GetBootDrive  ENDP


GetIndosFlagPtr  PROC NEAR
   MOV       AH, int21h_GetIndosFlagPtr
   CALL      Dos_IO
   MOV       WORD PTR [IndosFlagPtr], BX
   MOV       BX, ES
   MOV       WORD PTR [IndosFlagPtr+2], BX
   RET
GetIndosFlagPtr  ENDP


GetInterruptVector  PROC FAR
_Interrupt     EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_GetInterruptVector
   MOV       AL, _Interrupt
   CALL      Dos_IO
   MOV       AX, BX
   MOV       DX, ES
   RET       2
GetInterruptVector ENDP


GetFreeDiskSpace  PROC FAR
  Drive        EQU  (BYTE  PTR SS:[DI+8])
  Info         EQU  (DWORD PTR SS:[DI+8])
   macro_StackFrame DI
   MOV       AH, int21h_GetFreeDiskSpace
   MOV       AL, Drive
   CALL      Dos_1_IO
   LES       DI, Info
   MOV       WORD PTR ES:[DI], DX
   MOV       WORD PTR ES:[DI+2], BX
   MOV       WORD PTR ES:[DI+4], AX
   MOV       WORD PTR ES:[DI+6], CX
   RET       6
GetFreeDiskSpace  ENDP


GetSwitchChar  PROC FAR
   MOV       AX,int21h_GetSwitchChar
   CALL      Dos_IO
   MOV       AL, DL
   RET
GetSwitchChar  ENDP


SetSwitchChar  PROC FAR
  Flag         EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int21h_SetSwitchChar
   MOV       DL, Flag
   CALL      Dos_IO
   RET       2
SetSwitchChar  ENDP


CreateDirectory  PROC FAR
  Directory    EQU  (DWORD PTR SS:[BX+4])
   MOV       AH, int21h_CreateDirectory
   JMP       SHORT @@Directory_SetFunction
RemoveDirectory  PROC FAR
   MOV       AH, int21h_RemoveDirectory
   JMP       SHORT @@Directory_SetFunction
ChangeDirectory  PROC FAR
   MOV       AH, int21h_ChangeDirectory
@@Directory_SetFunction:
   macro_StackFrame BX
   PUSH      DS
   LDS       DX, Directory
   CALL      Dos_3_IO
   POP       DS
   RET       4
ChangeDirectory  ENDP
RemoveDirectory  ENDP
CreateDirectory  ENDP


CreateFile  PROC FAR
  FileName     EQU  (DWORD PTR SS:[BX+10])
  Attribute    EQU  (WORD  PTR SS:[BX+8])
  Handle       EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_CreateFile
   PUSH      DS
   LDS       DX, FileName
   MOV       CX, Attribute
   CALL      Dos_3_IO
   LES       DI, Handle
   STOSW
   POP       DS
   RET       10
CreateFile  ENDP


OpenFile  PROC FAR
  FileName     EQU  (DWORD PTR SS:[BX+8])
  Handle       EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_OpenFile
   MOV       AL, FileOpenMode
   PUSH      DS
   LDS       DX, FileName
   CALL      Dos_3_IO
   LES       DI, Handle
   STOSW
   POP       DS
   RET       8
OpenFile  ENDP


CloseFile  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_CloseFile
   MOV       BX, Handle
   CALL      Dos_3_IO
   RET       2
CloseFile  ENDP


ReadFile  PROC FAR
  Handle       EQU (WORD  PTR SS:[SI+14])
  Buffer      EQU (DWORD PTR SS:[SI+10])
  Count        EQU (WORD  PTR SS:[SI+8])
  _Result      EQU (DWORD PTR SS:[SI+4])
  MOV        AH, int21h_ReadFile
  JMP        SHORT @@ReadWriteFile_Init
WriteFile  PROC FAR
  MOV        AH, int21h_WriteFile
@@ReadWriteFile_Init:
  macro_StackFrame SI
  PUSH       DS
  MOV        BX, Handle
  MOV        CX, Count
  LDS        DX, Buffer
  CALL       Dos_3_IO
  POP        DS
  macro_StackFrame SI
  LES        DI, _Result
  STOSW
  RET        12
WriteFile  ENDP
ReadFile  ENDP


DeleteFile  PROC FAR
  FileName     EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, int21h_DeleteFile
   LDS       DX, FileName
   CALL      Dos_3_IO
   POP       DS
   RET       4
DeleteFile  ENDP


SeekFile  PROC FAR
  Handle    EQU   (WORD  PTR SS:[BX+8])
  Position  EQU   (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       DX, WORD PTR [Position]
   MOV       CX, WORD PTR [Position+2]
   MOV       AH, int21h_SeekFile
   macro_Zero AL
   CALL      Dos_3_IO
   RET       6
SeekFile  ENDP


GetFileAttributes  PROC FAR
  FileName     EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, int21h_GetFileAttributes
   LDS       DX, FileName
   CALL      Dos_3_IO
   POP       DS
   RET       4
GetFileAttributes  ENDP


SetFileAttributes  PROC FAR
  FileName     EQU  (DWORD PTR SS:[BX+6])
  Attribute    EQU  (WORD  PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, int21h_SetFileAttributes
   LDS       DX, FileName
   MOV       CX, Attribute
   CALL      Dos_3_IO
   POP       DS
   RET       6
SetFileAttributes  ENDP


DuplicateHandle PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_DuplicateHandle
   MOV       BX, Handle
   CALL      Dos_3_IO
   RET       4
DuplicateHandle ENDP


ForceDuplicateHandle PROC FAR
  InHandle     EQU  (WORD PTR SS:[BX+6])
  OutHandle    EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_ForceDuplicateHandle
   MOV       CX, OutHandle
   MOV       BX, InHandle
   CALL      Dos_3_IO
   RET       4
ForceDuplicateHandle ENDP


GetCurrentDirectory  PROC FAR
  Drive        EQU  (BYTE  PTR SS:[BX+8])
  Buffer       EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, int21h_GetCurrentDirectory
   MOV       DL, Drive
   LDS       SI, Buffer
   CALL      Dos_3_IO
   POP       DS
   RET       6
GetCurrentDirectory  ENDP


AllocateMemory  PROC FAR
  BlockSize    EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_AllocateMemory
   MOV       BX, BlockSize
   CALL      Dos_3_IO
   RET       2
AllocateMemory  ENDP


ReleaseMemory  PROC FAR
  _Segment     EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_FreeMemory
   MOV       BX, _Segment
   MOV       ES, BX
   CALL      Dos_3_IO
   RET       2
ReleaseMemory  ENDP


ReallocateMemory  PROC FAR
  _Segment     EQU  (WORD PTR SS:[BX+6])
  BlockSize    EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, _Segment
   MOV       ES, AX
   MOV       BX, BlockSize
   MOV       AH, int21h_ReallocateMemory
   CALL      Dos_3_IO
   RET       4
ReallocateMemory  ENDP


GetProgramExitCode  PROC FAR
  MOV        AH, int21h_GetProgramExitCode
  CALL       Dos_3_IO
  RET
GetProgramExitCode  ENDP


FindFirstFile  PROC FAR

FindFirstFile  ENDP


FindNextFile  PROC FAR
FindNextFile  ENDP


SetPSP_Address  PROC FAR
  PSP_Segment   EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_SetPSP_Address
   MOV       BX, PSP_Segment
   CALL      Dos_3_IO
   RET       2
SetPSP_Address  ENDP


GetPSP_Address  PROC FAR
   MOV       AH, int21h_GetPSP_Address
   CALL      Dos_3_IO
   MOV       AX, BX
   RET
GetPSP_Address  ENDP


GetSysVarsPtr  PROC NEAR
   MOV       AH, int21h_GetSysvarsPtr
   CALL      Dos_IO
   SUB       BX, SysvarsShift
   MOV       WORD PTR [SysVars], BX
   MOV       BX, ES
   MOV       WORD PTR [SysVars+2], BX
   RET
GetSysVarsPtr  ENDP


ConvertBPBtoDPB  PROC FAR
BPB_table      EQU  (DWORD PTR SS:[BX+8])
DPB_table      EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, int21h_ConvertBPBtoDPB
   LDS       SI, BPB_table
   LES       DI, DPB_table
   CALL      Dos_IO
   POP       DS
   RET       8
ConvertBPBtoDPB  ENDP


GetVerifyFlag  PROC FAR
   MOV       AH, int21h_GetVerifyFlag
   CALL      Dos_IO
   RET
GetVerifyFlag  ENDP


CreateChild_PSP  PROC FAR
  PSP_Segment  EQU  (WORD PTR SS:[BX+6])
  PSP_Size     EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_CreateChild_PSP
   MOV       DX, PSP_Segment
   MOV       SI, PSP_Size
   CALL      Dos_IO
   RET       4
CreateChild_PSP  ENDP


RenameFile  PROC FAR
  InFileName   EQU  (DWORD PTR SS:[BX+8])
  OutFileName  EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_RenameFile
   PUSH      DS
   LDS       DX, InFileName
   LES       DI, OutFileName
   CALL      Dos_3_IO
   POP       DS
   RET       8
RenameFile  ENDP


GetFileDate  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int21h_GetFileDate
   MOV       BX, Handle
   CALL      Dos_3_IO
   MOV       AX, DX
   RET       2
GetFileDate  ENDP


GetFileTime  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int21h_GetFileTime
   MOV       BX, Handle
   CALL      Dos_3_IO
   MOV       AX, CX
   RET       2
GetFileTime  ENDP


SetFileTimeDate  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+8])
  Time         EQU  (WORD PTR SS:[BX+6])
  Date         EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int21h_SetFileTimeDate
   MOV       CX, Time
   MOV       DX, Date
   MOV       BX, Handle
   CALL      Dos_3_IO
   RET       6
SetFileTimeDate  ENDP


GetAllocationStrategy  PROC FAR
   MOV       AX, int21h_GetAllocationStrategy
   CALL      Dos_IO
   RET
GetAllocationStrategy  ENDP


SetAllocationStrategy  PROC FAR
  NewState     EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int21h_SetAllocationStrategy
   MOV       BL, NewState
   XOR       BH, BH
   CALL      Dos_3_IO
   RET       2
SetAllocationStrategy  ENDP


GetUMB_LinkState  PROC FAR
   MOV       AX, int21h_GetUMBLinkState
   CALL      Dos_IO
   RET
GetUMB_LinkState  ENDP


SetUMB_LinkState  PROC FAR
  NewState     EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int21h_SetUMBLinkState
   MOV       BL, NewState
   XOR       BH, BH
   CALL      Dos_3_IO
   RET
SetUMB_LinkState  ENDP


CreateNewFile  PROC FAR
  FileName     EQU  (DWORD PTR SS:[BX+10])
  Attribute    EQU  (WORD  PTR SS:[BX+8])
  Handle       EQU  (DWORD  PTR SS:[BX+4])
   MOV       AH, int21h_CreateNewFile
   JMP       SHORT  @@CreateNew_TempFile
CreateTempFile  PROC FAR
   MOV       AH, int21h_CreateTempFile
@@CreateNew_TempFile:
   macro_StackFrame BX
   PUSH      DS
   MOV       CX, Attribute
   LDS       DX, FileName
   CALL      Dos_3_IO
   LES       DI, Handle
   STOSW
   POP       DS
   RET       10
CreateTempFile  ENDP
CreateNewFile  ENDP


UnlockFile  PROC FAR
  Handle       EQU  (WORD  PTR SS:[BX+12])
  StartOffset  EQU  (DWORD PTR SS:[BX+8])
  LockSize     EQU  (DWORD PTR SS:[BX+4])
   MOV       AX, int21h_UnlockFile
   JMP       SHORT  @@FileLocking_Unlocking
LockFile  PROC FAR
   MOV       AX, int21h_LockFile
@@FileLocking_Unlocking:
   macro_StackFrame BX
   MOV       DX, WORD PTR [StartOffset]
   MOV       CX, WORD PTR [StartOffset+2]
   MOV       DI, WORD PTR [LockSize]
   MOV       SI, WORD PTR [LockSize+2]
   MOV       BX, Handle
   CALL      Dos_3_IO
   RET       10
LockFile     ENDP
UnlockFile     ENDP


DisableDrive  PROC FAR
  Drive        EQU  (BYTE PTR SS:[BX+4])
   MOV       AX, int21h_DisableDrive
   JMP       SHORT @@Enable_DisableDrive
EnableDrive  PROC FAR
   MOV       AX, int21h_EnableDrive
@@Enable_DisableDrive:
   MOV       DL, Drive
   CALL      Dos_3_IO
   RET       2
EnableDrive  ENDP
DisableDrive  ENDP


GetTrueName  PROC FAR
  FilePath     EQU  (DWORD PTR SS:[BX+8])
  Buffer       EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_GetTrueName
   LDS       SI, FilePath
   LES       DI, Buffer
   CALL      Dos_3_IO
   RET       8
GetTrueName  ENDP


GetCurrentPSP  PROC FAR
   MOV       AH, int21h_GetCurrentPSP
   CALL      Dos_IO
   MOV       AX, BX
   RET
GetCurrentPSP  ENDP


GetExtCountryInfo  PROC FAR
GetExtCountryInfo  ENDP


CapitalizeChar  PROC FAR
  OutChar      EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int21h_CapitalizeChar
   MOV       DL, OutChar
   CALL      Dos_3_IO
   MOV       AL, DL
   RET       2
CapitalizeChar  ENDP


CapitalizeString  PROC FAR
  String       EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   LDS       DX, String
   LODSB
   CBW
   MOV       CX, AX
   MOV       AX, int21h_CapitalizeString
   CALL      Dos_3_IO
   POP       DS
   RET       4
CapitalizeString  ENDP


CapitalizePChar  PROC FAR
  PChar        EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, int21h_CapitalizePChar
   LDS       DX, PChar
   CALL      Dos_3_IO
   POP       DS
   RET       4
CapitalizePChar  ENDP


SetGlobalCodePage  PROC FAR
SetGlobalCodePage  ENDP


GetGlobalCodePage  PROC FAR
GetGlobalCodePage  ENDP


SetHandlesCount  PROC FAR
  Count        EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int21h_SetHandlesCount
   MOV       BX, Count
   CALL      Dos_3_IO
   RET       2
SetHandlesCount  ENDP


CommitFile  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int21h_CommitFile
   JMP       SHORT  @@Commit_FflushFile
FflushFile  PROC FAR
   MOV       AH, int21h_FflushFile
@@Commit_FflushFile:
   CALL      Dos_3_IO
   RET       2
FflushFile  ENDP
CommitFile  ENDP


FindFirstROM_Program  PROC FAR
FindFirstROM_Program  ENDP


FindNextROM_Program  PROC FAR
FindNextROM_Program  ENDP


GetROM_ScanStartAddr  PROC FAR
GetROM_ScanStartAddr  ENDP


SetROM_ScanStartAddr  PROC FAR
SetROM_ScanStartAddr  ENDP


GetExlRegionList  PROC FAR
GetExlRegionList  ENDP


GetFreeHMA_Addr  PROC FAR
   MOV       AX, int2Fh_GetFreeHMA
   INT       2Fh
   MOV       AX, DI
   MOV       DX, ES
   RET
GetFreeHMA_Addr  ENDP


HMA_MemAvail  PROC FAR
   macro_StackFrame BX
   MOV       AX, int2Fh_GetFreeHMA
   INT       2Fh
   MOV       AX, BX
   RET
HMA_MemAvail  ENDP


AllocateHMA  PROC FAR
  BlockSize    EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int2Fh_AllocateHMA
   MOV       BX, BlockSize
   INT       2Fh
   MOV       AX, DI
   MOV       DX, ES
   RET       2
AllocateHMA  ENDP


CheckEnviroment  PROC NEAR
   PUSH      DS
   PUSH      AX
   PUSH      ES
   PUSH      DI
   PUSH      AX
   DEC       AX
   MOV       ES, AX
   MOV       DI, 1
   MOV       AX, WORD PTR ES:[DI]
   MOV       ES, AX
   MOV       DI, psp_EnvPtr
   MOV       AX, ES:[DI]
   POP       BX
   CLC
   XOR       AX, BX
   JZ        @@CheckEnviroment_Ok
   STC
@@CheckEnviroment_Ok:
   POP       DI
   POP       ES
   POP       AX
   POP       BX
   RET
CheckEnviroment  ENDP


GetEnvCount  PROC FAR
  _Segment     EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, _Segment
   CALL      CheckEnviroment
   MOV       ES, AX
   JC        @@GetEnvCount_Error
   macro_Zero AX
   macro_Zero DI
   MOV       CX, 8000h
   macro_Zero BX
@@GetEnvCount_Loop:
   SCASB
   JE        @@GetEnvCount_LoopEnd
   REPNE     SCASB
   JCXZ      @@GetEnvCount_LoopEnd
   INC       BX
   JNE       @@GetEnvCount_Loop
@@GetEnvCount_Error:
   macro_Zero AX
   JMP       SHORT @@GetEnvCount_End
@@GetEnvCount_LoopEnd:
   MOV       AX, BX
@@GetEnvCount_End:
   RET       2
GetEnvCount  ENDP


EnvPChar  PROC FAR
  _Segment     EQU  (WORD PTR SS:[BX+6])
  _Index       EQU  (WORD PTR SS:[BX+6])
   macro_StackFrame BX
   PUSH      DS
   PUSH      BX
   PUSH      WORD PTR [_Segment]
   CALL      GetEnvCount
   POP       BX
   CMP       AX, 0
   JE        @@EnvPChar_Error
   MOV       CX, _Index
   MOV       DX, _Segment
   MOV       DS, DX
   macro_Zero SI
   JCXZ      @@EnvPChar_Error
   CMP       CX, AX
   JG        @@EnvPChar_Error
   MOV       BX, CX
   MOV       CX, 08000h
@@EnvPChar_SetAddr:
   MOV       DX, SI
@@EnvPChar_Loop:
   LODSB
   CMP       AL, 00h
   JNE       @@EnvPchar_Loop
   DEC       BX
   JNE       @@EnvPchar_SetAddr
   MOV       AX, DX
   MOV       DX, DS
   JMP       SHORT @@EnvPChar_End
@@EnvPChar_Error:
   macro_Zero AX
   macro_Zero DX
@@EnvPChar_End:
   RET       4
EnvPChar  ENDP


CODE  ENDS


      END




