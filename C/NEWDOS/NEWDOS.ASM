include ASMMACRO.INC


 .MODEL LARGE

 .DATA

  PrefixSeg             DW 0000h
  FileOpenMode          DB 00h
  DosResult             TFunctionResult  <0, 0, 0, 0, 0>


   ; DOS Sysvars table address shift
SysvarsShift             EQU  24

   ; DOS File create flag
dfl_ReWrite              EQU  01h


   ; DOS File open modes
dfm_Read                 EQU  00h
dfm_Write                EQU  01h
dfm_ReadWrite            EQU  02h


    ; DOS errors
de_NoError               EQU  00h
de_InvalidParameter      EQU  0100h


    ; CON/PRN/AUX  Input/Output functions
dc_EchoReadChar          EQU  01h
dc_WriteChar             EQU  02h
dc_ReadAuxChar           EQU  03h
dc_WriteAuxChar          EQU  04h
dc_WritePrnChar          EQU  05h
dc_NoEchoReadChar        EQU  07h
dc_WriteString           EQU  09h
dc_BufferedInput         EQU  0Ah
dc_GetStdinStatus        EQU  0Bh

    ; Drives functions
dc_DiskReset             EQU  0Dh
dc_SelectDrive           EQU  0Eh
dc_GetDefaultDrive       EQU  19h
dc_SetDiskTransferArea   EQU  1Ah
dc_GetDefDriveInfo       EQU  1Bh
dc_GetDriveInfo          EQU  1Ch
dc_GetDefDriveDPT        EQU  1Fh

    ; Misc. functions
dc_SetInterruptVector    EQU  25h
dc_GetSystemDate         EQU  2Ah
dc_SetSystemDate         EQU  2Bh
dc_GetSystemTime         EQU  2Ch
dc_SetSystemTime         EQU  2Dh
dc_SetVerifyFlag         EQU  2Eh
dc_GetDiskTransferArea   EQU  2Fh
dc_GetDosVersion         EQU  30h
dc_StayTSR               EQU  31h
dc_GetDriveDPT           EQU  32h
dc_GetExtBreakCheck      EQU  3300h
dc_SetExtBreakCheck      EQU  3401h
dc_GetBootDrive          EQU  3505h
dc_GetTrueVersion        EQU  3606h
dc_GetInDosFlagPtr       EQU  34h
dc_GetInterruptVector    EQU  35h
dc_GetFreeDiskSpace      EQU  36h
dc_GetSwitchChar         EQU  3700h
dc_SetSwitchChar         EQU  3701h
dc_GetCountryInfo        EQU  38h

    ; Directories functions
dc_CreateDirectory       EQU  39h
dc_RemoveDirectory       EQU  3Ah
dc_ChangeDirectory       EQU  3Bh

    ; Files control functions
dc_CreateFile            EQU  3Ch
dc_OpenFile              EQU  3Dh
dc_CloseFile             EQU  3Eh
dc_ReadFile              EQU  3Fh
dc_WriteFile             EQU  40h
dc_DeleteFile            EQU  41h
dc_SeekFile              EQU  42h
dc_GetFileAttr           EQU  4300h
dc_SetFileAttr           EQU  4301h
dc_DuplicateHandle       EQU  45h
dc_ForceDuplicateHandle  EQU  46h

dc_GetCurrentDirectory   EQU  47h

    ; Memory functions
dc_AllocateMemory        EQU  48h
dc_FreeMemory            EQU  49h
dc_ReAllocateMemory      EQU  4Ah

dc_ExecProgram           EQU  4B00h
dc_ExecOverlay           EQU  4B02h
dc_LoadProgram           EQU  4B01h
dc_SetExecutionState     EQU  4B05h
dc_Exit                  EQU  4Ch
dc_GetExitCode           EQU  4Dh

dc_FindFirstFile         EQU  4Eh
dc_FindNextFile          EQU  4Fh
dc_SetPSPAddress         EQU  50h
dc_GetPSPAddress         EQU  51h
dc_GetSysvarsPtr         EQU  52h

dc_ConvertBPBtoDPB       EQU  53h
dc_GetVerifyFlag         EQU  54h
dc_CreateChildPSP        EQU  55h
dc_RenameFile            EQU  56h
dc_GetFileDate           EQU  5700h
dc_GetFileTime           EQU  5700h
dc_SetFileTimeDate       EQU  5701h

dc_GetAllocationStrat    EQU  5800h
dc_SetAllocationStrat    EQU  5801h
dc_GetLinkState          EQU  5802h
dc_SetLinkState          EQU  5803h
dc_GetExtErrorInfo       EQU  59h

dc_CreateTempFile        EQU  5Ah
dc_CreateNewFile         EQU  5Bh
dc_LockFile              EQU  5C00h
dc_UnlockFile            EQU  5C01h

dc_EnableDrive           EQU  5F07h
dc_DisableDrive          EQU  5F08h
dc_GetTrueName           EQU  60h
dc_GetCurrentPSP         EQU  61h

