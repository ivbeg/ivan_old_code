Program Memview;
{$F+}
{$S-}
{$I-}
{$M 4096,100000,100000}

Uses IvCrt,IvDos,IvString,IvSystem,IvMouse,IvGraph,IvKbd,IvEms,ShowTErr;

Const
 PointersNum = 50;
 MaxParams   =  8;
Type
 TParam          = String[10];
 TMain           = Procedure(Mcb:McbBlockP);
 McbOutputBlockP = ^McbOutputBlock;
 McbOutputBlock  = record
                    Address    : McbBlockP;
                    McbType    : string[14];
                    Name       : str8;
                    Parent     : str8;
                  end;
 PMcbPointers    = ^McbPointers;
 McbPointers     = array[1..100] of McbOutputBlockP;

 ProgOutputBlockP = ^ProgOutputBlock;
 ProgOutputBlock  = record
                     Address  : McbBlockP;
                     Name     : str8;
                     Parent   : str8;
                     Envir    : str4;
                     FullPath : Pchar;
                    end;
  PPrgPointers = ^PrgPointers;
  PrgPointers  = array[1..PointersNum] of ProgOutputBlockP;

  PDeviceOutPutBlock =^DeviceOutPutBlock;
  DeviceOutPutBlock  = record
                        McbName : String[8];
                        Address : DeviceDrvRecP;
                        DrvName : String[8];
                        DevType : String[30];
                       end;
  PDrvPointers = ^DrvPointers;
  DrvPointers  = array[1..PointersNum] of PDeviceOutputBlock;



