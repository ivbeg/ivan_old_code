include ASMMACRO.INC



DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA



   EXTRN    XMS_Present              : BYTE
   EXTRN    XMS_HandlesTable         : DWORD
   EXTRN    XMS_Version              : WORD
   EXTRN    XMS_Revision             : WORD
   EXTRN    HMA_Present              : BYTE
   EXTRN    XMM_DriverAPI            : DWORD
   EXTRN    XMS_Result               : TFunctionResult


   EXTRN    EMS_Present              : BYTE
   EXTRN    EMS_Version              : BYTE
   EXTRN    PageFrame                : WORD
   EXTRN    TotalRAWPages            : WORD
   EXTRN    TotalEMSPages            : WORD
   EXTRN    TotalEMSHandles          : WORD
   EXTRN    EMS_DriverType           : BYTE
   EXTRN    EMM_DriverAPI            : DWORD
   EXTRN    EMS_Exchange             : BYTE
   EXTRN    EMS_Result               : TFunctionResult


multi_XmsDriverCheck               EQU  4300h
multi_HIMEM_GetA20Handler          EQU  4308h
multi_HIMEM_GetXmsHandlesTable     EQU  4309h
multi_GetXmsDriverAPI              EQU  4310h
multi_HIMEM_GetExtA20Handler       EQU  4330h


xms_GetXMSVersion                  EQU  00h
xms_RequestHMA                     EQU  01h
xms_ReleaseHMA                     EQU  02h
xms_GlobalEnableA20                EQU  03h
xms_GlobalDisableA20               EQU  04h
xms_LocalEnableA20                 EQU  05h
xms_LocalDisableA20                EQU  06h
xms_QueryA20State                  EQU  07h
xms_QueryFreeExtMemory             EQU  08h
xms_AllocateEMB                    EQU  09h
xms_FreeEMB                        EQU  0Ah
xms_MoveEMB                        EQU  0Bh
xms_LockEMB                        EQU  0Ch
xms_UnlockEMB                      EQU  0Dh
xms_GetHandleInfo                  EQU  0Eh
xms_ReallocateEMB                  EQU  0Fh
xms_RequestUMB                     EQU  10h
xms_ReallocateUMB                  EQU  11h
xms_ReleaseUMB                     EQU  12h
xms_QueryFreeExtMemory30           EQU  88h
xms_AllocateAnyExtMemory           EQU  89h
xms_GetEMBHandleInfo               EQU  8Eh
xms_ReallocateAnyExtMemory         EQU  8Fh


xms_error_NoDriver                 EQU  80h


ems_QEMMPresent                    EQU  3Fh

ems_GetEMSStatus                   EQU  40h
ems_GetPageFrame                   EQU  41h
ems_GetEMSPages                    EQU  42h
ems_AllocateEMS                    EQU  43h
ems_MapEMS                         EQU  44h
ems_ReleaseEMS                     EQU  45h
ems_GetEMSVersion                  EQU  46h
ems_SaveContext                    EQU  47h
ems_RestoreContext                 EQU  48h
ems_GetHandlesCount                EQU  4Bh
ems_GetHandlePages                 EQU  4Ch
ems_GetEMSTable                    EQU  4Dh
ems_GetSetPageMap                  EQU  4Eh
ems_GetSetPPageMap                 EQU  4Fh
ems_MapUnmapHandle                 EQU  50h
ems_ReallocateEMS                  EQU  51h
ems_GetSetAttrib                   EQU  52h
ems_GetSetHandleName               EQU  53h
ems_GetHandleDirectory             EQU  54h
ems_MoveEMS                        EQU  57h
ems_GetMapArray                    EQU  58h
ems_GetHardwareInfo                EQU  59h
ems_AllocateRAWPages               EQU  5Ah
ems_AltMapRegSet                   EQU  5Bh
ems_WarmBootPrepare                EQU  5Ch

ems_EMM386Present                  EQU  0FFA5h


ems_error_WrongDriver              EQU  0100h
ems_error_NoDriver                 EQU  080h


manager_EMM386_GetState            EQU  00h
manager_EMM386_SetState            EQU  01h
manager_EMM386_GetWeitekSupport    EQU  02h
manager_EMM386_PrintCopyright      EQU  04h
manager_EMM386_PrintReport         EQU  05h

manager_QEMM_GetState              EQU  00h
manager_QEMM_SetState              EQU  01h
manager_QEMM_GetVersion            EQU  03h
manager_QEMM_GetHiramChain         EQU  12h
manager_QEMM_GetMemoryStatistics   EQU  17h
manager_QEMM_UntrappedIORead       EQU  1A00h
manager_QEMM_UntrappedIOWrite      EQU  1A01h
manager_QEMM_UntrappedIOIndexRead  EQU  1A02h
manager_QEMM_UntrappedIOIndexWrite EQU  1A03h
manager_QEMM_GetIOCallback         EQU  1A06h
manager_QEMM_SetIOCallback         EQU  1A07h
manager_QEMM_GetPortTrap           EQU  1A08h
manager_QEMM_SetPortTrap           EQU  1A09h
manager_QEMM_ClearPortTrap         EQU  1A0Ah
manager_QEMM_GetInfo               EQU  1E00h
manager_QEMM_GetStealthCount       EQU  1E01h
manager_QEMM_GetStealthList        EQU  1E02h
manager_QEMM_CopyStealthRoms       EQU  21h


