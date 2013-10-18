{$G+}
Unit IvXMS;

Interface
 {** Used Units **}
Uses TSystem;

Type
 TQEMM_Statistics = record
                     ShadowRam              : Boolean;
                     Total_Conv_Mem_Size    : LongInt;
                     Total_Ext_Mem_Size     : LongInt;
                     Total_Exp_Mem_Size     : LongInt;
                     Initial_Shadow_Mem     : LongInt;
                     UnAvail_Conv_Mem       : LongInt;
                     UnAvail_Ext_Mem        : LongInt;
                     UnAvail_Exp_Mem        : LongInt;
                     UnAvail_Shadow_Mem     : LongInt;
                     QEMM_CodeSize          : LongInt;
                     QEMM_DataSize          : LongInt;
                     TASKS_Size             : LongInt;
                     DMABufferSize          : LongInt;
                     MAPS_Size              : LongInt;
                     Mapped_ROMs_Size       : LongInt;
                     Conv_Mem_Size          : LongInt;
                     EXT_Mem_Size           : LongInt;
                     QEMM_XMS_EMS_Size      : LongInt;
                     Shadow_RAM_Size        : LongInt;
                     Conv_Mem_OverHeap      : LongInt;
                    end;

 TQEMM_Info       = record
                     Disk_Buffer_Flag       : Byte;
                     Memory_Config_Flag     : Byte;
                     Stealth_Type           : Byte;
                     SuspendInterrupt       : Byte;
                     QEMM_Disk_Buffer_Size  : Byte;
                    end;

 PEmsHandleName = ^TEmsHandleName;
 TEmsHandleName = Array[1..8] of Char;

 PEmsHardWareInfoRec = ^EmsHardWareInfoRec;
 EmsHardWareInfoRec = record
   RawPagesSize        : Word;
   AltRegsSet          : Word;
   SaveContextBuffSize : Word;
   DMAregs             : Word;
   DMAOperationType    : WordBool;
 end;

 EmsBlock = record
  Handle:word;
  Pages:word;
 end;

 PEmsArr =^EmsArr;
 EmsArr  = array[1..128] of EmsBlock;


 TXMSHandle = record
               Flag    : byte;
               Lock    : byte;
               Address,
               Size    : LongInt;
              end;
 THandle    = Word;

 PXMSTable  = ^TXMSTable;
 TXMSTable  = Array[1..5000] of TXMSHandle;

 PXMSHandlesTable = ^TXMSHandlesTable;
 TXMSHandlesTable = record
                     VerFlag    : Byte;
                     HandleSize : Byte;
                     HandlesNum : Word;
                     Table      : PXMSTable;
                    end;

Var
 XMSError        : Byte;
 XMSResult       : Wordbool;
 XMSPresent      : Boolean;
 XMSHandlesTable : PXMSHandlesTable;
 XMSVersion      : Word;
 XMSRevision     : Word;
 HMAPresent      : Boolean;
 XMM_Driver      : Pointer;
 LastXMSFunction : Byte;
 XMSErrorProc    : Procedure;

 EMSError        : Word;
 EMSPresent      : Boolean;
 EMMVersion      : Byte;
 PageFrame       : Word;
 TotalRAWPages   : Word;
 TotalEMSPages   : Word;
 TotalEMSHandles : Word;
 EMSDriverType   : Byte;
 EMM_Driver      : Pointer;
 EMSExchange     : Boolean;
 LastEMSFunction : Byte;
 EMSErrorProc    : Procedure;
 EMSHardwareInfo : EMSHardwareInfoRec;


Procedure ReleaseHMA;
Function  AllocateHMA(Size:Word):Word;


Procedure GlobalEnableA20;
Procedure GlobalDisableA20;
Procedure LocalEnableA20;
Procedure LocalDisableA20;
Function  QueryA20:Boolean;


Function  GetFreeXMS:Word;      {** Result in KBytes**}
Function  GetMaxFreeBlock:Word;

Function  AllocateEMB(Size:Word):THandle;
Procedure ReleaseEMB(Handle:THandle);
Procedure ReallocateEMB(Handle:THandle;Size:Word);

Function  LockEMB(Handle:THandle):LongInt;
Procedure UnLockEMB(Handle:THandle);

Function  GetEMBSize(Handle:THandle):Word;
Function  GetEMBLockCount(Handle:THandle):Byte;
Function  GetEMBFreeHandles(Handle:THandle):Byte;

