{-----------------------------------------------------------------------}
{ PROJECT               PSYCHOLOGY TESTS COLLECTION                     }
{                       FREWARE SOFTWARE                                }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                PSYCHOLOGY_TEST                                 }
{ FILE NAME             PSTEST.PAS                                      }
{ PURPOSE               Test your psychology self-checking.             }
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
{                      0.01   23-Dec-95  IB  first idea                 }
{                      0.10   15-Mar-96  IB  program basis              }
{                      0.20   15-Mar-96  IB  start window created       }
{                      0.22   16-Mar-96  IB  Test completed.            }
{                                                                       }
{                                                                       }
{ THANKS TO            Dmitry Stefankov for style lessons               }
{                      Victor Begtin for first Pascal lessons           }
{-----------------------------------------------------------------------}


{*======================= PROGRAM HEADER PART ==========================*}
Program TVisionPsychologyTest;


{*** other modules ***}
USES  Objects, Drivers, Views, Menus,
      Strings,MsgBox,Dialogs,App,ShowTErr;



{** switches for compilation **}
{$S-}                    {*  stack checking     *}
{$R-}                    {*  range checking     *}
{$M 16384,65536,65536}   {*  memory allocation  *}


{*========================== CONSTANTS PART ============================*}

CONST
     asPurpose                  =       'Psychology Test';
     asVersion                  =       '0.22';
     asAuthor                   =       'Ivan Begtin';
     asCopyright                =       'Copyright (c) 1995,1996';
     asProgram                  =       'PsTest';

     aPsCharactersCount         =       20;
     aFamilyNameSize            =       20;
     aNameSize                  =       10;
     aAgeSize                   =       3;

     aFirstDescStrs             =       7;
     aSecondDescStrs            =       3;


     asFamilyName               =       '~Ф~амилия';
     asName                     =       '~И~мя';
     asAge                      =       '~В~озраст';
     asSex                      =       '~П~ол';
     asHuman                    =       '~М~ужской';
     asWoman                    =       '~Ж~енский';
     asOkButton                 =       'O~K~';
     asInputWindow              =       'Окно ввода';
     asTestDialog               =       'Тест "Самооценка"';
     asNumber                   =       'Номер: ';
     asSelfCheckLevel           =       'Ваш уровень самооценки';

     errsNumberInput            =       'Для ИДИОТОВ! '#13#3'Возраст записывается числом!!';
     errsLittle_10              =       'А тебе не рановато?';
     errsHigher80               =       'А ну без шуток!';

     cmSendPerson               =       1001;
     cmAddCounter               =       1002;
     cmListEmpty                =       1003;
     cmFirstListEnded           =       1004;
     cmSecondListEnded          =       1005;


{*==================== TYPE DECLARATIONS PART ==========================*}

TYPE
    TFamilyNameStr              =  String[aFamilyNameSize];
    TNameStr                    =  String[aNameSize];
    TAgesStr                    =  String[aAgeSize];

    PPsCharacterType            =  ^TPsCharacterType;
    TPsCharacterType            =  RECORD
              dwNumber        :  System.Word;
              dpPsName        :  System.PChar;
                                   END;

    PCharactersResultInfo       =  ^TCharactersResultInfo;
    TCharactersResultInfo       =  ARRAY[1..aPsCharactersCount] of Word;

    PPersonInfo                 =  ^TPersonInfo;
    TPersonInfo                 =  RECORD
              dsFamilyName    :  TFamilyNameStr;
              dsName          :  TNameStr;
              dsAge           :  TAgesStr;
              dwSex           :  System.Word;
                                   END;


{*====================== TYPED CONSTANTS PART ==========================*}

