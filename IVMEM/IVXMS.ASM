INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

; External Variables
      EXTRN XMSError         : BYTE
      EXTRN XMSResult        : WORD
      EXTRN XMSPresent       : BYTE
      EXTRN XMSHandlesTable  : DWORD
      EXTRN XMSVersion       : WORD
      EXTRN XMSRevision      : WORD
      EXTRN HMAPresent       : BYTE
      EXTRN XMM_Driver       : DWORD
      EXTRN LastXMSFunction  : BYTE
      EXTRN XMSErrorProc     : DWORD

      EXTRN EMSPresent       : BYTE
      EXTRN EMSError         : WORD
      EXTRN EMMVersion       : BYTE
      EXTRN PageFrame        : WORD
      EXTRN TotalRAWPages    : WORD
      EXTRN TotalEMSPages    : WORD
      EXTRN TotalEMSHandles  : WORD
      EXTRN EMSDriverType    : BYTE
      EXTRN EMM_Driver       : DWORD
      EXTRN EMSExchange      : BYTE
      EXTRN LastEMSFunction  : BYTE
      EXTRN EMSErrorProc     : DWORD

;Used Constants

     ; XMS Manager Functions
xGetXMSVersion             EQU 00h
xRequestHMA                EQU 01h
xReleaseHMA                EQU 02h
xGlobalE20                 EQU 03h
xGlobalD20                 EQU 04h
xLocalE20                  EQU 05h
xLocalD20                  EQU 06h
xQuery20                   EQU 07h
xGetFreeXMS                EQU 08h
xAllocEMB                  EQU 09h
xFreeEMB                   EQU 0Ah
xMoveEMB                   EQU 0Bh
xLockEMB                   EQU 0Ch
xUnlockEMB                 EQU 0Dh
xGetHandleInfo             EQU 0Eh
xReallocEMB                EQU 0Fh
xRequestUMB                EQU 10h
xReleaseUMB                EQU 11h
xReallocUMB                EQU 12h

xNoneXMM_Driver            EQU 80h

eGetEMSStatus              EQU 40h
eGetPageFrame              EQU 41h
eGetEMSPages               EQU 42h
eAllocateEMS               EQU 43h
eMapEMS                    EQU 44h
eReleaseEMS                EQU 45h
eGetEMMVersion             EQU 46h
eSaveContext               EQU 47h
eRestoreContext            EQU 48h
eGetHandlesNum             EQU 4Bh
eGetHandlePages            EQU 4Ch
eGetEMSTable               EQU 4Dh
eGetSetPageMap             EQU 4Eh
eGetSetPPageMap            EQU 4Fh
eMapUnmapHandle            EQU 50h
eReallocateEMS             EQU 51h
eGetSetAttrib              EQU 52h
eGetSetName                EQU 53h
eGetHandleDir              EQU 54h
eMoveEMS                   EQU 57h
eGetMapArray               EQU 58h
eGetHardware               EQU 59h
eAllocateRAW               EQU 5Ah
eAltMapRegSet              EQU 5Bh
eWarmBootPrep              EQU 5Ch

eEMM386_GetState           EQU 00h
eEMM386_SetState           EQU 01h
eEMM386_GetWeitekState     EQU 02h
eEMM386_PrintCopyright     EQU 04h
eEMM386_PrintReport        EQU 05h

eQEMM_GetState                 EQU 00h
eQEMM_SetState                 EQU 01h
eQEMM_GetVersion               EQU 03h
eQEMM_GetHiramChain            EQU 12h
eQEMM_GetMemoryStatistics      EQU 17h
eQEMM_UntrappedIORead          EQU 1A00h
eQEMM_UntrappedIOWrite         EQU 1A01h
eQEMM_UntrappedIOReadIndexed   EQU 1A02h
eQEMM_UntrappedIOWriteIndexed  EQU 1A03h
eQEMM_GetIOCallback            EQU 1A06h
eQEMM_SetIOCallback            EQU 1A07h
eQEMM_SetPortTrap              EQU 1A09h
eQEMM_GetPortTrap              EQU 1A08h
eQEMM_ClearPortTrap            EQU 1A0Ah
eQEMM_GetInfo                  EQU 1E00h
eQEMM_GetStealthCount          EQU 1E01h
eQEMM_GetStealthList           EQU 1E02h
eQEMM_Copy_Stealth_Roms        EQU 21h

eNoThisDriver                  EQU 0100h

eNoneEMM_Driver            EQU 80h


EMSTrRec   STRUC
  eTransferSize  DW 0
                 DW 0
  eSourceType    DB 0
  eSourceHandle  DW 0
  eSourceOffset  DW 0
                 DW 0
  eDestType      DB 0
  eDestHandle    DW 0
  eDestOffset    DW 0
                 DW 0
EMSTrRec   ENDS


XMSTrRec   STRUC
  xTransferSize  DW 0
                 DW 0
  xSourceHandle  DW 0
  xSourceOffset  DW 0
                 DW 0
  xDestHandle    DW 0
  xDestOffset    DW 0
                 DW 0
