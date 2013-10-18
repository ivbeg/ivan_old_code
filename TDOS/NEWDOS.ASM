INCLUDE MACRO.INC

FALSE EQU 00h


DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA


      EXTRN   DosResult       : TFunctionResult
      EXTRN   DosVersion      : WORD
      EXTRN   SysVars         : DWORD
      EXTRN   DosFlags        : BYTE
      EXTRN   InDosFlagPtr    : DWORD
      EXTRN   PrefixSeg       : WORD
      EXTRN   FileOpenMode    : BYTE


 ; dc  = ~D~os ~C~ommand (INT 21h)
 ; de  = ~D~os ~E~rror
 ; dfl = ~D~os ~Fl~ags
 ; dfm = ~D~os ~F~ile ~M~ode
 ; dcm = ~D~os ~C~ommand ~M~ultiplex (INT 2Fh)

SysvarsShift             EQU  24

dflReWrite               EQU  01h

dfmRead                  EQU  00h
dfmWrite                 EQU  01h
dfmReadWrite             EQU  02h

deNoError                EQU  0000h
deInvalidParameter       EQU  0100h


dcEchoReadChar           EQU  01h
dcWriteChar              EQU  02h
dcReadAuxChar            EQU  03h
dcWriteAuxChar           EQU  04h
dcWritePrnChar           EQU  05h
dcNoEchoReadChar         EQU  07h
dcWriteString            EQU  09h
dcBufferedInput          EQU  0Ah
dcGetStdInStatus         EQU  0Bh

dcDiskReset              EQU  0Dh
dcSelectDrive            EQU  0Eh
dcGetDefaultDrive        EQU  19h
dcSetDiskTransferArea    EQU  1Ah
dcGetDefDriveInfo        EQU  1Bh
dcGetDriveInfo           EQU  1Ch
dcGetDefDriveDPT         EQU  1Fh
dcSetInterruptVector     EQU  25h
dcGetSystemDate          EQU  2Ah
dcSetSystemDate          EQU  2Bh
dcGetSystemTime          EQU  2Ch
dcSetSystemTime          EQU  2Dh
dcSetVerifyFlag          EQU  2Eh
dcGetDiskTransferArea    EQU  2Fh
dcGetDosVersion          EQU  30h
dcStayTSR                EQU  31h
dcGetDriveDPT            EQU  32h
dcGetExtBreakCheck       EQU  3300h
dcSetExtBreakCheck       EQU  3301h
dcGetBootDrive           EQU  3305h
dcGetTrueVersion         EQU  3306h
dcGetInDOSFlagPtr        EQU  34h
dcGetInterruptVector     EQU  35h
dcGetFreeDiskSpace       EQU  36h
dcGetSwitChar            EQU  3700h
dcSetSwitChar            EQU  3701h
dcGetCountryInfo         EQU  38h

dcCreateDirectory        EQU  39h
dcRemoveDirectory        EQU  3Ah
dcChangeDirectory        EQU  3Bh

dcCreateFile             EQU  3Ch
dcOpenFile               EQU  3Dh
dcCloseFile              EQU  3Eh
dcReadFile               EQU  3Fh
dcWriteFile              EQU  40h
dcDeleteFile             EQU  41h
dcSeekFile               EQU  42h
dcGetFileAttr            EQU  4300h
dcSetFileAttr            EQU  4301h
dcDupHandle              EQU  45h
dcForceDupHandle         EQU  46h
dcGetCurrentDirectory    EQU  47h

dcAllocateMemory         EQU  48h
dcFreeMemory             EQU  49h
dcReAllocateMemory       EQU  4Ah

dcExecProgram            EQU  4B00h
dcExecOverlay            EQU  4B02h
dcLoadProgram            EQU  4B01h
dcSetExecutionState      EQU  4B05h
dcExit                   EQU  4Ch
dcGetExitCode            EQU  4Dh
dcFindFirstFile          EQU  4Eh
dcFindNextFile           EQU  4Fh
dcSetPSPAddress          EQU  50h
dcGetPSPAddress          EQU  51h
dcGetSysvarsPtr          EQU  52h
dcConvertBPBtoDPB        EQU  53h
dcGetVerifyFlag          EQU  54h
dcCreateChildPSP         EQU  55h
dcRenameFile             EQU  56h
dcGetFileDate            EQU  5700h
dcGetFileTime            EQU  5700h
dcSetFileTimeDate        EQU  5700h
dcGetAllocationStrat     EQU  5800h
dcSetAllocationStrat     EQU  5801h
dcGetLinkState           EQU  5802h
dcSetLinkState           EQU  5803h
dcGetExtErrorInfo        EQU  59h
dcCreateTempFile         EQU  5Ah
dcCreateNewFile          EQU  5Bh
dcLockFile               EQU  5C00h
dcUnLockFile             EQU  5C01h
dcEnableDrive            EQU  5F07h
dcDisableDrive           EQU  5F08h
dcGetTrueName            EQU  60h
dcGetCurrentPSP          EQU  62h

