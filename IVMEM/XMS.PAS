Uses IvXMS,IvString,IvDos,IvSystem,IvGraph,IvKbd,IvMouse;

Type
 Str10   = string[20];

Const
 seg_Bios     = $F000;
 seg_VideoRom = $C000;

 EMSPageSize = $4000;
 Bytes   : String[6] = (' Bytes');
 Kb      : String[3] = (' Kb');
 OnOff   : Array[Boolean] of String[3] = ('OFF','ON');
 YesNo   : Array[Boolean] of String[3] = ('NO','YES');
 DrvType : Array[0..2] of String[20] = ('Unknown',
                                        'Microsoft EMM386',
                                        'Quarterdeck QEMM');
 csaDmaOperationType :  Array[boolean] of String[30] = ('Only one DMA register used.',
                                                        'DMA with alternate register.');

 NotRes  : Array[Boolean] of String[4] = ('not ','');
 Resident: String[8] = ('resident');
 csSystem  = 'SYSTEM';

var
 XMS_FreeHandles: Byte;

Function DigitToString(Num: Longint;Width:Byte):Str10;
var
 S:Str10;
begin
 Str(Num:Width,S);
 DigitToString:=S;
end;


Function WordToBCDStr(W:word):Str8;
 Begin
  WordToBCDStr:=Digit(Hi(W))+'.'+Digit(Lo(W));
 end;

Function ByteToBCDStr(B:byte):Str5;
 Begin
  ByteToBCDStr:=Digit(B shr 4)+'.'+Digit(B and 4);
 end;

Function TheWait:boolean;Far;
 Begin
  IF MousePresent THEN TheWait:=KeyPresent or LeftButton or RightButton ELSE
  TheWait:=KeyPresent;
 end;

Function PutInStr(S:string;S1:string;P:byte):string;
Var C:byte;
 Begin
  For C:=1 to Byte(S1[0]) do
   Begin
    S[P+C-1]:=S1[C];
    if Byte(S[0]) < Byte(S1[0]) + P then Byte(S[0]):=Byte(S1[0]) + P;
   end;
   PutInStr:=S;
 end;


procedure Create_Output_XMS_Table;
const
 xerrInvalidHandle = $A2;
var
 XMS_Table:Array[1..32] of THandle;
 Entries: Byte;

 procedure Create_XMS_Table;
 var
  Handle:THandle;
 const
  MaxHandles = 65534;
 begin
  Entries:=0;
  FOR Handle:=1 TO MaxHandles DO
   begin
    XMS_FreeHandles:= GetEMBFreeHandles(Handle);
    IF XMSResult Then
    begin
     Inc(Entries);
     XMS_Table[Entries]:=Handle;
    end;
   end;
  IF (Entries > 0) THEN
   XMS_FreeHandles:= GetEMBFreeHandles(XMS_Table[Entries]);
 end;

 function GetHandleAddress(Handle:THandle):LongInt;
 var
  Temp:Longint;
 begin
  Temp:=LockEMB(Handle);
  if XMSResult THEN
  begin
   UnlockEMB(Handle);
   GetHandleAddress:=Temp;
  end          ELSE
   GetHandleAddress:=0;
 end;

 procedure Output_XMS_Table;
 Const
  MessageSize = 50;
 Var
  S        : string[MessageSize];
  Count    : Byte;
 begin
  WriteCenter(GetY,TextAttr,'XMS Handles Table:');EndL;
  FastWriteln('XMS Free Handles : '+Digit(XMS_FreeHandles));
  FastWriteln('Block  Handle  Size in bytes  Lock  Address ');
  FastWriteln('-----  ------  -------------  ----  ------- ');
  IF Entries = 0 THEN FastWriteln('No any XMS handles used')  ELSE
   FOR Count:=1 TO Entries DO
    begin
     S[0]:=Char(MessageSize);
     FillByteVar(S[1],MessageSize,$20);
     S:=PutInStr(S,Digit(Count),1);
     S:=PutInStr(S,Digit(XMS_Table[Count]),8);
     S:=PutInStr(S,Digit(LongInt(GetEMBSize(XMS_Table[Count]))*1024),16);
     S:=PutInStr(S,Digit(GetEMBLockCount(XMS_Table[Count])),31);
     S:=PutInStr(S,Digit(GetHandleAddress(XMS_Table[Count])),37);
     FastWriteln(S);
    end;
 end;