XMSTrRec   ENDS


DATA  ENDS


CODE  SEGMENT BYTE PUBLIC
.386
      ASSUME CS:CODE,DS:DATA,GS:DATA
;XMS Functions and Procedures
      PUBLIC InitIvXMS,ReleaseHMA,AllocateHMA
      PUBLIC GlobalEnableA20,GlobalDisableA20
      PUBLIC LocalEnableA20,LocalDisableA20,QueryA20
      PUBLIC GetFreeXMS,GetMaxFreeBlock
      PUBLIC AllocateEMB,ReleaseEMB,ReallocateEMB
      PUBLIC LockEMB,UnlockEMB,GetEMBSize
      PUBLIC GetEMBLockCount,GetEMBFreeHandles
      PUBLIC AllocateUMB,ReleaseUMB,ReallocateUMB
      PUBLIC UMBMaxAvail,MoveEMBUsers

;EMS Functions and Procedures
      PUBLIC GetHardwareInfo,InitIvEMS
      PUBLIC AvailEMSPages,ActiveEMSHandles
      PUBLIC AllocateEMS,ReleaseEMS,MapEMSPages
      PUBLIC SaveMappingContext,RestoreMappingContext
      PUBLIC GetEMS_HandlePages,GetEMSHandlesTable
      PUBLIC ReallocateEMS,GetEMS_HandleAttr,SetEMS_HandleAttr
      PUBLIC SetEMS_HandleName,GetEMS_HandleName
      PUBLIC FindEMS_Handle,MoveEMSUsers,WarmBootPrepare
      PUBLIC AllocateRAWPages,MapUnmapPages
      PUBLIC GetFreeRawPages

      PUBLIC EMM386_GetState,EMM386_SetState
      PUBLIC EMM386_GetWeitekSupport,EMM386_SetWeitekSupport
      PUBLIC EMM386_PrintCopyright,EMM386_PrintReport

      PUBLIC QEMM_GetHiramChain,QEMM_GetManifestPresent
      PUBLIC QEMM_GetVersion,QEMM_GetState,QEMM_SetState
      PUBLIC QEMM_Copy_Stealth_Roms
      PUBLIC QEMM_UntrappedIORead,QEMM_UntrappedIOWrite
      PUBLIC QEMM_UntrappedIOReadIndexed,QEMM_UntrappedIOWriteIndexed
      PUBLIC QEMM_GetIOCallback,QEMM_SetIOCallback
      PUBLIC QEMM_GetPortTrap,QEMM_SetPortTrap,QEMM_ClearPortTrap
      PUBLIC QEMM_GetStealthCount,QEMM_GetInfo
      PUBLIC QEMM_GetMemoryStatistics
      PUBLIC QEMM_GetStealthList



EMMDosHandle  DW 0
XMSTr         XMSTrRec <0,0,0,0,0>
EMSTr         EMSTrRec <0,0,0,0,0,0,0>
EMMDriverName DB 'EMMXXXX0'
EMMOpen_Zero  DB 0




XMM_Call PROC NEAR
         PUSH  SEG DATA
         POP   GS
         MOV   GS:[XMSError],xNoneXMM_Driver
         MOV   GS:[XMSResult],0
         CMP   GS:[XMSPresent],0
         JE    @@XMS_Error
         MOV   GS:[LastXMSFunction],AH
         CALL  DWORD PTR GS:[XMM_Driver]
         PUSH  GS
         POP   DS
         MOV   [XMSResult],AX
         MOV   [XMSError],BL
         CMP   AX,1
         JNE   @@XMS_Error
         MOV   [XMSResult],1
         MOV   [XMSError],0
         JMP   @@XMS_Ok
@@XMS_Error:
         MOV   [XMSResult],0
         CALL  XMSErrorProc
@@XMS_Ok:
         RET
XMM_Call ENDP



InitIvXMS PROC NEAR
           MOV    [XMSPresent],0
           MOV    AX,4300h
           INT    2Fh
           CMP    AL,80h
           JNE    @@XMS_NotInstalled
           MOV    AX,4310h
           INT    2Fh
           MOV    WORD PTR [XMM_Driver],BX
           MOV    WORD PTR [XMM_Driver+2],ES
           INC    [XMSPresent]
           MOV    AH,xGetXMSVersion
           CALL   [XMM_Driver]
           MOV    [HMAPresent],DL
           MOV    [XMSVersion],AX
           MOV    [XMSRevision],BX
           MOV    AX,4309h
           INT    2Fh
           CMP    AL,43h
           JE     @@XMS_TablePresent
           MOV    WORD PTR [XMSHandlesTable],0
           MOV    WORD PTR [XMSHandlesTable+2],0
           JMP    @@XMS_NotInstalled
@@XMS_TablePresent:
           MOV    WORD PTR [XMSHandlesTable],BX
           MOV    WORD PTR [XMSHandlesTable+2],ES
@@XMS_NotInstalled:
           RET
InitIvXMS ENDP


