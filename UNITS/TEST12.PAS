Uses IvDos,IvString,IvSystem;

Var
    Address : Pointer;
    SeOfe   : SegOfs absolute Address;
    P       : PChar;
    Handle  : Word;
    Result  : Word;

const
 MaxSeg = $F800;
 BlockSize = $8000;

Function  StrToPchar(S: String): Pchar;
Var C:byte;
    P:PChar;
 Begin
  C:=0;
  if Ord(S[0]) >0 then
  begin
   New(P);  
   For C:=1 to Length(S) do P[C-1]:=S[C];
  end else P:=nil;
   StrToPChar:=P;
 end;

begin
 Address:=Ptr(0000,0000);
 repeat
  P:=StrToPChar(Digit(SeOfe.S));
  OpenFile(P,Handle);
  Writeln('Writing ',HexW(SeOfe.S),' - ',HexW(SeOfe.S+(BlockSize - 1 )),'...');
  WriteFilePtr(Handle,P,BlockSize,Result);
  CloseFile(Handle);
 until SeOfe.S = MaxSeg;
end.