manager_type_Unknown               EQU  00h
manager_type_EMM386                EQU  01h
manager_type_QEMM                  EQU  02h
manager_type_386MAX                EQU  03h


dos_OpenFile                       EQU  3Ch
dos_CloseFile                      EQU  3Eh
dos_IORead                         EQU  4402h


XmsTrRec   STRUC
   xTransferSize  DD 000000h
   xSourceHandle  DW 0000h
   xSourceOffset  DD 000000h
   xDestHandle    DW 0000h
   xDestOffset    DD 000000h
XmsTrRec   ENDS


EmsTrRec   STRUC
   eTransferSize  DD 0000h
   eSourceType    DB 00h
   eSourceHandle  DW 0000h
   eSourceOffset  DD 000000h
   eDestType      DB 00h
   eDestHandle    DW 0000h
   eDestOffset    DD 000000h
EmsTrRec   ENDS


DATA  ENDS



CODE  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA


      PUBLIC  ReleaseHMA, AllocateHMA
      PUBLIC  GlobalEnableA20, GlobalDisableA20
      PUBLIC  LocalEnableA20, LocalDisableA20, QueryA20

      PUBLIC  GetFreeXMS, GetMaxFreeXMSBlock
      PUBLIC  AllocateEMB, ReleaseEMB, ReallocateEMB
      PUBLIC  LockEMB, UnlockEMB, GetEMBSize, MoveEMBUsers
      PUBLIC  GetEMBLockCount, GetEMBFreeHandles
      PUBLIC  AllocateUMB, ReleaseUMB, ReallocateUMB
      PUBLIC  UMBMaxAvail


      PUBLIC  GetFreeEMSPages, GetActiveEMSHandles
      PUBLIC  AllocateEMS, ReleaseEMS, MapEMSPages
      PUBLIC  GetEMSHandlePages, GetEMSHandlesTable
      PUBLIC  ReallocateEMS, MoveEMSUsers
      PUBLIC  GetEMS_HandleAttr, SetEMS_HandleAttr
      PUBLIC  GetEMS_HandleName, SetEMS_HandleName, FindEMS_Handle
      PUBLIC  WarmBootPrepare, GetFreeRawPages
      PUBLIC  AllocateRawPages, MapUnmapPages
      PUBLIC  GetHardwareInfo


      PUBLIC  EMM386_GetState, EMM386_SetState
      PUBLIC  EMM386_GetWeitekSupport, EMM386_SetWeitekSupport
      PUBLIC  EMM386_PrintReport, EMM386_PrintCopyright


      PUBLIC  QEMM_GetState, QEMM_SetState
      PUBLIC  QEMM_GetVersion, QEMM_GetHiramChain
      PUBLIC  QEMM_GetManifestPresent, QEMM_CopyStealthRoms
      PUBLIC  QEMM_UntrappedIORead, QEMM_UntrappedIOWrite
      PUBLIC  QEMM_UntrappedIOReadIndexed, QEMM_UntrappedIOWriteIndexed
      PUBLIC  QEMM_GetIOCallback, QEMM_SetIOCallback
      PUBLIC  QEMM_GetPortTrap, QEMM_SetPortTrap, QEMM_ClearPortTrap
      PUBLIC  QEMM_GetStealthCount, QEMM_GetInfo
      PUBLIC  QEMM_GetMemoryStatistics, QEMM_GetStealthList


      PUBLIC  InitTXms, InitTEms


XmsTr    XmsTrRec <0, 0, 0, 0, 0>
EmsTr    EmsTrRec <0, 0, 0, 0, 0, 0, 0>

EmsDriverName    DB 'EMMXXXX0'
ems_DriverHandle DW 0000h

       .386


XMM_Call  PROC NEAR
   macro_SetDATA_GS
   MOV        GS:[XMS_Result].Result, 0000h
   CMP        GS:[XMS_Present], boolean_False
   JE         @@XMM_Call_NoDriver
   MOV        GS:[XMS_Result].Function, AX
   CALL       DWORD PTR GS:[XMM_DriverAPI]
   PUSH       GS
   POP        DS
   CMP        AX, boolean_False
   JNE        @@XMM_Call_End
   MOV        BYTE PTR [XMS_Result].Result, BL
   MOV        BYTE PTR [XMS_Result].Result+1, 00h
   JMP        @@XMM_Call_Error
@@XMM_Call_NoDriver:
   MOV        GS:[XMS_Result].Result, xms_error_NoDriver