ReleaseHMA PROC FAR
            MOV   AH,xReleaseHMA
            CALL  XMM_Call
            RET
ReleaseHMA ENDP


AllocateHMA PROC FAR
Size        EQU  (WORD PTR [BP+6])
             StackFrameBP
             MOV       DX,Size
             MOV       AH,xRequestHMA
             CALL      XMM_Call
             ExitCode  2
AllocateHMA ENDP


GlobalEnableA20 PROC FAR
                 MOV   AH,xGlobalE20
                 CALL  XMM_Call
                 RET
GlobalEnableA20 ENDP


GlobalDisableA20 PROC FAR
                 MOV   AH,xGlobalD20
                 CALL  XMM_Call
                 RET
GlobalDisableA20 ENDP


LocalEnableA20 PROC FAR
                MOV   AH,xLocalE20
                CALL  XMM_Call
                RET
LocalEnableA20 ENDP


LocalDisableA20 PROC FAR
                 MOV   AH,xLocalD20
                 CALL  XMM_Call
                 RET
LocalDisableA20 ENDP


QueryA20 PROC FAR
          MOV   AH,xQuery20
          CALL  XMM_Call
          RET
QueryA20 ENDP


GetFreeXMS PROC FAR
            MOV   AH,xGetFreeXMS
            CALL  XMM_Call
            MOV   AX,DX
            RET
GetFreeXMS ENDP


GetMaxFreeBlock PROC FAR
                 MOV   AH,xGetFreeXMS
                 CALL  XMM_Call
                 RET
GetMaxFreeBlock ENDP


AllocateEMB PROC FAR
Size        EQU  (WORD PTR [BP+6])
             StackFrameBP
             MOV      AH,xAllocEMB
             MOV      DX,Size
             CALL     XMM_Call
             MOV      AX,DX
             ExitCode 2
AllocateEMB ENDP


ReleaseEMB PROC FAR
Handle      EQU  (WORD PTR [BP+6])
            StackFrameBP
            MOV      AH,xFreeEMB
            MOV      DX,Handle
            CALL     XMM_Call
            ExitCode 2
ReleaseEMB ENDP

ReAllocateEMB PROC FAR
Handle        EQU  (WORD PTR [BP+8])
Size          EQU  (WORD PTR [BP+6])
               StackFrameBP
               MOV      AH,xReallocEMB
               MOV      BX,Size
               MOV      DX,Handle
               CALL     XMM_Call
               ExitCode 2
ReAllocateEMB ENDP


LockEMB PROC FAR
Handle  EQU  (WORD PTR [BP+6])
         StackFrameBP
         MOV      AH,xLockEMB
         MOV      DX,Handle
         CALL     XMM_Call
         MOV      AX,BX
         ExitCode 2
LockEMB ENDP

UnlockEMB PROC FAR
Handle  EQU  (WORD PTR [BP+6])
         StackFrameBP
         MOV       AH,xUnlockEMB
         MOV       DX,Handle
         CALL      XMM_Call
         ExitCode 2
UnlockEMB ENDP

GetEMBSize PROC FAR
Handle     EQU  (WORD PTR [BP+6])
            StackFrameBP
            MOV       AH,xGetHandleInfo
            MOV       DX,Handle
            CALL      XMM_Call
            MOV       AX,DX
            ExitCode  2
GetEMBSize ENDP


GetEMBLockCount PROC FAR
Handle          EQU  (WORD PTR [BP+6])
                 StackFrameBP
                 MOV       AH,xGetHandleInfo
                 MOV       DX,Handle
                 CALL      XMM_Call
                 MOV       AL,BH
                 ExitCode  2
GetEMBLockCount ENDP

GetEMBFreeHandles PROC FAR
Handle            EQU  (WORD PTR [BP+6])
                   StackFrameBP
                   MOV       AH,xGetHandleInfo
                   MOV       DX,Handle
                   CALL      XMM_Call
                   MOV       AL,BH
                   ExitCode  2
GetEMBFreeHandles ENDP


AllocateUMB PROC FAR
Size        EQU  (WORD PTR [BP+6])
             StackFrameBP
             MOV      AH,xRequestUMB
             MOV      DX,Size
             CALL     XMM_Call
             MOV      AX,BX
             ExitCode 2
AllocateUMB ENDP

ReleaseUMB PROC FAR
Segment    EQU  (WORD PTR [BP+6])
            StackFrameBP
            MOV      AH,xReleaseUMB
            MOV      DX,Segment
            CALL     XMM_Call
            ExitCode 2
ReleaseUMB ENDP

ReAllocateUMB PROC FAR
Segment       EQU  (WORD PTR [BP+8])
Size          EQU  (WORD PTR [BP+6])
               StackFrameBP
               MOV      AH,xReallocUMB
               MOV      BX,Size
               MOV      DX,Segment
               CALL     XMM_Call
               ExitCode 4
ReAllocateUMB ENDP

