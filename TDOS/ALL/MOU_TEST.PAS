PROGRAM TMOUSE_TEST;

Uses
   TSystem, TMouse, TKeyb, TStrings;

Type
   TString_3 = String[3];

Const
   csa_YesNo: array[System.Boolean] of TString_3 =
              ('No',
               'Yes');

Var
   CopirightString: PChar;

Begin
  Writeln ('Mouse Present.......', csa_YesNo[TMouse.MousePresent]);
  CopirightString:= GetCopirightString;
  Writeln (CopirightString);
  Writeln (HexPtr (CopirightString));
End.