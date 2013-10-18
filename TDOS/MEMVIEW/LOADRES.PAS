Uses Objects, Drivers, Dialogs, App, StdDlg,
     Views, Menus, TSystem, NewDos, ShowTErr, Globals, Equ;

Var
   C: Integer;


Begin
  RezStream := New(PBufStream, Init('MEMVIEW.RES', stOpen, 4096));
  RezFile.Init(RezStream);

  RegisterObjects;  { registers TStringCollection }
  RegisterViews;
  RegisterMenus;
  RegisterDialogs;
  RegisterStdDlg;
  RegisterGlobals;
  RegisterType(RStringList);

  RezStrings := PStringList(RezFile.Get('Strings'));
  if RezStrings = nil then Writeln('Error');
  Writeln(RezStrings^.Get(hcInformation));
End.