begin
 FastWrite('Creating XMS Handles Table...');
 Create_XMS_Table;EndL;
 Output_XMS_Table;
end;

Procedure OutputEmsTable;
Const
 MessageSize = 50;
Var S        : string[MessageSize];
    C        : byte;
    EmsCount : byte;
    EMSTable : PEmsArr;
    HandleName : Str8;
 Begin
  New(EmsTable);
  WriteCenter(GetY,TextAttr,'EMS Handles Table:');EndL;
  FastWriteln('Handle  Pages   Size in bytes  Handle Name');
  FastWriteln('------  -----   -------------  -----------');
  EmsCount:=GetEmsHandlesTable(EMSTable);
  For C:=1 To EmsCount Do
   Begin
    S[0]:=Char(MessageSize);
    FillByteVar(S[1],MessageSize,$20);
    S:=PutInStr(S,Digit(EmsTable^[C].Handle),1);
    S:=PutInStr(S,Digit(EmsTable^[C].Pages),9);
    S:=PutInStr(S,Digit(LongInt(EmsTable^[C].Pages)*1024*16),17);
    GetEMS_HandleName(EmsTable^[C].Handle,Addr(HandleName[1]));
    HandleName[0]:=#8;
    if EmsTable^[C].Handle = 0 then HandleName:=csSystem;
    S:=PutInStr(S,HandleName,33);
    FastWriteln(S);
   end;
  DisPose(EmsTable);
 end;


procedure QEMM_InfoOutput;
Var
   InfoRec:TQEMM_Info;
   StealthList: PQEMM_StealthList;
   Count: System.Byte;
begin
 QEMM_GetInfo(InfoRec);
 StealthList:= QEMM_GetStealthList;

 FastWriteLn('QEMM  Active      : '+YesNo[Boolean(QEMM_GetState and 3)]);
 FastWriteLn('QEMM  Auto Mode   : '+YesNo[Boolean((QEMM_GetState and 2 ) shr 1)]);
 FastWriteLn('QEMM  Version     : '+WordToBCDStr(QEMM_GetVersion));
 FastWriteLn('QEMM  HiRam Chain : '+HexW(QEMM_GetHiramChain));
 FastWriteLn('QEMM  Manifest is '+NotRes[QEMM_GetManifestPresent]+Resident);
 FastWriteln('QEMM  IOCallBack  : '+HexPtr(QEMM_GetIOCallback));
 FastWriteln('QEMM  StealthCount: '+Digit(QEMM_GetStealthCount));
 EndL;
 FastWriteln('QEMM Stealth List:');
 for Count:= 1 to QEMM_GetStealthCount do
 begin
   FastWrite(' ROM at '+ HexW(StealthList^[Count].Segment) + ' with size '+ Digit(Longint(StealthList^[Count].RomSize) * 16) +
             ' bytes');

   case StealthList^[Count].Segment of
     seg_VideoRom: FastWriteln(' (Video ROM).');
     seg_Bios: FastWriteln(' (ROM Bios).');
     else  FastWriteln('.');
   end;
 end;
 EndL;
 FastWrite('QEMM  Stealth Type: ');
{ if InfoRec.Stealth_Type = 0 then
  FastWriteln('none')
 else }
  FastWriteln(Char(InfoRec.Stealth_Type));
end;

