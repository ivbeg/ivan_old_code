{$S-}
{$I-}
Uses IvSystem,IvDos,IvKbd,IvString,IvCrt,IvEms,IvMouse;

Const
 NoPSP        = 'No PSP';
 None         = 'None';
 PspMask      = $20CD;
 NoEnviroment : String[14] = ('No Enviroment'+#0);
 CmdLine      = 'CMDLINE';
 PointersNum  = 50;
 UmbManager   : String[12] = ('UMB Manager');

Type
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

Var
    AdvancedCheck  : boolean;
    UmbCheck       : boolean;
    UmbPresent     : boolean;
    FindLast       : boolean;
    CurrMcb        : McbBlockP;
    SegOfe         : SegOfs absolute CurrMcb;
    CurrPchar      : Pchar;
    Pointers       : PPrgPointers;
    Count          : byte;
    LastCount      : byte;
    NoEnvir        : Pchar;


Function TheWait:Boolean;Far;
 Begin
  TheWait:=KeyPresent or LeftButton or RightButton;
 end;


Procedure InitProgram;
 Begin
  NoEnvir:=Addr(NoEnviroment[1]);
  New(Pointers);
  New(CurrPchar);
  UmbCheck:=True;
  AdvancedCheck:=true;
  WaitProc:=TheWait;
  UmbPresent:=false;
  DosOutPut:=true;
  SetCounter:=true;
  Count:=0;
  LastCount:=0;
 end;


Function PspPresent(Se:word):boolean;
 Begin
  PspPresent:=(PspRecP(Ptr(Se,0))^.RetComm = PspMAsk);
 end;

Function CharsToStr(A:array of Char):string;
 Begin
  ArrChToPchar(A,CurrPchar);
  CharsToStr:=PcharToStr(CurrPchar);
 end;

Procedure OutPutPrg(Start,Last:byte);
Const
 StrSize = 44;
Var S:string[StrSize];
    C:byte;
 Begin
  For C:=Start To Last Do
   Begin
  With Pointers^[C]^ do
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

Procedure CheckMcb;
 Begin
  if not (byte(CurrMcb^.McbType) < 65) and (byte(CurrMcb^.McbType) > 90) then
   Begin
    WriteStr('Error in Memory Chain. Halting...');EndL;
    Halt(9);
   end;
 end;

Procedure FreeProgramMemory;
Var C:byte;
 Begin
  For C:=1 to Count do Dispose(Pointers^[C]);
  Dispose(Pointers);
  Dispose(CurrPchar);
 end;

Procedure SortInformation;
 Begin
  if CurrMcb^.Owner = SegOfe.S+1 then
   Begin
    if PspPresent(SegOfe.S+1) then
     Begin
      if McbBlockP(Ptr(PspRecP(Ptr(SegOfe.S+1,0))^.PrgOwnerSeg-1,0))^.McbType = 'M' then
      Pointers^[Count]^.Parent  :=CharsToStr(McbBlockP(Ptr(PspRecP(Ptr(SegOfe.S+1,0))^.PrgOwnerSeg-1,0))^.Name) else
      Pointers^[Count]^.Parent  :=None;
      Pointers^[Count]^.Envir   :=HexW(PspRecP(Ptr(SegOfe.S+1,0))^.PrgEnvSeg);
      Pointers^[Count]^.FullPath:=EnvString(Ptr(PspRecP(Ptr(SegOfe.S+1,0))^.PrgEnvSeg,0),CmdLine);
      {SearchString(Ptr(PspRecP(Ptr(SegOfe.S+1,0))^.PrgEnvSeg,0)
      ,McbBlockP(Ptr(PspRecP(Ptr(SegOfe.S+1,0))^.PrgEnvSeg-1,0))^.Size,CmdLine);}
      if Pointers^[Count]^.FullPath = nil Then Pointer(Pointers^[Count]^.FullPath) :=Pointer(NoEnvir) else
     end                      else
     Begin
      Pointers^[Count]^.Parent  :=NoPsp;
      Pointers^[Count]^.Envir   :=None;
      Pointers^[Count]^.FullPath:=NoEnvir;
     end;
   end else Dec(Count);
 end;

Procedure MainProc(StartMcb:McbBlockP);
 Begin
  FindLast:=False;
  CurrMcb:=StartMcb;
  repeat
  if AdvancedCheck then CheckMcb;
  Inc(Count);
  New(Pointers^[Count]);
  Pointers^[Count]^.Address:=CurrMcb;
  Pointers^[Count]^.Name:=CharsToStr(CurrMcb^.Name);
  SortInformation;
  FindLast:=(CurrMcb^.McbType = 'Z');
  SegOfe.S:=SegOfe.S+CurrMcb^.Size+1;
  if (CurrMcb^.McbType = 'M') and FindLast then
   Begin                            UmbPresent:=true;
    Pointer(Pointers^[Count+1]):=Pointer(CurrMcb);
   end;
  Until FindLast;
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


Begin
 InitProgram;
 WriteStr('Segm:Offs  McbName  Envir  Size    Parent   FullName');EndL;
 WriteStr('---------  -------  -----  ----    ------   --------');EndL;
 MainProc(Ptr(SysVars^.FirstMcbSeg,0));
 OutPutPrg(1,Count);
 if (UmbPresent or QemmPresent) and UmbCheck then
  Begin
   UmbProc;
   OutPutPrg(LastCount+1,Count);
  end;
 SetCounter:=false;
 Counter:=0;
 WriteStr(CharRep(#45,44));EndL;
 WriteStr('Total TSR'+#96+'s Num: '+Digit(Count));EndL;
 FreeProgramMemory;
end.