dc_GetExtCountryInfo     EQU  65h
dc_CapitalizeChar        EQU  6520h
dc_CapitalizeString      EQU  6521h
dc_CapitalizePChar       EQU  6522h

dc_GetGlobalCodePage     EQU  6601h
dc_SetGlobalCodePage     EQU  6602h

dc_SetHandlesCount       EQU  67h
dc_FflushFile            EQU  68h
dc_CommitFile            EQU  6Ah
dc_ExtOpenCreateFile     EQU  6C00h
dc_FindFirstROMProg      EQU  6Dh
dc_FindNextROMProg       EQU  6Eh
dc_GetROMScanStartAddr   EQU  6F00h
dc_SetROMScanStartAddr   EQU  6F01h
dc_GetExlRegionList      EQU  6F02h
dc_SetExlRegionList      EQU  6F03h

dc_multi_AllocateHMA     EQU  4A01h
dc_multi_GetFreeHMA      EQU  4A02h

int_DosInterrupt         EQU  21h

MaxLenOfEnv              EQU  8000h
pspEnvPtr                EQU  2Ch


 .CODE


   PUBLIC C  DosResult
   PUBLIC C  PrefixSeg
   PUBLIC C  FileOpenMode


   PUBLIC C  DosReadChar
   PUBLIC C  DosReadAuxChar
   PUBLIC C  DosWriteChar
   PUBLIC C  DosWriteAuxChar
   PUBLIC C  DosWritePrnChar
   PUBLIC C  GetStdinStatus
   PUBLIC C  DosBufferedInput
   PUBLIC C  DosWriteString

   PUBLIC C  DiskReset
   PUBLIC C  GetBootDrive
   PUBLIC C  SelectDrive
   PUBLIC C  GetDefaultDrive
   PUBLIC C  GetDefDriveInfo
   PUBLIC C  GetDriveInfo
   PUBLIC C  GetDefDriveDPT
   PUBLIC C  GetDriveDPT
   PUBLIC C  SetVerifyFlag
   PUBLIC C  GetVerifyFlag
   PUBLIC C  GetFreeDiskSpace
   PUBLIC C  ConvertBPBtoDPB
   PUBLIC C  EnableDrive
   PUBLIC C  DisableDrive

   PUBLIC C  SetInterruptVector
   PUBLIC C  GetInterruptVector
   PUBLIC C  GetSystemDate
   PUBLIC C  SetSystemDate
   PUBLIC C  GetSystemTime
   PUBLIC C  SetSystemTime
   PUBLIC C  GetDiskTransferArea
   PUBLIC C  SetDiskTransferArea
   PUBLIC C  GetDosVersion
   PUBLIC C  GetIndosFlagPtr
   PUBLIC C  GetExtBreakCheck
   PUBLIC C  SetExtBreakCheck
   PUBLIC C  GetSwitchChar
   PUBLIC C  SetSwitchChar
   PUBLIC C  GetSysvarsPtr

   PUBLIC C  StayTSR
   PUBLIC C  GetExitCode
   PUBLIC C  SetPSP_Address
   PUBLIC C  GetPSP_Address
   PUBLIC C  CreateChild_PSP
   PUBLIC C  GetCurrentPSP
   PUBLIC C  GetExtErrorInfo


   PUBLIC C  CreateDirectory
   PUBLIC C  RemoveDirectory
   PUBLIC C  ChangeDirectory
   PUBLIC C  GetCurrentDirectory

   PUBLIC C  CreateFile
   PUBLIC C  OpenFile
   PUBLIC C  CloseFile
   PUBLIC C  ReadFile
   PUBLIC C  WriteFile
   PUBLIC C  SeekFile
   PUBLIC C  GetFileAttribute
   PUBLIC C  SetFileAttribute
   PUBLIC C  DuplicateHandle
   PUBLIC C  ForceDuplicateHandle
   PUBLIC C  GetFileDate
   PUBLIC C  GetFileTime
   PUBLIC C  SetFileTimeDate
   PUBLIC C  CreateNewFile
   PUBLIC C  UnlockFile
   PUBLIC C  LockFile
   PUBLIC C  GetTrueName
   PUBLIC C  SetHandlesCount
   PUBLIC C  CommitFile
   PUBLIC C  FflushFile
   PUBLIC C  RenameFile
   PUBLIC C  DeleteFile

   PUBLIC C  AllocateMemory
   PUBLIC C  ReleaseMemory
   PUBLIC C  ReallocateMemory
   PUBLIC C  GetAllocationStrategy
   PUBLIC C  SetAllocationStrategy
   PUBLIC C  GetUMB_LinkState
   PUBLIC C  SetUMB_LinkState
   PUBLIC C  GetFreeHMA_Addr
   PUBLIC C  HMA_MemAvail
   PUBLIC C  AllocateHMA

   PUBLIC C  CapitalizeChar
   PUBLIC C  CapitalizeBuffer
   PUBLIC C  CapitalizePChar

   PUBLIC C  CheckEnvir
   PUBLIC C  GetEnvCount
   PUBLIC C  EnvPChar


           .386

    ; Standard DOS int calling service
    ; Error not indicated
