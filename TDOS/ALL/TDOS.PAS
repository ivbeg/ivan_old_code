{-----------------------------------------------------------------------}
{ PROJECT               TURBO PASCAL LIBRARY                            }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                DOS CONTROL FUNCTIONS                           }
{ FILE NAME             TDOS.PAS                                        }
{ PURPOSE               Use 386+ 32 bits codes and optimizating,        }
{                       some tools and utilities                        }
{ VERSION               0.01                                            }
{ DATE                  30-Mar-96                                       }
{ DESIGN                Begtin Ivan                                     }
{ IMPLEMENTATION        Begtin Ivan                                     }
{ COMPANY               None                                            }
{ COPYRIGHT NOTICE      Copyright (C) 1995-1997, Begtin Ivan            }
{ RESTRICTED RIGHTS     AVAILABLE ONLY FOR FREE DISTRIBUTION,           }
{                       NOT FOR COMMERCIAL PURPOSE                      }
{ COMPUTER              IBM PC or compatible                            }
{ OPERATING SYSTEM      MS/PC-DOS Version 3.30 or higher                }
{ COMPILER              Turbo Pascal Version 7.0                        }
{                       (Borland International Inc.)  or compatible     }
{ ASSEMBLY LANGUAGE     Turbo Assember 3.2 or compatible                }
{ LINKER                Turbo Pascal internal                           }
{ ARGUMENTS             None                                            }
{                                                                       }
{                                                                       }
{ RETURN                None                                            }
{ REQUIRES              None                                            }
{ NATURAL LANGUAGE      English Language                                }
{ SECOND LANGUAGE       Russian Language                                }
{ SPECIAL               Works only on 386+ processor                    }
{ DESCRIPTION           1. Files I/O control functions.                 }
{                       2. Memory control functions                     }
{                       3. e.t.c                                        }
{ REVISION HISTORY      Ivan Begtin (IB)                                }
{                                                                       }
{-----------------------------------------------------------------------}



Unit TDos;


interface

uses TSystem;

const
     fo_mode_Read       = 00;
     fo_mode_Write      = 01;
     fo_mode_ReadWrite  = 02;

Var
   DosResult    : TFunctionResult;
   DosVersion   : System.Word;
   SysVars      : PSysVars;
   InDosFlagPtr : PByte;
   FileOpenMode : System.Byte;
   PrefixSeg    : System.Word;
   DosFlags     : System.Byte;

 procedure DiskReset;
 procedure SelectDrive(Drive: System.Byte);
 function  GetDefaultDrive: System.Byte;
 procedure SetDiskTransferArea(NewDTA: System.Pointer);
 procedure SetInterruptVector(Interrupt: System.Byte; Vector: System.Pointer);
 procedure SetVerifyFlag(Flag: System.Boolean);
 function  GetDiskTransferArea: System.Pointer;

 function  GetBootDrive: System.Byte;
 function  GetInterruptVector(Interrupt: System.Byte): System.Pointer;


 function  GetSwitchChar: System.Char;
 procedure SetSwitchChar(Switch: System.Char);

 procedure CreateDirectory(Directory: System.PChar);
 procedure ChangeDirectory(Directory: System.PChar);
 procedure RemoveDirectory(Directory: System.PChar);

 function  GetCurrentPSP: System.Word;

 procedure CreateFile(Filename: System.PChar; Attrubute: System.Word;
                      Var Handle: System.Word);
 procedure OpenFile(Filename: System.PChar; Var Handle: System.Word);
 procedure ReadFile(Handle: System.Word; ReadBuffer: System.Pointer;
                    Count: System.Word; Var Result: System.Word);
 procedure WriteFile(Handle: System.Word; ReadBuffer: System.Pointer;
                     Count: System.Word; Var Result: System.Word);
 procedure CloseFile(Handle: System.Word);
 procedure SeekFile(Handle: System.Word; Position: System.Longint);
 procedure DeleteFile(Filename: PChar);

 function  GetFileAttributes(Filename: PChar): System.Word;
 procedure SetFileAttributes(Filename: PChar; Attributes: System.Word);

 procedure DuplicateHandle(Handle: System.Word);
 procedure ForceDuplicateHandle(InHandle: System.Word; OutHandle: System.Word);


 function  AllocateMemory(BlockSize: System.Word): System.Word;
 procedure ReleaseMemory(_Segment: System.Word);
 procedure ReallocateMemory(_Segmet: System.Word; BlockSize: System.Word);

 function  GetProgramExitCode: System.Byte;

 procedure SetPSP_Address(PSP_Segment: System.Word);
 function  GetPSP_Address: System.Word;

 function  GetVerifyFlag: System.Boolean;
 procedure RenameFile(InFilename: System.PChar; OutFilename: System.PChar);

 function  GetFileDate(Handle: System.Word): System.Word;
 function  GetFileTime(Handle: System.Word): System.Word;
 procedure SetFileTimeDate(Handle: System.Word; Time: System.Word;
                           Date: System.Word);

 function  CapitalizeChar(OutChar: System.Char): System.Char;
 procedure CapitalizeString(Var OutString: String);
 procedure CapitalizePChar(OutPChar: System.PChar);

 procedure CommitFile(Handle: System.Word);
 procedure FflushFile(Handle: System.Word);


 function  GetFreeHMA_Addr: System.Pointer;
 function  HMA_MemAvail: System.Word;
 function  AllocateHMA(BlockSize: System.Word): System.Pointer;


 function  GetEnvCount: System.Word;
 function  EnvPChar(_Segment, _Index: System.Word): System.PChar;