@@XMM_Call_Error:
   CALL       DWORD PTR GS:[XMS_Result].ErrorProc
@@XMM_Call_End:
   RET
XMM_Call  ENDP



InitTXMS  PROC NEAR
   MOV       XMS_Present, boolean_False
   MOV       AX, multi_XMSDriverCheck
   INT       2Fh
   CMP       AL, 80h
   JNE       @@InitTXMS_End
   MOV       XMS_Present, boolean_True
   MOV       AX, multi_GetXMSDriverAPI
   INT       2Fh
   MOV       WORD PTR [XMM_DriverAPI], BX
   MOV       WORD PTR [XMM_DriverAPI+2], ES
   MOV       AH, xms_GetXMSVersion
   CALL      DWORD PTR [XMM_DriverAPI]
   MOV       [HMA_Present], DL
   MOV       [XMS_Version], AX
   MOV       [XMS_Revision], BX
   MOV       AX, multi_HIMEM_GetXmsHandlesTable
   INT       2Fh
   CMP       AL, 43h
   JE        @@InitTXMS_TablePresent
   MOV       WORD PTR [XMS_HandlesTable], 0000h
   MOV       WORD PTR [XMS_HandlesTable+2], 0000h
   JMP       @@InitTXMS_End
@@InitTXMS_TablePresent:
   MOV       WORD PTR [XMS_HandlesTable], BX
   MOV       WORD PTR [XMS_HandlesTable+2], ES
@@InitTXMS_End:
   RET
InitTXMS  ENDP


    ; HMA control functions
ReleaseHMA  PROC FAR
   MOV       AH, xms_ReleaseHMA
   CALL      XMM_Call
   RET
ReleaseHMA  ENDP


AllocateHMA  PROC FAR
  HMASize      EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_RequestHMA
   MOV       DX, HMASize
   CALL      XMM_Call
   RET       2
AllocateHMA  ENDP


    ; Line A20 control functions
GlobalEnableA20  PROC FAR
   MOV       AH, xms_GlobalEnableA20
   CALL      XMM_Call
   RET
GlobalEnableA20  ENDP


GlobalDisableA20  PROC FAR
   MOV       AH, xms_GlobalDisableA20
   CALL      XMM_Call
   RET
GlobalDisableA20  ENDP


LocalEnableA20  PROC FAR
   MOV       AH, xms_LocalEnableA20
   CALL      XMM_Call
   RET
LocalEnableA20  ENDP


LocalDisableA20  PROC FAR
   MOV       AH, xms_LocalEnableA20
   CALL      XMM_Call
   RET
LocalDisableA20  ENDP


QueryA20  PROC FAR
   MOV       AH, xms_QueryA20State
   CALL      XMM_Call
   RET
QueryA20  ENDP



   ; Free XMS functions
GetFreeXMS  PROC FAR
   MOV       AH, xms_QueryFreeExtMemory
   CALL      XMM_Call
   MOV       AX, DX
   RET
GetFreeXMS  ENDP


GetMaxFreeXMSBlock  PROC FAR
   MOV       AH, xms_QueryFreeExtMemory
   CALL      XMM_Call
   RET
GetMaxFreeXMSBlock  ENDP


    ; EMB control functions

AllocateEMB  PROC FAR
  EMBSize      EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_AllocateEMB
   MOV       DX, EMBSize
   CALL      XMM_Call
   MOV       AX, DX
   RET       2
AllocateEMB  ENDP


ReleaseEMB  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_FreeEMB
   MOV       DX, Handle
   CALL      XMM_Call
   RET       2
ReleaseEMB  ENDP


ReallocateEMB  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+6])
  EMBSize      EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_ReallocateEMB
   MOV       BX, EMBSize
   MOV       DX, Handle
   CALL      XMM_Call
   RET       4
ReallocateEMB  ENDP


LockEMB  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_LockEMB
   MOV       DX, Handle
   CALL      XMM_Call
   MOV       AX, BX
   RET       2
LockEMB  ENDP


UnlockEMB  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_UnlockEMB
   MOV       DX, Handle
   CALL      XMM_Call
   RET       2
UnlockEMB  ENDP


GetEMBSize  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_GetHandleInfo
   MOV       DX, Handle
   CALL      XMM_Call
   MOV       AX, DX
   RET       2
GetEMBSize  ENDP


GetEMBLockCount  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_GetHandleInfo
   MOV       DX, Handle
   CALL      XMM_Call
   MOV       AL, BH
   RET       2
GetEMBLockCount  ENDP


GetEMBFreeHandles  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_GetHandleInfo
   MOV       DX, Handle
   CALL      XMM_Call
   MOV       AL, BL
   RET       2
GetEMBFreeHandles  ENDP


    ; UMB control functions
AllocateUMB  PROC FAR
  UMBSize      EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_RequestUMB
   MOV       DX, UMBSize
   CALL      XMM_Call
   MOV       AX, BX
   RET       2
AllocateUMB  ENDP