dcGetExtCountryInfo      EQU  65h
dcCapitalizeChar         EQU  6520h
dcCapitalizeString       EQU  6521h
dcCapitalizePChar        EQU  6522h

dcGetGlobalCodePage      EQU  6601h
dcSetGlobalCodePage      EQU  6602h

dcSetHandlesCount        EQU  67h
dcFflushFile             EQU  68h
dcCommitFile             EQU  6Ah
dcExtOpenCreate          EQU  6C00h
dcFindFirstROMProg       EQU  6Dh
dcFindNextROMProg        EQU  6Eh
dcGetROMScanStartAddr    EQU  6F00h
dcSetROMScanStartAddr    EQU  6F01h
dcGetExlRegionList       EQU  6F02h
dcSetExlRegionList       EQU  6F03h

dcmAllocateHMA           EQU  4A01h
dcmGetFreeHMA            EQU  4A02h

intDosInterrupt          EQU  21h

MaxLenOfEnv              EQU  8000h
pspEnvPtr                EQU  2Ch



DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA


                     ;DOS 1+ Standard I/O Functions

             PUBLIC  DosReadChar,DosReadAuxChar
             PUBLIC  DosWriteChar,DosWritePrnChar,DosWriteAuxChar
             PUBLIC  GetStdInStatus,DosBufferedInput,DosWriteString

                     ;DOS 1+ Drives Control Functions

             PUBLIC  DiskReset,GetBootDrive
             PUBLIC  SelectDrive,GetDefaultDrive
             PUBLIC  SetDiskTransferArea,GetDiskTransferArea
             PUBLIC  GetDefDriveInfo,GetDriveInfo
             PUBLIC  GetDefDriveDPT,GetDriveDPT
             PUBLIC  GetFreeDiskSpace,ConvertBPBtoDPB
             PUBLIC  DisableDrive,EnableDrive

                     ;DOS 1+ Misc. Functions

             PUBLIC  SetInterruptVector,GetInterruptVector
             PUBLIC  GetSystemDate,SetSystemDate
             PUBLIC  GetSystemTime,SetSystemTime
             PUBLIC  SetVerifyFlag,GetVerifyFlag
             PUBLIC  SetExtBreakCheck,GetExtBreakCheck
             PUBLIC  GetSwitchar,SetSwitchar

                     ;DOS 1+ Process Control Functions

             PUBLIC  StayTSR,GetExitCode
             PUBLIC  SetPSP_Address,GetPSP_Address
             PUBLIC  CreateChild_PSP,GetCurrentPSP

                     ;DOS 3+ Directories Functions

             PUBLIC  CreateDirectory,RemoveDirectory
             PUBLIC  ChangeDirectory,GetCurrentDirectory

                     ;DOS 3+ Files Functions

             PUBLIC  CreateFile,OpenFile,CloseFile
             PUBLIC  ReadFile,WriteFile
             PUBLIC  DeleteFile,SeekFile
             PUBLIC  SetFileAttribute,GetFileAttribute
             PUBLIC  DuplicateHandle,ForceDuplicateHandle
             PUBLIC  FindFirstFile,FindNextFile          ; Not Added!!
             PUBLIC  RenameFile,SetFileTimeDate
             PUBLIC  GetFileTime,GetFileDate
             PUBLIC  CreateNewFile,CreateTempFile
             PUBLIC  LockFile,UnlockFile
             PUBLIC  SetHandlesCount,
             PUBLIC  CommitFile,FflushFile

                     ;DOS 1+ (5+) MCB/UMB/HMA Memory Control

             PUBLIC  AllocateMemory,ReleaseMemory
             PUBLIC  ReallocateMemory
             PUBLIC  SetAllocationStrategy,GetAllocationStrategy
             PUBLIC  SetUMB_LinkState,GetUMB_LinkState
             PUBLIC  AllocateHMA,HMAMemAvail,GetFreeHMAddr

                     ;DOS 5+ Strings Functions

             PUBLIC  GetTrueName
             PUBLIC  CapitalizeChar,CapitalizeString,CapitalizePChar


             PUBLIC  GetEnvCount
             PUBLIC  EnvPChar
                     ;DOS Unit Initialize
             PUBLIC  Init_DOS


               .386
Dos_IO PROC NEAR
        PUSH  GS
        mcSetDATA_GS
        MOV   BYTE PTR GS:[DosResult].Interrupt, intDosInterrupt
        MOV   WORD PTR GS:[DosResult].Result, deNoError
        INT   21h
        POP   GS
        RET
Dos_IO ENDP


Dos_3_IO PROC NEAR
          PUSH  GS
          mcSetDATA_GS
          MOV   BYTE PTR GS:[DosResult].Interrupt,intDosInterrupt
          MOV   WORD PTR GS:[DosResult].Result, deNoError
          INT   21h
          POP   GS
          mcSetDATA_GS
          JNC    @@Dos_3_NoError
          MOV   WORD PTR GS:[DosResult].Result,AX
          CALL  DWORD PTR GS:[DosResult].ErrorProc
