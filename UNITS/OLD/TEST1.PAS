uses Module,Crt,Misc,IvString;
var Segm,Offs:word;
    S,O:word;
    Name:string;
    Se,Ofe:word;
    Ses,Ofes:word;
    C:char;
    K:byte;
 begin
  DosTableAdr(Segm,Offs);
  Ses:=MemW[Segm:Offs+$24];
  Ofes:=MemW[Segm:Offs+$22];
  K:=0;
 repeat
  Se:=Ses;
  Ofe:=Ofes;
    Name:=GetString(Ses,Ofes+$0A,8);

  Writeln(HexWord(Se),':',HexWord(Ofe));
  Writeln(Name);
  Ses:=MemW[Se:Ofe+$2];
  Ofes:=MemW[Se:Ofe];
  C:=ReadKey;
  If C='a' then
   Halt(0);

 until (Ofes = $FFFF) or KeyPressed;
 end.