ReleaseUMB  PROC FAR
  Segment      EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_ReleaseUMB
   MOV       DX, Segment
   CALL      XMM_Call
   RET       2
ReleaseUMB  ENDP


ReallocateUMB  PROC FAR
  Segment      EQU  (WORD PTR SS:[BX+6])
  UMBSize      EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, xms_ReallocateUMB
   MOV       DX, Segment
   MOV       BX, UMBSize
   CALL      XMM_Call
   RET       4
ReallocateUMB  ENDP


UMBMaxAvail  PROC FAR
   MOV       AH, xms_RequestUMB
   MOV       DX, 0FFFFh
   macro_SetDATA_GS
   MOV        GS:[XMS_Result].Result, 0000h
   CMP        GS:[XMS_Present], boolean_False
   JE         @@UMBMaxAvail_NoDriver
   MOV        GS:[XMS_Result].Function, AX
   CALL       DWORD PTR GS:[XMM_DriverAPI]
   PUSH       GS
   POP        DS
   MOV        AX,DX
   MOV        BX,16
   MUL        BX
   JMP        @@UMBMaxAvail_End
@@UMBMaxAvail_NoDriver:
   MOV        GS:[XMS_Result].Result, xms_error_NoDriver
@@UMBMaxAvaill_Error:
   CALL       DWORD PTR GS:[XMS_Result].ErrorProc
@@UMBMaxAvail_End:
   RET
UMBMaxAvail  ENDP


MoveEMBUsers  PROC FAR
  SourceHandle EQU  (WORD PTR SS:[BX+18])
  SourceOffset EQU  (DWORD PTR SS:[BX+14])
  DestHandle   EQU  (WORD PTR SS:[BX+12])
  DestOffset   EQU  (DWORD PTR SS:[BX+8])
  Count        EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       ECX, Count
   MOV       DWORD PTR [XmsTr.xTransferSize], ECX
   MOV       CX, SourceHandle
   MOV       WORD PTR [XmsTr.xSourceHandle], CX
   MOV       CX, DestHandle
   MOV       WORD PTR [XmsTr.xDestHandle], CX
   MOV       ECX, SourceOffset
   MOV       DWORD PTR [XmsTr.xSourceOffset], ECX
   MOV       ECX, DestOffset
   MOV       DWORD PTR [XmsTr.xDestOffset], ECX
   MOV       AH, xms_MoveEMB
   PUSH      DS
   PUSH      CS
   POP       DS
   LEA       SI, XmsTr
   CALL      XMM_Call
   POP       DS
   RET       16
MoveEMBUsers  ENDP


EMS_Call  PROC FAR
   macro_SetDATA_GS
   MOV       GS:[EMS_Result].Result, ems_error_NoDriver
   CMP       GS:[EMS_Present], boolean_False
   JE        @@EMS_Call_Error
   MOV       GS:[EMS_Result].Function, AX
   MOV       GS:[EMS_Result].Interrupt, 67h
   INT       67h
   PUSH      GS
   POP       DS
   MOV       BYTE PTR [EMS_Result].Result, AH
   MOV       BYTE PTR [EMS_Result].Result+1, 00h
   CMP       AH, boolean_False
   JE        @@EMS_Call_End
@@EMS_Call_Error:
   CALL      [EMS_Result].ErrorProc
   MOV       [EMS_Result].Result, 00h
@@EMS_Call_End:
   RET
EMS_Call  ENDP


Open_EMMXXX0  PROC NEAR
   PUSH      DS
   MOV       AX, dos_OpenFile
   LEA       DX, EmsDriverName
   INT       21h
   MOV       ems_DriverHandle, AX
   POP       DS
   RET
Open_EMMXXX0  ENDP


Close_EMMXXX0  PROC NEAR
   MOV       AX, dos_CloseFile
   MOV       BX, ems_DriverHandle
   INT       21h
   RET
Close_EMMXXX0  ENDP


GetEMM_API  PROC NEAR
   PUSH      DS
   CALL      Open_EMMXXX0
   MOV       BX, ems_DriverHandle
   MOV       AX, dos_IORead
   MOV       CX, 0006h
   LEA       DX, EMSTr
   INT       21h
   POP       DS
   CALL      Close_EMMXXX0
   MOV       CX, WORD PTR [EMSTr+2]
   MOV       DX, WORD PTR [EMSTr+4]
   RET
GetEMM_API  ENDP



GetEMM386Present  PROC NEAR
   MOV       AX, ems_EMM386Present
   INT       67h
   CMP       AH, 84h
   JNE       @@GetEMM386Present_IsNot
   CMP       AL, 0A5h
   JE        @@GetEMM386Present_Is
   CMP       AL, 0A5h
   JE        @@GetEMM386Present_Is
@@GetEMM386Present_IsNot:
   CLC
   RET
@@GetEMM386Present_Is:
   MOV       DX, BX
   STC
   RET
GetEMM386Present  ENDP