Dos_IO  PROC NEAR
   PUSH      GS
   macro_SetDATA_GS
   MOV       BYTE PTR GS:[DosResult].Interrupt, int_DosInterrupt
   MOV       WORD PTR GS:[DosResult].Result, de_NoError
   MOV       WORD PTR GS:[DosResult].Function, AX
   INT       21h
   POP       GS
   RET
Dos_IO  ENDP


    ; Standard DOS 3.0+ int calling service
    ; if CF = 1 then (Error)
Dos_3_IO  PROC NEAR
   PUSH      GS
   macro_SetDATA_GS
   MOV       BYTE PTR GS:[DosResult].Interrupt, int_DosInterrupt
   MOV       WORD PTR GS:[DosResult].Result, de_NoError
   MOV       WORD PTR GS:[DosResult].Function, AX
   INT       21h
   POP       GS
   macro_SetDATA_GS
   JNC       @@Dos_3_NoErrors
   MOV       WORD PTR GS:[DosResult].Result, AX
   CALL      DWORD PTR GS:[DosResult].ErrorProc
@@Dos_3_NoErrors:
   RET
Dos_3_IO  ENDP


    ; Standard DOS 1.0 - 2.0 int calling service
    ; if AL = 0FFh then (Error)
Dos_1_IO PROC NEAR
   PUSH      GS
   macro_SetDATA_GS
   MOV       BYTE PTR GS:[DosResult].Interrupt, int_DosInterrupt
   MOV       WORD PTR GS:[DosResult].Result, de_NoError
   MOV       WORD PTR GS:[DosResult].Function, AX
   INT       21h
   POP       GS
   macro_SetDATA_GS
   OR        AL,AL
   JZ        @@Dos_1_NoError
   MOV       WORD PTR GS:[DosResult].Result, de_InvalidParameter
   CALL      DWORD PTR GS:[DosResult].ErrorProc
@@Dos_1_NoError:
   RET
Dos_1_IO ENDP

    ; StdIO functions


    ; Dos read character from Consol
DosReadChar  PROC FAR
  EchoChar     EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, dc_EchoReadChar
   CMP       EchoChar, boolean_False
   JNE       @@DosReadChar_Int21
   MOV       AH, dc_NoEchoReadChar
@@DosReadChar_Int21:
   CALL      Dos_IO
   RETF
DosReadChar  ENDP


    ; Read character from AUX
DosReadAuxChar  PROC FAR
   MOV       AH, dc_ReadAuxChar
   CALL      Dos_IO
   RET
DosReadAuxChar  ENDP


DosWriteChar  PROC FAR
  OutChar      EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, dc_WriteChar
   JMP       SHORT @@WriteChar_Int
DosWritePrnChar  PROC FAR
   MOV       AH, dc_WritePrnChar
   JMP       SHORT @@WriteChar_Int
DosWriteAuxChar  PROC FAR
   MOV       AH, dc_WriteAuxChar
@@WriteChar_Int:
   macro_StackFrame BX
   MOV       DL, OutChar
   CALL      Dos_IO
   RET
DosWriteAuxChar  ENDP
DosWritePrnChar  ENDP
DosWriteChar  ENDP


GetStdinStatus  PROC FAR
   MOV       AH, dc_GetStdinStatus
   CALL      Dos_IO
   AND       AL, 01h
   RET
GetStdinStatus  ENDP


DosBufferedInput  PROC FAR
  Buffer       EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   LDS       DX, Buffer
   MOV       AH, dc_BufferedInput
   CALL      Dos_IO
   POP       DS
   RET
DosBufferedInput  ENDP


DosWriteString  PROC FAR
  OutString    EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   LDS       DX, OutString
   INC       DX
   MOV       AH, dc_WriteString
   CALL      Dos_IO
   POP       DS
   RET
DosWriteString  ENDP


    ; Drives functions

DiskReset  PROC FAR
   MOV       AH, dc_DiskReset
   CALL      Dos_IO
   RET
DiskReset  ENDP


SelectDrive  PROC FAR
  Drive        EQU    (BYTE PTR SS:[BX+4])
   MOV       AH, dc_SelectDrive
   MOV       DL, Drive
   CALL      Dos_IO
   RET
SelectDrive  ENDP


GetDefaultDrive  PROC FAR
   MOV       AH, dc_GetDefaultDrive
   CALL      Dos_IO
   RET
GetDefaultDrive  ENDP


