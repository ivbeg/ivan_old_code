{-----------------------------------------------------------------------}
{ PROJECT               TURBO PASCAL LIBRARY                            }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             TDISK.PAS                                       }
{ PURPOSE               May be used for BIOS access to disk drives.     }
{                                                                       }
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
{ DESCRIPTION                                                           }
{                                                                       }
{ REVISION HISTORY      Ivan Begtin (IB)                                }
{                       0.01 - First version                            }
{ THANKS TO             Dmitry Stefankov for programming style lessons  }
{-----------------------------------------------------------------------}

Unit TDisk;

Interface

Uses TSystem;

Const
     Floppy_0     = $00;
     Floppy_1     = $01;
     Floppy_2     = $02;

     HardDisk_0   = $80;
     HardDisk_1   = $81;
     HardDisk_3   = $82;
     HardDisk_4   = $83;




Var
   DiskResult: TFunctionResult;      {* Here is result of each operation *}

procedure ResetDisk(Disk: System.Byte);
procedure RecalibrateDisk(Disk: System.Byte);
procedure ResetHardDisk(Disk: System.Byte);
procedure InitializeController(Disk: System.Byte);
function  CheckDriveReady(Disk: System.Byte): Boolean;
procedure ReadSectors(Disk: System.Byte; Cyllinder: System.Word;
                      Head: System.Byte; StartSector: System.Byte;
                      SectorsNum: System.Byte; Var Buffer);

procedure ReadLongSectors(Disk: System.Byte; Cyllinder: System.Word;
                          Head: System.Byte; StartSector: System.Byte;
                          SectorsNum: System.Byte; Var Buffer);

procedure WriteSectors(Disk: System.Byte; Cyllinder: System.Word;
                      Head: System.Byte; StartSector: System.Byte;
                      SectorsNum: System.Byte; Var Buffer);

procedure WriteLongSectors(Disk: System.Byte; Cyllinder: System.Word;
                          Head: System.Byte; StartSector: System.Byte;
                          SectorsNum: System.Byte; Var Buffer);

procedure VerifySectors(Disk: System.Byte; Cyllinder: System.Word;
                      Head: System.Byte; StartSector: System.Byte;
                      SectorsNum: System.Byte; Var Buffer);




Implementation

{$L TDISK.OBJ}

procedure ResetDisk(Disk: System.Byte);external;
procedure RecalibrateDisk(Disk: System.Byte);external;
procedure ResetHardDisk(Disk: System.Byte);external;
procedure InitializeController(Disk: System.Byte);external;
function  CheckDriveReady(Disk: System.Byte): Boolean;external;
procedure ReadSectors(Disk: System.Byte; Cyllinder: System.Word;
                      Head: System.Byte; StartSector: System.Byte;
                      SectorsNum: System.Byte; Var Buffer);external;

procedure ReadLongSectors(Disk: System.Byte; Cyllinder: System.Word;
                          Head: System.Byte; StartSector: System.Byte;
                          SectorsNum: System.Byte; Var Buffer);external;

procedure WriteSectors(Disk: System.Byte; Cyllinder: System.Word;
                      Head: System.Byte; StartSector: System.Byte;
                      SectorsNum: System.Byte; Var Buffer);external;

procedure WriteLongSectors(Disk: System.Byte; Cyllinder: System.Word;
                          Head: System.Byte; StartSector: System.Byte;
                          SectorsNum: System.Byte; Var Buffer);external;

procedure VerifySectors(Disk: System.Byte; Cyllinder: System.Word;
                      Head: System.Byte; StartSector: System.Byte;
                      SectorsNum: System.Byte; Var Buffer);external;




procedure Init_TDisk;
Begin
  FillByte(Addr(DiskResult), Sizeof(DiskResult), 00);
  DiskResult.ErrorProc:= DoNone;
End;

Begin
  Init_TDisk;
End.