GetQEMMPresent  PROC NEAR
   MOV       AH, ems_QEMMPresent
   MOV       CX, 5145h           ;"QE"
   MOV       DX, 4D4Dh           ;"MM"
   INT       67h
   CMP       AH, 0
   JNE       @@GetQEMMPresent_No
   MOV       DX, ES
   MOV       CX, DI
   STC
   RET
@@GetQEMMPresent_No:
   CLC
   RET
GetQEMMPresent  ENDP


SetEmsDriverType  PROC NEAR
   MOV       EMS_DriverType, manager_type_QEMM
   CALL      GetQEMMPresent
   JC        @@SetEmsDriverType_SetAPI
   MOV       EMS_DriverType, manager_type_EMM386
   CALL      GetEMM386Present
   JC        @@SetEmsDriverType_SetAPI
;   MOV       EMS_DriverType, manager_type_386MAX
;   CALL      Get386MaxPresent
;   JC        @@SetEmsDriverType_SetAPI
   MOV       EMS_DriverType, manager_type_Unknown
   CALL      GetEMM_API
@@SetEmsDriverType_SetAPI:
   MOV       WORD PTR [EMM_DriverAPI], CX
   MOV       WORD PTR [EMM_DriverAPI+2], DX
   RET
SetEmsDriverType  ENDP


GetEmsPresent  PROC NEAR
   XOR       AX, AX
   MOV       ES, AX
   MOV       DI, 19Ch
   MOV       AX, WORD PTR ES:[DI+2]
   MOV       ES, AX
   MOV       DI, 10
   CLD
   PUSH      DS
   MOV       SI, SEG EmsDriverName
   MOV       DS, SI
   LEA       SI, EmsDriverName
   MOV       CX, 2
   REP       CMPSD
   POP       DS
   SETE      [EMS_Present]
   RET
GetEmsPresent  ENDP


GetTotalEMSPages  PROC NEAR
   MOV       AH, ems_GetEMSPages
   INT       67h
   MOV       TotalEMSPages, DX
   RET
GetTotalEMSPages  ENDP


GetPageFrame  PROC NEAR
   MOV       AH, ems_GetPageFrame
   INT       67h
   MOV       PageFrame, BX
   RET
GetPageFrame  ENDP


GetEMSVersion  PROC NEAR
   MOV       AH, ems_GetEMSVersion
   INT       67h
   MOV       EMS_Version, AL
   RET
GetEMSVersion  ENDP


GetEMSHandles  PROC NEAR
   MOV       AH, ems_GetHandleDirectory
   MOV       AL, 02h
   INT       67h
   MOV       TotalEMSHandles, BX
   RET
GetEMSHandles  ENDP


GetHardwareInfo  PROC NEAR
 EmsHardware   EQU  (DWORD PTR SS:[BX+2])
   macro_StackFrame BX
   CMP       [EMS_Present], boolean_False
   JE        @@GetHardwareInfo_End
   MOV       AH, ems_GetHardwareInfo
   MOV       AL, 00h
   LES       DI, EmsHardware
   INT       67h
@@GetHardwareInfo_End:
   RET       4
GetHardwareInfo  ENDP


GetTotalRawPages  PROC FAR
   MOV       AH, ems_GetHardwareInfo
   MOV       AL, 01h
   INT       67h
   MOV       TotalRAWPages, DX
   RET
GetTotalRawPages  ENDP


InitTEms  PROC NEAR
   CALL      GetEMSPresent
   CMP       EMS_Present, boolean_False
   JE        @@InitTEms_End
   CALL      GetEMSVersion
   CALL      GetPageFrame
   CALL      GetEMSHandles
   CALL      GetTotalRawPages
   CALL      GetTotalEMSPages
   CALL      SetEmsDriverType
   MOV       EMS_Exchange, 00h
   MOV       AX, DS
   MOV       GS, AX
@@InitTEms_End:
   RET
InitTEms  ENDP


GetFreeEMSPages  PROC FAR
   MOV       AH, ems_GetEMSPages
   CALL      EMS_Call
   MOV       AX, BX
   RET
GetFreeEMSPages  ENDP


GetActiveEMSHandles  PROC FAR
   MOV       AH, ems_GetHandlesCount
   CALL      EMS_Call
   MOV       AX, BX
   RET
GetActiveEMSHandles  ENDP


AllocateEMS  PROC FAR
  Size_pages   EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_AllocateEMS
   MOV       BX, Size_pages
   CALL      EMS_Call
   MOV       AX, DX
   RET       2
AllocateEMS  ENDP


ReleaseEMS  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_ReleaseEMS
   MOV       DX, Handle
   CALL      EMS_Call
   MOV       AX, DX
   RET       2
ReleaseEMS  ENDP


MapEMSPages  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+8])
  LogicalPage  EQU  (WORD PTR SS:[BX+6])
  PhysicalPage EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_MapEMS
   MOV       AL, PhysicalPage
   MOV       DX, Handle
   MOV       BX, LogicalPage
   CALL      EMS_Call
   RET       6