GetDefDriveInfo  PROC FAR
  Info         EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, dc_GetDefDriveInfo
   CALL      Dos_IO
   LES       DI, Info
   MOV       WORD PTR ES:[DI], DX
   MOV       WORD PTR ES:[DI+2], CX
   MOV       BYTE PTR ES:[DI+3], AL
   MOV       AL, BYTE PTR DS:[BX]
   MOV       BYTE PTR ES:[DI+4], AL
   POP       DS
   RET
GetDefDriveInfo  ENDP


GetDriveInfo  PROC FAR
  Drive        EQU    (BYTE  PTR SS:[BX+4])
  Info         EQU    (DWORD PTR SS:[BX+6])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, dc_GetDefDriveInfo
   MOV       AL, Drive
   CALL      Dos_IO
   LES       DI, Info
   MOV       WORD PTR ES:[DI], DX
   MOV       WORD PTR ES:[DI+2], CX
   MOV       BYTE PTR ES:[DI+3], AL
   MOV       AL, BYTE PTR DS:[BX]
   MOV       BYTE PTR ES:[DI+4], AL
   POP       DS
   RET
GetDriveInfo  ENDP


GetDefDriveDPT  PROC FAR
   PUSH      DS
   MOV       AH, dc_GetDefDriveDPT
   CALL      Dos_1_IO
   MOV       DX, DS
   MOV       AX, BX
   POP       DS
   RET
GetDefDriveDPT  ENDP


SetVerifyFlag  PROC FAR
 Flag          EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, dc_SetVerifyFlag
   MOV       AL, Flag
   CALL      Dos_IO
   RET
SetVerifyFlag  ENDP


GetDriveDPT  PROC FAR
 Drive         EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, dc_GetDriveDPT
   MOV       DL, Drive
   CALL      Dos_IO
   MOV       DX, DS
   MOV       AX, BX
   POP       DS
   RET
GetDriveDPT  ENDP


GetBootDrive  PROC FAR
   MOV       AX, dc_GetBootDrive
   CALL      Dos_IO
   MOV       AL, DL
   RET
GetBootDrive  ENDP


GetFreeDiskSpace  PROC FAR
 Drive         EQU    (BYTE  PTR SS:[BX+4])
 Info          EQU    (DWORD PTR SS:[BX+6])
   macro_StackFrame BX
   MOV       AH, dc_GetFreeDiskSpace
   MOV       AL, Drive
   CALL      Dos_IO
   LES       DI, Info
   MOV       WORD PTR ES:[DI], DX
   MOV       WORD PTR ES:[DI+2], BX
   MOV       WORD PTR ES:[DI+4], AX
   MOV       WORD PTR ES:[DI+6], CX
   RET
GetFreeDiskSpace  ENDP


ConvertBPBtoDPB  PROC FAR
 BPB           EQU    (DWORD PTR SS:[BX+4])
 DPB           EQU    (DWORD PTR SS:[BX+8])
   macro_StackFrame BX
   PUSH      DS
   LDS       SI, BPB
   LES       DI, DPB
   MOV       AH, dc_ConvertBPBtoDPB
   CALL      Dos_IO
   POP       DS
   RET
ConvertBPBtoDPB  ENDP


GetVerifyFlag  PROC FAR
   MOV       AH, dc_GetVerifyFlag
   CALL      Dos_IO
   RET
GetVerifyFlag  ENDP


DisableDrive  PROC FAR
 Drive         EQU    (BYTE PTR SS:[BX+4])
   MOV       AX, dc_DisableDrive
   JMP       SHORT @@Enable_DisableDrive
EnableDrive  PROC FAR
   MOV       AX, dc_EnableDrive
@@Enable_DisableDrive:
   macro_StackFrame BX
   MOV       DL, Drive
   CALL      Dos_3_IO
   RET
EnableDrive  ENDP
DisableDrive  ENDP



    ; Misc. functions


SetInterruptVector  PROC FAR
  _Interrupt   EQU    (BYTE  PTR SS:[BX+4])
  NewVector    EQU    (DWORD PTR SS:[BX+6])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, dc_SetInterruptVector
   MOV       AL, _Interrupt
   LDS       DX, NewVector
   CALL      Dos_IO
   POP       DS
   RET
SetInterruptVector  ENDP


GetSystemDate  PROC FAR
  Date        EQU    (DWORD PTR SS:[BX+4])
   MOV       AH, dc_GetSystemDate
   CALL      Dos_IO
   macro_StackFrame BX
   LES       DI, Date
   MOV       WORD PTR ES:[DI], CX
   MOV       WORD PTR ES:[DI+2], DX
   RET
GetSystemDate  ENDP


SetSystemDate  PROC FAR
  Date        EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   LES       DI, Date
   MOV       CX, WORD PTR ES:[DI]
   MOV       DX, WORD PTR ES:[DI+2]
   MOV       AH, dc_GetSystemDate
   CALL      Dos_1_IO
   RET
SetSystemDate  ENDP