CONST
     gapsPsCharacters     :       ARRAY[1..aPsCharactersCount] of TPsCharacterType =
       ((dwNumber: 01;  dpPsName: 'Аккуратность'),
        (dwNumber: 02;  dpPsName: 'Доброта'),
        (dwNumber: 03;  dpPsName: 'Жизнерадостность'),
        (dwNumber: 04;  dpPsName: 'Настойчивость'),
        (dwNumber: 05;  dpPsName: 'Ум'),
        (dwNumber: 06;  dpPsName: 'Правдивость'),
        (dwNumber: 07;  dpPsName: 'Принципиальность'),
        (dwNumber: 08;  dpPsName: 'Самостоятельность'),
        (dwNumber: 09;  dpPsName: 'Скромность'),
        (dwNumber: 10;  dpPsName: 'Общительность'),
        (dwNumber: 11;  dpPsName: 'Гордость'),
        (dwNumber: 12;  dpPsName: 'Добросовестность'),
        (dwNumber: 13;  dpPsName: 'Равнодушие'),
        (dwNumber: 14;  dpPsName: 'Лень'),
        (dwNumber: 15;  dpPsName: 'Зазнайство'),
        (dwNumber: 16;  dpPsName: 'Трусость'),
        (dwNumber: 17;  dpPsName: 'Жадность'),
        (dwNumber: 18;  dpPsName: 'Подозрительность'),
        (dwNumber: 19;  dpPsName: 'Эгоизм'),
        (dwNumber: 20;  dpPsName: 'Нахальство'));

     gapcFirstText        :       ARRAY[1..aFirstDescStrs] of PChar =
      ('1-м выберите качество которое',
       'вы наиболее цените в людях.',
       '2-м - чуть меньше и т.д.',
       '13-m укажите качество которое',
       'вы легче всего могли бы просить людям',
       '14-м - которое простить труднее и т.д',
       'И 20-м - самое мерзкое человеческое качество');


     gapcSecondText        :       ARRAY[1..aSecondDescStrs] of PChar =
      ('1-м выберите качество которое',
       'наиболее всего у вас развито',
       '2-м - чуть меньше и т.д.');


{*=================== OBJECTS TYPE DECLARATIONS PART ===================*}
TYPE
    PPsTypesCollection          =  ^TPsTypesCollection;
    TPsTypesCollection          =  OBJECT(TCollection)
              PROCEDURE    FreeItem(Item: Pointer); VIRTUAL;
    END;


    PInitWindow                 =  ^TInitWindow;
    TInitWindow                 =  OBJECT(TDialog)
              PersonData      :  TPersonInfo;
              CONSTRUCTOR  Init(Var Bounds: TRect; ATitle: TTitleStr);
              PROCEDURE    HandleEvent(Var Event : TEvent); VIRTUAL;
              DESTRUCTOR   Done; VIRTUAL;
                                   END;


    PTestListBox                = ^TTestListBox;
    TTestListBox                = OBJECT(TListBox)
              CharactersInfo  :  PCharactersResultInfo;
              CONSTRUCTOR  Init(Var Bounds: TRect; NCols: Word; ScrBar: PScrollBar);
              PROCEDURE    HandleEvent(Var Event : TEvent); VIRTUAL;
              FUNCTION     GetText(Item: Integer; MaxLen: Integer): String; VIRTUAL;
              FUNCTION     ConvertListToResultInfo: PCharactersResultInfo;
              DESTRUCTOR   Done; VIRTUAL;
    END;


    PTestDialogWindow           =  ^TTestDialogWindow;
    TTestDialogWindow           =  OBJECT(TDialog)
              CloseAble       :  System.Boolean;
              CountText       :  PStaticText;
              Counter         :  Integer;
              NumOfD          :  Integer;
              CONSTRUCTOR  Init(Var Bounds: TRect; ATitle: TTitleStr; Num: Integer);
              PROCEDURE    HandleEvent(Var Event : TEvent); VIRTUAL;
              DESTRUCTOR   Done; VIRTUAL;
                                   END;


    PTestApplication            =  ^TTestApplication;
    TTestApplication            =  OBJECT(TApplication)
              Person          :  TPersonInfo;
              FirstList       :  PCharactersResultInfo;
              SecondList      :  PCharactersResultInfo;
              SelfCheck       :  Integer;
              CONSTRUCTOR  Init;
              PROCEDURE    HandleEvent(Var Event : TEvent); VIRTUAL;
              PROCEDURE    PsychoTest;
              FUNCTION     ConvertTablesToResult: integer;
              PROCEDURE    CreateResultWindow;
              FUNCTION     GetSelfCheckType: String;
              DESTRUCTOR   Done; VIRTUAL;
                                   END;



