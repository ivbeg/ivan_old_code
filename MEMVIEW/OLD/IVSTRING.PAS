Unit IVstring;

InterFace
Uses IvSystem;
Type
 Str2  = String[2];
 Str4  = String[4];
 Str8  = String[8];
 Str16 = String[16];
Function  LowCase(Ch:Char):Char;
Function  CheckString(SomeStr:string):string;
Function  GetString(Address:Pointer;Count:byte):string;
Function  GetStringU(Address:Pointer;Count:byte):string;
Function  PCharToPas(SomeStr:PChar):String;
Function  StrUpp(SomeStr:string):string;
Function  StrLow(SomeStr:string):string;
Function  HexW(Wrd:word):Str4;
Function  HexB(Bt:byte):Str2;
Function  DeHexW(Hex:str4):Word;
Function  DeHexB(Hex:Str2):byte;
Function  SearchString(S:string;Count:word;var PtrS:Pointer):boolean;
Function  BinB(Bt:byte):Str8;
Function  BinW(Wrd:word):Str16;
Function  DeBinB(S:Str8):byte;
Function  DeBinW(S:Str16):Word;
Function  FindChar(S:string;Ch:Char):byte;
Function  MemS(Point:pointer;Count:byte):string;
Function  CheckChar(Var Ch:char; Start,Ende:byte):boolean;
Procedure DelChars(Var S:string; Start,Ende:byte);

Implementation

Function  LowCase(Ch:Char):Char;
 begin
  if Ch in [#65..#90] then
   begin
    LowCase:=Chr(Ord(Ch)+32);
   end;
 end;

Function CheckString(SomeStr:string):string;
Const
Zero =  Chr($FF);

var S:string;
    Count:byte;
    Size:byte;
    CurCount:byte;
 begin
 S:='';
 if Length(SomeStr) <> 0 then
  Size:=Length(SomeStr);
  begin
   for Count:=1 to Size do
    begin
     if SomeStr[Count] in [#32..#127] then
      begin
       S:=S+SomeStr[Count];
      end
     else
      begin
       S:=S+Zero;
      end;
   end;
CheckString:=S;
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

Function  GetStringU(Address:Pointer;Count:byte):string;
var I,K,X:byte;
    Name:string;
    Segm,Offs:Word;
begin
Segm:=Seg(Address^);
Offs:=Ofs(Address^);
I:=1;
X:=Count;
 repeat
  Name[I]:=Chr(Mem[Segm:Offs-1+I]);
  if (Name[I] = Chr($20)) or (Name[I] = Chr($0)) or (Name[I] = Chr($FF)) or (Ord(Name[I]) < 32)
  then
   begin
   X:=I;
   I:=Count;
   end;
  Inc(I);
 UNTIL I = Count +1 ;
Name[0]:=Chr(X);
GetStringU:=Name;
end;

Function  PCharToPas(SomeStr:PChar):String;
var I:byte;
 begin
  for I:=1 to Sizeof(SomeStr) do
   begin
    PCharToPas[i]:=SomeStr[i-1];
   end;
  PCharToPas[0]:=Chr(Sizeof(SomeStr));
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

Function  DeHexW(Hex:str4):Word;
 begin
  DeHexW:=DeHexB(PartofStr(Hex,0,2))*256+DeHexB(PartofStr(Hex,2,2));
 end;

Function  DeHexB(Hex:Str2):byte;
var Arr:array[1..2] of Byte;
    Count:byte;
 begin
  for Count:= 1 to 2 do
   begin
    if Ord(Hex[Count]) < 65 then
     Arr[Count]:=Ord(Hex[Count]) - 48
    else
     Arr[Count]:=Ord(Hex[Count]) - 55;
   end;
  DeHexB:=Arr[1]*16+Arr[2];
 end;

Function  SearchString(S:string;Count:word;var PtrS:Pointer):boolean;
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
 end;

Function  BinB(Bt:byte):Str8;
var Count:byte;
 begin
  for Count:= 1 to 8 do
   begin
    BinB[Count]:=Chr(BitofB(Bt,Count)+48);
   end;
  BinB[0]:=#8;
 end;

Function  BinW(Wrd:word):Str16;
 begin
  BinW:=BinB(Hi(Wrd))+BinB(Lo(Wrd));
  BinW[0]:=#16;
 end;

Function  DeBinB(S:Str8):byte;
var Arr:array[1..8] of Byte;
    Count:byte;
 begin
  for Count:= 1 to 8 do
   begin
    Arr[Count]:=Ord(S[Count]) - 48;
   end;
  DeBinB:=Arr[1]*128+Arr[2]*64+Arr[3]*32+Arr[4]*16+Arr[5]*8+Arr[6]*4+Arr[7]*2+Arr[8];
 end;

Function  DeBinW(S:Str16):Word;
 begin
  DeBinW:=DeBinB(PartOfStr(S,0,8))*256+DeBinB(PartOfStr(S,8,8));
 end;

Function  FindChar(S:string;Ch:Char):byte;
var I:byte;
 begin
  I:=0;
  FindChar:=255;
  repeat
   Inc(I);
    If S[I] = Ch then
     begin
      FindChar:=I;
      I:=255;
     end;
  Until I = 255;
 end;


Function SayNo( Inp:boolean):str3;
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

Function  CheckChar(Var Ch:char; Start,Ende:byte):boolean;
 Begin
  If Start > Ende then
   asm
    mov  al,Start
    xchg Ende,al
    mov  Start,al
   end;
  CheckChar:= (Ch in [Chr(Start)..Chr(Ende)]);
 end;

Procedure DelChars(Var S:string; Start,Ende:byte);
 Var
  Count,C:byte; Bool:boolean;
 Begin
  For Count:=1 to Length(S) do
   Begin
    Bool:=CheckChar(S[Count],Start,Ende);
    if Bool then
     Begin
      For C:=Count to (Length(S) - 1) do
      S[C]:=S[C+1];
      S[0]:=Chr(Length(S) - 1);
      Dec(Count);
     end;
   end;
 end;

end.