@@Dos_3_NoError:
          RET
Dos_3_IO ENDP


Dos_1_IO PROC NEAR
          PUSH  GS
          mcSetDATA_GS
          MOV   BYTE PTR GS:[DosResult].Interrupt, intDosInterrupt
          MOV   WORD PTR GS:[DosResult].Result, deNoError
          INT   21h
          POP   GS
          mcSetDATA_GS
          OR    AL,AL
          JZ   @@Dos_1_NoError
          MOV   WORD PTR GS:[DosResult].Result, deInvalidParameter
          CALL  DWORD PTR GS:[DosResult].ErrorProc
@@Dos_1_NoError:
          RET
Dos_1_IO ENDP


DosReadChar PROC FAR
EchoChar    EQU  SS:[BX+4]
              mcStackFrame BX
              MOV        AH,dcEchoReadChar
              CMP        BYTE PTR EchoChar, false
              JE         @@NoEchoRead
  @@NoEchoRead:
              MOV        AH,dcNoEchoReadChar
              CALL       Dos_IO
              RET        2
DosReadChar ENDP


DosReadAuxChar PROC FAR
                MOV  AH,dcReadAuxChar
                CALL       Dos_IO
                RET
DosReadAuxChar ENDP


DosWriteChar    PROC FAR
OutChar         EQU  SS:[BX+4]
                 MOV  AH,dcWriteChar
                 JMP  SHORT @@WriteChar
DosWritePrnChar PROC FAR
                 MOV  AH,dcWritePrnChar
                 JMP  SHORT @@WriteChar
DosWriteAuxChar PROC FAR
                 MOV  AH,dcWriteAuxChar
@@WriteChar:
                 mcStackFrame BX
                 MOV        DL,OutChar
                 CALL       Dos_IO
                 RET        2
DosWriteAuxChar ENDP
DosWritePrnChar ENDP
DosWriteChar    ENDP


GetStdInStatus PROC FAR
                 MOV  AH,dcGetStdInStatus
                 CALL       Dos_IO
                 AND  AL,01h
                 RET
GetStdInStatus ENDP


DosBufferedInput PROC FAR
Buffer           EQU SS:[BX+4]
                  mcStackFrame BX
                  PUSH       DS
                  LDS        DX,Buffer
                  MOV        AH,dcBufferedInput
                  CALL       Dos_IO
                  POP        DS
                  RET        4
DosBufferedInput ENDP


DosWriteString PROC FAR
OutString      EQU  SS:[BX+4]
                mcStackFrame BX
                PUSH       DS
                LDS        DX,OutString
                INC        DX
                MOV        AH,dcWriteString
                CALL       Dos_IO
                POP        DS
                RET        4
DosWriteString ENDP


DiskReset PROC FAR
           MOV    AH,dcDiskReset
           CALL   Dos_IO
           RET
DiskReset ENDP


SelectDrive PROC FAR
Drive       EQU  SS:[BX+4]
              mcStackFrame BX
              MOV        AH,dcSelectDrive
              MOV        DL,Drive
              CALL       Dos_IO
              RET        2
SelectDrive ENDP


GetDefaultDrive PROC FAR
                 MOV   AH,dcGetDefaultDrive
                 CALL  Dos_IO
                 RET
GetDefaultDrive ENDP


SetDiskTransferArea PROC FAR
NewDTA              EQU  SS:[BX+4]
                     mcStackFrame BX
                     PUSH       DS
                     MOV        AH,dcSetDiskTransferArea
                     LDS        DX,NewDTA
                     CALL       Dos_IO
                     POP        DS
                     RET        4
SetDiskTransferArea ENDP


GetDefDriveInfo PROC FAR
Info            EQU  SS:[BX+4]
                 mcStackFrame BX
                 MOV        AH,dcGetDefDriveInfo
                 CALL       Dos_IO
                 LES        DI,Info
                 MOV        WORD PTR ES:[DI],DX
                 MOV        WORD PTR ES:[DI+2],CX
                 MOV        BYTE PTR ES:[DI+3],AL
                 MOV        AL,BYTE PTR DS:[BX]
                 MOV        BYTE PTR ES:[DI+4],AL
                 RET        4
GetDefDriveInfo ENDP


GetDriveInfo PROC FAR
Drive        EQU  SS:[BX+8]
Info         EQU  SS:[BX+4]
              mcStackFrame BX
              MOV        AH,dcGetDriveInfo
              MOV        AL,Drive
              CALL       Dos_IO
              LES        DI,Info
              MOV        WORD PTR ES:[DI],DX
              MOV        WORD PTR ES:[DI+2],CX
              MOV        BYTE PTR ES:[DI+3],AL
              MOV        AL,BYTE PTR DS:[BX]
              MOV        BYTE PTR ES:[DI+4],AL
              RET        6
GetDriveInfo ENDP