UMBMaxAvail PROC FAR
             CMP   [XMSPresent],0
             JE    @@XMS_Error_2
             MOV   AH,xRequestUMB
             MOV   DX,0FFFFh
             MOV   [LastXMSFunction],AH
             MOV   [XMSError],xNoneXMM_Driver
             MOV   [XMSResult],0
             CALL  [XMM_Driver]
             MOV   [XMSResult],AX
             MOV   [XMSError],BL
             MOV   AX,DX
             MOV   BX,16
             MUL   BX
             RET
@@XMS_Error_2:
             CALL  XMSErrorProc
             RET
UMBMaxAvail ENDP


MoveEMBUsers PROC FAR
SourceHandle EQU  (WORD  PTR [BP+20])
SourceOffset EQU  (DWORD PTR [BP+16])
DestHandle   EQU  (WORD  PTR [BP+14])
DestOffset   EQU  (DWORD PTR [BP+10])
Count        EQU  (DWORD PTR [BP+6])
              StackFrameBP
              MOV       ECX,Count
              MOV       DWORD PTR [XMSTr.xTransferSize],ECX
              MOV       CX,SourceHandle
              MOV       WORD PTR [XMSTr.xSourceHandle],CX
              MOV       CX,DestHandle
              MOV       WORD PTR [XMSTr.xDestHandle],CX
              MOV       ECX,SourceOffset
              MOV       DWORD PTR [XMSTr.xSourceOffset],ECX
              MOV       ECX,DestOffset
              MOV       DWORD PTR [XMSTr.xDestOffset],ECX
              MOV       AH,xMoveEMB
              PUSH      DS
              PUSH      CS
              POP       DS
              LEA       SI,XMSTr
              CALL      XMM_Call
              POP       DS
              ExitCode  16
MoveEMBUsers ENDP

    ; Now EMS Part
    ; Functions of EMS Control and EMS Drivers

EMS_Call PROC NEAR
         PUSH  SEG DATA
         POP   GS
         MOV   GS:[EMSError],eNoneEMM_Driver
         CMP   GS:[EMSPresent],0
         JE    @@EMS_Error
         MOV   GS:[LastEMSFunction],AH
         INT   67h
         PUSH  GS
         POP   DS
         MOV   BYTE PTR [EMSError],AH
         MOV   BYTE PTR [EMSError+1],0
         CMP   AH,0
         JE    @@EMS_Ok
@@EMS_Error:
         CALL  EMSErrorProc
         MOV   [EMSError],0
@@EMS_Ok:
         RET
EMS_Call ENDP


OpenEMM       PROC NEAR
               PUSH DS
               MOV  AX,3C00h
               LEA  DX,EMMDriverName
               INT  21h
               MOV  EMMDosHandle,AX
               POP  DS
               RET
OpenEMM       ENDP


CloseEMM      PROC NEAR
               MOV  AX,3Eh
               MOV  BX,EMMDosHandle
               INT  21h
               RET
CloseEMM      ENDP


GetEMM_API    PROC NEAR
               PUSH DS
               CALL OpenEMM
               MOV  BX,EMMDosHandle
               MOV  AX,4402h
               MOV  CX,0006h
               LEA  DX,XMSTr
               INT  21h
               POP  DS
               CALL CloseEMM
               MOV  CX,WORD PTR [XMSTr+2]
               MOV  DX,WORD PTR [XMSTr+4]
               RET
GetEMM_API    ENDP


EMM386Present PROC NEAR
               MOV  AX,0FFA5h
               INT  67h
               CMP  AH,84h
               JNE  @@NoEMM386
               CMP  AL,05Ah
               JE   @@IsEMM386
               CMP  AL,0A5h
               JE   @@IsEMM386
@@NoEMM386:
               STC
               RET
@@IsEMM386:
               MOV  DX,BX
               CLC
               RET
EMM386Present ENDP


QEMMPresent   PROC NEAR
               MOV  AH,3Fh
               MOV  CX,5145h  ;"QE"
               MOV  DX,4D4Dh  ;"MM"
               INT  67h
               CMP  AH,0
               JNE  @@NoQEMM
               MOV  DX,ES
               MOV  CX,DI
               CLC
               RET
@@NoQEMM:
               STC
               RET
QEMMPresent   ENDP


SetDriverType PROC NEAR
               MOV  EMSDriverType,2
               CALL QEMMPresent
               JNC  @@SetAPI
               DEC  EMSDriverType
               CALL EMM386Present
               JNC  @@SetAPI
               DEC  EMSDriverType
               CALL GetEMM_API
@@SetAPI:
               MOV  WORD PTR [EMM_Driver],CX
               MOV  WORD PTR [EMM_Driver+2],DX
               RET
SetDriverType ENDP


IsEMSInstalled PROC NEAR
                XOR AX,AX
                MOV ES,AX
                MOV DI,19Ch
                MOV AX,WORD PTR ES:[DI+2]
                MOV ES,AX
                MOV DI,10
                CLD
                PUSH DS
                MOV SI,SEG EMMDriverName
                MOV DS,SI
                LEA SI,EMMDriverName
                MOV CX,2
                REP CMPSD
                POP  DS
                SETE [EMSPresent]
                RET