GetSystemTime  PROC FAR
  Time        EQU    (DWORD PTR SS:[BX+4])
   MOV       AH, dc_GetSystemTime
   CALL      Dos_IO
   macro_StackFrame BX
   LES       DI, Time
   MOV       WORD PTR ES:[DI], CX
   MOV       WORD PTR ES:[DI+2], DX
   RET
GetSystemTime  ENDP


SetSystemTime  PROC FAR
  Time        EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   LES       DI, Time
   MOV       CX, WORD PTR ES:[DI]
   MOV       DX, WORD PTR ES:[DI+2]
   MOV       AH, dc_GetSystemTime
   CALL      Dos_IO
   RET
SetSystemTime  ENDP


SetDiskTransferArea  PROC FAR
  NewDta       EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, dc_SetDiskTransferArea
   LDS       DX, NewDTA
   CALL      Dos_IO
   POP       DS
   RET
SetDiskTransferArea  ENDP


GetDiskTransferArea  PROC FAR
   MOV       AH,dc_GetDiskTransferArea
   CALL      Dos_IO
   MOV       DX, ES
   MOV       AX, BX
   RET
GetDiskTransferArea  ENDP


GetDosVersion  PROC FAR
   MOV       AH, dc_GetDosVersion
   CALL      Dos_IO
   XCHG      AH, AL
   RET
GetDosVersion  ENDP


GetExtBreakCheck  PROC FAR
   MOV       AX, dc_GetExtBreakCheck
   CALL      Dos_IO
   MOV       AL, DL
   RET
GetExtBreakCheck  ENDP


SetExtBreakCheck  PROC FAR
 Flag          EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       DL, Flag
   MOV       AX, dc_GetExtBreakCheck
   CALL      Dos_IO
   RET
SetExtBreakCheck  ENDP


GetIndosFlagPtr  PROC FAR
   MOV       AH, dc_GetIndosFlagPtr
   CALL      Dos_IO
   MOV       AX, BX
   MOV       DX, ES
   RET
GetIndosFlagPtr  ENDP


GetInterruptVector  PROC FAR
 _Interrupt    EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, dc_GetInterruptVector
   MOV       AL, _Interrupt
   CALL      Dos_IO
   MOV       AX, BX
   MOV       DX, ES
   RET
GetInterruptVector  ENDP


GetSwitchChar  PROC FAR
   MOV       AX, dc_GetSwitchChar
   CALL      Dos_IO
   MOV       AL, DL
   RET
GetSwitchChar  ENDP


SetSwitchChar  PROC FAR
 Flag          EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, dc_SetSwitchChar
   MOV       DL, Flag
   CALL      Dos_IO
   RET
SetSwitchChar  ENDP


GetSysvarsPtr   PROC FAR
   MOV       AH, dc_GetSysvarsPtr
   CALL      Dos_IO
   SUB       BX, SysvarsShift
   MOV       AX, BX
   MOV       DX, ES
   RET
GetSysvarsPtr   ENDP



    ; Program process control


StayTSR  PROC FAR
 DosExitCode   EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, PrefixSeg
   MOV       ES, AX
   MOV       DX, WORD PTR ES:[02h]
   SUB       DX, AX
   MOV       AH, dc_StayTSR
   MOV       AL, DosExitCode
   CALL      Dos_IO
   RET
StayTSR  ENDP


GetExitCode  PROC FAR
   MOV       AH, dc_GetExitCode
   CALL      Dos_3_IO
   RET
GetExitCode  ENDP


SetPSP_Address  PROC FAR
 PSP_Seg       EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, dc_SetPSPAddress
   MOV       BX, PSP_Seg
   CALL      Dos_3_IO
   RET
SetPSP_Address  ENDP


GetPSP_Address  PROC FAR
   MOV       AH, dc_GetPSPAddress
   CALL      Dos_IO
   RET
GetPSP_Address  ENDP

CreateChild_PSP  PROC FAR
 PSP_Seg       EQU    (WORD PTR SS:[BX+4])
 PSP_Size      EQU    (WORD PTR SS:[BX+6])
   macro_StackFrame BX
   MOV       AH, dc_CreateChildPSP
   MOV       DX, PSP_Seg
   MOV       SI, PSP_Size
   CALL      Dos_IO
   RET
CreateChild_PSP  ENDP


GetCurrentPSP  PROC FAR
   MOV       AH,  dc_GetCurrentPSP
   CALL      Dos_IO
   MOV       PrefixSeg, BX

   RET
GetCurrentPSP  ENDP


GetExtErrorInfo  PROC FAR
   RET
GetExtErrorInfo  ENDP





    ; Directories functions


CreateDirectory  PROC FAR
 Directory     EQU    (DWORD PTR SS:[BX+4])
   MOV       AH, dc_CreateDirectory
   JMP       SHORT @@Directories_SetDir
RemoveDirectory  PROC FAR
   MOV       AH, dc_RemoveDirectory
   JMP       SHORT @@Directories_SetDir
ChangeDirectory  PROC FAR
   MOV       AH, dc_ChangeDirectory