GetDefDriveDPT PROC FAR
                PUSH DS
                MOV  AH,dcGetDefDriveDPT
                CALL Dos_1_IO
                MOV  DX,DS
                MOV  AX,BX
                POP  DS
                RET
GetDefDriveDPT ENDP


SetInterruptVector PROC FAR
_Interrupt         EQU  SS:[BX+8]
NewVector          EQU  SS:[BX+4]
                    mcStackFrame BX
                    PUSH       DS
                    MOV        AH, dcSetInterruptVector
                    MOV        AL, _Interrupt
                    LDS        DX, NewVector
                    CALL       Dos_IO
                    POP        DS
                    RET        6
SetInterruptVector ENDP


GetSystemDate PROC FAR
Date          EQU SS:[BX+4]
               MOV        AH,dcGetSystemDate
               CALL       Dos_IO
               mcStackFrame BX
               LES        DI,Date
               MOV        ES:[DI],CX
               MOV        ES:[DI+2],DX
               RET        4
GetSystemDate ENDP


SetSystemDate PROC FAR
Date          EQU SS:[BX+4]
               mcStackFrame BX
               LES        DI,Date
               MOV        CX,WORD PTR ES:[DI]
               MOV        DX,WORD PTR ES:[DI+2]
               MOV        AH,dcSetSystemDate
               CALL       Dos_1_IO
               RET        4
SetSystemDate ENDP


GetSystemTime PROC FAR
Time          EQU SS:[BX+4]
               MOV        AH,dcGetSystemTime
               CALL       Dos_IO
               mcStackFrame BX
               LES        DI,Time
               MOV        ES:[DI],CX
               MOV        ES:[DI+2],DX
               RET        4
GetSystemTime ENDP


SetSystemTime PROC FAR
Time          EQU SS:[BX+4]
               mcStackFrame BX
               LES        DI,Time
               MOV        CX,WORD PTR ES:[DI]
               MOV        DX,WORD PTR ES:[DI+2]
               MOV        AH,dcSetSystemTime
               CALL       Dos_1_IO
               RET        4
SetSystemTime ENDP


SetVerifyFlag PROC FAR
Flag          EQU SS:[BX+4]
               mcStackFrame BX
               MOV        AH,dcSetVerifyFlag
               MOV        AL,Flag
               CALL       Dos_IO
               RET        4
SetVerifyFlag ENDP


GetDiskTransferArea PROC FAR
                     MOV    AH,dcGetDiskTransferArea
                     CALL   Dos_IO
                     MOV    DX,ES
                     MOV    AX,BX
                     RET
GetDiskTransferArea ENDP


GetDosVersion PROC NEAR
               MOV    AH,dcGetDosVersion
               CALL   Dos_IO
               XCHG   AH,AL
               MOV    [DosVersion],AX
               RET
GetDosVersion ENDP


StayTSR     PROC FAR
DosExitCode EQU SS:[BX+4]
             mcStackFrame BX
             MOV        AX,PrefixSeg
             MOV        ES,AX
             MOV        DX,WORD PTR ES:[02h]
             SUB        DX,AX
             MOV        AH,dcStayTSR
             MOV        AL,DosExitCode
             CALL       Dos_IO
             RET        2
StayTSR     ENDP


GetDriveDPT PROC FAR
Drive       EQU SS:[BX+4]
             mcStackFrame BX
             PUSH       DS
             MOV        AH,dcGetDriveDPT
             MOV        DL,Drive
             CALL       Dos_IO
             MOV        DX,DS
             MOV        AX,BX
             POP        DS
             RET        2
GetDriveDPT ENDP


GetExtBreakCheck PROC FAR
                  MOV   AX,dcGetExtBreakCheck
                  CALL  Dos_IO
                  MOV   AL,DL
                  RET
GetExtBreakCheck ENDP


SetExtBreakCheck PROC FAR
Flag              EQU SS:[BX+4]
                  mcStackFrame BX
                  MOV        AX,dcSetExtBreakCheck
                  MOV        DL,Flag
                  CALL       Dos_IO
                  RET
SetExtBreakCheck ENDP


GetBootDrive PROC FAR
              MOV    AX,dcGetBootDrive
              CALL   Dos_IO
              MOV    AL,DL
              RET
GetBootDrive ENDP


GetInDosFlagPtr PROC FAR
                 MOV  AH,dcGetInDosFlagPtr
                 CALL Dos_IO
                 MOV  WORD PTR [InDosFlagPtr],BX
                 MOV  BX, ES
                 MOV  WORD PTR [InDosFlagPtr+2],BX
                 RET
GetInDosFlagPtr ENDP


GetInterruptVector PROC FAR
_Interrupt         EQU SS:[BX+4]
                    mcStackFrame BX
                    MOV        AH, dcGetInterruptVector
                    MOV        AL, _Interrupt
                    CALL       Dos_IO
                    MOV        AX, BX
                    MOV        DX, ES
                    RET        2
GetInterruptVector ENDP