FUNCTION IntToString(Int: Longint): String;
VAR
   S: String;
BEGIN
   Str(Int,S);
   IntToString:= S;
END;


FUNCTION  CreatePsCharactersCollection: PPsTypesCollection;
VAR
  Collection:  PPsTypesCollection;
  C         :  Integer;
  Item      :  PPsCharacterType;

BEGIN
  New(Collection, Init(10,8));
  FOR C:= 1 TO aPsCharactersCount DO
  BEGIN
    New(Item);
    Item^:= gapsPsCharacters[C];
    Collection^.Insert(Item);
  END;
  CreatePsCharactersCollection:= Collection;
END;


  {** TPsTypesCollection **}

PROCEDURE  TPsTypesCollection.FreeItem(Item: Pointer);
BEGIN
  System.Dispose(PPsCharacterType(Item));
END;


  {** TTestListBox **}

CONSTRUCTOR TTestListBox.Init(Var Bounds: TRect; NCols: Word; ScrBar: PScrollBar);
BEGIN
  inherited Init(Bounds, NCols, ScrBar);
  New(CharactersInfo);
END;


DESTRUCTOR  TTestListBox.Done;
BEGIN
  Dispose(CharactersInfo);
  inherited Done;
END;


FUNCTION   TTestListBox.GetText(Item: Integer; MaxLen: Integer): String;
BEGIN
   IF List = nil THEN GetText:= ''
   ELSE GetText:= StrPas(PPsCharacterType(List^.At(Item))^.dpPsName);
END;

PROCEDURE  TTestListBox.HandleEvent(Var Event: TEvent);
VAR
   Result: PCharactersResultInfo;
BEGIN
  inherited  HandleEvent(Event);
  CASE Event.What of
    evKeyDown: CASE Event.KeyCode of
                 kbEnter:  BEGIN
                               CharactersInfo^[20 - List^.Count + 1]:= PPsCharacterType(List^.At(Focused))^.dwNumber;
                               List^.AtFree(Focused);
                               IF Focused > 0 THEN Dec(Focused);
                               Range:= List^.Count;
                               IF List^.Count = 0 THEN
                               BEGIN
                                 Result:= ConvertListToResultInfo;
                                 Message(Owner, evCommand, cmListEmpty,Result );
                                 NewList(nil);
                                 Done;
                               END
                               ELSE
                               BEGIN
                                 Message(Owner, evCommand, cmAddCounter, nil);
                                 Draw;
                               END;
                           END;
               END;
  END;
END;


FUNCTION   TTestListBox.ConvertListToResultInfo: PCharactersResultInfo;
VAR
   C    : Word;
   B    : Word;
   Found: Boolean;
   Result: PCharactersResultInfo;
BEGIN
  New(Result);
  FOR C:=1 TO aPsCharactersCount DO
  BEGIN
    B:= 0;
    REPEAT
      Inc(B);
    UNTIL  (CharactersInfo^[B] = C) OR (B = 20);
    Result^[C]:= B;
  END;
  ConvertListToResultInfo:= Result;
END;


  {** TInitWindow **}

CONSTRUCTOR  TInitWindow.Init(Var Bounds: TRect; ATitle: TTitleStr);
VAR
   R: TRect;
   InputLine: PInputLine;
   RButtons : PRadioButtons;