@@Directories_SetDir:
   macro_StackFrame BX
   PUSH      DS
   LDS       DX, Directory
   CALL      Dos_3_IO
   POP       DS
   RET
ChangeDirectory  ENDP
RemoveDirectory  ENDP
CreateDirectory  ENDP


GetCurrentDirectory  PROC FAR
 Drive         EQU    (BYTE PTR SS:[BX+4])
 Buffer        EQU    (DWORD PTR SS:[BX+6])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, dc_GetCurrentDirectory
   MOV       DL, Drive
   LDS       SI, Buffer
   CALL      Dos_3_IO
   POP       DS
   RET
GetCurrentDirectory  ENDP



    ; File control


CreateFile  PROC FAR
 FileName      EQU    (DWORD PTR SS:[BX+4])
 Attribute     EQU    (WORD  PTR SS:[BX+8])
   macro_StackFrame BX
   PUSH      DS
   LDS       DX, FileName
   MOV       CX, Attribute
   MOV       AH, dc_CreateFile
   CALL      Dos_3_IO
   POP       DS
   RET
CreateFile  ENDP


OpenFile  PROC FAR
 FileName      EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, dc_OpenFile
   MOV       AL, FileOpenMode
   PUSH      DS
   LDS       DX, FileName
   CALL      Dos_3_IO
   POP       DS
   RET
OpenFile  ENDP


CloseFile  PROC FAR
 Handle        EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, dc_CloseFile
   MOV       BX, Handle
   CALL      Dos_3_IO
   RET
CloseFile  ENDP


ReadFile  PROC FAR
 Handle        EQU    (WORD  PTR SS:[BX+4])
 Buffer        EQU    (DWORD PTR SS:[BX+6])
 Count         EQU    (WORD  PTR SS:[BX+10])
   macro_StackFrame SI
   MOV       AH, dc_ReadFile
   JMP       SHORT  @@ReadWriteFile_Call
WriteFile  PROC FAR
   macro_StackFrame SI
   MOV       AH, dc_WriteFile
@@ReadWriteFile_Call:
   PUSH      DS
   MOV       BX, Handle
   MOV       CX, Count
   LDS       DX, Buffer
   CALL      Dos_3_IO
   POP       DS
   RET
WriteFile  ENDP
ReadFile  ENDP


DeleteFile  PROC FAR
 FileName      EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, dc_DeleteFile
   LDS       DX, FileName
   CALL      Dos_3_IO
   POP       DS
   RET
DeleteFile  ENDP


SeekFile  PROC FAR
 Handle        EQU    (WORD  PTR SS:[BX+4])
 SeekPos       EQU    (DWORD PTR SS:[BX+6])
   macro_StackFrame BX
   MOV       DX, WORD PTR SeekPos
   MOV       DX, WORD PTR SeekPos+2
   MOV       AH, dc_SeekFile
   macro_Zero AL
   CALL      Dos_3_IO
   RET
SeekFile  ENDP


GetFileAttribute  PROC FAR
 FileName      EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, dc_GetFileAttr
   LDS       DX, FileName
   CALL      Dos_3_IO
   POP       DS
   RET
GetFileAttribute  ENDP


SetFileAttribute  PROC FAR
 FileName      EQU    (DWORD PTR SS:[BX+4])
 Attribute     EQU    (WORD  PTR SS:[BX+8])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, dc_SetFileAttr
   LDS       DX, FileName
   MOV       CX, Attribute
   CALL      Dos_3_IO
   POP       DS
   RET
SetFileAttribute  ENDP


DuplicateHandle  PROC FAR
 Handle        EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       BX, Handle
   MOV       AH, dc_DuplicateHandle
   CALL      Dos_3_IO
   RET
DuplicateHandle  ENDP


ForceDuplicateHandle  PROC FAR
 InHandle      EQU    (WORD PTR SS:[BX+4])
 OutHandle     EQU    (WORD PTR SS:[BX+6])
   macro_StackFrame BX
   MOV       CX, OutHandle
   MOV       BX, InHandle
   MOV       AH, dc_ForceDuplicateHandle
   CALL      Dos_3_IO
   RET
ForceDuplicateHandle  ENDP


FindFirstFile  PROC FAR
   RET
FindFirstFile  ENDP


FindNextFile  PROC FAR
   RET
FindNextFile  ENDP


RenameFile  PROC FAR
 InFileName    EQU    (DWORD PTR SS:[BX+4])
 OutFileName   EQU    (DWORD PTR SS:[BX+8])
   macro_StackFrame BX
   PUSH      DS
   LDS       DX, InFileName
   LES       DI, OutFileName
   MOV       AH, dc_RenameFile
   CALL      Dos_3_IO
   POP       DS
   RET
RenameFile  ENDP


GetFileDate  PROC FAR
 Handle        EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, dc_GetFileDate
   MOV       BX, Handle
   CALL      Dos_3_IO
   MOV       AX, DX
   RET