GetFreeDiskSpace PROC FAR
Drive            EQU SS:[DI+8]
Info             EQU SS:[DI+4]
                  mcStackFrame DI
                  MOV        AH,dcGetFreeDiskSpace
                  MOV        AL,Drive
                  CALL       Dos_1_IO
                  LES        DI,Info
                  MOV        WORD PTR ES:[DI],DX
                  MOV        WORD PTR ES:[DI+2],BX
                  MOV        WORD PTR ES:[DI+4],AX
                  MOV        WORD PTR ES:[DI+6],CX
                  RET        6
GetFreeDiskSpace ENDP


GetSwitchar PROC FAR
             MOV    AX,dcGetSwitChar
             CALL   Dos_IO
             MOV    AL,DL
             RET
GetSwitchar ENDP


SetSwitchar PROC FAR
Flag        EQU SS:[BX+4]
             mcStackFrame BX
             MOV        AX,dcSetSwitchar
             MOV        DL,Flag
             CALL       Dos_IO
             RET        2
SetSwitchar ENDP


CreateDirectory PROC FAR
Directory       EQU SS:[BX+4]
                 MOV        AH,dcCreateDirectory
                 JMP        SHORT @@SetDir
RemoveDirectory PROC FAR
                 MOV        AH,dcRemoveDirectory
                 JMP        SHORT @@SetDir
ChangeDirectory PROC FAR
                 MOV        AH,dcChangeDirectory
@@SetDir:
                 mcStackFrame BX
                 PUSH       DS
                 LDS        DX,Directory
                 CALL       Dos_3_IO
                 POP        DS
                 RET        4
ChangeDirectory ENDP
RemoveDirectory ENDP
CreateDirectory ENDP


CreateFile PROC FAR
FileName   EQU SS:[BX+10]
Attribute  EQU SS:[BX+8]
Handle     EQU SS:[BX+4]
            mcStackFrame BX
            MOV        AH,dcCreateFile
            PUSH       DS
            LDS        DX,FileName
            MOV        CX,Attribute
            CALL       Dos_3_IO
            LES        DI,Handle
            STOSW
            POP        DS
            RET        10
CreateFile ENDP


OpenFile  PROC FAR
FileName  EQU  SS:[BX+8]
Handle    EQU  SS:[BX+4]
           mcStackFrame BX
           MOV        AH,dcOpenFile
           MOV        AL,[FileOpenMode]
           PUSH       DS
           LDS        DX,FileName
           CALL       Dos_3_IO
           LES        DI,Handle
           STOSW
           POP        DS
           RET        8
OpenFile  ENDP


CloseFile PROC FAR
Handle    EQU  SS:[BX+4]
           mcStackFrame BX
           MOV        AH,dcCloseFile
           MOV        BX,Handle
           CALL       Dos_3_IO
           RET
CloseFile ENDP


ReadFile PROC FAR
Handle   EQU SS:[SI+14]
Buffer   EQU SS:[SI+10]
Count    EQU SS:[SI+8]
_Result  EQU SS:[SI+4]
           mcStackFrame SI
           MOV        AH,dcReadFile
           JMP        SHORT @@ReadWrite
WriteFile PROC FAR
           mcStackFrame SI
           MOV        AH,dcWriteFile
@@ReadWrite:
           PUSH       DS
           MOV        BX,Handle
           MOV        CX,Count
           LDS        DX,Buffer
           CALL       Dos_3_IO
           POP        DS
           mcStackFrame SI
           LES        DI,_Result
           STOSW
           RET        12
WriteFile ENDP
ReadFile ENDP


DeleteFile PROC FAR
FileName   EQU SS:[BX+4]
            mcStackFrame BX
            PUSH       DS
            MOV        AH,dcDeleteFile
            LDS        DX,FileName
            CALL       Dos_3_IO
            POP        DS
            RET        4
DeleteFile ENDP


SeekFile PROC FAR
Handle   EQU SS:[BX+8]
SeekPos  EQU SS:[BX+4]
          mcStackFrame BX
          MOV        DX,WORD PTR [SeekPos]
          MOV        CX,WORD PTR [SeekPos+2]
          MOV        AH,dcSeekFile
          XOR        AL,AL
          CALL       Dos_3_IO
          RET        6
SeekFile ENDP


GetFileAttribute PROC FAR
FileName         EQU SS:[BX+4]
                  mcStackFrame BX
                  PUSH       DS
                  MOV        AX,dcGetFileAttr
                  LDS        DX,FileName
                  CALL       Dos_3_IO
                  POP        DS
                  RET        4
GetFileAttribute ENDP


SetFileAttribute PROC FAR
FileName         EQU SS:[BX+6]
Attribute        EQU SS:[BX+4]
                  mcStackFrame BX
                  PUSH       DS
                  MOV        AX,dcSetFileAttr
                  LDS        DX,FileName
                  MOV        CX,Attribute
                  CALL       Dos_3_IO
                  POP        DS
                  RET        6
SetFileAttribute ENDP