MapEMSPages  ENDP


GetEMSHandlePages  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_GetHandlePages
   MOV       DX, Handle
   CALL      EMS_Call
   RET       2
GetEMSHandlePages  ENDP


GetEMSHandlesTable  PROC FAR
  Table        EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   LES       DI, Table
   MOV       AX, WORD PTR ES:[DI+2]
   MOV       DI, WORD PTR ES:[DI]
   MOV       ES, AX
   MOV       AH, ems_GetEMSTable
   CALL      EMS_Call
   MOV       AX, BX
   RET       4
GetEMSHandlesTable  ENDP


ReallocateEMS  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+6])
  Size_pages   EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_ReallocateEMS
   MOV       DX, Handle
   MOV       BX, Size_pages
   CALL      EMS_Call
   RET       4
ReallocateEMS  ENDP


GetEMS_HandleAttr  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_GetSetAttrib
   MOV       AL, 00h
   MOV       DX, Handle
   CALL      EMS_Call
   RET       2
GetEMS_HandleAttr  ENDP


SetEMS_HandleAttr  PROC FAR
  Handle       EQU  (WORD PTR SS:[BX+6])
  Attr         EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_GetSetAttrib
   MOV       AL, 01h
   MOV       DX, Handle
   MOV       BL, Attr
   CALL      EMS_Call
   RET       2
SetEMS_HandleAttr  ENDP


GetEMS_HandleName  PROC FAR
  Handle       EQU  (WORD  PTR SS:[BX+8])
  HName        EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_GetSetHandleName
   MOV       AL, 00h
   MOV       DX, Handle
   LES       DI, HName
   CALL      EMS_Call
   RET       6
GetEMS_HandleName  ENDP


SetEMS_HandleName  PROC FAR
  Handle       EQU  (WORD  PTR SS:[BX+8])
  HName        EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_GetSetHandleName
   MOV       AL, 01h
   MOV       DX, Handle
   LDS       SI, HName
   CALL      EMS_Call
   RET       6
SetEMS_HandleName  ENDP


FindEMS_Handle  PROC FAR
  HName        EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AH, ems_GetHandleDirectory
   MOV       AL, 1
   LDS       SI,  HName
   PUSH      AX
   MOV       AX, SEG DATA
   MOV       GS, AX
   POP       AX
   MOV       GS:[EMS_Result].Result, ems_error_NoDriver
   CMP       GS:[EMS_Present], boolean_False
   JE        @@FindHandle_Error
   MOV       GS:[EMS_Result].Function, AX
   MOV       GS:[EMS_Result].Interrupt, 67h
   PUSH      GS
   POP       DS
   MOV       BYTE PTR [EMS_Result].Result, AH
   MOV       BYTE PTR [EMS_Result].Result+1, 00h
   CMP       AH, boolean_False
   JE        @@EMS_Call_End
   CMP       AH, 0A1h
   JE        @@FindHandle_NoneHandle
@@FindHandle_Error:
   CALL      [EMS_Result].ErrorProc
   MOV       [EMS_Result].Result, 00h
@@FindHandle_NoneHandle:
   MOV       DX, 0
@@FindHandle_End:
   MOV       AX, DX
   RET       4
FindEMS_Handle  ENDP


MoveEMSUsers  PROC FAR
  SourceHandle EQU  (WORD  PTR SS:[BX+22])
  SourceType   EQU  (BYTE  PTR SS:[BX+20])
  SourceOffset EQU  (DWORD PTR SS:[BX+16])
  DestHandle   EQU  (WORD  PTR SS:[BX+14])
  DestType     EQU  (BYTE  PTR SS:[BX+12])
  DestOffset   EQU  (DWORD PTR SS:[BX+8])
  Count        EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       EAX, Count
   MOV       DWORD PTR [EMSTr.eTransferSize], EAX
   MOV       AX, SourceHandle
   MOV       WORD PTR [EMSTr.eSourceHandle], AX
   MOV       AL, SourceType
   MOV       BYTE PTR [EMSTr.eSourceType], AL
   MOV       EAX, SourceOffset
   MOV       DWORD PTR [EMSTr.eSourceOffset], EAX
   MOV       AX, DestHandle
   MOV       WORD PTR [EMSTr.eDestHandle], AX
   MOV       AL, DestType
   MOV       BYTE PTR [EMSTr.eDestType], AL
   MOV       EAX, DestOffset
   MOV       DWORD PTR [EMSTr.eDestOffset], EAX
   PUSH      DS
   MOV       AX, CS
   MOV       DS, AX
   LEA       SI, EMSTr
   MOV       AL, EMS_Exchange
   CALL      EMS_Call
   POP       DS
   RET       20
MoveEMSUsers  ENDP


WarmBootPrepare  PROC FAR
   MOV       AH, ems_WarmBootPrepare
   CALL      EMS_Call
   RET
WarmBootPrepare  ENDP


