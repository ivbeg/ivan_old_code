Uses TSystem, TString;

const
     lcCpuTypes : array[3..6] of PChar = ('80386',
                                         '80486',
                                         'Pentium',
                                         'PentiumPro');

     lcBiosTypes: array[0..8] of PChar = ('Unrecongnized',
                                         'Dell',
                                         'Hewlett_Packard',
                                         'Compaq',
                                         'Toshiba',
                                         'Tandy1000',
                                         'Phoenix',
                                         'AMI',
                                         'Award');

     lcsBios     : PChar = 'BIOS';


var
   ReadBuffer: TMbrRec;


function CharsToString (Var Buffer: array of System.Char) : String;
Var
   TempStr : String;
Begin
  if Sizeof (Buffer) < 256 then TempStr[0] := System.Char (Sizeof(Buffer))
  else TempStr[0] := System.Char ($FF);
  MovePtr(Pointer(Addr(Buffer)), Pointer(Addr(TempStr[1])),
          System.Byte(TempStr[0]));
  CharsToString:=TempStr;
End;


procedure MainPart;
Begin
  Writeln ('CPU Type    : ', lcCpuTypes[TSystem.CpuType]);
  Writeln ('CPU Speed   : ', TSystem.CpuSpeed, ' Mz');
  Writeln ('CPUID Valid : ', CpuIDValid);
  Writeln ('CPUID Vendor: ', CharsToString(CpuVendor));
  Writeln ('BIOS Type   : ', lcBiosTypes[TSystem.BiosType], ' ',lcsBios, '.');
  Writeln ('BIOS Date   : ', CharsToString(TSystem.BiosDate));
  Writeln ('Ext. Memory : ', ExtendedMemorySize, ' Kb');
End;


Begin
  MainPart;
end.