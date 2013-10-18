Uses IvDos,IvSystem,IvString;
Procedure DisableDrive(Drive:byte);assembler;
 asm
  mov  ax,5F08h
  mov  dl,Drive
  int  21h
 end;

Procedure EnableDrive(Drive:byte);assembler;
asm
 mov ax,5f07h
 mov dl,Drive
 int 21h
end;
Var P:Pchar;
S:string;
Begin
{ DisableDrive(0);}
{ EnableDrive(0);}

New(P);
S:='Newstat.exe';
StrToPchar(S,P);
Writeln(P);
{FullExec(P,'');}
DisPose(P);
end.
