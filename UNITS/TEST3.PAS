Uses IvSystem,IvString,IvDos,IvEms,IvCrt,IvKbd,IvMouse;
Var
 C:byte;
Begin



With SysVars^.FirstSft^ do
 Begin
  For C:=1 to FilesNum Do
   begin
    Writeln(ArrChToStr(Files[C].Name),':',ArrChToStr(Files[C].Ext),'--',Files[C].FileSize);
   end;
 end;
 Writeln;

With SysVars^.FirstSft^.NextSft^ do
 Begin
  For C:=1 to FilesNum Do
   begin
    Writeln(ArrChToStr(Files[C].Name),':',ArrChToStr(Files[C].Ext),'--',Files[C].FileSize);
    if (Files[C+1].FileSize = 0) and (Files[C+1].DirEntrySect = 0 ) then C:=FilesNum;
   end;
 end;
end.