Begin
 WaitProc   := TheWait;
 SetCounter := true;
 SetPauseStr('Any key for more information...');
 FastWriteLn('XMS Present        : '+YesNo[IvXms.XMSPresent]);
 if XMSPresent Then Begin
 FastWriteLn('HMA Present        : '+YesNo[IvXms.HMAPresent]);
 FastWriteLn('XMM Driver API     : '+HexPtr(IvXms.XMM_Driver));
 FastWriteLn('XMS Version        : '+WordToBCDStr(XmsVersion));
 FastWriteLn('XMS Revision       : '+WordToBCDStr(XmsRevision));
 FastWriteLn('Line A20           : '+OnOff[IvXms.QueryA20]);
 FastWriteLn('XMS Free Memory    : '+Digit(IvXms.GetFreeXMS)+Kb);
 FastWriteLn('XMS Largest Free   : '+Digit(IvXms.GetMaxFreeBlock)+Kb);
 FastWriteLn('UMB Free Memory    : '+Digit(IvXms.UMBMaxAvail)+Bytes);
if IvXms.XMSHandlesTable = nil Then
 FastWriteLn('No XMS Table') else
  Begin
   FastWriteLn('XMS Table Addr     : '+HexPtr(IvXms.XMSHandlesTable));
   FastWriteLn('XMS Handles Array  : '+HexPtr(IvXms.XMSHandlesTable^.Table));
   FastWriteLn('Total Handles      : '+Digit(IvXms.XMSHandlesTable^.HandlesNum));
  end;
 FastWriteLn('DOS Free HMA       : '+Digit(IvDos.HMAMemAvail)+Bytes);
 FastWriteLn('Free HMA Address   : '+HexPtr(IvDos.FreeHMAAddr));
 EndL;
 {* Pause; *}
 Create_Output_XMS_Table;
 EndL;
 {* Pause; *}
 EndL;
end;
 FastWriteLn('EMS Present        : '+YesNo[EMSPresent]);
 if EMSPresent Then Begin
 FastWriteLn('EMS Version        : '+ByteToBCDStr(EMMVersion));
 FastWriteLn('Page Frame         : '+HexW(IvXms.PageFrame));
 FastWriteLn('Total  EMS Memory  : '+Digit(LongInt(TotalEMSPages)*EMSPageSize)+Bytes);
 FastWriteLn('Free   EMS Memory  : '+Digit(LongInt(AvailEMSPages)*EMSPageSize)+Bytes);
 FastWriteLn('Total  EMS Handles : '+Digit(TotalEMSHandles));
 FastWriteLn('Active EMS Handles : '+Digit(ActiveEMSHandles));
 FastWriteLn('Total  Raw Pages   : '+Digit(TotalRawPages));
 FastWriteLn('Free   Raw Pages   : '+Digit(GetFreeRawPages));
 FastWriteln('Raw  Pages Size    : '+Digit(LongInt(EMSHardwareInfo.RawPagesSize*16))+Bytes);
 FastWriteln(csaDMAOPerationType[EMSHardwareInfo.DMAOperationType]);
 FastWriteln('Number of Alternate Register sets is '+Digit(EMSHardwareInfo.AltRegsSet));
 FastWriteln('Number of registers sets assignable to DMA is '+Digit(EMSHardwareInfo.DMARegs));
 FastWriteLn('EMS Memory Manager : '+DrvType[EMSDriverType]);
 CASE EMSDriverType of
  1:  Begin
   {    FastWriteLn('EMM386  Active     : '+YesNo[Boolean(EMM386_GetState and 3)]);
        FastWriteLn('EMM386  Auto Mode  : '+YesNo[Boolean((EMM386_GetState and 2 ) shr 1)]);
   }
      end;
  2:  QEMM_InfoOutput;
   end;

 FastWriteLn('EMM   Driver API   : '+HexPtr(EMM_Driver));
 EndL;
 OutputEmsTable;
 SetCounter:=False;
end;
end.


