{$M 4096,100,100}
Uses IvDos,IvString,IvSystem;
Const
 Ver = '1.00';

Var P:Pchar;


Procedure Help;
 Begin
  Writeln('LoadUp Utility Version ',Ver,' Copiright (C) Ivan Begtin');
  Writeln('Usage: filename [command line]');
  Writeln('  filename     -  name of file for up loading (def.ext. = exe,com)');
  Writeln('  command line -  command line of this file');
  Halt(0);
 end;

 Begin
  If ParamCount > 0 Then
   Begin
     New(P);
     StrToPChar(ParamStr(1),P);
     SetUMBLinkState(True);
     Exec(P,PspAddr^.CommandLine);
     SetUMBLinkState(False);
   end else Help;
 end.