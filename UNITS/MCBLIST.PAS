Program McbList;
{$S-}
{$I-}
{$F+}
Uses IvSystem,IvString
    ,IvCrt,IvDos,IvEms
    ,IvXms,IvMouse
    ,IvGraph,IvKbd;

Type
 McbOutputBlockP = ^McbOutputBlock;
 McbOutputBlock  = record
                    Address    : McbBlockP;
                    McbType    : string[14];
                    Name       : str8;
                    Parent     : str8;
                  end;
 PMcbPointers    = ^McbPointers;
 McbPointers     = array[1..100] of McbOutputBlockP;
 TParam          = String[10];

Const
 MaxParams     =  5;
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

 asPurpose     = 'Memory Control Blocks Lister';
 asVersion     = '1.15';
 asAuthor      = 'Ivan Begtin';
 asCopyright   = 'Copyright (C) 1995';
 asProgram     = 'McbList';


 None          = 'None';
 DosData       = 'DOS';
 PspMask       = $20CD;
 NoPsp         = 'No PSP';
 MsdosSys      = 'MSDOS.SYS';
 ThisProg      = 'This Program';
 UmbManager    = 'UMB Manager';


Var UmbPresent:boolean;
    UmbCheck  :boolean;
    AdvancedCheck:boolean;
    Count:byte;
    FindLast:boolean;
    Data:boolean;
    CurrMcb:McbBlockP;
    SegOfe:SegOfs absolute CurrMcb;
    Pointers:PMcbPointers;
    CurrPchar:PChar;
    LastCount:byte;

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

Procedure WriteHelp;Forward;

Const
 ParamsArr     :Array[1..MaxParams] of TParam =
                                     ('/P',
                                      '/U',
                                      '/A',
                                      '/D',
                                      '/H');
 ParamsCall    :Array[1..MaxParams] of Procedure =(SetPagesOut,
                                                  SetUmbCheck,
                                                  SetAdvCheck,
                                                  UseDosOutput,
                                                  WriteHelp);
 HelpParams    :Array[1..MaxParams] of String[32] =
                                       ('Pauses after each screenfull',
                                        'Display UMB Mcb'#39's (if present)',
                                        'Set Advanced Check for Errors in MCB Chain',
                                        'Use Dos Output for redirect',
                                        'This Help');

Procedure WriteHeader;
 Begin
  WriteStr(asPurpose+' '+'Version '+asVersion+' '+asCopyright+' '+asAuthor);EndL;
 end;

Procedure WriteHelp;
Var C:byte;
 Begin
  WriteHeader;
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

Function SearchPointer(P:pointer):byte;
Var C:byte;
    Found:boolean;
 Begin
  C:=LastCount+1;
  Dec(SegOfs(P).S);
  repeat
   Inc(C);
   if Pointers^[C]^.Address = P then
    Begin
     Found:=true;
    end;
  Until Found or (C = LastCount);
  if Found = false then C:=255;
  SearchPointer:=C;
 end;

Procedure SetPtrType(P:pointer;Typ:string);
Var Found:byte;
 Begin
  Found:=SearchPointer(P);
  if Found < 255 then Pointers^[Found]^.McbType:=Typ;
 end;

Procedure InitDosAddresses;
 Begin
  With SysVars^ do
   Begin
    SetPtrType(CurrDiskBuff,DosBuffers);
    SetPtrType(DosDiskBuffer,DosBuffers);
    SetPtrType(FirstSft^.NextSft,DosFiles);
    SetPtrType(CurrDirAddr,DosCurrDir);
    SetPtrType(FcbTableAddr,DosFcbTable);
   end;
 end;


Function TheWait:boolean;Far;
 Begin
  TheWait:=KeyPresent or LeftButton or RightButton;
 end;

Function  PspPresent(Seg:word):boolean;
 Begin
  PspPresent:=(PspRecP(Ptr(Seg,0))^.RetComm = PspMask);
 end;


Function PutStr(S:string;S1:string;P:byte):string;
Var C:byte;
 Begin
  For C:=1 to Byte(S1[0]) do
   Begin
    S[P+C-1]:=S1[C];
    if Byte(S[0]) < Byte(S1[0]) + P then Byte(S[0]):=Byte(S1[0]) + P;
   end;
   PutStr:=S;
 end;