IsEMSInstalled ENDP

GetTotalEMSPages PROC NEAR
                  MOV  AH,eGetEMSPages
                  INT  67h
                  MOV  TotalEMSPages,DX
                  RET
GetTotalEMSPages ENDP

GetPageFrame PROC NEAR
              MOV  AH,eGetPageFrame
              INT  67h
              MOV  PageFrame,BX
              RET
GetPageFrame ENDP



GetEMMVersion PROC NEAR
               MOV  AH,eGetEMMVersion
               INT  67h
               MOV  EMMVersion,AL
               RET
GetEMMVersion ENDP

GetEMSHandles PROC NEAR
               MOV  AH,eGetHandleDir
               MOV  AL,02h
               INT  67h
               MOV  TotalEMSHandles,BX
               RET
GetEMSHandles ENDP

GetHardwareInfo PROC NEAR
EMSHardware     EQU  (DWORD PTR [BP+4])
                 StackFrameBP
                 CMP       [EmsPresent],0
                 JE        @@Dont_Get
                 MOV       AH,eGetHardware
                 MOV       AL,0
                 LES       DI,EMSHardware
                 INT       67h
@@Dont_Get:
                 ExitCode  4
GetHardwareInfo ENDP


GetTotalRawPages PROC NEAR
                  MOV  AH,eGetHardware
                  MOV  AL,1
                  INT  67h
                  MOV  TotalRawPages,DX
                  RET
GetTotalRawPages ENDP


InitIvEMS        PROC NEAR
                  CALL IsEMSInstalled
                  CMP  EMSPresent,0
                  JE   @@EMMNotLoaded
                  CALL GetEMMVersion
                  CALL GetPageFrame
                  CALL GetTotalEMSPages
                  CALL GetEMSHandles
                  CALL GetTotalRawPages
                  CALL SetDriverType
                  MOV  EMSExchange,0
                  MOV  AX,DS
                  MOV  GS,AX
@@EMMNotLoaded:
                  RET
InitIvEMS        ENDP


AvailEMSPages    PROC FAR
                  MOV  AH,eGetEMSPages
                  CALL EMS_Call
                  MOV  AX,BX
                  RET
AvailEMSPages    ENDP


ActiveEMSHandles PROC FAR
                  MOV  AH,eGetHandlesNum
                  CALL EMS_Call
                  MOV  AX,BX
                  RET
ActiveEMSHandles ENDP


AllocateEMS PROC FAR
Size        EQU  (WORD PTR [BP+6])
             StackFrameBP
             MOV       AH,eAllocateEMS
             MOV       BX,Size
             CALL      EMS_Call
             MOV       AX,DX
             ExitCode  2
AllocateEMS ENDP


ReleaseEMS  PROC FAR
Handle      EQU (WORD PTR [BP+6])
             StackFrameBP
             MOV       AH,eReleaseEMS
             MOV       DX,Handle
             CALL      EMS_Call
             MOV       AX,DX
             ExitCode  2
ReleaseEMS  ENDP

MapEMSPages   PROC FAR
Handle        EQU  (WORD PTR [BP+10])
Logical_Page  EQU  (WORD PTR [BP+8])
Phisical_Page EQU  (BYTE PTR [BP+6])
               StackFrameBP
               MOV  AH,eMapEMS
               MOV  AL,Phisical_Page
               MOV  BX,Logical_Page
               MOV  DX,Handle
               CALL EMS_Call
               ExitCode 6
MapEMSPages   ENDP


Handle                EQU (WORD PTR [BP+6])
SaveMappingContext    PROC FAR
                       StackFrameBP
                       MOV AH,47h
                       JMP @@Save_Context
RestoreMappingContext PROC FAR
                       StackFrameBP
                       MOV AH,48h
@@Save_Context:
                       CALL EMS_Call
                       ExitCode 4
RestoreMappingContext ENDP
SaveMappingContext    ENDP


GetEMS_HandlePages PROC FAR
Handle             EQU (WORD PTR [BP+6])
                    StackFrameBP
                    MOV       AH,eGetHandlePages
                    MOV       DX,Handle
                    CALL      EMS_Call
                    ExitCode  2
GetEMS_HandlePages ENDP


GetEMSHandlesTable PROC FAR
Table              EQU  (DWORD PTR [BP+6])
                    StackFrameBP
                    LES       DI,Table
                    MOV       AX,WORD PTR ES:[DI+2]
                    MOV       DI,WORD PTR ES:[DI]
                    MOV       ES,AX
                    MOV       AH,eGetEMSTable
                    CALL      EMS_Call
                    MOV       AX,BX
                    ExitCode  4
GetEMSHandlesTable ENDP


ReallocateEMS PROC FAR
Handle        EQU  (WORD PTR [BP+8])
Size          EQU  (WORD PTR [BP+6])
               StackFrameBP
               MOV       AH,eReallocateEMS
               MOV       DX,Handle
               MOV       BX,Size
               CALL      EMS_Call
               ExitCode  4
ReallocateEMS ENDP