DuplicateHandle PROC FAR
Handle          EQU SS:[BX+4]
                 mcStackFrame BX
                 MOV        BX,Handle
                 MOV        AH,dcDupHandle
                 CALL       Dos_3_IO
                 RET        2
DuplicateHandle ENDP


ForceDuplicateHandle PROC FAR
InHandle             EQU SS:[BX+6]
OutHandle            EQU SS:[BX+4]
                      mcStackFrame BX
                      MOV        AH,dcForceDupHandle
                      MOV        CX,OutHandle
                      MOV        BX,InHandle
                      CALL       Dos_3_IO
                      RET        4
ForceDuplicateHandle ENDP


GetCurrentDirectory PROC FAR
Drive               EQU SS:[BX+8]
Buffer              EQU SS:[BX+4]
                     mcStackFrame BX
                     PUSH       DS
                     MOV        AH,dcGetCurrentDirectory
                     MOV        DL,Drive
                     LDS        SI,Buffer
                     CALL       Dos_3_IO
                     POP        DS
                     RET        6
GetCurrentDirectory ENDP


AllocateMemory PROC FAR
BlockSize      EQU SS:[BX+4]
                mcStackFrame BX
                MOV        AH,dcAllocateMemory
                MOV        BX,BlockSize
                CALL       Dos_3_IO
                RET        2
AllocateMemory ENDP


ReleaseMemory PROC FAR
Segm          EQU SS:[BX+4]
               mcStackFrame BX
               MOV        AH,dcFreeMemory
               MOV        BX,Segm
               MOV        ES,BX
               CALL       Dos_3_IO
               RET        2
ReleaseMemory ENDP


ReallocateMemory PROC FAR
Segm             EQU SS:[BX+6]
BlockSize        EQU SS:[BX+4]
                  mcStackFrame BX
                  MOV        AX,Segm
                  MOV        ES,AX
                  MOV        BX,BlockSize
                  MOV        AH,dcReallocateMemory
                  CALL       Dos_3_IO
                  RET        4
ReallocateMemory ENDP


GetExitCode PROC FAR
             MOV    AH,dcGetExitCode
             CALL   Dos_IO
             RET
GetExitCode ENDP


FindFirstFile PROC FAR
               RET
FindFirstFile ENDP


FindNextFile PROC FAR
              RET
FindNextFile ENDP


SetPSP_Address PROC FAR
PSPSeg         EQU SS:[BX+4]
                mcStackFrame BX
                MOV        AH,dcSetPSPAddress
                MOV        BX,PSPSeg
                CALL       Dos_IO
                RET        2
SetPSP_Address ENDP


GetPSP_Address PROC FAR
                MOV    AH,dcGetPSPAddress
                CALL   Dos_IO
                MOV    AX,BX
                RET
GetPSP_Address ENDP


GetSysVarsPtr PROC FAR
               MOV   AH,dcGetSysvarsPtr
               CALL  Dos_IO
               SUB   BX,SysvarsShift
               MOV   WORD PTR [SysVars],BX
               MOV   BX,ES
               MOV   WORD PTR [SysVars+2],BX
               RET
GetSysVarsPtr ENDP


ConvertBPBtoDPB PROC FAR
BPB             EQU SS:[BX+8]
DPB             EQU SS:[BX+4]
                 mcStackFrame BX
                 PUSH       DS
                 LDS        SI,BPB
                 LES        BP,DPB
                 MOV        AH,dcConvertBPBtoDPB
                 CALL       Dos_IO
                 POP        DS
                 RET        8
ConvertBPBtoDPB ENDP


GetVerifyFlag PROC FAR
               MOV   AH,dcGetVerifyFlag
               CALL  Dos_IO
               RET
GetVerifyFlag ENDP


CreateChild_PSP PROC FAR
PSP_Seg         EQU SS:[BX+6]
PSP_Size        EQU SS:[BX+4]
                 mcStackFrame BX
                 MOV        AH,dcCreateChildPSP
                 MOV        DX,PSP_Seg
                 MOV        SI,PSP_Size
                 CALL       Dos_IO
                 RET        4
CreateChild_PSP ENDP


RenameFile  PROC FAR
InFileName  EQU SS:[BX+8]
OutFileName EQU SS:[BX+4]
             mcStackFrame BX
             MOV        AH,dcRenameFile
             PUSH       DS
             LDS        DX,InFileName
             LES        DI,OutFileName
             CALL       Dos_3_IO
             POP        DS
             RET        8
RenameFile  ENDP


GetFileDate PROC FAR
Handle      EQU SS:[BX+4]
             mcStackFrame BX
             MOV        AX,dcGetFileDate
             MOV        BX,Handle
             CALL       Dos_3_IO
             MOV        AX,DX
             RET        2
GetFileDate ENDP


GetFileTime PROC FAR
Handle      EQU SS:[BX+4]
             mcStackFrame BX
             MOV        AX,dcGetFileTime
             MOV        BX,Handle
             CALL       Dos_3_IO
             MOV        AX,CX
             RET        2
GetFileTime ENDP