implementation
{$L tdos.obj}

procedure DiskReset; external;
{ Reset hard drives }

procedure SelectDrive(Drive: System.Byte); external;
{Select DOS drive}

function  GetDefaultDrive: System.Byte; external;
{return number of current drive}

procedure SetDiskTransferArea(NewDTA: System.Pointer);external;
{To point DTA on your buffer }

procedure SetInterruptVector(Interrupt: System.Byte; Vector: System.Pointer);external;
{}

procedure SetVerifyFlag(Flag: System.Boolean);external;
{Set VERIFY ON or OFF}


function  GetDiskTransferArea: System.Pointer;external;
{Return DTA address}


function  GetBootDrive: System.Byte; external;
{return number of boot drive}

function  GetInterruptVector(Interrupt: System.Byte): System.Pointer; external;


function  GetSwitchChar: System.Char; external;
procedure SetSwitchChar(Switch: System.Char); external;

procedure CreateDirectory(Directory: System.PChar); external;
procedure ChangeDirectory(Directory: System.PChar); external;
procedure RemoveDirectory(Directory: System.PChar); external;




function  GetCurrentPSP: System.Word; external;
{Return program PSP}




 procedure CreateFile(Filename: System.PChar; Attrubute: System.Word;
                      Var Handle: System.Word); external;
 procedure OpenFile(Filename: System.PChar; Var Handle: System.Word); external;
 procedure ReadFile(Handle: System.Word; ReadBuffer: System.Pointer;
                    Count: System.Word; Var Result: System.Word); external;
 procedure WriteFile(Handle: System.Word; ReadBuffer: System.Pointer;
                     Count: System.Word; Var Result: System.Word); external;
 procedure CloseFile(Handle: System.Word); external;
 procedure SeekFile(Handle: System.Word; Position: System.Longint); external;
 procedure DeleteFile(Filename: PChar); external;

 function  GetFileAttributes(Filename: PChar): System.Word; external;
 procedure SetFileAttributes(Filename: PChar; Attributes: System.Word); external;

 procedure DuplicateHandle(Handle: System.Word); external;
 procedure ForceDuplicateHandle(InHandle: System.Word; OutHandle: System.Word); external;


 function  AllocateMemory(BlockSize: System.Word): System.Word; external;
 procedure ReleaseMemory(_Segment: System.Word); external;
 procedure ReallocateMemory(_Segmet: System.Word; BlockSize: System.Word); external;

 function  GetProgramExitCode: System.Byte; external;

 procedure SetPSP_Address(PSP_Segment: System.Word); external;
 function  GetPSP_Address: System.Word; external;

 function  GetVerifyFlag: System.Boolean; external;
 procedure RenameFile(InFilename: System.PChar; OutFilename: System.PChar); external;

 function  GetFileDate(Handle: System.Word): System.Word; external;
 function  GetFileTime(Handle: System.Word): System.Word; external;
 procedure SetFileTimeDate(Handle: System.Word; Time: System.Word;
                           Date: System.Word); external;

 function  CapitalizeChar(OutChar: System.Char): System.Char; external;
 procedure CapitalizeString(Var OutString: String); external;
 procedure CapitalizePChar(OutPChar: System.PChar); external;

 procedure CommitFile(Handle: System.Word); external;
 procedure FflushFile(Handle: System.Word); external;


 function  GetFreeHMA_Addr: System.Pointer; external;
 function  HMA_MemAvail: System.Word; external;
 function  AllocateHMA(BlockSize: System.Word): System.Pointer; external;


 function  GetEnvCount: System.Word; external;
 function  EnvPChar(_Segment, _Index: System.Word): System.PChar; external;





procedure GetDosVersion; external;
procedure GetSysVarsPtr; external;
procedure GetIndosFlagPtr; external;


procedure Init_TDos;
begin
 FillByte(Addr(DosResult), Sizeof(DosResult), 00);
 DosResult.ErrorProc:= DoNone;
 GetDosVersion;
 GetSysVarsPtr;
 GetIndosFlagPtr;
 FileOpenMode:= fo_mode_ReadWrite;
 PrefixSeg:= GetCurrentPSP;
end;

begin
 Init_TDos;
End.


