Uses IvDos,IvString,IvSystem;

Var OutFile  :Word;
    Name:Pchar;
    Ivan:record
          BornYear  : word;
          BornMonth : byte;
          BornDay   : byte;
          Years     : byte;
         end;
     Result:word;
Begin
 WITH Ivan DO
  Begin
   BornYear  :=1980;
   BornMonth :=1;
   BornDay   :=6;
   Years     :=15
  end;
 New(Name);
 Name:='Ivan.rpt';
 Writeln('Creating File...',Name);
 CreateFile(Name,StdAttr,OutFile);
 IsError;
 Writeln('Writing File... ','from ',HexPtr(Addr(Ivan)));
 WriteFile(OutFile,Ivan,Sizeof(Ivan),Result);
 IsError;
 Writeln('Result: ',Result);
 Writeln('Closing File...',Name);
 CloseFile(OutFile);
end.