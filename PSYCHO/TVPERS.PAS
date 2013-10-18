{-----------------------------------------------------------------------}
{ PROJECT               TVISION TOOLS COLLECTION                        }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                TVISION_LIBRARY                                 }
{ FILE NAME             TVPERS.PAS                                      }
{ PURPOSE               Persons Library                                 }
{ VERSION               0.22                                            }
{ DATE                  16-Mar-96                                       }
{ DESIGN                Begtin Ivan                                     }
{ IMPLEMENTATION        Begtin Ivan                                     }
{ COMPANY               None                                            }
{ ADDRESS               Smolensky str, 17-10-61                         }
{                       Moscow, 119121                                  }
{                       SNG                                             }
{                       Tel. 007 (095) 241-5514                         }
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
{ SPECIAL               None                                            }
{ DESCRIPTION           1.                                              }
{                       2.                                              }
{                       3.                                              }
{ REVISION HISTORY     Ivan Begtin (IB)                                 }
{                                                                       }
{                                                                       }
{ THANKS TO            Dmitry Stefankov for style lessons               }
{                      Victor Begtin for first Pascal lessons           }
{-----------------------------------------------------------------------}


Unit TvPers;

INTERFACE


CONST
     cspName                =  '~И~мя';
     cspFamilyName          =  '~Ф~амилия';
     cspAge                 =  '~В~озраст';
     cspBornDate            =  'Дата рождения';
     cspYear                =  '~Г~од';
     cspMonth               =  '~М~есяц';
     cspDay                 =  '~Д~ень';
     cspSex                 =  '~П~ол';
     cspComment             =  '~К~омментарий';
     cspTelephone           =  '~Т~елефон';

     cbPersonNameSize       =  12;
     cbPersonFamilyNameSize =  30;
     cbPersonCommentSize    =  60;
     cbTelephoneStrSize     =  13;
     cbAgeStrSize           =  03;
     cbYearStrSize          =  04;
     cbMonthStrSize         =  02;
     cbDayStrSize           =  02;



{*==================== TYPE DECLARATIONS PART ==========================*}
TYPE
    PDateRec                    = ^TDateRec;
    TDateRec                    =  RECORD
                                     Day,Month:  Byte;
                                     Year     :  Word;
                                   END;

    PTimeRec                    = ^TTimeRec;
    TTimeRec                    =  RECORD
                                     Hour,
                                     Minute,
                                     Second,
                                     Second100:  Byte;
                                   END;


    TPersonName                 =  String[cbPersonNameSize];
    TPersonFamilyName           =  String[cbPersonFamilyNameSize];
    TPersonCommentStr           =  String[cbPersonCommentSize];
    TTelephoneStr               =  String[cbTelephoneStrSize];
    TAgeStr                     =  String[cbAgeStrSize];
    TYearStr                    =  String[cbYearStrSize];
    TDayStr                     =  String[cbMonthStrSize];
    TMonthStr                   =  String[cbDayStrSize];

    TDateStrs                   =  RECORD
              Year          :  TYearStr;
              Month         :  TMonthStr;
              Day           :  TDayStr;
                                   END;


    PPersonInfo                 =  ^TPersonInfo;
    TPersonInfo                 =  RECORD
              Name          :  TPersonName;
              FamilyName    :  TPersonFamilyName;
              Age           :  TAgeStr;
              BornDate      :  TDateStrs;
              Sex           :  Word;
              Comment       :  TPersonCommentStr;
              Telephone     :  TTelephoneStr;
                                   END;


TYPE
    PPersonCollection           =  ^TPersonCollection;
    TPersonCollection           =  OBJECT(TCollection)
              PROCEDURE    FreeItem(Item: Pointer); VIRTUAL;
                                   END;


    PPersonDialog               =  ^TPersonDialog
    TPersonDialog               =  OBJECT(TDialog)
              PersonInfo        : PPersonInfo;
              CONSTRUCTOR  Init(Var Bounds: TRect; TitleStr: TTitleStr);
              PROCEDURE    HandleEvent(Var Event: TEvent); VIRTUAL;
              DESTRUCTOR   Done; VIRTUAL;
              PROCEDURE    GetPerson(Var Person: TPersonInfo);
              PROCEDURE    SetData(Var Rec); VIRTUAL;
              PROCEDURE    GetData(Var Rec); VIRTUAL;
              PROCEDURE    InsertInpLine(Var Bounds: TRect; TitleStr: string; MaxLen: Integer);
    END;




IMPLEMENTATION


PROCEDURE   TPersonCollection.FreeItem(Item: Pointer);
BEGIN
   Dispose(PPersonInfo(Item));
END;


PROCEDURE  TPersonDialog.InsertInpLine(Var Bounds: TRect; TitleStr: string; MaxLen: Integer);
VAR
   Control: PView;
BEGIN
  Control:= New(PInputLine, Init(Bounds, MaxLen));
  Insert(Control);
  Dec(Bounds.A.Y);  Dec(Bounds.B.Y);
  Insert(New(PLabel, Init(Bounds, TitleStr, Control)));
END;


CONSTRUCTOR  TPersonDialog.Init(Var Bounds: TRect; TitleStr: TTitleStr);
VAR
   R      :  TRect;
   Control:  PView;
BEGIN
  inherited Init(Bounds, TitleStr);
  GetExtent(R);

  R.Assign();
  InsertInpLine(R, cspName, cbPersonNameSize);

  R.Assign();
  InsertInpLine(R, cspFamilyName, cbPersonFamilyNameSize);

  R.Assign();
  InsertInpLine(R, cspAge, cbAgeStrSize);

  R.Assign();
  InsertInpLine(R, cspAge, cbAgeStrSize);

  R.Assign();
  Insert(New(PStaticText, Init(R, cspBornDate)));

  R.Assign();
  InsertInpLine(R, cspYear, cbYearStrSize);

  R.Assign();
  InsertInpLine(R, cspMonth, cbMonthStrSize);

  R.Assign();
  InsertInpLine(R, cspDay, cbDayStrSize);

  R.Assign();
  Control:=
END;


PROCEDURE

{*==================== MODULE INITIALIZATION PART ================*}
BEGIN
END.