GetEMS_HandleAttr PROC FAR
Handle            EQU  (WORD PTR [BP+6])
                   StackFrameBP
                   MOV       AH,eGetSetAttrib
                   MOV       AL,0
                   MOV       DX,Handle
                   CALL      EMS_Call
                   ExitCode  2
GetEMS_HandleAttr ENDP

SetEMS_HandleAttr PROC FAR
Handle            EQU  (WORD PTR [BP+8])
Attr              EQU  (BYTE PTR [BP+6])
                   StackFrameBP
                   MOV       AH,eGetSetAttrib
                   MOV       AL,1
                   MOV       BL,Attr
                   MOV       DX,Handle
                   CALL      EMS_Call
                   ExitCode  4
SetEMS_HandleAttr ENDP


GetEMS_HandleName PROC FAR
Handle            EQU  (WORD  PTR [BP+10])
HName             EQU  (DWORD PTR [BP+6])
                   StackFrameBP
                   MOV       AH,eGetSetName
                   MOV       AL,00
                   MOV       DX,HAndle
                   LES       DI,HName
                   CALL      EMS_Call
                   ExitCode  6
GetEMS_HandleName ENDP


SetEMS_HandleName PROC FAR
Handle            EQU  (WORD  PTR [BP+10])
HName             EQU  (DWORD PTR [BP+6])
                   StackFrameBP
                   MOV       AH,eGetSetName
                   MOV       AL,1
                   LDS       SI,HName
                   CALL      EMS_Call
                   ExitCode  6
SetEMS_HandleName ENDP


FindEMS_Handle    PROC FAR
HName             EQU  (DWORD PTR [BP+6])
                   StackFrameBP
                   MOV       AH,eGetHandleDir
                   MOV       AL,1
                   LDS       SI,HName
                   PUSH      AX
                   MOV       AX,SEG DATA
                   MOV       GS,AX
                   POP       AX
                   MOV       GS:[EMSError],eNoneEMM_Driver
                   CMP       GS:[EMSPresent],0
                   JE        @@EMS_Error_1
                   MOV       GS:[LastEMSFunction],AH
                   INT       67h
                   PUSH  AX
                   MOV   AX,SEG DATA
                   MOV   DS,AX
                   POP   AX
                   MOV       BYTE PTR [EMSError],AH
                   MOV       BYTE PTR [EMSError+1],0
                   CMP       AH,0
                   JE        @@EMS_Ok
                   CMP       AH,0A1h
                   JE        @@NoneHandle_1
@@EMS_Error_1:
                   CALL      EMSErrorProc
                   MOV       [EMSError],0
                   JMP       @@EMS_Ok_1
@@NoneHandle_1:
                   MOV       DX,0
@@EMS_Ok_1:
                   MOV       AX,DX
                   ExitCode  4
FindEMS_Handle    ENDP


MoveEMSUsers  PROC FAR
SourceHandle  EQU  (WORD  PTR [BP+24])
SourceType    EQU  (BYTE  PTR [BP+22])
SourceOffset  EQU  (DWORD PTR [BP+18])
DestHandle    EQU  (WORD  PTR [BP+16])
DestType      EQU  (BYTE  PTR [BP+14])
DestOffset    EQU  (DWORD PTR [BP+10])
Count         EQU  (DWORD PTR [BP+6])
               StackFrameBP
               MOV       EAX,Count
               MOV       DWORD PTR [EMSTr.eTransferSize],EAX
               MOV       AX,SourceHandle
               MOV       WORD PTR [EMSTr.eSourceHandle],AX
               MOV       AX,DestHandle
               MOV       WORD PTR [EMSTr.eDestHandle],AX
               MOV       AL,SourceType
               MOV       BYTE PTR [EMSTr.eSourceType],AL
               MOV       AL,DestType
               MOV       BYTE PTR [EMSTr.eDestType],AL
               MOV       EAX,DestOffset
               MOV       DWORD PTR [EMSTr.eDestOffset],EAX
               MOV       EAX,SourceOffset
               MOV       DWORD PTR [EMSTr.eSourceOffset],EAX
               LEA       SI,EMSTr
               MOV       AH,eMoveEMS
               MOV       AL,EMSExchange
               CALL      EMS_Call
               ExitCode  20
MoveEMSUsers  ENDP

WarmBootPrepare PROC FAR
                 MOV  AH,eWarmBootPrep
                 CALL EMS_Call
                 RET
WarmBootPrepare ENDP


GetFreeRawPages PROC FAR
                 MOV  AH,eGetHardware
                 MOV  AL,01h
                 CALL EMS_Call
                 MOV  AX,BX
                 RET
GetFreeRawPages ENDP


AllocateRAWPages PROC FAR
Size             EQU  (WORD PTR [BP+6])
                  StackFrameBP
                  MOV       AH,eAllocateRAW
                  MOV       AL,1
                  MOV       BX,Size
                  CALL      EMS_Call
                  MOV       AX,DX
                  ExitCode  2
AllocateRAWPages ENDP


