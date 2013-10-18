{-----------------------------------------------------------------------}
{ PROJECT               TURBO PASCAL LIBRARY                            }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                XMS/EMS MEMORY CONTROL                          }
{ FILE NAME             TXMS.PAS                                        }
{ PURPOSE               Use 386+ 32 bits codes and optimizating,        }
{                       some tools and utilities                        }
{ VERSION               0.01                                            }
{ DATE                  30-Mar-96                                       }
{ DESIGN                Begtin Ivan                                     }
{ IMPLEMENTATION        Begtin Ivan                                     }
{ COMPANY               None                                            }

{ COPYRIGHT NOTICE      Copyright (C) 1995-1996, Begtin Ivan            }
{ RESTRICTED RIGHTS     AVAILABLE ONLY FOR FREE DISTRIBUTION,           }
{                       NOT FOR COMMERCIAL PURPOSE                      }
{ COMPUTER              IBM PC or compatible                            }
{ OPERATING SYSTEM      MS/PC-DOS Version 3.30 or higher                }
{ COMPILER              Turbo Pascal Version 7.0                        }
{                       (Borland International Inc.)  or compatible     }
{ ASSEMBLY LANGUAGE     Turbo Assember 3.2 or compatible                }
{ LINKER                Turbo Pascal internal                           }
{ ARGUMENTS                                                             }
{                                                                       }
{                                                                       }
{ RETURN                None                                            }
{ REQUIRES              None                                            }
{ NATURAL LANGUAGE      English Language                                }
{ SECOND LANGUAGE       Russian Language                                }
{ SPECIAL               Works only on 386+ processor                    }
{ DESCRIPTION           1. Full XMS and EMS memory control              }
{                       2. Current EMS driver identification            }
{                       3. Specific functions for current driver        }
{                       4. Errors autodetection                         }
{                       5. Full QEMM support                            }
{                       6. 386 processor features used                  }
{                       7. No any note!                                 }
{ REVISION HISTORY     Ivan Begtin (IB)                                 }
{                                                                       }
{-----------------------------------------------------------------------}
Unit TXms;


interface

Uses TSystem;

const
     manager_type_Unknown = 00;
     manager_type_EMM386  = 01;
     manager_type_QEMM    = 02;
     manager_type_386MAX  = 03;   {** Sorry, but unusable in this version**}

     const_QEMM_StealthFrame   = $46;
     const_QEMM_StealthMapping = $4D;



type
    TQEMM_Statistics = record
      ShadowRam             : System.Boolean;
      TotalConvMemSize      : System.Longint;
      TotalExtMemSize       : System.Longint;
      TotalExpMemSize       : System.Longint;
      InitialShadowMemory   : System.Longint;
      UnavailConvMemory     : System.Longint;
      UnavailExtMemory      : System.Longint;
      UnavailExpMemory      : System.Longint;
      QEMM_CodeSize         : System.Longint;
      QEMM_DataSize         : System.Longint;
      TASKS_Size            : System.Longint;
      DMABufferSize         : System.Longint;
      MAPS_Size             : System.Longint;
      MappedRomsSize        : System.Longint;
      ConvMemSize           : System.Longint;
      ExtMemSize            : System.Longint;
      QEMM_XmsEmsSize       : System.Longint;
      ShadowRamSize         : System.Longint;
      ConvMemoryOverheap    : System.Longint;
    end;


    TStealthListEntry = record
      Segment    : System.Word;
      RomSize    : System.Word;
    end;

    PQEMM_StealthList = ^TQEMM_StealthList;
    TQEMM_StealthList = array[1..80] of TStealthListEntry;

    TQEMM_Info = record
      DiskBufferFlag      : System.Byte;
      MemoryConfigFlag    : System.Byte;
      StealthType         : System.Byte;
      SuspendInterrupt    : System.Byte;
      QEMM_DiskBufferSize : System.Byte;
    end;


    PEmsHandleName = ^TEmsHandleName;
    TEmsHandleName = TDosName;


    PEmsHardwareInfoRec = ^TEmsHardwareInfoRec;
    TEmsHardwareInfoRec = record
      RawPagesSize        : System.Word;
      AltRegsSet          : System.Word;
      SaveContextBuffSize : System.Word;
      DMA_Regs            : System.Word;
      DMA_OperationType   : System.WordBool;
    end;


    TEmsBlock = record
      Handle    : System.Word;
      Pages     : System.Word;
    end;


    PEmsHandlesArray = ^TEmsHandlesArray;
    TEmsHandlesArray = array[1..128] of TEmsBlock;


    THandle = System.Word;
    TXMSHandle = record
      Flag       : System.Byte;
      Lock       : System.Byte;
      Address    : System.Longint;
      Size       : System.Longint;
    end;

    PXMSTable = ^TXMSTable;
    TXMSTable = array[1..5000] of TXMSHandle;


    PXMSHandlesTable = ^TXMSHandlesTable;
    TXMSHandlesTable = record
      VerFlag       : System.Byte;
      HandleSize    : System.Byte;
      HandlesCount  : System.Word;
      Table         : PXMSTable;
    end;


