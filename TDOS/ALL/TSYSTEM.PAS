{-----------------------------------------------------------------------}
{ PROJECT               TURBO PASCAL LIBRARY                            }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             TSYSTEM.PAS                                     }
{ PURPOSE               Use 386+ 32 bits codes and optimizating,        }
{                       some tools and utilities                        }
{ VERSION               0.02                                            }
{ DATE                  30-Mar-96                                       }
{ DESIGN                Begtin Ivan                                     }
{ IMPLEMENTATION        Begtin Ivan                                     }
{ COMPANY               None                                            }
{ COPYRIGHT NOTICE      Copyright (C) 1995-1996, Begtin Ivan            }
{ RESTRICTED RIGHTS     AVAILABLE ONLY FOR FREE DISTRIBUTION,           }
{                       NOT FOR COMMERCIAL PURPOSE                      }
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
{ DESCRIPTION           1.BIOS and CPU Identification.                  }
{                       2.All BIOS Static information in variables.     }
{                       3.Different assembler tools.                    }
{                                                                       }
{ REVISION HISTORY      Ivan Begtin (IB)                                }
{                       v0.01 - First version                           }
{                        0.02 - Some bugs fixed                         }
{                                                                       }
{                                                                       }
{ THANKS TO             Dmitry Stefankov for programming style lessons  }
{-----------------------------------------------------------------------}

UNIT TSystem;

INTERFACE


{$I DOSTYPES.INC}