SetFileTimeDate PROC FAR
Handle          EQU SS:[BX+8]
Time            EQU SS:[BX+6]
Date            EQU SS:[BX+4]
                 mcStackFrame BX
                 MOV        AX,dcSetFileTimeDate
                 MOV        CX,Time
                 MOV        DX,Date
                 MOV        BX,Handle
                 CALL       Dos_3_IO
                 RET        6
SetFileTimeDate ENDP


GetAllocationStrategy PROC FAR
                       MOV   AX,dcGetAllocationStrat
                       CALL  Dos_IO
                       RET
GetAllocationStrategy ENDP


SetAllocationStrategy PROC FAR
NewState              EQU SS:[BX+4]
                       mcStackFrame BX
                       MOV   AX,dcSetAllocationStrat
                       MOV   BL,NewState
                       XOR   BH,BH
                       CALL  Dos_3_IO
                       RET
SetAllocationStrategy ENDP


GetUMB_LinkState PROC FAR
                  MOV   AX,dcGetLinkState
                  CALL  Dos_IO
                  RET
GetUMB_LinkState ENDP


SetUMB_LinkState PROC FAR
NewState         EQU SS:[BX+4]
                  mcStackFrame BX
                  MOV   AX,dcSetLinkState
                  MOV   BL,NewState
                  XOR   BH,BH
                  CALL  Dos_3_IO
                  RET
SetUMB_LinkState ENDP


GetExtErrorInfo PROC FAR
GetExtErrorInfo ENDP


CreateNewFile PROC FAR
FileName       EQU SS:[BX+10]
Attribute      EQU SS:[BX+8]
Handle         EQU SS:[BX+4]
                MOV        AH, dcCreateNewFile
                JMP        SHORT @@Create
CreateTempFile PROC FAR
                MOV        AH,dcCreateTempFile
@@Create:
                mcStackFrame BX
                PUSH       DS
                MOV        CX, Attribute
                LDS        DX, FileName
                CALL       Dos_3_IO
                LES        DI,Handle
                STOSW
                POP        DS
                RET        10
CreateTempFile ENDP
CreateNewFile ENDP


UnLockFile  PROC FAR
Handle      EQU SS:[BX+12]
StartOffset EQU SS:[BX+8]
LockSize    EQU SS:[BX+4]
             MOV   AX, dcUnLockFile
             JMP   SHORT @@FLock
LockFile PROC FAR
             MOV   AX,dcLockFile
@@FLock:
             mcStackFrame BX
             MOV        DX,WORD PTR [StartOffset]
             MOV        CX,WORD PTR [StartOffset+2]
             MOV        DI,WORD PTR [LockSize]
             MOV        SI,WORD PTR [LockSize+2]
             MOV        BX,Handle
             CALL       Dos_3_IO
             RET        10
LockFile ENDP
UnLockFile ENDP


DisableDrive PROC FAR                          ;DOS 5+ functions Enable/Disable drive
Drive        EQU SS:[BX+4]                     ;Change ~valid~ byte in drive's DPT
              MOV    AX,dcEnableDrive          ;Set CF if error.
              JMP    SHORT @@Lock_UnlockDrive
EnableDrive PROC FAR
              MOV    AX,dcDisableDrive
@@Lock_UnlockDrive:
              MOV    DL,Drive
              CALL   Dos_3_IO
              RET    2
EnableDrive ENDP
DisableDrive ENDP


GetTrueName PROC FAR
FilePath    EQU SS:[BX+8]
Buffer      EQU SS:[BX+4]
             mcStackFrame BX
             MOV        AH,dcGetTrueName
             LDS        SI,FilePath
             LES        DI,Buffer
             CALL       Dos_IO
             RET        8
GetTrueName ENDP


GetCurrentPSP PROC FAR
               MOV    AH,dcGetCurrentPSP
               CALL   Dos_IO
               MOV    AX,BX
               RET
GetCurrentPSP ENDP


GetExtCountryInfo PROC FAR
GetExtCountryInfo ENDP


CapitalizeChar PROC FAR
OutChar        EQU SS:[BX+4]
                mcStackFrame BX
                MOV        AX,dcCapitalizeChar
                MOV        DL,OutChar
                CALL       Dos_3_IO
                MOV        AL,DL
                RET        2
CapitalizeChar ENDP


CapitalizeString PROC FAR
String           EQU SS:[BX+4]
                  mcStackFrame BX
                  PUSH       DS
                  LDS        DX,String
                  LODSB
                  CBW
                  MOV        CX,AX
                  MOV        AX,dcCapitalizeString
                  CALL       Dos_3_IO
                  POP        DS
                  RET        4
CapitalizeString ENDP


CapitalizePChar PROC FAR
PChar           EQU SS:[BX+4]
                 mcStackFrame BX
                 PUSH       DS
                 MOV        AX, dcCapitalizePChar
                 LDS        DX,PChar
                 CALL       Dos_3_IO
                 POP        DS
                 RET        4
CapitalizePChar ENDP