Var
   XMS_Present      : System.Boolean;
   XMS_HandlesTable : PXMSHandlesTable;
   XMS_Version      : System.Word;
   XMS_Revision     : System.Word;
   HMA_Present      : System.Boolean;
   XMM_DriverAPI    : System.Pointer;
   XMS_Result       : TSystem.TFunctionResult;

   EMS_Present      : System.Boolean;
   EMS_Version      : System.Byte;
   PageFrame        : System.Word;
   TotalRawPages    : System.Word;
   TotalEmsPages    : System.Word;
   TotalEmsHandles  : System.Word;
   EMS_HardwareInfo : TEmsHardwareInfoRec;
   EMS_DriverType   : System.Byte;
   EMM_DriverAPI    : System.Pointer;
   EMS_Exchange     : System.Byte;
   EMS_Result       : TSystem.TFunctionResult;


procedure ReleaseHMA;
function  AllocateHMA(Size: System.Word): System.Word;

procedure GlobalEnableA20;
procedure GlobalDisableA20;
procedure LocalEnableA20;
procedure LocalDisableA20;
function  QueryA20: System.Boolean;

function  GetFreeXMS: Word;
function  GetMaxFreeXMSBlock: Word;

function  AllocateEMB(Size: System.Word): THandle;
procedure ReleaseEMB(Handle: THandle);
procedure ReallocateEMB(Handle: THandle; Size: System.Word);
function  LockEMB(Handle: THandle): System.Longint;
procedure UnlockEMB(Handle: THandle);
procedure MoveEMBUsers(SourceHandle: THandle; SourceOffset: System.Longint;
                       DestHandle: THandle; DestOffset: System.Longint; Count: System.Longint);

function  GetEMBSize(Handle: THandle): System.Word;
function  GetEMBLockCount(Handle: THandle): System.Byte;
function  GetEMBFreeHandles(Handle: THandle): System.Byte;

function  AllocateUMB(Size: System.Word): System.Word;
procedure ReleaseUMB(UMBSegment: System.Word);
procedure ReallocateUMB(UMBSegment, Size: System.Word);

function  UMBMaxAvail: System.Word;


function  GetFreeEMSPages: System.Word;
function  GetActiveEMSHandles: System.Word;

function  AllocateEMS(Size: System.Word): THandle;
procedure ReleaseEMS(Handle: THandle);
procedure ReallocateEMS(Handle: THandle; Size: System.Word);
procedure MapEMSPages(Handle: THandle; LogicalPage: System.Word; PhisicalPage: System.Byte);

function  GetEMSHandlesTable(Var Table: PEmsHandlesArray): System.Word;

function  GetEMSHandlePages(Handle: THandle): System.Word;
function  GetEMS_HandleAttr(Handle: THandle): System.Word;
function  SetEMS_HandleAttr(Handle: THandle): System.Word;
function  GetEMS_HandleName(Handle: THandle; Name: PEMSHandleName): System.Word;
function  SetEMS_HandleName(Handle: THandle; Name: PEMSHandleName): System.Word;
function  FindEMS_Handle(Name: PEMSHandleName): System.Word;
procedure WarmBootPrepare;
function  GetFreeRawPages: System.Word;
procedure MoveEMSUsers(SourceHandle:THandle; SType:System.Byte; SourceOffset:System.Longint;
                       DestHandle:THandle; DType:System.Byte; DestOffset:LongInt;Count:System.Longint);

function  EMM386_GetState:System.Byte;
procedure EMM386_SetState(State:System.Byte);
function  EMM386_GetWeitekSupport:System.Byte;
procedure EMM386_SetWeitekSupport(State:System.Byte);
procedure EMM386_PrintCopyright;
procedure EMM386_PrintReport;

Function  QEMM_GetHiramChain:System.Word;
Function  QEMM_GetManifestPresent: System.Boolean;
Function  QEMM_GetVersion: System.Word;
Function  QEMM_GetState: System.Byte;
Procedure QEMM_SetState(State: System.Byte);
Procedure QEMM_CopyStealthRoms(Source, Dest: System.Pointer; Size: System.Longint);

Function  QEMM_UntrappedIORead(PortNum: System.Word): System.Byte;
Procedure QEMM_UntrappedIOWrite(PortNum: System.Word; Value: System.Byte);
Function  QEMM_UntrappedIOReadIndexed(PortNum: System.Word; Index: System.Byte): System.Byte;
Procedure QEMM_UntrappedIOWriteIndexed(PortNum: System.Word; Index,Value: System.Byte);

Function  QEMM_GetIOCallback:System.Pointer;
Procedure QEMM_SetIOCallback(NewCallBack: System.Pointer);

Function  QEMM_GetPortTrap(PortNum: System.Word):System.Boolean;
Procedure QEMM_SetPortTrap(PortNum: System.Word);
Procedure QEMM_ClearPortTrap(PortNum: System.Word);

Function  QEMM_GetStealthCount: System.Word;
function  QEMM_GetStealthList: PQEMM_StealthList;

Procedure QEMM_GetMemoryStatistics(Var States:TQEMM_Statistics);
Procedure QEMM_GetInfo(Var Info:TQEMM_Info);