BEGIN
  inherited  Init(Bounds, ATitle);
  R.Assign(1,2,10,3);
  InputLine:= New(PInputLine, Init(R,aFamilyNameSize));
  Insert(InputLine);
  Dec(R.A.Y);  Dec(R.B.Y);
  Insert(New(PLabel, Init(R, asFamilyName, InputLine)));

  R.Assign(1,5,10,6);
  InputLine:= New(PInputLine, Init(R,aNameSize));
  Insert(InputLine);
  Dec(R.A.Y);  Dec(R.B.Y);
  Insert(New(PLabel, Init(R, asName, InputLine)));

  R.Assign(1,8,10,9);
  InputLine:= New(PInputLine, Init(R,aAgeSize));
  Insert(InputLine);
  Dec(R.A.Y);  Dec(R.B.Y);
  Insert(New(PLabel, Init(R, asAge, InputLine)));

  R.Assign(12,2,25,4);
  RButtons:= New(PRadioButtons, Init(R,
              NewSItem(asHuman,
              NewSItem(asWoman,
              nil))));

  Insert(RButtons);
  Dec(R.A.Y);
  R.B.Y:= R.A.Y+1;
  Insert(New(PLabel, Init(R, asSex, RButtons)));

  R.Assign(11,7,20,9);
  Insert(New(PButton, Init(R, asOkButton ,cmOk, bfNormal)));

  SetData(PersonData);
  SelectNext(False);
END;


PROCEDURE  TInitWindow.HandleEvent(Var Event: TEvent);
VAR
   PersonDat: TPersonInfo;
   Temp: Longint;
   Code: Integer;
   F: Text;
   PTemp: Pointer;

BEGIN
  if (Event.What = evCommand) then
  CASE Event.Command of
    cmOk, cmClose: BEGIN
                     GetData(PersonDat);
                     Val(PersonDat.dsAge, Temp, Code);
                     if (Code <> 0)  then
                       MessageBox(#3+errsNumberInput,nil,
                                  mfOkButton + mfInformation)
                     else
                     if Temp < 10 then
                       MessageBox(#3+errsLittle_10,nil,
                                  mfOkButton + mfInformation)
                     else
                     if Temp > 80 then
                       MessageBox(#3+errsHigher80,nil,
                                  mfOkButton + mfInformation)
                     else begin
                            Message(Owner, evCommand, cmSendPerson, Addr(PersonDat));
                          end;
                     ClearEvent(Event);
                   END;
  END;
  inherited  HandleEvent(Event);
END;


DESTRUCTOR  TInitWindow.Done;
BEGIN
  inherited Done;
END;


  {** TTestDialogWindow **}

CONSTRUCTOR TTestDialogWindow.Init(Var Bounds: TRect; ATitle: TTitleStr; Num: Integer);
VAR
  C: BYTE;
  R: TRect;
  StaticText: PStaticText;
  ScrollBar: PScrollBar;
  ListBox: PTestListBox;
BEGIN
  inherited Init(Bounds, asTestDialog);
  CloseAble:= false;
  R.Assign(33,1,78,2);
  NumofD:= Num;
  IF Num = 1 THEN
  FOR C:=1 TO aFirstDescStrs DO
  BEGIN
    Insert(New(PStaticText, Init(R,StrPas(gapcFirstText[C]))));
    Inc(R.A.Y);
    Inc(R.B.Y);
  END ELSE
  FOR C:=1 TO aSecondDescStrs DO
  BEGIN
    Insert(New(PStaticText, Init(R,StrPas(gapcSecondText[C]))));
    Inc(R.A.Y);
    Inc(R.B.Y);
  END;

  Counter:= 1;
  R.Assign(8,1,11,2);
  CountText:= New(PStaticText,Init(R, IntToString(Counter)));
  Insert(CountText);

  GetExtent(R);
  R.Grow(-1, -1);
  R.A.Y:=2;
  R.A.X:= R.B.X - 48;
  R.B.X:= R.A.X + 1;
  New(ScrollBar,Init(R));
  Insert(ScrollBar);
  R.B.X:= R.A.X;
  R.A.X:= 1;
  ListBox:= New(PTestListBox, Init(R,1,ScrollBar));
  Insert(ListBox);
  ListBox^.NewList(CreatePsCharactersCollection);

  SelectNext(False);
END;


PROCEDURE  TTestDialogWindow.HandleEvent(Var Event: TEvent);
VAR
   R: TRect;
   CallCommand: Integer;
   C: Integer;
