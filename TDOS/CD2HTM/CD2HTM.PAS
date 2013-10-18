{-----------------------------------------------------------------------}
{ PROJECT               NOT PROJECT (SINGLE PROGRAM)                    }
{                       FOR INTERNAL USE ONLY                           }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             CD2HTM.PAS                                      }
{ PURPOSE               Use 386+ 32 bits codes and optimizating,        }
{                       some tools and utilities                        }
{ VERSION               0.01                                            }
{ DATE                  24-Mar-98                                       }
{ DESIGN                Begtin Ivan                                     }
{ IMPLEMENTATION        Begtin Ivan                                     }
{ COMPANY               None                                            }
{ COPYRIGHT NOTICE      Copyright (C) 1997-1998, Begtin Ivan            }
{ RESTRICTED RIGHTS     AVAILABLE ONLY FOR INTERNAL USE                 }
{                       NOT FOR COMMERCIAL PURPOSE                      }
{                       NOT FREEWARE/SHAREWARE PROGRAM                  }
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
{ SPECIAL               Works only with 386+ processor                  }
{ DESCRIPTION           Convert CD-DISK to HTML hypertext format file   }
{                       Designed for systemating programs library       }
{ REVISION HISTORY      Ivan Victorovich Begtin (IVB)                   }
{                       v0.01 - First version                           }
{                                                                       }
{ THANKS TO             Dmitry Stefankov for programming style lessons  }
{-----------------------------------------------------------------------}

PROGRAM  CD_DiskToHTML;

USES  TSystem;

CONST
    cs_Purpose          =  'Disk Catalog to HTML converter (CD2HTML)';
    cs_Version          =  '0.01';
    cs_Copyright        =  'Copyright (C) 1998';
    cs_Author           =  'Ivan Begtin';

    {** HTML text constants **}
    ch_LArrow           =  '<';
    ch_RArrow           =  '>';
    ch_EndSym           =  '/';
    ch_Equal            =  '=';
    ch_A                =  'a';
    cs_HTML             =  'html';
    cs_Head             =  'head';
    cs_Title            =  'title';
    cs_Body             =  'body';
    cs_Name             =  'name';
    cs_Link             =  'href';


type
    type_General_Info  = record
        CD_Serial    : System.Word;
        CD_Name      : String;
        CD_Comment   : String;
                         end;

function Is_Win95Here: System.Boolean;
Begin
End;

function Is_MSCDEX_Installed: System.Boolean;assembler;
Asm
   PUSH  0DADAh
   MOV   AX, 01100h
   INT   2Fh
   POP   AX
   MOV   AL, 00h
   CMP   AH, 0ADh
   JNE   @@Not_Installed
   MOV   AL, 01h
 @@Not_Installed:
End;


function Get_CDROM_Drive: System.Char;Assembler;
Asm
   MOV   AX, 1500h
   MOV   BX, 0000h
   INT   2Fh
   MOV   AL, 0
   CMP   BX, 0
   JE    @@No_CDROM_Drive
   MOV   AL, CL          { ; CX - drive leter (0=A:) }
   ADD   AL, 041h        { ; AL+'A' }
@@No_CDROM_Drive:
End;

VAR
  CD_Drive: System.Char;
  
BEGIN

  {**  All string between these commnts are only for test **}
  Writeln ('CD Present: ', Is_MSCDEX_Installed);
  CD_Drive:= Get_CDROM_Drive;
  IF Byte (CD_Drive) = 0 then
    Writeln ('CD Drive letter unknown.')
  else
    Writeln ('CD Drive letter: ', CD_DRIVE);
  {**  All string between these commnts are only for test **}    

END.