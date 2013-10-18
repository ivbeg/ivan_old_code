{-----------------------------------------------------------------------}
{ PROJECT               TURBO PASCAL LIBRARY                            }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             TMOUSE.PAS                                      }
{ PURPOSE               Mouse control unit.                             }
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

Unit TMouse;         {* TMouse *}

Interface

Uses TSystem;

type
   TPosition = record
      X      : System.Word;
      Y      : System.Word;
   end;

const
    MouseType    : System.Word = 0;
    MouseVersion : System.Word = 0;
    MousePresent : System.Boolean = false;

procedure ShowMouseCursor; far;
procedure HideMouseCursor; far;

function  LeftButtonPressed: System.Boolean; far;
function  RightButtonPressed: System.Boolean; far;
function  MiddleButtonPressed: System.Boolean; far;
function  AnyButtonPressed: System.Boolean; far;


function  GetCopirightString : PChar;


Implementation

{$L TMouse.OBJ}

procedure ShowMouseCursor; external;
procedure HideMouseCursor; external;

function  LeftButtonPressed: System.Boolean; external;
function  RightButtonPressed: System.Boolean; external;
function  MiddleButtonPressed: System.Boolean; external;
function  AnyButtonPressed: System.Boolean; external;

function  GetCopirightString : PChar; external;

procedure Init_TMouse; near; external;

Begin
  Init_TMouse;
End.