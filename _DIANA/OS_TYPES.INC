FUNCTION  Get_OS_Type (Os_ID: System.Byte): PChar;

CONST
     pchar__Empty        : PChar = 'Empty partition';
     pchar__DOS12        : PChar = 'DOS 12-bit FAT';
     pchar__ExtDOS       : PChar = 'Extended Partition';
     pchar__DOS16        : PChar = 'DOS 16-bit FAT';
     pchar__FAT32        : PChar = 'Windows 95  FAT32';
     pchar__FAT32wLBA    : PChar = 'Windows 95  FAT32 with LBA';
     pchar__Linux        : PChar = 'Linux';
     pchar__LinuxSwap    : PChar = 'Linux swap';
     pchar__Unknown      : PChar = 'Unknown (could be damaged)';

     byte__id_Empty      = $00;
     byte__id_DOS12      = $01;
     byte__id_ExtDOS     = $05;
     byte__id_DOS16      = $06;
     byte__id_FAT32      = $0B;
     byte__id_FAT32wLBA  = $0C;
     byte__id_Linux      = $81;
     byte__id_LinuxSwap  = $82;

BEGIN {** Get_OS_Type **}
  CASE  Os_ID of
     byte__id_Empty      : Get_OS_Type:= pchar__Empty;
     byte__id_DOS12      : Get_OS_Type:= pchar__DOS12;
     byte__id_DOS16      : Get_OS_Type:= pchar__DOS16;
     byte__id_FAT32      : Get_OS_Type:= pchar__FAT32;
     byte__id_FAT32wLBA  : Get_OS_Type:= pchar__FAT32wLBA;
     byte__id_Linux      : Get_OS_Type:= pchar__Linux;
     byte__id_LinuxSwap  : Get_OS_Type:= pchar__LinuxSwap;
        ELSE  Get_OS_Type:= pchar__Unknown;
   END;
END;  {** Get_OS_Type **}