BEGIN
  CASE Event.What of
    evCommand : CASE Event.Command of
                  cmAddCounter: BEGIN
                                  Inc(Counter);
                                  Dispose(CountText, Done);
                                  R.Assign(8,1,11,2);
                                  CountText:= New(PStaticText,Init(R, IntToString(Counter)));
                                  Insert(CountText);
                                END;
                  cmClose,
                  cmCancel:     BEGIN
                                  If not CloseAble THEN ClearEvent(Event);
                                END;

                  cmListEmpty:  BEGIN
                                 IF NumOfD = 1 THEN CallCommand:= cmFirstListEnded
                                ELSE CallCommand:= cmSecondListEnded;
                                 CloseAble:= true;
                                 Message(Owner, evCommand, CallCommand,Event.InfoPtr);
                                END;
                END;
  END;
  inherited HandleEvent(Event);
END;


DESTRUCTOR TTestDialogWindow.Done;
BEGIN
  inherited Done;
END;


  {** TTestApplication **}

FUNCTION     TTestApplication.ConvertTablesToResult: Integer;
VAR
   Temp: Real;
   C   : Integer;
BEGIN
  Temp:=0;
  FOR C:=1 TO aPsCharactersCount DO
  BEGIN
    Temp:= Temp + Sqr(Integer(Abs(FirstList^[C] - SecondList^[C])));
  END;
  Temp:=1 - (Temp * 6) / 7980 ;
  ConvertTablesToResult:= Trunc(Temp * 100);
END;

CONSTRUCTOR  TTestApplication.Init;
BEGIN
  inherited Init;
  PsychoTest;
END;


PROCEDURE    TTestApplication.HandleEvent(Var Event : TEvent);
VAR
    C: Byte;
BEGIN
  CASE Event.What of
    evCommand : CASE Event.Command of
                  cmFirstListEnded: FirstList:= Event.InfoPtr;
                  cmSecondListEnded: BEGIN
                                       SecondList:= Event.InfoPtr;
                                     END;
                END;
  END;
  inherited HandleEvent(Event);
END;



PROCEDURE    TTestApplication.PsychoTest;
VAR
   R        : TRect;
BEGIN
  R.Assign(0,0,80,23);
  ExecView(New(PTestDialogWindow, Init(R, asTestDialog,1)));
  R.Assign(0,0,80,23);
  ExecView(New(PTestDialogWindow, Init(R, asTestDialog,2)));
  CreateResultWindow;
END;


FUNCTION     TTestApplication.GetSelfCheckType: String;
VAR
   S: String;
BEGIN
  IF SelfCheck >= 31 THEN
    IF SelfCheck >= 51 THEN
      IF SelfCheck >= 66 THEN
        IF SelfCheck >= 80 THEN S:= 'Неадекватно высокий.'
        ELSE  S:= 'Высокий.'
      ELSE  S:= 'Выше среднего.'
    ELSE  S:= 'Средний.'
  ELSE
    IF SelfCheck <=20 THEN
      IF  SelfCheck <=00 THEN
        IF SelfCheck <= -50 THEN S:='Крайне неадекватно низкий.'
        ELSE S:= 'Неадекватно низкий.'
      ELSE  S:= 'Низкий.'
    ELSE  S:= 'Ниже среднего.'
    ;
  GetSelfCheckType:=S;
END;


PROCEDURE    TTestApplication.CreateResultWindow;
BEGIN
  SelfCheck:=ConvertTablesToResult;
  MessageBox(#3+asSelfCheckLevel+
             #13#3+IntToString(ConvertTablesToResult)+
             #13#3+GetSelfCheckType,nil,mfInformation);
END;


DESTRUCTOR   TTestApplication.Done;
BEGIN
  inherited Done;
END;


{*=========================== VARIABLES PART ===========================*}
VAR
   Application        :  TTestApplication;


{*============================== MAIN PART =============================*}
begin
  Application.Init;
  Application.Run;
  Application.Done;
end.