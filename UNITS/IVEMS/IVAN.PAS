Uses NewIvEms,IvString;
Var C:byte;
    W:word;
Begin
 Writeln(ActiveHandles);
 Writeln(TotalHandles);
 Writeln(TotalEmsPages);
 Writeln(AvailEmsPages);
 Writeln(HexW(PageFrame));
 C:=0;
 W:=GetHandlePages(C);
 repeat
 Writeln(W);
 inc(C);
 W:=GetHandlePages(C);
 Until EmsIsErr;
end.