GetFileDate  ENDP


GetFileTime  PROC FAR
 Handle        EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, dc_GetFileTime
   MOV       BX, Handle
   CALL      Dos_3_IO
   MOV       AX, CX
   RET
GetFileTime  ENDP


SetFileTimeDate  PROC FAR
 Handle        EQU    (WORD PTR SS:[BX+4])
 Time          EQU    (WORD PTR SS:[BX+6])
 Date          EQU    (WORD PTR SS:[BX+8])
   macro_StackFrame BX
   MOV       AX, dc_SetFileTimeDate
   MOV       CX, Time
   MOV       DX, Date
   MOV       BX, Handle
   CALL      Dos_3_IO
   RET
SetFileTimeDate  ENDP


CreateNewFile  PROC FAR
 FileName      EQU    (DWORD PTR SS:[BX+4])
 Attribute     EQU    (WORD  PTR SS:[BX+8])
   MOV       AH, dc_CreateNewFile
   JMP       SHORT  @@CreateNewTempFile_Call
CreateTempFile  PROC FAR
   MOV       AH, dc_CreateTempFile
@@CreateNewTempFile_Call:
   macro_StackFrame BX
   PUSH      DS
   MOV       CX, Attribute
   LDS       DX, FileNAme
   CALL      Dos_3_IO
   POP       DS
   RET
CreateTempFile  ENDP
CreateNewFile  ENDP


UnlockFile  PROC FAR
 Handle        EQU    (WORD  PTR SS:[BX+4])
 StartOffset   EQU    (DWORD PTR SS:[BX+6])
 LockSize      EQU    (DWORD PTR SS:[BX+10])
   MOV       AX, dc_UnlockFile
   JMP       SHORT  @@Lock_UnlockFile
LockFile  PROC FAR
   MOV       AX, dc_LockFile
@@Lock_UnlockFile:
   macro_StackFrame BX
   MOV       DX, WORD PTR StartOffset
   MOV       CX, WORD PTR StartOffset+2
   MOV       SI, WORD PTR LockSize
   MOV       DI, WORD PTR LockSize+2
   MOV       BX, Handle
   CALL      Dos_3_IO
   RET
LockFile  ENDP
UnlockFile  ENDP


GetTrueName  PROC FAR
 FilePath      EQU    (DWORD PTR SS:[BX+4])
 Buffer        EQU    (DWORD PTR SS:[BX+8])
   macro_StackFrame BX
   MOV       AH, dc_GetTrueName
   LDS       SI, FilePath
   LES       DI, Buffer
   CALL      Dos_3_IO
   RET
GetTrueName  ENDP


SetHandlesCount  PROC FAR
 Count         EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, dc_SetHandlesCount
   MOV       BX, Count
   CALL      Dos_3_IO
   RET
SetHandlesCount  ENDP


CommitFile  PROC FAR
 Handle        EQU    (WORD PTR SS:[BX+4])
   MOV       AH, dc_CommitFile
   JMP       SHORT  @@Commit_FflushFile
FflushFile  PROC FAR
   MOV       AH, dc_FflushFile
@@Commit_FflushFile:
   macro_StackFrame BX
   MOV       BX, Handle
   CALL      Dos_3_IO
   RET
FflushFile  ENDP
CommitFile  ENDP


ExtOpen_CreateFile  PROC
   RET
ExtOpen_CreateFile  ENDP



    ; Memory control functions


AllocateMemory  PROC FAR
 BlockSize     EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, dc_AllocateMemory
   MOV       BX, BlockSize
   CALL      Dos_3_IO
   RET
AllocateMemory  ENDP


ReleaseMemory  PROC FAR
 Segm          EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, Segm
   MOV       ES, BX
   MOV       AH, dc_FreeMemory
   CALL      Dos_3_IO
   RET       2
ReleaseMemory  ENDP


ReallocateMemory  PROC FAR
 Segm          EQU    (WORD PTR SS:[BX+4])
 BlockSize     EQU    (WORD PTR SS:[BX+6])
   macro_StackFrame BX
   MOV       AX, Segm
   MOV       ES, AX
   MOV       BX, BlockSize
   MOV       AH, dc_ReallocateMemory
   CALL      Dos_3_IO
   RET
ReallocateMemory  ENDP


GetAllocationStrategy  PROC FAR
   MOV       AX, dc_GetAllocationStrat
   CALL      Dos_IO
   RET
GetAllocationStrategy  ENDP


SetAllocationStrategy  PROC FAR
NewState       EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, dc_SetAllocationStrat
   MOV       BL, NewState
   macro_Zero BH
   CALL      Dos_3_IO
   RET
SetAllocationStrategy  ENDP


GetUMB_LinkState  PROC FAR
   MOV       AX, dc_GetLinkState
   CALL      Dos_IO
   RET
GetUMB_LinkState  ENDP


