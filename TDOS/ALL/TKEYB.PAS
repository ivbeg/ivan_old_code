{-----------------------------------------------------------------------}
{ PROJECT               TURBO PASCAL LIBRARY                            }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             TKEYB.PAS                                       }
{ PURPOSE               Using keyboard (BIOS - int 16h). More than CRT. }
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

Unit TKeyb;         {* TKeyboard *}

Interface

Uses TSystem;


type
   TGetKeyFunction  = function : System.Word;

const
   kbd_Standard    = 01;
   kbd_Extended    = 02;
   kbd_122key      = 03;


   Keyb_Functions  : System.Byte = 0;
   KeyboardType    : System.Byte = 0;

var
   GetKey  : TGetKeyFunction;



function  GetShiftStates: System.Byte; far;
function  GetExtShiftStates: System.Word; far;
function  Get122ShiftStates: System.Word; far;

function  KeyPresent : System.Boolean; far;
procedure FlushKbdBuffer; far;

procedure SetKeyboardRate_Delay (RepeatRate, Delay: System.Byte);


implementation

{$L TKeyb.OBJ}

function  Standard_GetKey: System.Word; far; external;
function  Extended_GetKey: System.Word; far; external;
function  _122key_GetKey: System.Word; far; external;
procedure _Init_TKeyboard; near; external;
function  GetShiftStates: System.Byte; external;
function  GetExtShiftStates: System.Word; external;
function  Get122ShiftStates: System.Word; external;

function  KeyPresent: System.Boolean; external;

procedure FlushKbdBuffer; external;

procedure SetKeyboardRate_Delay (RepeatRate, Delay: System.Byte);external;

procedure Init_TKeyboard;
Begin
  _Init_TKeyboard;
  case  KeyboardType of
   kbd_Standard  : GetKey:= Standard_GetKey;
   kbd_Extended  : GetKey:= Extended_GetKey;
   kbd_122key    : GetKey:= _122key_GetKey;
   else GetKey:= Standard_GetKey;
  end; {* case KeyboardType *}
End;


Begin
  Init_TKeyboard;
End.
