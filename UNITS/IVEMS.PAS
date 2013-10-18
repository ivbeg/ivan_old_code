Unit IvEms;

InterFace
Uses IvSystem;

Type
 PEmsHandleName = ^TEmsHandleName;
 TEmsHandleName = Array[1..8] of Char;

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


Var
  EMSError : byte;
  isEMM    : boolean;
  EmsIsErr : Boolean absolute EMSError;

                  { ** This Functions returns you Information about Ems ** }
{Function  EmsPresent:boolean;}
Function  QemmPresent:boolean;
Function  QemmHiramSeg:word;
Function  GetHandleName(Handle:word):str8;
Function  GetHandlePages(Handle:word):word;
Function  EmsResult:byte;
Function  EmsVersion:Byte;
Function  TotalEmsPages:word;
Function  AvailEmsPages:word;
Function  TotalHandles:word;
Function  ActiveHandles:Word;
Function  PageFrame:Word;
Function  EmsHandleTable(var Table:PEmsArr):word;
Function  FreeRawPages:word;
Function  TotalRawPages:word;
Procedure GetEmsHardwareInfo(Var Info:EmsHardwareInfoRec);
Procedure MapEmsPages(Handle:word; LogicalPage:word; PhisicalPage:byte);
Procedure SaveEmsContext(Handle:word);
Procedure RestoreEmsContext(Handle:word);
Function  GetHandleAttr(Handle:word):boolean;
Procedure SetHandleAttr(Handle:word;Attr:boolean);
Procedure SetHandleName(Handle:word;Name:TEmsHandleName);

                  { ** The Procedures give you control of Expanded Memory ** }
Procedure AllocateEmsPages(Pages:word;Var Handle:word);
Procedure DeAllocateEmsPages(Handle:word);
Procedure ReAllocateEmsPages(Handle,Pages:word;Var Result:word);


Implementation


{$L IVEMS.OBJ}

Function  EmsResult:byte;external;
Function  EmsVersion:Byte;external;
Function  TotalEmsPages:word;external;
Function  AvailEmsPages:word;external;
Function  TotalHandles:word;external;
Function  ActiveHandles:Word;external;
Function  PageFrame:Word;external;
Procedure SetHandleAttr(Handle:word;Attr:boolean);external;
Procedure SetHandleName(Handle:word;Name:TEmsHandleName);external;
Function  GetHandleName(Handle:word):str8;external;
Function  GetHandlePages(Handle:word):word;external;
Function  EmsHandleTable(var Table:PEmsArr):word;external;
Function  FreeRawPages:word;external;
Function  TotalRawPages:word;external;
Procedure GetEmsHardwareInfo(Var Info:EmsHardwareInfoRec);external;
Procedure MapEmsPages(Handle:word; LogicalPage:word; PhisicalPage:byte);external;
Procedure SaveEmsContext(Handle:word);external;
Procedure RestoreEmsContext(Handle:word);external;
Function  GetHandleAttr(Handle:word):boolean;external;

Procedure AllocateEmsPages(Pages:word;Var Handle:word);external;
Procedure DeAllocateEmsPages(Handle:word);external;
Procedure ReAllocateEmsPages(Handle,Pages:word;Var Result:word);external;

Function  QemmPresent:boolean;external;
Function  QemmHiramSeg:word;external;

end.