SetUMB_LinkState  PROC FAR
NewState       EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, dc_SetLinkState
   MOV       BL, NewState
   macro_Zero BH
   CALL      Dos_3_IO
   RET
SetUMB_LinkState  ENDP


GetFreeHMA_Addr  PROC FAR
   MOV       AX, dc_multi_GetFreeHMA
   INT       2Fh
   MOV       AX, DI
   MOV       DX, ES
   RET
GetFreeHMA_Addr  ENDP


HMA_MemAvail  PROC FAR
   MOV       AX, dc_multi_GetFreeHMA
   INT       2Fh
   MOV       AX, BX
   RET
HMA_MemAvail  ENDP


AllocateHMA  PROC FAR
 BlockSize     EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, dc_multi_AllocateHMA
   MOV       BX, BlockSize
   INT       2Fh
   MOV       AX, DI
   MOV       DX, ES
   RET
AllocateHMA  ENDP



    ; Country functions


GetExtCountryInfo  PROC FAR
GetExtCountryInfo  ENDP


CapitalizeChar  PROC FAR
 OutChar       EQU    (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, dc_CapitalizeChar
   MOV       DL, OutChar
   CALL      Dos_3_IO
   MOV       AL, DL
   RET
CapitalizeChar  ENDP


CapitalizeBuffer  PROC FAR
 Buffer        EQU    (DWORD PTR SS:[BX+4])
 Size          EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   LDS       DX, Buffer
   MOV       CX, Size
   MOV       AX, dc_CapitalizeString
   CALL      Dos_3_IO
   POP       DS
   RET
CapitalizeBuffer  ENDP


CapitalizePChar  PROC FAR
 PChar         EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   LDS       DX, PChar
   MOV       AX, dc_CapitalizePChar
   CALL      Dos_3_IO
   POP       DS
   RET
CapitalizePChar  ENDP


SetGlobalPage  PROC FAR
SetGlobalPage  ENDP


GetGlobalPage  PROC FAR
GetGlobalPage  ENDP


    ; ROM programs functions

FindFirstROMProg  PROC FAR
   RET
FindFirstROMProg  ENDP


FindNextROMProg  PROC FAR
   RET
FindNextROMProg  ENDP


GetROMScanStartAddr  PROC FAR
   RET
GetROMScanStartAddr  ENDP


SetROMScanStartAddr  PROC FAR
   RET
SetROMScanStartAddr  ENDP


GetExlRegionList  PROC FAR
   RET
GetExlRegionList  ENDP


CheckEnvir  PROC NEAR
   PUSH      BX
   PUSH      AX
   PUSH      ES
   PUSH      DI
   PUSH      AX
   DEC       AX
   MOV       ES, AX
   MOV       DI, 1
   MOV       AX, WORD PTR ES:[DI]
   MOV       ES, AX
   MOV       DI, pspEnvPtr
   MOV       AX, WORD PTR ES:[DI]
   POP       BX
   CLC
   XOR       AX, BX
   JZ        @@CheckEnvir_OkCheck
   STC
@@CheckEnvir_OkCheck:
   POP       DI
   POP       ES
   POP       AX
   POP       BX
   RET
CheckEnvir  ENDP


GetEnvCount  PROC FAR
 Segm          EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, Segm
   CALL      CheckEnvir
   MOV       ES, AX
   JC        @@GetEnvCount_Error
   macro_Zero AX
   macro_Zero DI
   MOV       CX, MaxLenOfEnv
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
   JMP       SHORT  @@GetEnvCount_End
@@GetEnvCount_LoopEnd:
   MOV       AX, BX
@@GetEnvCount_End:
   RET
GetEnvCount  ENDP


EnvPChar  PROC FAR
 Segm          EQU    (WORD PTR SS:[BX+4])
 Index         EQU    (WORD PTR SS:[BX+6])
   macro_StackFrame BX
   PUSH      DS
   PUSH      BX
   PUSH      WORD PTR Segm
   CALL      GetEnvCount
   POP       BX
   POP       BX
   CMP       AX, 0
   JE        @@EnvPChar_Error
   MOV       CX, Index
   MOV       DX, Segm
   MOV       DS, DX
   macro_Zero SI
   JCXZ      @@EnvPChar_Error
   CMP       CX, AX
   JG        @@EnvPChar_Error
   MOV       BX, CX
   MOV       CX, MaxLenOfEnv
@@EnvPChar_SetAddr:
   MOV       DX, SI
@@EnvPChar_Loop:
   LODSB
   CMP       AL, 0
   JNE       @@EnvPChar_Loop
   DEC       BX
   JNE       @@EnvPChar_SetAddr
   MOV       AX, DX
   MOV       DX, DS
   JMP       SHORT @@EnvPChar_End
@@EnvPChar_Error:
   macro_Zero AX
   macro_Zero DX
   JMP       SHORT  @@EnvPChar_End
@@EnvPChar_End:
   POP       DS
   RET
EnvPChar  ENDP


      END



