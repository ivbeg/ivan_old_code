{-----------------------------------------------------------------------}
{ PROJECT               TURBO PASCAL LIBRARY                            }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             TSYSTEM.PAS                                     }
{ PURPOSE                                                               }
{                                                                       }
{ VERSION               0.01                                            }
{ DATE                  01-Oct-97                                       }
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
{                                                                       }
{                                                                       }
{ THANKS TO             Dmitry Stefankov for programming style lessons  }
{-----------------------------------------------------------------------}

Unit TStrings;

interface

Uses TSystem;

Type
    TString_2    = String[2];
    TString_4    = String[4];
    TString_8    = String[8];
    TString_9    = String[9];


function   HexNibble(Number : byte) : char;
{ return the hexadecimal representation of the lower nibble. }
   inline($58         {  pop  ax       ; AL = Number }
         /$24/$0F     {  and  al,15    ; mask 4 lower bits }
         /$04/$90     {  add  al,90h   ; this code supposed }
         /$27         {  daa           ; by Time Paterson }
         /$14/$40     {  adc  al,40h   ; }
         /$27);       {  daa           ; AL = Result }


function  LowCase (Character: System.Char): System.Char;
function  Russian_LowCase(Character: System.Char):  System.Char;
function  Russian_UpCase(Character: System.Char):  System.Char;

function  HexByte (Value: System.Byte) : TString_2;
function  HexWord (Value: System.Word) : TString_4;
function  HexLong (Value: System.Longint) : TString_8;
function  HexPtr  (Value: System.Pointer) : TString_9;



function  StrLen(Str: PChar): Word;
function  StrEnd(Str: PChar): PChar;
function  StrCopy(Source, Dest: PChar): PChar;
function  StrMove(Source, Dest: PChar; Count: Word): PChar;
function  StrPCopy(Source: PString; Dest: PChar): PChar;
procedure StrPas(Source: PChar; Dest: PString);
function  StrUpper(Str: PChar): PChar;
function  StrLower(Str: PChar): PChar;


implementation
{$L TStrings.OBJ}

function  StrLen(Str: PChar): Word; External;
function  StrEnd(Str: PChar): PChar; External;
function  StrCopy(Source, Dest: PChar): PChar; External;
function  StrMove(Source, Dest: PChar; Count: Word): PChar; External;
function  StrPCopy(Source: PString; Dest: PChar): PChar; External;
procedure StrPas(Source: PChar; Dest: PString); External;
function  StrUpper(Str: PChar): PChar; External;
function  StrLower(Str: PChar): PChar; External;


function  LowCase (Character: System.Char): System.Char; assembler;
Asm  {* Asm *}
   MOV       AL, Character
   CMP       AL, 'A'
   JB        @@LowCase_End
   CMP       AL, 'Z'
   JA        @@LowCase_End
   ADD       AL, 'a'-'A'
@@LowCase_End:
End; {* Asm *}



function  Russian_UpCase(Character: System.Char):  System.Char; assembler;
Asm
   MOV       AL, Character
   CMP       AL, 'a'
   JB        @@Russian_UpCase_End
   CMP       AL, 'z'
   JA        @@Russian_UpCase_Check
   SUB       AL, 'a'-'A'
   JMP       @@Russian_UpCase_End
@@Russian_UpCase_Check:
   CMP       AL, $A0
   JB        @@Russian_UpCase_End
   CMP       AL, $AF
   JA        @@Russian_UpCase_NextCheck
   SUB       AL, $20
   JMP       @@Russian_UpCase_End
@@Russian_UpCase_NextCheck:
   CMP       AL, $E0
   JB        @@Russian_UpCase_End
   CMP       AL, $EF
   JA        @@Russian_UpCase_End
   SUB       AL, $E0 - $90
@@Russian_UpCase_End:
End;



function  Russian_LowCase(Character: System.Char):  System.Char; assembler;
Asm
   MOV       AL, Character
   CMP       AL, 'A'
   JB        @@Russian_LowCase_End
   CMP       AL, 'Z'
   JA        @@Russian_LowCase_Check
   ADD       AL, 'a'-'A'
   JMP       @@Russian_LowCase_End
@@Russian_LowCase_Check:
   CMP       AL, $80
   JB        @@Russian_LowCase_End
   CMP       AL, $8F
   JA        @@Russian_LowCase_NextCheck
   ADD       AL, $20
   JMP       @@Russian_LowCase_End
@@Russian_LowCase_NextCheck:
   CMP       AL, 90
   JB        @@Russian_LowCase_End
   CMP       AL, $9F
   JA        @@Russian_LowCase_End
   ADD       AL, $E0 - $90
@@Russian_LowCase_End:
End;


function  HexByte (Value: System.Byte) : TString_2;
Begin
  HexByte:= HexNibble (Value SHR 4) + HexNibble (Value);
End;


function  HexWord (Value: System.Word) : TString_4;
Begin
  HexWord:= HexByte (Hi(Value)) + HexByte (Lo(Value));
End;


function  HexLong (Value: System.Longint) : TString_8;
Var
   SegOfs: TSegOfs absolute Value;
Begin
  HexLong:= HexWord(SegOfs.S) + HexWord(SegOfs.O);
End;


function  HexPtr  (Value: System.Pointer) : TString_9;
Var
   SegOfs: TSegOfs absolute Value;
Begin
  HexPtr:= HexWord(SegOfs.S) + ':' + HexWord(SegOfs.O);
End;




Begin
End.