MapUnmapPages PROC FAR
Handle        EQU  (WORD PTR [BP+14])
MapType       EQU  (BYTE PTR [BP+12])
MapTable      EQU  (DWORD PTR [BP+8])
TableSize     EQU  (WORD PTR [BP+6])
               StackFrameBP
               MOV       AH,eMapUnmapHandle
               MOV       AL,MapType
               MOV       DX,Handle
               MOV       CX,Size
               LDS       SI,MapTable
               CALL      EMS_Call
               ExitCode  10
MapUnmapPages ENDP


EMM386_Call_API PROC NEAR
                 PUSH      AX
                 MOV       AX,SEG DATA
                 MOV       GS,AX
                 POP       AX
                 CMP       BYTE PTR GS:[EMSDriverType],1 ; EMM386 Present
                 JNE       @@EMM386_Not
                 CALL      DWORD PTR GS:[EMM_Driver]
                 JMP       @@EMM386_Ok
@@EMM386_Not:
                 PUSH      SEG DATA
                 POP       GS
                 MOV       GS:[EmsError],eNoThisDriver
                 CALL      GS:[EMSErrorProc]
@@EMM386_Ok:
                 RET
EMM386_Call_API ENDP


QEMM_Call_API PROC NEAR
               PUSH      AX
               MOV       AX,SEG DATA
               MOV       GS,AX
               POP       AX
               CMP       BYTE PTR GS:[EMSDriverType],2  ; QEMM Present
               JNE       @@EMM386_Not
               CALL      DWORD PTR GS:[EMM_Driver]
               JMP       @@Qemm_Ok
@@QEMM_Not:
               PUSH      SEG DATA
               POP       GS
               MOV       GS:[EmsError],eNoThisDriver
               CALL      GS:[EMSErrorProc]
@@Qemm_Ok:

               RET
QEMM_Call_API ENDP


QEMM_GetState PROC FAR
               MOV  AH,eQEMM_GetState
               CALL QEMM_Call_API
               RET
QEMM_GetState ENDP


QEMM_SetState PROC FAR
State         EQU  (BYTE PTR [BP+6])
               StackFrameBP
               MOV       AL,State
               MOV       AH,eQEMM_SetState
               CALL      QEMM_Call_API
               ExitCode  2
QEMM_SetState ENDP


QEMM_GetVersion PROC FAR
                 MOV  AH,eQEMM_GetVersion
                 CALL QEMM_Call_API
                 RET
QEMM_GetVersion ENDP


EMM386_GetState PROC FAR
                 MOV   AH,eEMM386_GetState
                 CALL  EMM386_Call_API
                 MOV   AL,AH
                 RET
EMM386_GetState ENDP

EMM386_SetState PROC FAR
State           EQU  (BYTE PTR [BP+6])
                 StackFrameBP
                 MOV       AH,eEMM386_SetState
                 MOV       AL,State
                 CALL      EMM386_Call_API
                 ExitCode  2
EMM386_SetState ENDP


EMM386_GetWeitekSupport PROC FAR
                         MOV   AH,eEMM386_GetWeitekState
                         MOV   AL,0
                         CALL  EMM386_Call_API
                         RET
EMM386_GetWeitekSupport ENDP


EMM386_SetWeitekSupport PROC FAR
State                    EQU  (BYTE PTR [BP+6])
                         StackFrameBP
                         MOV       AH,eEMM386_GetWeitekState
                         MOV       AL,3
                         SUB       AH,State
                         CALL      EMM386_Call_API
                         ExitCode  2
EMM386_SetWeitekSupport ENDP


EMM386_PrintCopyright PROC FAR
                       MOV   AH,eEMM386_PrintCopyright
                       CALL  EMM386_Call_API
                       RET
EMM386_PrintCopyright ENDP


EMM386_PrintReport PROC FAR
                   MOV   AH,eEMM386_PrintReport
                   CALL  EMM386_Call_API
                   RET
EMM386_PrintReport ENDP


QEMM_GetHiramChain PROC FAR
                    MOV   AX,0D201h
                    MOV   BX,4849h ;"HI"
                    MOV   CX,5241h ;"RA"
                    MOV   DX,4D30h ;"M0"
                    INT   2Fh
                    CMP   BX,4F4Bh ;"OK"
                    JE    @@SetCX
                    XOR   AX,AX
                    JMP   @@SetZero
@@SetCX:
                    MOV  AX,CX
@@SetZero:
                    RET
QEMM_GetHiramChain ENDP


QEMM_GetManifestPresent PROC FAR
                         MOV   AX,0D201h
                         MOV   BX,4D41h ;"MA"
                         MOV   CX,4E49h ;"NI"
                         MOV   DX,4645h ;"FE"
                         INT   2Fh
                         XOR   AL,AL
                         CMP   BX,5354h ;"ST"
                         JNE    @@SetAL_End
                         INC   AL
@@SetAL_End:
                         RET
QEMM_GetManifestPresent ENDP


