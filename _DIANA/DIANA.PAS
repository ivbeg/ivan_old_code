{-----------------------------------------------------------------------}
{ PROJECT               Multi purpose Disk Analise program (DiAna)      }
{                                                                       }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             DIANA.PAS                                       }
{ PURPOSE               Use 386+ 32 bits codes and optimizating,        }
{                       some tools and utilities                        }
{ VERSION               0.01                                            }
{ DATE                  15-Jan-97                                       }
{ DESIGN                Begtin Ivan                                     }
{ IMPLEMENTATION        Begtin Ivan                                     }
{ COMPANY               None                                            }
{ COPYRIGHT NOTICE      Copyright (C) 1995-1996, Begtin Ivan            }
{ RESTRICTED RIGHTS                                                     }
{                                                                       }
{ COMPUTER              IBM PC or compatible                            }
{ OPERATING SYSTEM      MS/PC-DOS Version 3.30 or higher                }
{ COMPILER              Turbo Pascal Version 7.0                        }
{                       (Borland International Inc.)  or compatible     }
{ ASSEMBLY LANGUAGE     Turbo Assember 3.2 or compatible                }
{ LINKER                Turbo Pascal internal                           }
{ ARGUMENTS                                                             }
{                                                                       }
{                                                                       }
{ RETURN                None                                            }
{ REQUIRES              None                                            }
{ NATURAL LANGUAGE      English Language                                }
{ SECOND LANGUAGE       Russian Language                                }
{ SPECIAL               Works only on 386+ processor                    }
{ DESCRIPTION                                                           }
{                                                                       }
{ REVISION HISTORY      Ivan Begtin (IB)                                }
{                       v0.01 - First version                           }
{                                                                       }
{ THANKS TO             Dmitry Stefankov for programming style lessons  }
{-----------------------------------------------------------------------}


PROGRAM   Disk_Analise;   {** Diana **}

USES
     TSystem, TDisk, TString;

{$I OS_TYPES.INC}

CONST
    gcs__Version  = '0.01';

   gcb__PartitionsNumber = 4;

   gcw__FirstCyllinder = 0;
   gcb__FirstHead      = 0;
   gcb__FirstSector    = 1;
   gcw__SectorsNumber  = 1;


   pchar__Empty        : PChar = 'Empty';
   pchar__DOS12        : PChar = 'FAT12';
   pchar__ExtDOS       : PChar = 'Extended';
   pchar__DOS16        : PChar = 'FAT16B';
   pchar__FAT32        : PChar = 'FAT32';
   pchar__FAT32wLBA    : PChar = 'FAT32wLBA';
   pchar__Linux        : PChar = 'Linux';
   pchar__LinuxSwap    : PChar = 'Linux swap';
   pchar__Unknown      : PChar = 'Unknown';

   
   byte__id_Empty      = $00;
   byte__id_DOS12      = $01;
   byte__id_ExtDOS     = $05;
   byte__id_DOS16      = $06;
   byte__id_FAT32      = $0B;
   byte__id_FAT32wLBA  = $0C;
   byte__id_Linux      = $81;
   byte__id_LinuxSwap  = $82;




PROCEDURE  Short_Help;
BEGIN
   Writeln ('Disk Analizing program (Diana) v',gcs__Version,'  Copyright (C) 1998 Ivan Begtin ');
END;


PROCEDURE  DiskErrorsHandler; FAR;
BEGIN
   Writeln ('Disk error ', HexWord (DiskResult.Result));
   Halt;
END;



PROCEDURE  ShowMBR_Sector (DriveNum: System.Byte; Cyllinder : System.Word;
                           Head: System.Byte; Sector: System.Word;
                           SectorsNumber: System.Word);
VAR
   lvb_Counter :  System.Byte
   buffer__MBR_Sector : PMbrRec;
BEGIN
   New (buffer__MBR_Sector);
   ReadSectors (DriveNum, Cyllinder, Head, Sector, SectorsNumber,
                buffer__MBR_Sector);
                
   FOR  lvb_Counter:= 1 TO gcb__PartitionsNumber DO
   BEGIN
      CASE  buffer__MBR_Sector^.Partitions [lvb_Counter] OF
         byte__id_Empty       : BEGIN
                                 {** There is not info for empty partition **}
                                END;
         byte__id_DOS12,
         byte__id_ExtDOS,
         byte__id_DOS16,
         byte__id_FAT32,
         byte__id_FAT32wLBA,
         byte__id_Linux,
         byte__id_LinuxSwap    : BEGIN
                                   Writeln ('Something is here!');
                                 END;
      ELSE
   END;
END;



BEGIN
   {** Help messages **}
   ShortHelp;

   {** Error handlers init **}
   DiskResult.ErrorProc:= DiskErrorsHandler;

   {** Entire of process **}
   New (buffer__MBR_Sector);
   ShowMBR_Sector (HardDisk_0, gcw__FirstCyllinder, gcb__FirstHead,
                   gcw__FirstSector, gcw__SectorsNumber );



END.