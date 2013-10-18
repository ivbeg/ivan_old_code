USES TSystem;
CONST
     csCpuTypes      : array[3..6] of PChar =
       ('Intel 386',
        'Intel 486',
        'Pentium',
        'Pentium Upgrade');

     csBiosTypes     : array[0..8] of PChar =
       ('Unknown',
        'Dell',
        'Hewlett-Packard',
        'Compaq',
        'Toshiba',
        'Tandy1000',
        'Phoenix',
        'AMI',
        'Award');

     csBiosType      = 'Bios Type       : ';
     csProcessorType = 'Processor Type  : ';
     csCpu_Speed     = 'Cpu Speed       : ';
     csCpu_Vendor    = 'Cpu Vendor Str  : ';
     csCPUIDValid    = 'CPUID Valid     : ';
     csBase          = 'Base ';
     csExt           = 'Ext. ';
     csMemorySize    = 'Memory Size: ';
     csKB            = ' Kb';

Function  ArrChToStr(A:array of Char):string;
Var C:byte;
 Begin
  C:=0;
  repeat
   Inc(C);
   ArrChtoStr[C]:=A[C-1];
  Until (C = Sizeof(A)) or (C = 255);
  ArrChtoStr[0]:=Char(C);
 end;


Begin
  Writeln(csBiosType, csBiosTypes[BiosType]);
  Writeln(csProcessorType, csCpuTypes[CpuType]);
  Writeln(csCpu_Speed, CpuSpeed, ' Mhz');
  Writeln(csCPUIDValid, CpuIDValid);
{
  IF CpuIDValid THEN
    Writeln(csCpu_Vendor, ArrChToStr(Cpu_VendorStr));
}
  Writeln(csBase + csMemorySize, BiosArea.MemorySize, csKB);
  Writeln(csExt + csMemorySize, ExtendedMemorySize, csKB);
End.