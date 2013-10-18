PROGRAM  TEST_TVESA;

Uses
    TSystem, TVesa;



Begin
  if TVesa.VESA_Present then
   Begin
     Writeln (TVesa.VESA_Info.OEM_Name);
     Writeln (TVesa.VESA_Info.VBE2_VendorName);
     Writeln (TVesa.VESA_Info.VBE2_ProductName);
     Writeln (TVesa.VESA_Info.VBE2_RevisionName);
   End;
End.