SetGlobalCodePage PROC FAR
SetGlobalCodePage ENDP


GetGlobalCodePage PROC FAR
GetGlobalCodePage ENDP


SetHandlesCount PROC FAR
Count           EQU SS:[BX+4]
                 mcStackFrame BX
                 MOV        AX,dcSetHandlesCount
                 MOV        BX,Count
                 CALL       Dos_3_IO
                 RET        2
SetHandlesCount ENDP


CommitFile PROC FAR
Handle     EQU SS:[BX+4]
            MOV   AH,dcCommitFile
            JMP   SHORT @@CommFflush
FflushFile PROC FAR
            MOV   AH,dcFflushFile
@@CommFflush:
            mcStackFrame BX
            MOV        BX,Handle
            CALL       Dos_3_IO
            RET   2
FflushFile ENDP
CommitFile ENDP


ExtOpen_CreateFile PROC
                    RET
ExtOpen_CreateFile ENDP


FindFirstROMProg PROC FAR
                  RET
FindFirstROMProg ENDP


FindNextROMProg PROC FAR
                 RET
FindNextROMProg ENDP


GetROMScanStartAddr PROC FAR
                     RET
GetROMScanStartAddr ENDP


SetROMScanStartAddr PROC FAR
                     RET
SetROMScanStartAddr ENDP


GetExlRegionList PROC FAR
                  RET
GetExlRegionList ENDP



Init_DOS PROC NEAR
          CALL  GetDosVersion
          CALL  GetInDosFlagPtr
          CALL  GetSysvarsPtr
          MOV   [FileOpenMode],dfmReadWrite
          RET
Init_DOS ENDP



GetFreeHMAddr PROC FAR
               MOV  AX,dcmGetFreeHMA
               INT  2Fh
               MOV  AX,DI
               MOV  DX,ES
               RET
GetFreeHMAddr ENDP


HMAMemAvail PROC FAR
             MOV  AX,dcmGetFreeHMA
             INT  2Fh
             MOV  AX,BX
             RET
HMAMemAvail ENDP


AllocateHMA PROC FAR
BlockSize   EQU SS:[BX+4]
             mcStackFrame BX
             MOV        AX,dcmAllocateHMA
             MOV        BX,BlockSize
             INT        2Fh
             MOV        AX,DI
             MOV        DX,ES
             RET        2
AllocateHMA ENDP


CheckEnvir PROC NEAR
            PUSH       BX
            PUSH       AX
            PUSH       ES
            PUSH       DI
            PUSH       AX
            DEC        AX
            MOV        ES,AX
            MOV        DI,1
            MOV        AX,ES:[DI]
            MOV        ES,AX
            MOV        DI,pspEnvPtr
            MOV        AX,ES:[DI]
            POP        BX
            CLC
            XOR        AX,BX
            JZ         @@OkCheck
            STC
@@OkCheck:
            POP        DI
            POP        ES
            POP        AX
            POP        BX
            RET
CheckEnvir ENDP


GetEnvCount PROC FAR
Segm        EQU  SS:[BX+4]
             mcStackFrame BX
             MOV        AX,Segm
             CALL       CheckEnvir
             MOV        ES,AX
             JC         @@EnvCount_Error
             Zero       AX
             Zero       DI
             MOV        CX,MaxLenOfEnv
             Zero       BX
@@EnvCountLoop:
             SCASB
             JE         @@EnvCountLoopEnd
             REPNE      SCASB
             JCXZ       @@EnvCountLoopEnd
             INC        BX
             JNE        @@EnvCountLoop
@@EnvCount_Error:
             Zero       AX
             JMP        SHORT @@End_EnvCount
@@EnvCountLoopEnd:
             MOV        AX,BX
@@End_EnvCount:
             RET        2
GetEnvCount ENDP


EnvPChar PROC FAR
Segm      EQU  SS:[BX+6]
Index     EQU  SS:[BX+4]
          mcStackFrame BX
          PUSH       DS
          PUSH       BX
          PUSH       WORD PTR [Segm]
          CALL       GetEnvCount
          POP        BX
          CMP        AX,0
          JE         @@EnvPChar_Error
          MOV        CX,Index
          MOV        DX,Segm
          MOV        DS,DX
          Zero       SI
          JCXZ       @@EnvPChar_Error
          CMP        CX,AX
          JG         @@EnvPChar_Error
          MOV        BX,CX
          MOV        CX,MaxLenOfEnv
@@EnvPChar_SetAddr:
          MOV        DX,SI
@@EnvPChar_Loop:
          LODSB
          CMP        AL,0
          JNE        @@EnvPChar_Loop
          DEC        BX
          JNE        @@EnvPChar_SetAddr
          MOV        AX,DX
          MOV        DX,DS
          JMP        SHORT @@End_EnvPChar
@@EnvPChar_Error:
          Zero       AX
          Zero       DX
          JMP        SHORT @@End_EnvPChar
@@End_EnvPChar:
          POP        DS
          RET        4
EnvPChar ENDP


CODE  ENDS

      END