Function  AllocateUMB(Size:Word):Word;
Procedure ReleaseUMB(UMBSegment:Word);
Procedure ReallocateUMB(UMBSegment,Size:Word);
Function  UMBMaxAvail:Word;

Procedure MoveEMBUsers(SourceHandle:THandle;SourceOffset:LongInt;DestHandle:THandle;DestOffset:LongInt;Count:LongInt);

Function  AvailEMSPages:Word;
Function  ActiveEMSHAndles:Word;

Function  AllocateEMS(Size:Word):THandle;
Procedure ReleaseEMS(Handle:THandle);
Procedure ReallocateEMS(Handle:THandle;Size:Word);
Function  AllocateRAWPages(Size:Word):THandle;
Procedure MapEMSPages(Handle:THandle;Logical_Page:Word;Phisical_Page:Byte);
Procedure MapUnmapPages(Handle:THandle;MapType:Byte;MapTable:Pointer;TableSize:Word);

Function  GetEMSHandlesTable(Var Table:PEmsArr):Word;

Function  GetEMS_HandlePages(Handle:THandle):Word;
Function  GetEMS_HandleAttr(Handle:THandle):Byte;
Procedure SetEMS_HandleAttr(Handle:THandle;Attr:Byte);
Procedure GetEMS_HandleName(Handle:THandle;Name:PEmsHandleName);
Procedure SetEMS_HandleName(Handle:THandle;Name:PEmsHandleName);
Function  FindEMS_Handle(Name:PEmsHandleName):Word;

Procedure MoveEMSUsers(SourceHandle:THandle;SType:Byte;SourceOffset:LongInt;
                       DestHandle:THandle;DType:Byte;DestOffset:LongInt;Count:LongInt);

Procedure SaveMappingContext(Handle:THandle);
Procedure RestoreMappingContext(Handle:THandle);
Procedure WarmBootPrepare;
Function  GetFreeRawPages:Word;

         { ** EMS Drivers Special Procedures ** }

Function  EMM386_GetState:Byte;
Procedure EMM386_SetState(State:Byte);
Function  EMM386_GetWeitekSupport:Byte;
Procedure EMM386_SetWeitekSupport(State:Byte);
Procedure EMM386_PrintCopyright;
Procedure EMM386_PrintReport;

Function  QEMM_GetHiramChain:Word;
Function  QEMM_GetManifestPresent:Boolean;
Function  QEMM_GetVersion:Word;
Function  QEMM_GetState:Byte;
Procedure QEMM_SetState(State:Byte);

Function  QEMM_UntrappedIORead(PortNum: Word): Byte;
Procedure QEMM_UntrappedIOWrite(PortNum: Word;Value: Byte);
Function  QEMM_UntrappedIOReadIndexed(PortNum: Word; Index: Byte): Byte;
Procedure QEMM_UntrappedIOWriteIndexed(PortNum: Word; Index,Value: Byte);

Function  QEMM_GetIOCallback:Pointer;
Procedure QEMM_SetIOCallback(NewCallBack: Pointer);

Function  QEMM_GetPortTrap(PortNum: Word):Boolean;
Procedure QEMM_SetPortTrap(PortNum: Word);
Procedure QEMM_ClearPortTrap(PortNum: Word);

Function  QEMM_GetStealthCount:Word;
Procedure QEMM_GetMemoryStatistics(Var States:TQEMM_Statistics);
Procedure QEMM_GetInfo(Var Info:TQEMM_Info);




Implementation


{$L IVXMS.OBJ}
      { **  XMS 3.0+ API  ** }
Procedure InitIvXMS;Near;External;

Procedure ReleaseHMA;External;
Function  AllocateHMA(Size:Word):Word;External;

Procedure GlobalEnableA20;External;
Procedure GlobalDisableA20;External;
Procedure LocalEnableA20;External;
Procedure LocalDisableA20;External;
Function  QueryA20:Boolean;External;


Function  GetFreeXMS:Word;External;      {** Result in KBytes**}
Function  GetMaxFreeBlock:Word;External;

Function  AllocateEMB(Size:Word):THandle;External;
Procedure ReleaseEMB(Handle:THandle);External;
Procedure ReallocateEMB(Handle:THandle;Size:Word);External;

Function  LockEMB(Handle:THandle):LongInt;External;
Procedure UnLockEMB(Handle:THandle);External;

