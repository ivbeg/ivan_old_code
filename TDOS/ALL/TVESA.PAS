{-----------------------------------------------------------------------}
{ PROJECT               TURBO PASCAL LIBRARY                            }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             TVESA.PAS                                       }
{ PURPOSE                                                               }
{                                                                       }
{ VERSION               0.01                                            }
{ DATE                  23-Sep-97                                       }
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
{ DESCRIPTION                                                           }
{                                                                       }
{ REVISION HISTORY      Ivan Begtin (IB)                                }
{                       0.01 - First version                            }
{ THANKS TO             Dmitry Stefankov for programming style lessons  }
{-----------------------------------------------------------------------}

Unit TVesa;         {* TVesa *}

Interface


Uses TSystem;

Type
   TVESA_InfoRec = record
     Signature            : array [1..4] of System.Char; {* 'VESA' or 'VBE2' *}
     VesaVersion          : System.Word;                {* Minor version *}
     OEM_Name             : PChar;                      {* Pointer to OEM_Name *}
     Flags                : System.Longint;             {* Capabilities flags *}
     VesaModesList        : System.Pointer;             {* $FFFF at the end *}
     VideoMemorySize      : System.Word;                {* In 64K block *}
     VBE2_OEM_SoftVersion : System.Word;
     VBE2_VendorName      : PChar;
     VBE2_ProductName     : PChar;
     VBE2_RevisionName    : PChar;
     Reserved_1           : array [1..222] of System.Byte;
     OEM_Scratchpad       : array [1..256] of System.Byte;
   End;


   TVESA_ModeInfoRec = record
     ModeAttributes       : System.Word;
     Window_A_Attributes  : System.Byte;
     Window_B_Attributes  : System.Byte;
     Window_Granularity   : System.Word;
     Window_Size          : System.Word;
     Window_A_Segment     : System.Word;
     Window_B_Segment     : System.Word;
     Window_PosFunction   : System.Pointer;
     Bytes_in_ScanLine    : System.Word;
     Width                : System.Word;
     Height               : System.Word;
     CharacterCell_Width  : System.Byte;
     CharacterCell_Height : System.Byte;
     MemoryPlanes         : System.Byte;
     Bits_in_Pixel        : System.Byte;
     Banks                : System.Byte;
     MemoryModelType      : System.Byte;
     Size_of_Bank         : System.Byte;
     ImagePages           : System.Byte;
     Reserved_1           : System.Byte;
{* VBE 1.2+ only *}
     RedMask_Size         : System.Byte;
     RedField_Position    : System.Byte;
     GreenMask_Size       : System.Byte;
     GreenField_Position  : System.Byte;
     BlueMask_Size        : System.Byte;
     BlueField_Position   : System.Byte;
     ReservedMask_Size    : System.Byte;
     ReservedMask_Position: System.Byte;
     DirectColorMode      : System.Byte;
{* VBE 2.0+ only *}
     LinearVideoAddress   : System.Longint;
     OffscreenMemory_Ptr  : System.Pointer;
     OffscreenMemory_Size : System.Word;
     Reserved_2           : array [1..206] of System.Byte;
   End;

Const
   vesa_GetInformation     = $4F00;
   vesa_GetModeInformation = $4F01;
   vesa_SetMode            = $4F02;
   vesa_GetMode            = $4F03;

Var
   VESA_Present  : System.Boolean;
   VESA_Info     : TVESA_InfoRec;


function  GetVESA_ModeInfo (VESA_Mode: System.Word;
                           Var ModeInfo: TVESA_ModeInfoRec) : System.Boolean;
function  SetVESA_Mode (VESA_Mode: System.Word): System.Boolean;
function  GetVESA_Mode : System.Word;


implementation


procedure GetVESA_Info;
Var
   Temp : System.Pointer;
Begin
  Temp:= Addr(VESA_Info);
  Asm
     MOV       AX, vesa_GetInformation
     LES       DI, Temp
     INT       10h
     CMP       AH, 01
     JE        @@GetVESA_Info_End
     MOV       VESA_Present, True
  @@GetVESA_Info_End:
  End;
End;


procedure Init_TVesa;
Begin
  VESA_Present:= False;
  GetVESA_Info;
End;


function  GetVESA_ModeInfo (VESA_Mode: System.Word;
                           Var ModeInfo: TVESA_ModeInfoRec) : System.Boolean; assembler;
Asm
   MOV       AX, vesa_GetModeInformation
   MOV       BX, VESA_Mode
   LES       DI, ModeInfo
   INT       10h
   XOR       AL, AL
   CMP       AH, 01
   JE        @@GetVESA_ModeInfo_End
   MOV       AL, 1
@@GetVESA_ModeInfo_End:
End;


function  SetVESA_Mode (VESA_Mode: System.Word): System.Boolean; assembler;
Asm
   MOV       AX, vesa_SetMode
   MOV       BX, VESA_Mode
   INT       10h
   XOR       AL, AL
   CMP       AH, 01
   JE        @@SetVESA_Mode_End
   MOV       AL, 1
@@SetVESA_Mode_End:
End;


function  GetVESA_Mode : System.Word; assembler;
Asm
   MOV       AX, vesa_GetMode
   INT       10h
   MOV       AX, BX
End;




Begin
  Init_TVesa;
End.



