{$I-}
{$S-}

Uses IvSystem,IvDos,IvString,IvKbd,IvMouse,IvCrt;

Type
 PSftOutPutBlock = ^SftOutPutBlock;
 SftOutPutBlock = record
                   SftPtr  : SftFileRecP;
                   Parent  : Str8;
                  end;

 PPointersType  = ^PointersType;
 PointersType   = Array[1..50] of PSftOutPutBlock;

Const
 IoSys  = 'IO.SYS';
 None   = 'None';
 StrArr : Array[0..2] of String[10] = ('Read','Write','Read&Write');

Var Pointers:PPointersType;
    Table:byte;

Function TheWait:Boolean;Far;
 Begin
  TheWait:=KeyPresent or LeftButton or RightButton;
 end;

Procedure InitProgram;
 Begin
  New(Pointers);
  DosOutput:=False;
  SetCounter:=True;
  WaitProc:=TheWait;
  Table:=1;
 end;

Function GetParent(SftAddr:SftFileRecP):Str8;
 Begin
  if BitofW(SftAddr^.DevAttr,7) then GetParent:=IoSys
                               else GetParent:=ArrChToStr(McbBlockP(Ptr(SftAddr^.OwnerPspSeg-1,0))^.Name);
 end;

Procedure OutPutSft(Address:SftRecP);
Const
  StrSize = 79;
Var  S:string[StrSize];
     Count:byte;
     Free:boolean;
 Begin
  Free:=False;
  S:=CharRep(#32,20)+'System Files Table Num:'+Digit(Table)+' Total Descriptors : '+Digit(Address^.FilesNum);
  WriteStr(S);EndL;
  S:=CharRep(#32,20)+'Address '+HexPtr(Address);
  WriteStr(S);EndL;
  Count:=0;
  repeat
   Inc(Count);
   With Address^ do
   Begin
    S:=CharRep(#32,StrSize);
    S:=PutInStr(S,ArrChToStr(Files[Count].Name),1); S[9]:=':';
    S:=PutInStr(S,ArrChToStr(Files[Count].Ext),10);
    S:=PutInStr(S,Digit(Files[Count].Handles),15);
    S:=PutInStr(S,Digit(Files[Count].FileSize),24);
    S:=PutInStr(S,GetParent(Addr(Files[Count])),31);
    S:=PutInStr(S,StrArr[Files[Count].OpenMode and 3],40);
    WriteStr(S);EndL;
    Free:=((Files[Count+1].DevAttr = 0) and (Files[Count+1].DirEntrySect = 0));
   end;
  Until (Count = Address^.FilesNum) or Free;
  if Free then Begin WriteStr('Free Descriptors = '+Digit(Address^.FilesNum-Count));EndL;End;
  Inc(Table);
 end;

{Procedure OutPutSft(Start,Last:byte);
Const
  StrSize = 50;
Var  S:string[StrSize];
     C:byte;
 Begin
 WriteStr('Name     Ext  Handles  Size   Owner    OpenMode');ENDL;
 WriteStr('----     ---  -------  ----   -----    --------');ENDL;
  For C:=Start to Last do
   Begin
   With Pointers^[C]^ do
    Begin
     S:=CharRep(#32,StrSize);
     S:=PutInStr(S,ArrChToStr(SftPtr^.Name),1); S[9]:=':';
     S:=PutInStr(S,ArrChToStr(SftPtr^.Ext),10);
     S:=PutInStr(S,Digit(SftPtr^.Handles),15);
     S:=PutInStr(S,Digit(SftPtr^.FileSize),24);
     S:=PutInStr(S,Parent,31);
     S:=PutInStr(S,StrArr[SftPtr^.OpenMode and 3],40);
    end;
    WriteStr(S);ENDL;
   end;
 end;  }

{Procedure MainProc(Address:SftRecP);
 Begin
  Count:=0;
  repeat
   Inc(Count);
   New(Pointers^[Count+LastCount]);
   WITH Pointers^[Count+LastCount]^ DO
    Begin
     SftPtr:=Addr(Address^.Files[Count]);
     if Count < 4 then Parent:=IoSys else
     Parent:=ArrChToStr(McbBlockP(Ptr(SftPtr^.OwnerPspSeg-1,0))^.Name);
    end;
  Until (Address^.FilesNum = Count);
  end;}

{Procedure SecondTable;
 Begin
  LastCount:=Count;
  MainProc(Sysvars^.FirstSft^.NextSft);
 end;}

{Procedure FreeProgramMemory;
Var C:byte;
 Begin
  For C:=1 To LastCount do Dispose(Pointers^[Count]);
  Dispose(Pointers);
 end;}

Begin
 InitProgram;
{ MainProc(Sysvars^.FirstSft);
 OutPutSft(1,Count);
 SecondTable;
 OutPutSft(LastCount+1,LastCount+Count);}
 OutPutSft(Sysvars^.FirstSft);
 OutPutSft(Sysvars^.FirstSft^.NextSft);
 Counter:=0;
 SetCounter:=false;
end.