QEMM_Copy_Stealth_Roms PROC FAR
Source                 EQU  SS:[BX+10]
Dest                   EQU  SS:[BX+6]
Size                   EQU  SS:[BX+4]
                        StackFrame BX
                        PUSH       DS
                        MOV        AH,eQEMM_Copy_Stealth_Roms
                        LDS        SI,Source
                        LES        DI,Dest
                        MOV        ECX,Size
                        CALL       QEMM_Call_API
                        POP        DS
                        RET        10
QEMM_Copy_Stealth_Roms ENDP


QEMM_UntrappedIORead PROC FAR
Port                 EQU  SS:[BX+4]
                      StackFrame BX
                      MOV        AX,eQEMM_UntrappedIORead
                      MOV        DX,Port
                      CALL       QEMM_Call_API
                      RET        2
QEMM_UntrappedIORead ENDP


QEMM_UntrappedIOWrite PROC FAR
Port                  EQU  SS:[BX+6]
Value                 EQU  SS:[BX+4]
                       StackFrame BX
                       MOV        AX,eQEMM_UntrappedIOWrite
                       MOV        DX,Port
                       MOV        BL,Value
                       CALL       QEMM_Call_API
                       RET        4
QEMM_UntrappedIOWrite ENDP


QEMM_UntrappedIOReadIndexed  PROC FAR
Port                         EQU  SS:[BX+6]
Index                        EQU  SS:[BX+4]
                              StackFrame BX
                              MOV        AX,eQEMM_UntrappedIOReadIndexed
                              MOV        DX,Port
                              MOV        BH,Index
                              CALL       QEMM_Call_API
                              MOV        BL,AL
                              RET        4
QEMM_UntrappedIOReadIndexed  ENDP


QEMM_UntrappedIOWriteIndexed  PROC FAR
Port                          EQU  SS:[BX+8]
Index                         EQU  SS:[BX+6]
Value                         EQU  SS:[BX+4]
                               StackFrame BX
                               MOV        AX,eQEMM_UntrappedIOWriteIndexed
                               MOV        DH,Index
                               MOV        DL,Value
                               MOV        BX,DX
                               MOV        DX,Port
                               CALL       QEMM_Call_API
                               MOV        BL,AL
                               RET        6
QEMM_UntrappedIOWriteIndexed  ENDP


QEMM_GetIOCallback PROC FAR
                    MOV  AX,eQEMM_GetIOCallback
                    CALL QEMM_Call_API
                    MOV  DX,ES
                    MOV  AX,DI
                    RET
QEMM_GetIOCallback ENDP


QEMM_SetIOCallback PROC FAR
NewCallback        EQU SS:[BX+4]
                    StackFrame BX
                    MOV        AX,eQEMM_SetIOCallback
                    LES        DI,NewCallback
                    CALL       QEMM_Call_API
                    RET        2
QEMM_SetIOCallback ENDP


QEMM_GetPortTrap PROC FAR
Port             EQU  SS:[BX+4]
                  StackFrame BX
                  MOV        AX,eQEMM_GetPortTrap
                  MOV        DX,Port
                  CALL       QEMM_Call_API
                  RET        2
QEMM_GetPortTrap ENDP


QEMM_SetPortTrap PROC FAR
Port             EQU  SS:[BX+4]
                  StackFrame BX
                  MOV        AX,eQEMM_SetPortTrap
                  MOV        DX,Port
                  CALL       QEMM_Call_API
                  RET        2
QEMM_SetPortTrap ENDP


QEMM_ClearPortTrap PROC FAR
Port               EQU  SS:[BX+4]
                    StackFrame BX
                    MOV        AX,eQEMM_ClearPortTrap
                    MOV        DX,Port
                    CALL       QEMM_Call_API
                    RET        2
QEMM_ClearPortTrap ENDP


QEMM_GetStealthCount PROC FAR
                      MOV   AX,eQEMM_GetStealthCount
                      CALL  QEMM_Call_API
                      MOV   AX,BX
                      RET
QEMM_GetStealthCount ENDP


QEMM_GetInfo PROC FAR
InfoRec      EQU  (DWORD PTR [BP+6])
              StackFrameBP
              MOV        AX,eQEMM_GetInfo
              CALL       QEMM_Call_API
              LES        DI,InfoRec
              MOV        ES:[DI],BX
              MOV        ES:[DI+2],CX
              MOV        ES:[DI+4],DL
              ExitCode   4
QEMM_GetInfo ENDP


QEMM_GetMemoryStatistics PROC FAR
InfoRecord               EQU  (DWORD PTR [BP+6])
                          StackFrame BP
                          MOV       AH,eQEMM_GetMemoryStatistics
                          LES       DI,InfoRecord
                          CALL      QEMM_Call_API
                          ExitCode  4
QEMM_GetMemoryStatistics ENDP


QEMM_GetStealthList PROC FAR
                     MOV       AX, eQEMM_GetStealthList
                     CALL      QEMM_Call_API
                     MOV       DX, ES
                     MOV       AX, DI
                     RET
QEMM_GetStealthList ENDP


CODE ENDS

     END

