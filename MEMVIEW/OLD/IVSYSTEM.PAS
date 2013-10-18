unit IvSystem;

interface
type
 Str2 = String[2];
 Str3 = String[3];
 Str4 = String[4];
 Str8 = String;
Procedure Reboot;
Function  BitofB( Bite,Stat:byte):byte;
Function  BitofW(Wrd:word;Count:byte):byte;
Function  CheckPtr(Ptr1:Pointer):Pointer;
Function  BoolByte(B:byte):boolean;
Function  ByteBool(B:boolean):byte;
Function  SayNo(BooL:boolean):str3;

implementation

Procedure Reboot;
begin
MemW[0:$472]:=$1234;
Inline(
$EA/
$00/
$00/
$FF/
$FF );
end;



Function  BitofB(Bite,Stat:byte):byte;
 begin
  BitofB:=(Bite SHR Stat-1) AND 1;
end;

Function  BitofW(Wrd:word;Count:byte):byte;
 begin
  if Count <= 8 then
   BitofW:=BitofB(Lo(Wrd),Count)
  else
   BitofW:=BitofB(Hi(Wrd),Count - 8)
end;

Function  BoolByte(B:byte):boolean;
 begin
  BoolByte:=Boolean(B);
 end;

Function  ByteBool(B:boolean):byte;
 Begin
  ByteBool:=Byte(B);
 end;

Function CheckPtr(Ptr1:Pointer):Pointer;
 Const
   Max:word = $FFFF;
 Var Se,Ofe:word;
     TempS,TempO:word;
  begin
   Se:=SEG(Ptr1^);
   Ofe:=OFS(Ptr1^);
   if LongInt(Se) + (Ofe DIV 16 ) <= Max then
    begin
     Se:=Se + (Ofe DIV 16);
     Ofe:=Ofe MOD 16;
     CheckPtr:=Ptr(Se,OFe);
    end
   else
    begin
     TempS:=Se;
     TempO:=Ofe;
     Se:=Max;
     Ofe:= (TempS DIV 16) - (Se - TempS)*16 + (Ofe MOD 16);
     CheckPtr:=Ptr(Se,OFe);
    end;
   end;

Function  SayNo(BooL:boolean):str3;
 begin
  if Bool then SayNo:='Yes' else SayNo:='No';
 end;





end.