Function  GetEMBSize(Handle:THandle):Word;External;
Function  GetEMBLockCount(Handle:THandle):Byte;External;
Function  GetEMBFreeHandles(Handle:THandle):Byte;External;

Function  AllocateUMB(Size:Word):Word;External;
Procedure ReleaseUMB(UMBSegment:Word);External;
Procedure ReallocateUMB(UMBSegment,Size:Word);External;
Function  UMBMaxAvail:Word;External;

Procedure MoveEMBUsers(SourceHandle:THandle;SourceOffset:LongInt;DestHandle:THandle;DestOffset:LongInt;Count:LongInt);External;


    { **  EMS 3.2+ API  ** }

Procedure GetHardwareInfo(Var Table:EMSHardwareInfoRec);near;External;
Procedure InitIvEMS;near;External;

Function  AvailEMSPages:Word;External;
Function  ActiveEMSHAndles:Word;External;

Function  AllocateEMS(Size:Word):THandle;External;
Procedure ReleaseEMS(Handle:THandle);External;
Procedure ReallocateEMS(Handle:THandle;Size:Word);External;
Function  AllocateRAWPages(Size:Word):THandle;External;
Procedure MapEMSPages(Handle:THandle;Logical_Page:Word;Phisical_Page:Byte);External;
Procedure MapUnmapPages(Handle:THandle;MapType:Byte;MapTable:Pointer;TableSize:Word);External;

Function  GetEMSHandlesTable(Var Table:PEmsArr):Word;External;

Function  GetEMS_HandlePages(Handle:THandle):Word;External;
Function  GetEMS_HandleAttr(Handle:THandle):Byte;External;
Procedure SetEMS_HandleAttr(Handle:THandle;Attr:Byte);External;
Procedure GetEMS_HandleName(Handle:THandle;Name:PEmsHandleName);External;
Procedure SetEMS_HandleName(Handle:THandle;Name:PEmsHandleName);External;
Function  FindEMS_Handle(Name:PEmsHandleName):Word;External;

Procedure MoveEMSUsers(SourceHandle:THandle;SType:Byte;SourceOffset:LongInt;
                       DestHandle:THandle;DType:Byte;DestOffset:LongInt;Count:LongInt);External;

Procedure SaveMappingContext(Handle:THandle);External;
Procedure RestoreMappingContext(Handle:THandle);External;
Procedure WarmBootPrepare;External;
Function  GetFreeRawPages:Word;External;

         { ** Expanded Memory Managers API ** }

Function  EMM386_GetState:Byte;External;
Procedure EMM386_SetState(State:Byte);External;
Function  EMM386_GetWeitekSupport:Byte;External;
Procedure EMM386_SetWeitekSupport(State:Byte);External;
Procedure EMM386_PrintCopyright;External;
Procedure EMM386_PrintReport;External;

Function  QEMM_GetHiramChain:Word;External;
Function  QEMM_GetManifestPresent:Boolean;External;
Function  QEMM_GetVersion:Word;External;
Function  QEMM_GetState:Byte;External;
Procedure QEMM_SetState(State:Byte);External;
Procedure QEMM_Copy_Stealth_Roms(Source,Dest: pointer; Size: Longint);External;

Function  QEMM_UntrappedIORead(PortNum: Word): Byte;External;
Procedure QEMM_UntrappedIOWrite(PortNum: Word;Value: Byte);External;
Function  QEMM_UntrappedIOReadIndexed(PortNum: Word; Index: Byte): Byte;External;
Procedure QEMM_UntrappedIOWriteIndexed(PortNum: Word; Index,Value: Byte);External;

Function  QEMM_GetIOCallback:Pointer;External;
Procedure QEMM_SetIOCallback(NewCallBack: Pointer);External;

Function  QEMM_GetPortTrap(PortNum: Word):Boolean;External;
Procedure QEMM_SetPortTrap(PortNum: Word);External;
Procedure QEMM_ClearPortTrap(PortNum: Word);External;

Function  QEMM_GetStealthCount:Word;External;

Procedure QEMM_GetMemoryStatistics(Var States:TQEMM_Statistics);External;
Procedure QEMM_GetInfo(Var Info:TQEMM_Info);External;



{Procedure GetHardwareInfo(Hardware:PEmsHardWareInfoRec);External;}

Begin
 InitIvXMS;
 InitIvEMS;
 GetHardwareInfo(EMSHardwareInfo);
 XMSErrorProc:=DoNone;
 EMSErrorProc:=DoNone;
end.