GetFreeRawPages  PROC FAR
   MOV       AH, ems_GetHardwareInfo
   MOV       AL, 01h
   CALL      EMS_Call
   MOV       AX, BX
   RET
GetFreeRawPages  ENDP


AllocateRawPages  PROC FAR
  Size_pages   EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_AllocateRawPages
   MOV       AL, 01h
   MOV       BX, Size_pages
   CALL      EMS_Call
   MOV       AX, DX
   RET       2
AllocateRawPages  ENDP


MapUnmapPages  PROC FAR
  Handle       EQU  (WORD  PTR SS:[BX+12])
  MapType      EQU  (BYTE  PTR SS:[BX+10])
  MapTable     EQU  (DWORD PTR SS:[BX+6])
  TableSize    EQU  (WORD  PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, ems_MapUnmapHandle
   MOV       AL, MapType
   MOV       DX, Handle
   MOV       CX, TableSize
   LDS       SI, MapTable
   CALL      EMS_Call
   RET       2
MapUnmapPages  ENDP



EMM386_Call_API  PROC NEAR
   macro_SetDATA_GS
   CMP       GS:[EMS_DriverType], manager_type_EMM386
   JNE       @@EMM386_Call_API_NoDriver
   CALL      DWORD PTR GS:[EMM_DriverAPI]
   JMP       @@EMM386_Call_API_End
@@EMM386_Call_API_NoDriver:
   MOV       GS:[EMS_Result].Result, ems_error_WrongDriver
   MOV       GS:[EMS_Result].Function, 00h
   MOV       GS:[EMS_Result].Interrupt, 00h
   CALL      GS:[EMS_Result].ErrorProc
@@EMM386_Call_API_End:
   RET
EMM386_Call_API  ENDP


QEMM_Call_API  PROC NEAR
   macro_SetDATA_GS
   CMP       GS:[EMS_DriverType], manager_type_QEMM
   JNE       @@QEMM_Call_API_NoDriver
   CALL      DWORD PTR GS:[EMM_DriverAPI]
   JMP       @@QEMM_Call_API_End
@@QEMM_Call_API_NoDriver:
   MOV       GS:[EMS_Result].Result, ems_error_WrongDriver
   MOV       GS:[EMS_Result].Function, 00h
   MOV       GS:[EMS_Result].Interrupt, 00h
   CALL      GS:[EMS_Result].ErrorProc
@@QEMM_Call_API_End:
   RET
QEMM_Call_API  ENDP


EMM386_GetState  PROC FAR
   MOV       AH, manager_EMM386_GetState
   CALL      EMM386_Call_API
   MOV       AL, AH
   RET
EMM386_GetState  ENDP


EMM386_SetState  PROC FAR
  State        EQU  (BYTE PTR SS:[BX+4])
   MOV       AH, manager_EMM386_SetState
   MOV       AL, State
   CALL      EMM386_Call_API
   RET
EMM386_SetState  ENDP


EMM386_GetWeitekSupport  PROC FAR
   MOV       AH, manager_EMM386_GetWeitekSupport
   MOV       AL, 00h
   CALL      EMM386_Call_API
   RET
EMM386_GetWeitekSupport  ENDP


EMM386_SetWeitekSupport  PROC FAR
  State        EQU  (BYTE PTR SS:[BX+4])
   MOV       AH, manager_EMM386_GetWeitekSupport
   MOV       AL, 03h
   SUB       AL, State
   CALL      EMM386_Call_API
   RET       2
EMM386_SetWeitekSupport  ENDP


EMM386_PrintReport  PROC FAR
   MOV       AH, manager_EMM386_PrintReport
   CALL      EMM386_Call_API
   RET
EMM386_PrintReport  ENDP


EMM386_PrintCopyright PROC FAR
   MOV       AH, manager_EMM386_PrintCopyright
   CALL      EMM386_Call_API
   RET
EMM386_PrintCopyright  ENDP


QEMM_GetState  PROC FAR
   MOV       AH, manager_QEMM_GetState
   CALL      QEMM_Call_API
   RET
QEMM_GetState  ENDP


QEMM_SetState  PROC FAR
  State        EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, manager_QEMM_SetState
   MOV       AL, State
   CALL      QEMM_Call_API
   RET       2
QEMM_SetState  ENDP


QEMM_GetVersion  PROC FAR
   MOV       AH, manager_QEMM_GetVersion
   CALL      QEMM_Call_API
   RET
QEMM_GetVersion  ENDP


QEMM_GetHiramChain  PROC FAR
   MOV       AX, 0D201h
   MOV       BX, 04849h    ;"HI"
   MOV       CX, 05241h    ;"RA"
   MOV       DX, 04D30h    ;"M0"
   INT       2Fh
   CMP       BX, 04F4Bh    ;"OK"
   JE        @@QEMM_GetHiramChain_SetCX
   XOR       AX, AX
   JMP       @@QEMM_GetHiramChain_SetZero
@@QEMM_GetHiramChain_SetCX:
   MOV       AX, CX
@@QEMM_GetHiramChain_SetZero:
   RET
QEMM_GetHiramChain  ENDP


QEMM_GetManifestPresent  PROC FAR
   MOV       AX, 0D201h
   MOV       BX, 04D41h    ;"MA"
   MOV       CX, 04E49h    ;"NI"
   MOV       DX, 04645h    ;"FE"
   INT       2Fh
   MOV       AL, boolean_False
   CMP       BX, 05354h    ;"ST"
   JNE       @@QEMM_GetManifestPresent_End
   MOV       AL, boolean_True
@@QEMM_GetManifestPresent_End:
   RET
QEMM_GetManifestPresent  ENDP


QEMM_CopyStealthRoms  PROC FAR
  Source       EQU  (DWORD PTR SS:[BX+12])
  Dest         EQU  (DWORD PTR SS:[BX+8])
  CopySize     EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, manager_QEMM_CopyStealthRoms
   LDS       SI, Source
   LES       DI, Dest
   MOV       ECX, CopySize
   CALL      QEMM_Call_API
   POP       DS
   RET       12
QEMM_CopyStealthRoms  ENDP


QEMM_UntrappedIORead  PROC FAR
  Port         EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, manager_QEMM_UntrappedIORead
   MOV       DX, Port
   CALL      QEMM_Call_API
   RET       2
QEMM_UntrappedIORead  ENDP


QEMM_UntrappedIOWrite  PROC FAR
  Port         EQU  (WORD PTR SS:[BX+6])
  Value        EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, manager_QEMM_UntrappedIOWrite
   MOV       DX, Port
   MOV       BL, Value
   CALL      QEMM_Call_API
   RET       4
QEMM_UntrappedIOWrite  ENDP


QEMM_UntrappedIOReadIndexed  PROC FAR
  Port         EQU  (WORD PTR SS:[BX+6])
  Index        EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, manager_QEMM_UntrappedIOIndexRead
   MOV       DX, Port
   MOV       BH, Index
   CALL      QEMM_Call_API
   MOV       AL, BL
   RET       4
QEMM_UntrappedIOReadIndexed  ENDP



QEMM_UntrappedIOWriteIndexed  PROC FAR
  Port         EQU  (WORD PTR SS:[BX+8])
  Index        EQU  (BYTE PTR SS:[BX+6])
  Value        EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, Index
   MOV       AL, Value
   MOV       DX, Port
   MOV       BX, AX
   MOV       AX, manager_QEMM_UntrappedIOIndexWrite
   CALL      QEMM_Call_API
   RET       6
QEMM_UntrappedIOWriteIndexed  ENDP


QEMM_GetIOCallback  PROC FAR
   MOV       AX, manager_QEMM_GetIOCallback
   CALL      QEMM_Call_API
   MOV       DX, ES
   MOV       AX, DI
   RET
QEMM_GetIOCallback  ENDP


QEMM_SetIOCallback  PROC FAR
  NewCallback  EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, manager_QEMM_SetIOCallback
   LES       DI, NewCallback
   CALL      QEMM_Call_API
   RET       4
QEMM_SetIOCallback  ENDP


QEMM_GetPortTrap  PROC FAR
  Port         EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, manager_QEMM_GetPortTrap
   MOV       DX, Port
   CALL      QEMM_Call_API
   RET       2
QEMM_GetPortTrap  ENDP


QEMM_SetPortTrap  PROC FAR
  Port         EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, manager_QEMM_SetPortTrap
   MOV       DX, Port
   CALL      QEMM_Call_API
   RET       2
QEMM_SetPortTrap  ENDP


QEMM_ClearPortTrap  PROC FAR
  Port         EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, manager_QEMM_ClearPortTrap
   MOV       DX, Port
   CALL      QEMM_Call_API
   RET       2
QEMM_ClearPortTrap  ENDP


QEMM_GetStealthCount  PROC FAR
   MOV       AX, manager_QEMM_GetStealthCount
   CALL      QEMM_Call_API
   MOV       AX, BX
   RET
QEMM_GetStealthCount  ENDP


QEMM_GetInfo  PROC FAR
  InfoRec      EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, manager_QEMM_GetInfo
   CALL      QEMM_Call_API
   LES       DI, InfoRec
   MOV       ES:[DI], BX
   MOV       ES:[DI+2], CX
   MOV       ES:[DI+4], DL
   RET       4
QEMM_GetInfo  ENDP


QEMM_GetMemoryStatistics  PROC FAR
  InfoRecord   EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, manager_QEMM_GetMemoryStatistics
   CALL      QEMM_Call_API
   RET       4
QEMM_GetMemoryStatistics  ENDP


QEMM_GetStealthList  PROC FAR
   MOV       AX, manager_QEMM_GetStealthList
   CALL      QEMM_Call_API
   MOV       DX, ES
   MOV       AX, DI
   RET
QEMM_GetStealthList  ENDP


CODE  ENDS

      END



