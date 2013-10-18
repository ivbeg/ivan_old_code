{-----------------------------------------------------------------------}
{ PROJECT               TURBO PASCAL LIBRARY                            }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             TSYSTEM.PAS                                     }
{ PURPOSE               Disk Work Tools and Procedures                  }
{                       by BIOS and Ports.                              }
{ VERSION               0.01                                            }
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
{ DESCRIPTION                                                           }
{                                                                       }
{                                                                       }
{ REVISION HISTORY     Ivan Begtin (IB)                                 }
{                                                                       }
{                                                                       }
{ THANKS TO            Dmitry Stefankov for style lessons               }
{                      Victor Begtin for first Pascal lessons           }
{-----------------------------------------------------------------------}

UNIT TDisk;


INTERFACE

USES TSystem;

CONST
     FloppyA  = $00;
     FloppyB  = $01;
     Hard0    = $80;
     Hard1    = $81;

VAR
   DiskResult: TFunctionResult;

PROCEDURE ResetDisk(Drive: Byte);
FUNCTION  GetDiskStatus(Drive: Byte): Byte;
FUNCTION  GetDiskType(Drive: Byte): Byte;
PROCEDURE SetFloppyFormatType(Drive: Byte; FormatType: Byte);
PROCEDURE SetMediaType(Drive: Byte; Cyllinders: Word; Sectors: Byte);
PROCEDURE ControllerIntDiag;
PROCEDURE RecalibrateDrive(Drive: Byte);
PROCEDURE InitHardDiskTables(Drive: Byte);
PROCEDURE ReadFromDisk(SecNum: Byte; Cyllinder: Word; StartSec,Head,Drive: Byte; Var Buffer);
PROCEDURE WriteToDisk(SecNum: Byte; Cyllinder: Word; StartSec,Head,Drive: Byte; Var Buffer);
PROCEDURE VerifyDisk(SecNum: Byte; Cyllinder: Word; StartSec,Head,Drive: Byte; Var Buffer);

IMPLEMENTATION

{$L TDisk.OBJ}

PROCEDURE ResetDisk(Drive: Byte);External;
FUNCTION  GetDiskStatus(Drive: Byte): Byte;External;
FUNCTION  GetDiskType(Drive: Byte): Byte;External;
PROCEDURE SetFloppyFormatType(Drive: Byte; FormatType: Byte);External;
PROCEDURE SetMediaType(Drive: Byte; Cyllinders: Word; Sectors: Byte);External;
PROCEDURE ControllerIntDiag;External;
PROCEDURE RecalibrateDrive(Drive: Byte);External;
PROCEDURE InitHardDiskTables(Drive: Byte);External;
PROCEDURE ReadFromDisk(SecNum: Byte; Cyllinder: Word; StartSec,Head,Drive: Byte; Var Buffer);External;
PROCEDURE WriteToDisk(SecNum: Byte; Cyllinder: Word; StartSec,Head,Drive: Byte; Var Buffer);External;
PROCEDURE VerifyDisk(SecNum: Byte; Cyllinder: Word; StartSec,Head,Drive: Byte; Var Buffer);External;


BEGIN
  DiskResult.ErrorProc:= DoNone;
END.