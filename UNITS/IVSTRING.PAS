Unit IVstring;

InterFace

Uses IvSystem;



Procedure AsciizString(S:PString);
Procedure AscString(S:PString);
Function PutInStr(S:string;S1:string;P:byte):string;
Procedure StrToParamStr(S:String);
{ ** This funny procedure copy Your String in DTA and You Can to take some
 parts of It by Pascal 'ParamStr(N)'. I LIKE IT!! ** }

Function  Digit(B:longint):string;
 {** Working as STR,but is's Function ** }

Function  BooleanToStr(B:boolean):str5;
 {** Convert Boolean to String ** }

Function  LowCase(Ch:Char):Char;
 {** Large letter to small ** }

Function  CheckString(SomeStr:string):string;


Function  GetString(Address:Pointer;Count:byte):string;
Function  StrUpp(SomeStr:string):string;
Function  StrLow(SomeStr:string):string;
Function  CheckHex(Hex:string):boolean;
Function  CheckDigit(S:string):boolean;

 { ** Hex Convert Functions ** }
Function  HexW(Wrd:word):Str4;
Function  HexB(Bt:byte):Str2;
Function  HexPtr(P:pointer):str9;
Function  DeHexW(Hex:str4):Word;
Function  DeHexB(Hex:Str2):byte;
Function  DeHexPtr(Hex:Str9):pointer;
Function  SearchString(Ptr:pointer;Count:word;S:string):pointer;
Function  FindChar(S:string;Ch:Char):byte;
Function  MemS(Point:pointer;Count:byte):string;
Function  CheckChar(Ch:char; Start,Ende:byte):boolean;
Function  DelChar(S:String;P:byte):string;
Function  DelChars(S:String; Start,Ende:byte):string;
Function  CharRep(Cha:char;Count:byte):string;
Function  HexChr(Ch:char):byte;

Procedure StrToPchar(S:string;Var P:Pchar);
Function  PcharSize(var P:Pchar):word;
Procedure PcharUpp(var P:Pchar);
Procedure PcharLow(var P:Pchar);
Function  PcharToStr(P:Pchar):string;
Procedure AddPchar(Var P:pchar; P1:Pchar);
Function  SetOn(B:boolean):str3;
Function  ArrChToStr(A:array of Char):string;
Procedure ArrChToPchar(A:array of Char;Var P:Pchar);

Implementation

Procedure ArrChToPchar(A:array of Char;Var P:Pchar);
Var C:byte;
    Ch:char;
 Begin
  C:=0;
  repeat
   Inc(C);
   Ch:=A[C-1];
   P[C-1]:=Ch;
  until (Ch = #0) or (C =Sizeof(A));
  P[C]:=#0;
 end;

Function  ArrChToStr(A:array of Char):string;
Var C:byte;
 Begin
  C:=0;
  repeat
   Inc(C);
   ArrChtoStr[C]:=A[C-1];
  Until (C = Sizeof(A)) or (C = 255);
  ArrChtoStr[0]:=Char(C);
 end;

Procedure StrToParamStr(S:String);
Var DTA:^str127;
 Begin
  Dta:=Ptr(PrefixSeg,$80);
  DTA^:=S;
 end;

Function  BooleanToStr(B:boolean):str5;
Const BoolArr:array[0..1] of str5 = ('FALSE','TRUE');
 Begin
  if B then BooleanToStr:=BoolArr[1] else BooleanToStr:=BoolArr[0];
 end;

Function  DelChar(S:String;P:byte):string;
Var Ecount:byte;
    TmpStr:string;
 Begin
  if Byte(S[0]) >= P then
   Begin
    For Ecount:=P to Byte(S[0]) do
    TmpStr[Ecount]:=S[Ecount+1];
    Byte(TmpStr[0]):=Byte(S[0])-1;
    DelChar:=TmpStr;
   end else DelChar:='';
 end;


Procedure AddPchar(Var P:pchar; P1:Pchar);
Var W:word;
 Begin
  W:=PcharSize(P1);
  if LongInt(W)+PcharSize(P) > $FFFF then
   W:=$FFFF;
  Move(P[PcharSize(P)-1],P1^,W);
 end;


Function  PcharToStr(P:Pchar):string;
Var Max:byte;
    C:byte;
 Begin
  if PcharSize(P) > $FF then Max:=$FF else Max:=PcharSize(P);
  For C:=1 to Max do
  PcharToStr[C]:=P[C-1];
  PcharToStr[0]:=Char(Max);
 end;

Procedure PcharUpp(var P:Pchar);
Var C:word;
 Begin
  For C:=0 to PcharSize(P)-1 do
   P[C]:=UpCase(P[C]);
 end;

Procedure PcharLow(var P:Pchar);
Var C:word;
 Begin
  For C:=0 to PcharSize(P)-1 do
   P[C]:=LowCase(P[C]);
 end;

{$L IVSTRING.OBJ}
Function  PcharSize(var P:Pchar):word;External;
Procedure AsciizString(S:PString);External;
Procedure AscString(S:PString);External;
Function  LowCase(Ch:Char):Char;External;
Function  CheckChar(Ch:char; Start,Ende:byte):boolean;External;


Procedure StrToPchar(S:string;Var P:Pchar);
Var C:byte;
 Begin
  if Ord(S[0]) >0 then
   Begin
    For C:=1 to Length(S) do P[C-1]:=S[C];
    P[C]:=Char(0);
   end;
 end;

Function  Digit(B:longint):string;
Var TmpStr:string;
 Begin
  Str(B,TmpStr);
  Digit:=TmpStr;
 end;


Function  CheckHex(Hex:string):boolean;
Const
 HexSet   :set of Char = ['0'..'9','A'..'F'] ;
var Tmp:byte;
 begin
  CheckHex:=False;
  if Length(Hex) > 0 then
   begin
    for Tmp:=1 to Length(hex) do
     begin
      if not (Hex[1] in HexSet) then Exit;
     end;
    CheckHex:=True;
   end;
  end;

Function  HexChr(Ch:char):byte;
 begin
  asm
   mov  al,[bp+6]
   sub  al,'0'
   cmp  al,9
   jbe  @Ok
   and  al,11011111b
   sub  al,'A'-'9'-1
  @Ok:
   mov  [bp-1],al;
  end;
 end;


Function CheckString(SomeStr:string):string;
Const
Zero =  Chr($FF);

var Count:byte;
    Size:byte;
    CurCount:byte;
    TmpStr:string;
 begin
 TmpStr:='';
 if Length(SomeStr) <> 0 then
  Size:=Length(SomeStr);
  begin
   for Count:=1 to Size do
    begin
     if SomeStr[Count] in [#32..#127] then
      begin
       TmpStr:=TmpStr+SomeStr[Count];
      end
     else
      begin
       TmpStr:=TmpStr+Zero;
      end;
   end;
CheckString:=TmpStr;
end;
end;


Function PartOfStr(S:String;Move,Count:byte):string;
var Ct:word;
 begin
  for Ct:=1 to Count do
   begin
    PartOfStr[Ct]:=S[Ct+Move];
   end;
  PartOfStr[0]:=Chr(Count);

 end;

Function  GetString(Address:Pointer;Count:byte):string;
var I,K,X:byte;
    Name:string;
    Segm,Offs:Word;
begin
I:=1;
Segm:=Seg(Address^);
Offs:=Ofs(Address^);
 repeat
  Name[I]:=Chr(Mem[Segm:Offs-1+I]);
  if (Name[I] = Chr($20)) or (Name[I] = Chr($0)) or (Name[I] = Chr($FF)) or (Ord(Name[I]) < 32)
  then
   begin
    for K:= I to Count do
     begin
      Name[K]:=Chr($20);
     end;
    I:=Count;
   end;
   Inc(I);
 UNTIL I = Count +1 ;
Name[0]:=Chr(Count);
GetString:=Name;
end;

Function  StrUpp(SomeStr:string):string;
var Count:byte;
 begin
  for Count:=1 to Length(SomeStr) do
   begin
    StrUpp[Count]:=UpCase(SomeStr[Count]);
   end;
  StrUpp[0]:=Chr(Length(SomeStr));
 end;

Function  StrLow(SomeStr:string):string;
var Count:byte;
 begin
  for Count:=1 to Length(SomeStr) do
   begin
    StrLow[Count]:=LowCase(SomeStr[Count]);
   end;
  StrLow[0]:=Chr(Length(SomeStr));
 end;

        { ** Hex Functions ** }

Function  HexB(Bt:byte):Str2;
 Const
  HexArr:array[0..$F] of Char = '0123456789ABCDEF';
 begin
    HexB[1]:=HexArr[bt shr 4];
    HexB[2]:=HexArr[bt and $F];
    HexB[0]:=#2;
 end;

Function  HexW(Wrd:word):Str4;
 begin
  HexW:=HexB(Hi(Wrd))+HexB(Lo(Wrd));
 end;

Function  HexPtr(P:pointer):str9;
 begin
  HexPtr:=HexW(SEG(P^))+ ':' + HexW(OFS(P^))
 end;

Function  DeHexB(Hex:str2):byte;
 Var
  Slen:byte absolute Hex;
 begin
  if (Slen < 2) then Hex:=CharRep('0',2-Slen)+Hex;
  DeHexB:= (HexChr(Hex[1]) shl 4) + HexChr(Hex[2]);
 end;

Function  DeHexW(Hex:Str4):Word;
 var
  Slen:byte absolute Hex;
 begin
  if (Slen < 4) then Hex:=CharRep('0',4-Slen)+Hex;
  DeHexW:= (word(DeHexB(Copy(Hex,1,2)) shl 8)) + DeHexB(Copy(Hex,3,2));
 end;

Function  DeHexPtr(Hex:Str9):pointer;
 Var
  Slen:byte absolute Hex;
  FindOk:byte;
  StrOk:byte;
 Begin
  FindOk:=FindChar(Hex,':');
  if FindOk > 0 then
   Begin
    StrOk:=Length(Copy(Hex,1,FindOk-1));
    if (StrOk < 4) then Hex:=CharRep('0',4-StrOk)+Hex;
    StrOk:=Length(Copy(Hex,FindOk+1,Slen-FindOk));
    if (StrOk < 4) then Insert(CharRep('0',4-StrOk),Hex,FindOK+1);
    DeHexPtr:=Ptr(DeHexW(Copy(Hex,1,4)),DeHexW(Copy(Hex,6,4)));
   end
   else  DeHexPtr:=nil;
  End;

Function  SearchString(Ptr:pointer;Count:word;S:string):pointer;
Begin
 SearchString:=SearchPtr(Ptr,Count,Addr(S[1]),Length(S));
end;
{Function  SearchString(S:string;Count:word;var PtrS:Pointer):boolean;
var LengthS:byte;
    StrC:string;
    Bool:boolean;
    Ofes:word;
    Segm,Offs:word;
 begin
  LengthS:=Length(S);
  Bool:=False;
  Segm:=Seg(PtrS^);
  Offs:=Ofs(PtrS^);
  Ofes:=Offs;
  repeat
   Inc(Offs);
   StrC:= GetString(Ptr(Segm,Offs),LengthS);
   if StrC = S then Bool:= True;
  until (Offs > Ofes+Count) or (Bool = True) or (Offs = $FFFF);
   SearchString:=Bool;
   PtrS:=Ptr(Segm,Offs);
 end;}

Function  FindChar(S:string;Ch:Char):byte;
var I:byte;
 begin
  I:=0;
  FindChar:=0;
  repeat
   Inc(I);
    If S[I] = Ch then
     begin
      FindChar:=I;
      I:=255;
     end;
  Until I = 255;
 end;


Function SayNo(Inp:boolean):str3;
 begin
  if Inp = False then
   begin
    SayNo:= 'No';
   end
  else
   begin
    SayNo:= 'Yes';
   end;
 end;

Function SetOn(B:boolean):str3;
Const OnOff:array[0..1] of Str3 = ('Off','On');
 Begin
  SetOn:=OnOff[byte(B)];
 end;

Function  MemS(Point:pointer;Count:byte):string;
 Const
  Max:word = $FFFF;
 Var
  C:byte; Pt:pointer; Ch:char;
   Begin
    Pt:=CheckPtr(Point);
    C:=0;
    repeat
     Inc(C);
     Ch:=Chr(Mem[SEG(Pt^):OFS(Pt^)+C-1]);
     Mems[C]:=Ch;
    Until (ORD(Ch) > 127) or (ORD(Ch) < 33) or (C = Count) or (OFS(Pt^) = Max);
     MemS[0]:=Chr(C);
   end;

Function  DelChars(S:String; Start,Ende:byte):string;
Var Count:byte;
    St:string;
    Slen:byte absolute St;
 Begin
  St:=S;
 if Byte(S[0]) = 0 then
 Begin
  DelChars:='';
  Exit;
 end;
  Count:=0;
  repeat
   Inc(Count);
   if CheckChar(St[Count],Start,Ende) then Begin
    St:=DelChar(St,Count);
    Dec(Count);
    end;
  Until  (Count >= Slen);
  DelChars:=St;
 end;

Function  CharRep(Cha:char;Count:byte):string;
Var TmpStr:string;
 begin
  TmpStr[0]:=Char(Count);
  FillByteVar(TmpStr[1],Count,Byte(Cha));
  CharRep:=TmpStr;
 end;

Function  CheckDigit(S:string):boolean;
Const
 DigitSet :set of Char = ['0'..'9'] ;
Var C:byte;
 Begin
  CheckDigit:=True;
  if Ord(S[0]) < 0 then
   begin
    For C:=1 to Length(S) do
     Begin
      if not (S[C] in DigitSet) then
       begin
        CheckDigit:=False;
        Exit;
       end;
     end;
   end;
 end;

Function  ChrToByte(Ch:char):byte;
 Begin
  ChrToByte:=Ord(Ch)-48;
 end;


Function PutInStr(S:string;S1:string;P:byte):string;
Var C:byte;
    Count:Word;
 Begin
  Count:=Sizeof(S1);
  if Sizeof(S) > Count+P Then Count:=Sizeof(S)-P;
  MoveVar(S1[C],S[P+C-1],Count);
  PutInStr:=S;
 end;

Begin
end.