Const
 gcsBytes        = ' bytes';
 gcsConvent      = 'Conventional Memory: ';
 gcsCharacterDev = 'Character ';
 gcsInternal     = 'Internal ';
 gcsBlockDev     = 'Block ';
 gcsSubUnits     = ' SubUnits ';

 EndMcbType    = 'Z';
 SystemBlock:array[Boolean] of Str4 = ('Code','Data');
 SysBlock      = 'SysBlock';
 DosSystem     = 'System ';
 IoSys         = 'IO.SYS';
 Enviroment    = 'Environment';
 FreeMemory    = 'Free Memory';
 ProgData      = ' Data';
 ProgramType   = 'TSR Program';
 DeviceDriver  = 'Device ';
 DevDrvApp     = 'Dev. Drv. App.';
 DosFcbTable   = 'FCB Table';
 DosBuffers    = 'BUFFERS';
 DosFiles      = 'FILES';
 DosStacks     = 'STACKS';
 Driver        = 'Driver';
 DosEmsStacks  = 'EMS ';
 DosCurrDir    = 'Current Dirs';
 Unknown       = 'Unknown';

 None          = 'None';
 NoPSP         = 'No PSP';
 NoEnviroment  :  String[14] = ('No Enviroment'+#0);
 CmdLine       = 'CMDLINE';
 DosData       = 'DOS';
 PspMask       = $20CD;
 MsdosSys      = 'MSDOS.SYS';
 ThisProg      = 'This Program';
 UmbManager    = 'UMB Manager';

 asPurpose     = 'Memory Viewer Utility';
 asVersion     = '1.12';
 asAuthor      = 'Ivan Begtin';
 asCopyright   = 'Copyright (c) 1995';
 asProgram     = 'MemView';

Var DrvListOk,
    TsrListOk,
    McbListOk,
    WriteMemInfoOk,
    ShowHelp      : boolean;

    AdvancedCheck : boolean;
    UmbCheck      : boolean;
    SavedMcb      : McbBlockP;
    CurrMcb       : McbBlockP;
    SegOfe        : SegOfs absolute CurrMcb;
    Count         : byte;
    LastCount     : byte;
    CurrStr       : Pstring;
    CurrPchar     : Pchar absolute CurrStr;
    MPointers     : PMcbPointers;
    UmbPresent    : Boolean;
    FindLast      : Boolean;
    Data          : boolean;
    PPointers     : PPrgPointers;
    DPointers     : PDrvPointers;

Procedure SetPagesOut;
 Begin
  SetCounter:=True;
 end;

Procedure SetUmbCheck;
 Begin
  UmbCheck:=true;
 end;

Procedure SetAdvCheck;
 Begin
  AdvancedCheck:=true;
 end;

Procedure UseDosOutput;
 Begin
  DosOutPut:=true;
 end;

Procedure SetTsrList;
 Begin
  TsrListOk:=True;
 end;

Procedure SetDrvList;
 Begin
  DrvListOk:=True;
 end;

Procedure SetMcbList;
 Begin
  McbListOk:=True;
 end;

Procedure WriteHelp;Forward;

Procedure SetHelp;
 Begin
  ShowHelp:=true;
 end;

Const
 ParamsArr     :Array[1..MaxParams] of TParam =
                                     ('/P',
                                      '/U',
                                      '/A',
                                      '/O',
                                      '/H',
                                      '/M',
                                      '/T',
                                      '/D');
 ParamsCall    :Array[1..MaxParams] of Procedure =(SetPagesOut,
                                                  SetUmbCheck,
                                                  SetAdvCheck,
                                                  UseDosOutput,
                                                  SetHelp,
                                                  SetMcbList,
                                                  SetTsrList,
                                                  SetDrvList);
 HelpParams    :Array[1..MaxParams] of String[45] =
                                       ('Pauses after each screenfull',
                                        'Display UMB Mcb'#39's (if present)',
                                        'Set Advanced Check for Errors in MCB Chain',
                                        'Use Dos Output for redirect',
                                        'This Help',
                                        'List of MCB'#39's in memory',
                                        'TSR Programs list',
                                        'Device Drivers List');

Procedure WriteHeader;
 Begin
  WriteStr(asPurpose+' '+'Version '+asVersion+' '+asCopyright+' '+asAuthor);EndL;
 end;


Procedure InitHelp;
 Begin
  if (ShowHelp or not (TsrListOk or McbListOk or DrvListOk)) then WriteHelp;
 end;

Procedure WriteHelp;
Var C:byte;
 Begin
  WriteStr('Usage ');
  For C:=1 To MaxParams Do
   Begin
    WriteStr('['+ParamsArr[C]+'] ');
   end;
  EndL;
  For C:=1 To MaxParams Do
   Begin
    WriteStr('  '+ParamsArr[C]+' - '+HelpParams[C]);EndL;
   end;
  Halt(0);
 end;


Procedure ReadCommandLine;
Var C:byte;
    C1:byte;
 Begin
  if ParamCount > 0 then
  For C:=1 To ParamCount DO
   Begin
    For C1:=1 to MaxParams DO
     if StrUpp(Paramstr(C)) = ParamsArr[C1] then ParamsCall[C1];
   End;
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


Function CharsToStr(A:array of Char):string;
Var C:byte;
 Begin
   ArrChToPchar(A,CurrPchar);
   CharsToStr:=PcharToStr(CurrPchar);
 end;

Function  TheWait:boolean;Far;
 Begin
  TheWait:=KeyPresent or LeftButton or RightButton;
 end;



Function  PspPresent(Seg:word):Boolean;
 Begin
  PspPresent:=(PspRecP(Ptr(Seg,0))^.RetComm = PspMask);
 end;

Procedure CheckMcb;
 Begin
  if not (byte(CurrMcb^.McbType) < 65) and (byte(CurrMcb^.McbType) > 90) then
   Begin
    WriteStr('Error in Memory chain at '+HexPtr(CurrMcb)+' . Halting...');EndL;
    Halt(9);
   end;
 end;

Function ReallyMcb(Se:word):boolean;
Var Ok:boolean;
 Begin
  Ok:=(byte(McbBlockP(Ptr(Se,0))^.McbType) > 64) and (byte(McbBlockP(Ptr(Se,0))^.McbType) < 91);
  Se:=Se+McbBlockP(Ptr(Se,0))^.Size+1;
  ReallyMcb:=(Ok and (byte(McbBlockP(Ptr(Se,0))^.McbType) > 64) and (byte(McbBlockP(Ptr(Se,0))^.McbType) < 91));
 end;


Procedure WriteMemInfo;
 Begin
 if not WriteMemInfoOk then
  Begin
   EndL;
   WriteStr('Memory Info.');EndL;
   WriteStr('------------');Endl;
   WriteStr('Total '+gcsConvent+Digit(LongInt(LowMem)*1024)+gcsBytes);EndL;
   WriteStr('Free  '+gcsConvent+Digit(DosMaxMem)+gcsBytes);EndL;EndL;
   WriteMemInfoOk:=true;
  end;
 end;


Procedure UmbProc(MainProcedure:TMain);
Var P:pointer;
    S:string[30];
 Begin
  EndL;
  LastCount:=Count;
  if QemmPresent then
   Begin
    SetUmbLinkState(true);
    P:=Ptr($9FFF,0);
    S:='{ ** Qemm '+UmbManager+' ** }';
   end else
    Begin
     if GetUmbLinkState then S:='{ ** MS-DOS '+UmbManager+' ** }' else
     S:='{ ** Unknown '+UmbManager+' ** }';
     P:=SavedMcb;
    end;
  WriteStr(S);ENDL;
  WriteStr('UMB Memory Control Blocks');EndL;
  WriteStr('--- ------ ------- ------');EndL;
  MainProcedure(P);
  SetUmbLinkState(false);
 end;


Procedure OutPutMcb(B:byte);
Var S:string[70];
    C:byte;
 Begin
  For C:=B to Count do
   Begin
  With MPointers^[C]^ do
   Begin
    S:=CharRep(#32,61);
    S:=PutinStr(S,HexPtr(Address),1);
    S:=PutinStr(S,Name,13);
    S:=PutinStr(S,HexW(Address^.Owner),22);
    S:=PutinStr(S,Digit(Longint(Address^.Size)*16),30);
    S:=PutinStr(S,McbType,37);
    S:=PutinStr(S,Parent,53);
    WriteStr(S);EndL;
   end;
   end;
 end;

Procedure SystemDataOutPut;
Var DataMcb:McbBlockP;
    DataSegOfs:SegOfs absolute DataMcb;
Begin
 DataMcb:=CurrMcb;
 Inc(SegOfe.S);
 FindLast:=False;
 repeat
  Inc(Count);
  New(MPointers^[Count]);
  MPointers^[Count]^.Address:=CurrMcb;
  MPointers^[Count]^.Name:=CharsToStr(CurrMcb^.Name);
  if MPointers^[Count]^.Name[0] = Char(0) then MPointers^[Count]^.Name:=None;
  MPointers^[Count]^.Parent:=DosData+ProgData;
  Case CurrMcb^.McbType of
   'D': MPointers^[Count]^.McbType:=DeviceDriver+Driver;
   'I': MPointers^[Count]^.McbType:=DosSystem+Driver
   else
    Begin
     MPointers^[Count]^.Name:=None;
   Case CurrMcb^.McbType of
   'E': MPointers^[Count]^.McbType:=DevDrvApp;
   'X': MPointers^[Count]^.McbType:=DosFcbTable;
   'F': MPointers^[Count]^.McbType:=DosFiles;
   'S': MPointers^[Count]^.McbType:=DosStacks;
   'C': MPointers^[Count]^.McbType:=DosEmsStacks + DosStacks;
   'B': MPointers^[Count]^.McbType:=DosBuffers;
   'L': MPointers^[Count]^.McbType:=DosCurrDir;
   else MPointers^[Count]^.McbType:=Unknown;
  end;
  end;
  end;
   SegOfe.S:=SegOfe.S+CurrMcb^.Size+1;
   FindLast:=(DataSegOfs.S+DataMcb^.Size+1 = SegOfe.S);
 Until Findlast;
  SegOfe.S:=DataSegOfs.S;
  FindLast:=False;
end;

Procedure SortMCBInformation;
Var SaveB:byte;
 Begin
  Data:=False;
  SaveB:=Byte(MPointers^[Count]^.Name[0]);
  Byte(MPointers^[Count]^.Name[0]):=2;
  if CurrMcb^.Owner <> SegOfe.S+1 then
   if (CurrMcb^.Name[1] = 'S') and ((CurrMcb^.Name[2] = 'D') or (CurrMcb^.Name[2] = 'C')) then
    Begin
     if MPointers^[Count]^.Name = 'SD' then Data:=true;
     MPointers^[Count]^.McbType:=DosSystem+SystemBlock[Data];
     MPointers^[Count]^.Parent:=IoSys;
     if Data then SystemDataOutPut;
    end else
    if PspRecP(Ptr(CurrMcb^.Owner,0))^.PrgEnvSeg = SegOfe.S+1 then
     Begin
      MPointers^[Count]^.Name:=CharsToStr(McbBlockP(Ptr(CurrMcb^.Owner-1,0))^.Name);
      MPointers^[Count]^.McbType:=Enviroment;
      MPointers^[Count]^.Parent:=None;
     end
    else
     Begin
      MPointers^[Count]^.Name:=CharsToStr(McbBlockP(Ptr(CurrMcb^.Owner-1,0))^.Name);
      MPointers^[Count]^.McbType:=MPointers^[Count]^.Name+ProgData;
      MPointers^[Count]^.Parent:=None;
     end
    else
     Begin
      Byte(MPointers^[Count]^.Name[0]):=SaveB;
      if PspPresent(SegOfe.S+1) then
      begin
       if SegOfe.S +1 <> PrefixSeg then
       MPointers^[Count]^.McbType:=ProgramType
                                   else
       MPointers^[Count]^.McbType:=ThisProg;
       if McbBlockP(Ptr(PspRecP( Ptr( SegOfe.S+1,0 ))^.PrgOwnerSeg-1,0))^.McbType = 'M' then
       MPointers^[Count]^.Parent:=CharsToStr(McbBlockP(Ptr(PspRecP( Ptr( SegOfe.S+1,0 ))^.PrgOwnerSeg-1,0))^.Name)
       else MPointers^[Count]^.Parent:=None;
      end                       else
      Begin
       MPointers^[Count]^.McbType:=Unknown;
       MPointers^[Count]^.Parent:=NoPsp;
      end;

     end;
   if CurrMcb^.Owner = 0 then
    Begin
     MPointers^[Count]^.Name:=None;
     MPointers^[Count]^.McbType:=FreeMemory;
    end;
    end;


Procedure UmbMcbProc(StartMcb:McbBlockP);
 Begin


 end;

Procedure MainMcbProc(StartMcb:McbBlockP);
 begin
  FindLast:=False;
  CurrMcb:=StartMcb;
  repeat
   if  AdvancedCheck then CheckMcb;
   Inc(count);
   New(MPointers^[Count]);
   MPointers^[Count]^.Address:=CurrMcb;
   MPointers^[Count]^.Name:=CharsToStr(CurrMcb^.Name);
   if MPointers^[Count]^.Name[0] = Char(0) then MPointers^[Count]^.Name:=None;
   SortMCBInformation;
   FindLast:=(CurrMcb^.McbType = 'Z');
   if  AdvancedCheck then CheckMcb;
   SegOfe.S:=SegOfe.S+CurrMcb^.Size+1;
   if (CurrMcb^.McbType = 'M') and FindLast then
    Begin
     UmbPresent:=true;
     SavedMcb:=CurrMcb;
    end;
   Until FindLast;
 end;

Procedure InitMcbList;
 Begin
  New(MPointers);
  LastCount:=0;
  Count:=0;
  UmbPresent:=False;
 end;

Procedure FreeMcbListMemory;
Var C:byte;
 Begin
  For C:=1 to Count do Dispose(MPointers^[C]);
  Dispose(MPointers);
 end;

Procedure StartMcbList;
 Begin
  CurrMcb:=Ptr(SysVars^.FirstMcbSeg,0);
  WriteStr('Global MCB List. First MCB at '+HexPtr(CurrMcb));EndL;Endl;
  WriteStr('Segm:Offs   Name     Owner   Size     Type of Block   Parent ');EndL;
  WriteStr('---------   ----     -----   ----     -------------   ------ ');EndL;
  MainMcbProc(Ptr(SysVars^.FirstMcbSeg,0));
  OutPutMcb(1);
  if (UmbPresent or QemmPresent) and UmbCheck then Begin
   UmbProc(MainMcbProc);
   OutPutMcb(LastCount+1);
  end;
  WriteStr(CharRep(#45,61));EndL;
  WriteStr('Total Mcb'+#96+'s Num: '+Digit(Count));EndL;
  EndL;
 end;

Procedure McbBlocksList;
Begin
 if McbListOk then
 Begin
  WriteMemInfo;
  InitMcbList;
  StartMcbList;
  FreeMcbListMemory;
 end;
end;


Procedure OutPutPrg(Start,Last:byte);
Const
 StrSize = 44;
Var S:string[StrSize];
    C:byte;
 Begin
  For C:=Start To Last Do
   Begin
  With PPointers^[C]^ do
   Begin
    S:=CharRep(#32,StrSize);
    S:=PutInStr(S,HexPtr(Address),1);
    S:=PutInStr(S,Name,12);
    S:=PutInStr(S,Envir,21);
    S:=PutInStr(S,Digit(LongInt(Address^.Size)*16),28);
    S:=PutInStr(S,Parent,36);
    WriteStr(S);
    WritePchar(FullPath);EndL;
   end;
 end;
end;

Procedure FreeTSRListMemory;
Var C:byte;
 Begin
  For C:=1 to Count do Dispose(PPointers^[C]);
  Dispose(PPointers);
 End;

Procedure SortTSRInformation;
 Begin
  if CurrMcb^.Owner = SegOfe.S+1 then
   Begin
    if PspPresent(SegOfe.S+1) then
     Begin
      if McbBlockP(Ptr(PspRecP(Ptr(SegOfe.S+1,0))^.PrgOwnerSeg-1,0))^.McbType = 'M' then
      PPointers^[Count]^.Parent  :=CharsToStr(McbBlockP(Ptr(PspRecP(Ptr(SegOfe.S+1,0))^.PrgOwnerSeg-1,0))^.Name) else
      PPointers^[Count]^.Parent  :=None;
      PPointers^[Count]^.Envir   :=HexW(PspRecP(Ptr(SegOfe.S+1,0))^.PrgEnvSeg);
      PPointers^[Count]^.FullPath:=EnvString(Ptr(PspRecP(Ptr(SegOfe.S+1,0))^.PrgEnvSeg,0),CmdLine);
      {SearchString(Ptr(PspRecP(Ptr(SegOfe.S+1,0))^.PrgEnvSeg,0)
      ,McbBlockP(Ptr(PspRecP(Ptr(SegOfe.S+1,0))^.PrgEnvSeg-1,0))^.Size,CmdLine);}
      if PPointers^[Count]^.FullPath = nil Then Pointer(PPointers^[Count]^.FullPath) :=Addr(NoEnviroment[1]) else
     end                      else
     Begin
      PPointers^[Count]^.Parent  :=NoPsp;
      PPointers^[Count]^.Envir   :=None;
      PPointers^[Count]^.FullPath:=Addr(NoEnviroment[1]);
     end;
   end else Dec(Count);
 end;

Procedure MainTSRProc(StartMcb:McbBlockP);
 Begin
  FindLast:=False;
  CurrMcb:=StartMcb;
  repeat
  if AdvancedCheck then CheckMcb;
  Inc(Count);
  New(PPointers^[Count]);
  PPointers^[Count]^.Address:=CurrMcb;
  PPointers^[Count]^.Name:=CharsToStr(CurrMcb^.Name);
  SortTsrInformation;
  FindLast:=(CurrMcb^.McbType = 'Z');
  SegOfe.S:=SegOfe.S+CurrMcb^.Size+1;
  if (CurrMcb^.McbType = 'M') and FindLast then
   Begin                            UmbPresent:=true;
    SavedMcb:=CurrMcb;
   end;
  Until FindLast;
   end;

Procedure StartTSRList;
Begin
 CurrMcb:=Ptr(SysVars^.FirstMcbSeg,0);
 WriteStr('TSR Programs List. First MCB at '+HexPtr(CurrMcb));EndL;
 WriteStr('Segm:Offs  McbName  Envir  Size    Parent   FullName');EndL;
 WriteStr('---------  -------  -----  ----    ------   --------');EndL;
 MainTsrProc(Ptr(SysVars^.FirstMcbSeg,0));
 OutPutPrg(1,Count);
 if (UmbPresent or QemmPresent) and UmbCheck then
  Begin
   UmbProc(MainTsrProc);
   OutPutPrg(LastCount+1,Count);
  end;
 WriteStr(CharRep(#45,44));EndL;
 WriteStr('Total TSR'+#96+'s Num: '+Digit(Count));EndL;
 EndL;
end;

Procedure InitTsrList;
 Begin
  New(PPointers);
  LastCount:=0;
  Count:=0;
  UmbPresent:=False;
 end;


Procedure TSRProgramsList;
 Begin
  if TsrListOk then
   Begin
    WriteMemInfo;
    InitTsrList;
    StartTsrList;
    FreeTSRListMemory;
   end;
 end;

Procedure OutPutDrv;
Const
 StrSize = 60;
Var S:String[StrSize];
    C:byte;
 Begin
  WriteStr('Device Drivers List.');EndL;EndL;
  WriteStr('Segm:Offs  Dev.Name  Attr  MCB Name  Type');EndL;
  WriteStr('---------  --------  ----  --------  ----');EndL;
  For C:=1 To Count Do
  With DPointers^[C]^ DO
   Begin
    S:=CharRep(#32,StrSize);
    S:=PutInStr(S,HexPtr(Address),1);
    S:=PutInStr(S,DrvName,12);
    S:=PutInStr(S,HexW(Address^.DevAttr),22);
    S:=PutInStr(S,McbName,28);
    S:=PutInStr(S,DevType+DeviceDriver,38);
    WriteStr(S);EndL;
   end;
 end;

Procedure InitDrvList;
 Begin
  Count:=0;
  New(DPointers);
 end;

Procedure FreeDrvMemory;
Var C:byte;
 Begin
  For C:=1 To Count Do
   Dispose(DPointers^[C]);
  Dispose(DPointers);
 end;

Procedure MainDrvProc;
Type
 PBlockDeviceRec = ^BlockDeviceRec;
 BlockDeviceRec = record
                   NextDevice :DeviceDrvRecP;
                   DevAttr,
                   DevStrat,
                   DevInterr  :word;
                   Subunits   :byte;
                   Name       :array[1..7] of Char;
                  end;

Var CurrDev:DeviceDrvRecP;
    DevSeOfe:SegOfs absolute CurrDev;
 Begin
  CurrDev:=Addr(SysVars^.NullDevice);
  Count:=0;
  repeat
   Inc(Count);
   New(DPointers^[Count]);
   With DPointers^[Count]^ Do
    Begin
     Address:=CurrDev;
     if not BitofW(CurrDev^.DevAttr,15) then
      Begin
       DrvName:=CharsToStr(PBlockDeviceRec(CurrDev)^.Name);
       DevType:=gcsBlockDev +'( ' + Digit(Byte(CurrDev^.Name[1]))+gcsSubUnits+' )';
      end else
      Begin
       DrvName:=CharsToStr(CurrDev^.Name);
       if DevSeOfe.S = $70 then DevType:=gcsInternal else
       DevType:=gcsCharacterDev;
      end;
     if ReallyMcb(DevSeOfe.S-1) then McbName:=CharsToStr(McbBlockP(Ptr(DevSeOfe.S-1,0))^.Name)
                               else McbName:=None;
    end;
    CurrDev:=CurrDev^.NextDevice;
  Until (DevSeOfe.O = $FFFF);
 end;

Procedure DeviceDriversList;
 Begin
 if DrvListOk then
  Begin
   InitDrvList;
   MainDrvProc;
   OutPutDrv;
   FreeDrvMemory;
  end;
 end;

Procedure EmsList;
 Begin
 end;

Procedure XmsList;
 Begin
 end;

Procedure InitializeMemView;
 Begin
  New(CurrStr);
  ShowHelp:=false;
  AsciizString(CurrStr);
  DosOutPut:=false;
  TsrListOk:=false;
  DrvListOk:=false;
  WriteMemInfoOk:=False;
  McbListOk:=false;
  UmbCheck :=false;
  WaitProc :=TheWait;
  SetCounter:=false;
  AdvancedCheck:=false;
  ReadCommandLine;
 end;

Procedure StartMemview;
 Begin
  WriteHeader;
  InitHelp;
  McbBlocksList;
  TsrProgramsList;
  DeviceDriversList;
 end;

Procedure FreeMemview;
 Begin
  Dispose(CurrStr);
 end;

Begin
 InitializeMemView;
 StartMemview;
 FreeMemview;
end.