procedure InitTXms;
procedure InitTEms;

implementation

{$L TXMS.OBJ}

procedure ReleaseHMA; external;
function  AllocateHMA(Size: System.Word): System.Word; external;

procedure GlobalEnableA20; external;
procedure GlobalDisableA20; external;
procedure LocalEnableA20; external;
procedure LocalDisableA20; external;
function  QueryA20: System.Boolean; external;

function  GetFreeXMS: Word; external;
function  GetMaxFreeXMSBlock: Word; external;

function  AllocateEMB(Size: System.Word): THandle; external;
procedure ReleaseEMB(Handle: THandle); external;
procedure ReallocateEMB(Handle: THandle; Size: System.Word); external;
function  LockEMB(Handle: THandle): System.Longint; external;
procedure UnlockEMB(Handle: THandle); external;
procedure MoveEMBUsers(SourceHandle: THandle; SourceOffset: System.Longint;
                       DestHandle: THandle; DestOffset: System.Longint; Count: System.Longint); external;

function  GetEMBSize(Handle: THandle): System.Word; external;
function  GetEMBLockCount(Handle: THandle): System.Byte; external;
function  GetEMBFreeHandles(Handle: THandle): System.Byte; external;

function  AllocateUMB(Size: System.Word): System.Word; external;
procedure ReleaseUMB(UMBSegment: System.Word); external;
procedure ReallocateUMB(UMBSegment, Size: System.Word); external;
function  UMBMaxAvail: System.Word; external;


function  GetFreeEMSPages: System.Word; external;
function  GetActiveEMSHandles: System.Word; external;

function  AllocateEMS(Size: System.Word): THandle; external;
procedure ReleaseEMS(Handle: THandle); external;
procedure ReallocateEMS(Handle: THandle; Size: System.Word); external;
procedure MapEMSPages(Handle: THandle; LogicalPage: System.Word; PhisicalPage: System.Byte); external;

function  GetEMSHandlesTable(Var Table: PEmsHandlesArray): System.Word; external;

function  GetEMSHandlePages(Handle: THandle): System.Word; external;
function  GetEMS_HandleAttr(Handle: THandle): System.Word; external;
function  SetEMS_HandleAttr(Handle: THandle): System.Word; external;
function  GetEMS_HandleName(Handle: THandle; Name: PEMSHandleName): System.Word; external;
function  SetEMS_HandleName(Handle: THandle; Name: PEMSHandleName): System.Word; external;
function  FindEMS_Handle(Name: PEMSHandleName): System.Word; external;
procedure WarmBootPrepare; external;
function  GetFreeRawPages: System.Word; external;
procedure MoveEMSUsers(SourceHandle:THandle; SType:System.Byte; SourceOffset:System.Longint;
                       DestHandle:THandle; DType:System.Byte; DestOffset:LongInt;Count:System.Longint); external;

procedure GetHardwareInfo(Var Info: TEmsHardwareInfoRec);near;external;

function  EMM386_GetState: System.Byte; external;
procedure EMM386_SetState(State: System.Byte); external;
function  EMM386_GetWeitekSupport: System.Byte; external;
procedure EMM386_SetWeitekSupport(State:System.Byte); external;
procedure EMM386_PrintCopyright; external;
procedure EMM386_PrintReport; external;

Function  QEMM_GetHiramChain: System.Word; external;
Function  QEMM_GetManifestPresent: System.Boolean; external;
Function  QEMM_GetVersion: System.Word; external;
Function  QEMM_GetState: System.Byte; external;
Procedure QEMM_SetState(State: System.Byte); external;
Procedure QEMM_CopyStealthRoms(Source, Dest: System.Pointer; Size: System.Longint); external;

Function  QEMM_UntrappedIORead(PortNum: System.Word): System.Byte; external;
Procedure QEMM_UntrappedIOWrite(PortNum: System.Word; Value: System.Byte); external;
Function  QEMM_UntrappedIOReadIndexed(PortNum: System.Word; Index: System.Byte): System.Byte; external;
Procedure QEMM_UntrappedIOWriteIndexed(PortNum: System.Word; Index,Value: System.Byte); external;

Function  QEMM_GetIOCallback: System.Pointer; external;
Procedure QEMM_SetIOCallback(NewCallBack: System.Pointer); external;

Function  QEMM_GetPortTrap(PortNum: System.Word):System.Boolean; external;
Procedure QEMM_SetPortTrap(PortNum: System.Word); external;
Procedure QEMM_ClearPortTrap(PortNum: System.Word); external;

Function  QEMM_GetStealthCount: System.Word; external;
function  QEMM_GetStealthList: PQEMM_StealthList; external;

Procedure QEMM_GetMemoryStatistics(Var States:TQEMM_Statistics); external;
Procedure QEMM_GetInfo(Var Info:TQEMM_Info); external;


procedure InitTXms; external;
procedure InitTEms; external;


begin
  InitTXms;
  InitTEms;
  GetHardwareInfo (EMS_HardwareInfo);
  XMS_Result.ErrorProc:= DoNone;
  EMS_Result.ErrorProc:= DoNone;
end.