CONST

     {* Table of BIOS identificators *}
     btUnknown         =  00;         {* Unrecognized BIOS        *}
     btDell            =  01;         {* DELL                     *}
     btHewlett_Packard =  02;         {* Hewlett-Packard          *}
     btCompaq          =  03;         {* COMPAQ                   *}
     btToshiba         =  04;         {* Toshiba laptop           *}
     btTandy1000       =  05;         {* Tandy1000                *}
     btPhoenix         =  06;         {* Phoenix                  *}
     btAMI             =  07;         {* American Megatrends Inc. *}
     btAward           =  08;         {* AWARD                    *}

     cpu8086           =  01;         {* Detect only CPU higher   *}
     cpu80286          =  02;         {* then 80w86. Becouse this *}
     cpu80386          =  03;         {* module use 32-bits       *}
     cpu80486          =  04;         {* operations.              *}
     cpuPentium        =  05;
     cpuPentiumPro     =  06;

     seg_Bios          =  $F000;
     seg_StdVideoROM   =  $C000;


        {* Static constants *}
     CpuType            : System.Byte = 0;
     CpuSpeed           : System.Word = 0;
     CpuIDValid         : Boolean     = false;
     BiosType           : System.Byte = 0;
     ExtendedMemorySize : System.Word = 0;
     CpuVendor          : TCpuVendor  = (#0, #0, #0, #0, #0, #0,
                                         #0, #0, #0, #0, #0, #0);



VAR
   {* Static parts of conventional memory *}
   VGA_Memory       : TVGA_Memory          absolute $A000:$0000;
   Text_Memory      : TStdText_Memory      absolute $B800:$0000;
   VideoROM         : TRomInfoRec          absolute $C000:$0000;

   SelfAddr         : PMcb_PspRec;
   FirstUMB_MCB     : PMcbRec              absolute $9FFF:$0000;
   IntTable         : TInterruptTable      absolute $0000:$0000;
   Font8x8          : PVideoFont8x8        absolute $0000:$007C;
   VideoParms       : PVideoSaveTable      absolute $0000:$0074;
   FloppyTable      : PFloppyParmsTable    absolute $0000:$0078;
   HDD_0_PTable     : PHardDiskParmsTable  absolute $0000:$0104;
   HDD_1_PTable     : PHardDiskParmsTable  absolute $0000:$0118;
   BiosArea         : TBiosAreaRec         absolute $0040:$0000;
   BiosRealIntsOffs : TBiosIntsTable       absolute $F000:$FEE3;
   BiosIdentifity   : System.Byte          absolute $F000:$FFFE;
   BiosModel        : System.Byte          absolute $F000:$FFFF;
   BiosDate         : TBiosDate            absolute $F000:$FFF5;
   BiosConfigTable  : PBiosConfigTable;


   {* Different ~Fill~ procedures *}
PROCEDURE FillDword(Buffer: Pointer; Count: Word; DD: Longint);
PROCEDURE FillWord(Buffer: Pointer; Count: Word; DW: Word);
PROCEDURE FillByte(Buffer: Pointer; Count: Word; DB: Byte);
PROCEDURE Fill(Dest,Source: Pointer; Size,Count: Word);


PROCEDURE SwapByte(Var S,D: Byte);
PROCEDURE SwapWord(Var S,D: Word);
PROCEDURE SwapLong(Var S,D: Longint);
PROCEDURE Swap(Source, Dest: Pointer; Size: Word);

FUNCTION  CompareBuffersPtr(Var Source,Dest; Size: Word): Word;
PROCEDURE MovePtr(Source, Dest: Pointer; Count: Word);far;
FUNCTION  SearchPtr(Buffer: Pointer; Count: Word; Buff: Pointer; BuffSize: Word): Pointer;


   {* Functions to Read and Write Memory *}
   {* I don't know for that it may be used but maybe ... *}
FUNCTION  ReadMemoryByte(Address: Pointer): Byte;
FUNCTION  ReadMemoryWord(Address: Pointer): Word;
FUNCTION  ReadMemoryDword(Address: Pointer): Longint;

PROCEDURE WriteMemoryByte(Address: Pointer; Value: Byte);
PROCEDURE WriteMemoryWord(Address: Pointer; Value: Word);
PROCEDURE WriteMemoryDword(Address: Pointer; Value: Longint);

   {* Same but memory address is absolute. *}
   {* Err. It means that it's 32-bit memory operations *}
FUNCTION  AbsReadMemoryByte(Address: Longint): Byte;
FUNCTION  AbsReadMemoryWord(Address: Longint): Word;
FUNCTION  AbsReadMemoryDword(Address: Longint): Longint;

PROCEDURE AbsWriteMemoryByte(Address: Longint; Value: Byte);
PROCEDURE AbsWriteMemoryWord(Address: Longint; Value: Word);
PROCEDURE AbsWriteMemoryDword(Address: Longint; Value: Longint);


   {* CPU speed independet delay *}
PROCEDURE Delay(Ms: Longint);

   {* Read and Write in ports *}
FUNCTION  ReadPort(Port: Word): Byte;
PROCEDURE WritePort(Port: Word; Value: Byte);
FUNCTION  ReadIndexPort(Port: Word; Index: Byte): Byte;
PROCEDURE WriteIndexPort(Port: Word; Index, Value: Byte);

   {* Reboot computer *}
   {* Note! - It doesn't flush cache. BE CAREFUL! *}
PROCEDURE HardwareReboot;
PROCEDURE ColdReboot;
PROCEDURE WarmReboot;

   {* It's same as name *}
PROCEDURE DoNone;

   {* Check is the memory block ROM *}
   {* It's very silly operation and It doesn't work every time *}
FUNCTION  CheckROM (Segm: System.Word): Boolean;


IMPLEMENTATION

{$L TSYSTEM.OBJ}

PROCEDURE FillDword(Buffer: Pointer; Count: Word; DD: Longint);External;
PROCEDURE FillWord(Buffer: Pointer; Count: Word; DW: Word);External;
PROCEDURE FillByte(Buffer: Pointer; Count: Word; DB: Byte);External;
PROCEDURE Fill(Dest,Source: Pointer; Size,Count: Word);External;


PROCEDURE SwapByte(Var S,D: Byte);External;
PROCEDURE SwapWord(Var S,D: Word);External;
PROCEDURE SwapLong(Var S,D: Longint);External;
PROCEDURE Swap(Source, Dest: Pointer; Size: Word);External;

FUNCTION  CompareBuffersPtr(Var Source,Dest; Size: Word): Word;External;
PROCEDURE MovePtr(Source, Dest: Pointer; Count: Word);External;
FUNCTION  SearchPtr(Buffer: Pointer; Count: Word; Buff: Pointer; BuffSize: Word): Pointer;External;


FUNCTION  ReadMemoryByte(Address: Pointer): Byte;External;
FUNCTION  ReadMemoryWord(Address: Pointer): Word;External;
FUNCTION  ReadMemoryDword(Address: Pointer): Longint;External;

PROCEDURE WriteMemoryByte(Address: Pointer; Value: Byte);External;
PROCEDURE WriteMemoryWord(Address: Pointer; Value: Word);External;
PROCEDURE WriteMemoryDword(Address: Pointer; Value: Longint);External;

FUNCTION  AbsReadMemoryByte(Address: Longint): Byte;External;
FUNCTION  AbsReadMemoryWord(Address: Longint): Word;External;
FUNCTION  AbsReadMemoryDword(Address: Longint): Longint;External;

PROCEDURE AbsWriteMemoryByte(Address: Longint; Value: Byte);External;
PROCEDURE AbsWriteMemoryWord(Address: Longint; Value: Word);External;
PROCEDURE AbsWriteMemoryDword(Address: Longint; Value: Longint);External;

PROCEDURE Delay(MS: Longint);External;

FUNCTION  ReadPort(Port: Word): Byte;External;
PROCEDURE WritePort(Port: Word; Value: Byte);External;
FUNCTION  ReadIndexPort(Port: Word; Index: Byte): Byte;External;
PROCEDURE WriteIndexPort(Port: Word; Index,Value: Byte);External;


PROCEDURE HardwareReboot;External;
PROCEDURE ColdReboot;External;
PROCEDURE WarmReboot;External;



PROCEDURE GetBiosConfigTable;External;
PROCEDURE GetCPU_Type;External;
PROCEDURE GetCPU_Speed;External;
PROCEDURE GetExtendedMemorySize;External;


PROCEDURE DoNone;assembler;
ASM
END;


FUNCTION  CheckROM (Segm: System.Word): Boolean;
BEGIN
  CheckRom:= (PRomInfoRec(Ptr(Segm, 0000))^.Signature = ROM_Sign);
END;


PROCEDURE GetBios_Type;
TYPE
    TDellName     = array[1..4] of System.Char;
    THPName       = array[1..2] of System.Char;
    TCompaqName   = array[1..6] of System.Char;
    TToshibaName  = array[1..7] of System.Char;
    TAmiName      = array[1..3] of System.Char;

    PPhoenixName  = ^TPhoenixName;
    TPhoenixName  = array[1..4] of System.Char;
    PAwardName    = ^TAwardName;
    TAwardName    = array[1..5] of System.Char;

CONST
     cDellSign_1   = 'DELL';
     cDellSign_2   = 'Dell';
     cCompaqSign   = 'COMPAQ';
     cHPSign       = 'HP';
     cToshibaSign  = 'TOSHIBA';
     Tandy1000Fl_1 = $21;
     Tandy1000Fl_2 = $FF;
     cAwardSign    = 'Award';
     cAMI_Sign     = 'AMI';
     cPhoenixSign  = 'PTL'#0;

VAR
   DellSign           : TDellName     absolute $F000:$E076;
   HPSign             : THPName       absolute $F000:$00F8;
   CompaqSign         : TCompaqName   absolute $F000:$FFEA;
   ToshibaSign        : TToshibaName  absolute $F000:$E010;
   AMI_Sign           : TAmiName      absolute $F000:$FF60;
   Tandy1000FirstFlag : System.Byte   absolute $F000:$C000;
   Tandy1000SecondFlag: System.Byte   absolute $FFFF:$000E;


  PROCEDURE SetBiosType(BType: Byte);
  BEGIN
    PByte(Addr(BiosType))^:= BType;
  END;

  FUNCTION PhoenixInstalled: BOOLEAN;
  VAR
     SegOfs: TSegOfs absolute BiosConfigTable;
  BEGIN
    PhoenixInstalled:= (PPhoenixName(Ptr(SegOfs.S, SegOfs.O + $13))^ = cPhoenixSign);
  END;

  FUNCTION AwardInstalled: BOOLEAN;
  VAR
     SegOfs: TSegOfs absolute BiosConfigTable;
  BEGIN
    AwardInstalled:= (PAwardName(Ptr(SegOfs.S, SegOfs.O + $0A))^ = cAwardSign);
  END;

BEGIN
  IF (DellSign = cDellSign_1) or (DellSign = cDellSign_2) THEN SetBiosType(btDell)
  ELSE IF (HPSign = cHPSign) THEN SetBiosType(btHewlett_Packard)
  ELSE IF (CompaqSign = cCompaqSign) THEN SetBiosType(btCompaq)
  ELSE IF (ToshibaSign = cToshibaSign) THEN SetBiosType(btToshiba)
  ELSE IF (Tandy1000FirstFlag = Tandy1000Fl_1) and (Tandy1000SecondFlag = Tandy1000Fl_2)
  THEN SetBiosType(btTandy1000)
  ELSE IF PhoenixInstalled THEN SetBiosType(btPhoenix)
  ELSE IF (AMI_Sign = cAMI_Sign) THEN SetBiosType(btAMI)
  ELSE IF AwardInstalled THEN SetBiosType(btAward)
  ELSE SetBiosType(btUnknown);
END;


PROCEDURE Init_TSystem;
BEGIN
  GetCPU_Type;
  IF CpuType < cpu80386 THEN
  BEGIN
   Writeln('This module request at least 386 processor');
   Halt(255);
  END;
  GetCPU_Speed;
  GetExtendedMemorySize;
  GetBiosConfigTable;
  GetBios_Type;
  SelfAddr:= Ptr(PrefixSeg - 1, $0000);
END;


BEGIN
  Init_TSystem;
END.