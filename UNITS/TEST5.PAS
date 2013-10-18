Uses IvXMS,IvKbd,IvSystem,IvCrt,IvString;
Var P:PXMSHandleTable;
    Count:byte;

Procedure XmsBlockOutput;
Var S:string[40];
    C:byte;
 Begin
  WriteStr('Handle  Flag  Lock  Size');EndL;
  WriteStr('------  ----  ----  ----');EndL;
For C:=1 To Count Do
 Begin
  S:=CharRep(#32,40);
  S:=PutInStr(S,Digit(C),1);
  S:=PutInStr(S,Digit(P^.Table^[C].Flag),9);
  S:=PutInStr(S,SetOn(P^.Table^[C].Lock),15);
  S:=PutInStr(S,Digit(P^.Table^[C].Size),21);
  WriteStr(S);EndL;
  S[0]:=Char(40);
  end;
 end;

Procedure FindCount;
 Begin
  Count:=0;
  repeat
   Inc(Count);
  Until (Count =P^.HandleNum) or (P^.Table^[Count+1].Flag = 4);
 end;

Procedure Initialize;
 Begin
  DosOutPut:=true;
  P:=XmsTableAddr;
  Count:=0;
 end;

Procedure WriteHeader;
 Begin
  WriteStr('Total Handles: '+Digit(P^.HandleNum));EndL;
 end;

Begin
 Initialize;
 WriteHeader;
 FindCount;
 XmsBlockOutput;
end.