Function CharsToStr(A:array of Char):string;
Var C:byte;
 Begin
   ArrChToPchar(A,CurrPchar);
   CharsToStr:=PcharToStr(CurrPchar);
 end;

Procedure CheckMcb;
 Begin
  if not (byte(CurrMcb^.McbType) < 65) and (byte(CurrMcb^.McbType) > 90) then
   Begin
    WriteStr('Error in Memory Chain at '+HexPtr(CurrMcb)+'. Halting...');EndL;
    Halt(9);
   end;
 end;

Procedure OutPutMcb(B:byte);
Var S:string[61];
    C:byte;
 Begin
  For C:=B to Count do
   Begin
  With Pointers^[C]^ do
   Begin
    S:=CharRep(#32,61);
    S:=PutStr(S,HexPtr(Address),1);
    S:=PutStr(S,Name,13);
    S:=PutStr(S,HexW(Address^.Owner),22);
    S:=PutStr(S,Digit(Longint(Address^.Size)*16),30);
    S:=PutStr(S,McbType,37);
    S:=PutStr(S,Parent,53);
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
  New(Pointers^[Count]);
  Pointers^[Count]^.Address:=CurrMcb;
  Pointers^[Count]^.Name:=ArrChToStr(CurrMcb^.Name);
  if Pointers^[Count]^.Name[0] = Char(0) then Pointers^[Count]^.Name:=None;
  Pointers^[Count]^.Parent:=DosData+ProgData;
  Case CurrMcb^.McbType of
   'D': Pointers^[Count]^.McbType:=DeviceDriver+Driver;
   'I': Pointers^[Count]^.McbType:=DosSystem+Driver
   else
    Begin
     Pointers^[Count]^.Name:=None;
   Case CurrMcb^.McbType of
   'E': Pointers^[Count]^.McbType:=DevDrvApp;
   'X': Pointers^[Count]^.McbType:=DosFcbTable;
   'F': Pointers^[Count]^.McbType:=DosFiles;
   'S': Pointers^[Count]^.McbType:=DosStacks;
   'C': Pointers^[Count]^.McbType:=DosEmsStacks + DosStacks;
   'B': Pointers^[Count]^.McbType:=DosBuffers;
   'L': Pointers^[Count]^.McbType:=DosCurrDir;
   else Pointers^[Count]^.McbType:=Unknown;
  end;
  end;
  end;
   SegOfe.S:=SegOfe.S+CurrMcb^.Size+1;
   FindLast:=(DataSegOfs.S+DataMcb^.Size+1 = SegOfe.S);
 Until Findlast;
  SegOfe.S:=DataSegOfs.S;
  FindLast:=False;
end;

Procedure SortInformation;
Var SaveB:byte;
 Begin
  Data:=False;
  SaveB:=Byte(Pointers^[Count]^.Name[0]);
  Byte(Pointers^[Count]^.Name[0]):=2;
  if CurrMcb^.Owner <> SegOfe.S+1 then
   if (CurrMcb^.Name[1] = 'S') and ((CurrMcb^.Name[2] = 'D') or (CurrMcb^.Name[2] = 'C')) then
    Begin
     if Pointers^[Count]^.Name = 'SD' then Data:=true;
     Pointers^[Count]^.McbType:=DosSystem+SystemBlock[Data];
     Pointers^[Count]^.Parent:=IoSys;
     if Data then SystemDataOutPut;
    end else
    if PspRecP(Ptr(CurrMcb^.Owner,0))^.PrgEnvSeg = SegOfe.S+1 then
     Begin
      Pointers^[Count]^.Name:=CharsToStr(McbBlockP(Ptr(CurrMcb^.Owner-1,0))^.Name);
      Pointers^[Count]^.McbType:=Enviroment;
      Pointers^[Count]^.Parent:=None;
     end
    else
     Begin
      Pointers^[Count]^.Name:=CharsToStr(McbBlockP(Ptr(CurrMcb^.Owner-1,0))^.Name);
      Pointers^[Count]^.McbType:=Pointers^[Count]^.Name+ProgData;
      Pointers^[Count]^.Parent:=None;
     end
    else
     Begin
      Byte(Pointers^[Count]^.Name[0]):=SaveB;
      if PspPresent(SegOfe.S+1) then
      begin
       if SegOfe.S +1 <> PrefixSeg then
       Pointers^[Count]^.McbType:=ProgramType
                                   else
       Pointers^[Count]^.McbType:=ThisProg;
       if McbBlockP(Ptr(PspRecP( Ptr( SegOfe.S+1,0 ))^.PrgOwnerSeg-1,0))^.McbType = 'M' then
       Pointers^[Count]^.Parent:=CharsToStr(McbBlockP(Ptr(PspRecP( Ptr( SegOfe.S+1,0 ))^.PrgOwnerSeg-1,0))^.Name)
       else Pointers^[Count]^.Parent:=None;
      end                       else
      Begin
       Pointers^[Count]^.McbType:=Unknown;
       Pointers^[Count]^.Parent:=NoPsp;
      end;

     end;
   if CurrMcb^.Owner = 0 then
    Begin
     Pointers^[Count]^.Name:=None;
     Pointers^[Count]^.McbType:=FreeMemory;
    end;
    end;

Procedure MainProc(StartMcb:McbBlockP);
 begin
  FindLast:=False;
  CurrMcb:=StartMcb;
  repeat
   if  AdvancedCheck then CheckMcb;
   Inc(count);
   New(Pointers^[Count]);
   Pointers^[Count]^.Address:=CurrMcb;
   Pointers^[Count]^.Name:=CharsToStr(CurrMcb^.Name);
   if Pointers^[Count]^.Name[0] = Char(0) then Pointers^[Count]^.Name:=None;
   SortInformation;
   FindLast:=(CurrMcb^.McbType = 'Z');
   if  AdvancedCheck then CheckMcb;
   SegOfe.S:=SegOfe.S+CurrMcb^.Size+1;
   if (CurrMcb^.McbType = 'M') and FindLast then
    Begin
     UmbPresent:=true;
     Pointer(Pointers^[Count+1]):=Pointer(CurrMcb);
    end;
   Until FindLast;
 end;


Procedure InitializeProgram;
 Begin
   DosOutPut:=false;
   New(Pointers);
   New(CurrPchar);
   LastCount:=0;
   Count:=0;
   UmbCheck:=false;
   UmbPresent:=False;
   AdvancedCheck:=false;
   WaitProc:=TheWait;
   SetCounter:=false;
   ReadCommandLine;
 end;


Procedure FreeProgramMemory;
Var C:byte;
 Begin
  For C:=1 to Count do Dispose(Pointers^[C]);
  Dispose(Pointers);
  Dispose(CurrPchar);
 end;

Procedure UmbProc;
Var P:pointer;
    S:string[30];
 Begin
  EndL;
  LastCount:=Count;
  if QemmPresent then
   Begin
    P:=Ptr(QemmHiRamSeg,0);
    S:='{ ** Qemm'+UmbManager+' ** }';
   end else
    Begin
     if GetUmbLinkState then S:='{ ** MS-DOS '+UmbManager+' ** }' else
     S:='{ ** Unknown '+UmbManager+' ** }';
     P:=Pointer(Pointers^[Count+1]);
    end;
  WriteStr(S);ENDL;
  WriteStr('UMB Memory Control Blocks');EndL;
  WriteStr('--- ------ ------- ------');EndL;
  MainProc(P);
 end;


Procedure StartProgram;
 Begin
   WriteStr('Segm:Offs   Name     Owner   Size     Type of Block   Parent ');EndL;
   WriteStr('---------   ----     -----   ----     -------------   ------ ');EndL;
   MainProc(Ptr(SysVars^.FirstMcbSeg,0));
   OutPutMcb(1);
   if (UmbPresent or QemmPresent) and UmbCheck then Begin
    UmbProc;
   OutPutMcb(LastCount+1);
   end;
   SetCounter:=False;
   Counter:=0;
   WriteStr(CharRep(#45,61));EndL;
   WriteStr('Total Mcb'+#96+'s Num: '+Digit(Count));EndL;
 end;


Begin
 InitializeProgram;
 WriteHeader;
 StartProgram;
 FreeProgramMemory;
end.
