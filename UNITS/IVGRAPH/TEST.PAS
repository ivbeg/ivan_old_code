{$F+,O+}
Program Test;
(*
    const
      ovrOk          =  0;   { Success }
      ovrError       = -1;   { Overlay manager error }
      ovrNotFound    = -2;   { Overlay file not found }
      ovrNoMemory    = -3;   { Not enough memory for overlay buffer }
      ovrIOError     = -4;   { Overlay file I/O error }
      ovrNoEMSDriver = -5;   { EMS driver not installed }
      ovrNoEMSMemory = -6;   { Not enough EMS memory }


*)

Uses Overlay,IvGraph,IvString,IvKbd,IvSystem,IvMouse,
     TestStrs;

{$O TestStrs}

Var
 HaltFlag:Boolean;
 TitulColor: byte;

 Holer: byte;
 Melan: byte;
 Flegm: byte;
 Sangv: byte;

 Count: byte;
 ExitCount:byte;

 Name       : String;
 FamilyName : String;
 MemberNum  : byte;


function TheWait:boolean;far;
begin
 TheWait:=KeyPresent or LeftButton or RightButton;
end;

procedure WriteStr(S:string;Attr:byte);
begin
 IvGraph.WriteStr(Addr(S),Attr);
end;

function StrLow(S:String):String;
Var C:byte;
begin
  FOR C:=1 TO Byte(S[0]) DO
   begin
    if (S[C] in ['A'..'Z']) or (S[C] in [#$80..#$8F]) then
     Byte(S[C]):=Byte(S[C])+$20;
    if S[C] in [#$90..#$9F] then Byte(S[C]):=Byte(S[C])+$50;
   end;
    StrLow:=S;
end;

function UpCase(Ch:char):char;
begin
    if (CH in ['a'..'z']) or (Ch in [#$A0..#$AF]) then
     UpCase:=Char(Byte(Ch)-$20);
    if Ch in [#$E0..#$EF] then UpCase:=Char(Byte(Ch)-$50);
end;


procedure ReadString(Size:byte; Var S:AnyString;FillCh: char;FillAttr:byte);
const
 Null        = 0;
 CtrlA       = 1;
 CtrlC       = 3;
 CtrlD       = 4;
 CtrlF       = 6;
 Bell        = 7;
 BS          = 8;
 HT          = 9;
 LF          = 10;
 CR          = 13;
 CtrlR       = 18;
 CtrlS       = 19;
 CtrlX       = 24;
 ESC         = 27;
 SP          = 32;

 UpArrow     = $48;
 DownArrow   = $50;
 HomeKey     = $47;
 EndKey      = $4F;
 PageUp      = $49;
 PageDown    = $51;
 LeftArrow   = $4B;
 RightArrow  = $4D;
 InsKey      = $52;
 DelKey      = $53;

Var
 KeyW: word;
 Key: CharScan absolute KeyW;
 SLen: byte absolute S;
 I: byte;
 OldX,OldY: byte;
 Insert: boolean;
 CurrPos: byte;
begin
  CurrPos:=0;
  Insert:=true;
  OldX:=GetX;
  OldY:=GetY;
  SLen:=0;
  I:=0;
  repeat
   CursorOff;
   CursorXY(OldX,OldY);
   FastWrite(S);
   FOR I:=Slen+1 To Size DO WriteChar(FillCh,FillAttr);
   CursorOn;
   CursorXY(OldX+CurrPos,OldY);
   KeyW:=GetKey;
   if Key.CharCode = 0 then
    Case Key.ScanCode of
     LeftArrow:  if (CurrPos > 0) then Dec(CurrPos);
     RightArrow: if ((CurrPos < Slen) and (CurrPos < Size)) then Inc(CurrPos);
     HomeKey:    Currpos:=0;
     EndKey:     CurrPos:=Slen;
     DelKey:     if Slen > CurrPos then
                  FOR I:=CurrPos+1 TO Slen-1 DO S[I]:=S[I+1];
    end
   else
    Case Key.CharCode of
     CtrlC: begin
             FastWriteLn('^C');
             Halt;
            end;
     BS: if CurrPos > 0 then
          begin
           FOR I:=CurrPos TO Slen DO S[I]:=S[I+1];
           Dec(CurrPos);
           Dec(Slen);
          end;
SP..$FF: if Slen < Size then
                begin
                 Inc(CurrPos);
                 if Insert Then
                  begin
                   FOR I:=Slen DOWNTO CurrPos DO
                    S[I+1]:=S[I];
                   Inc(Slen);
                  end;
                  S[CurrPos]:=Char(Key.CharCode);
                end;
    end;
  until (Key.CharCode = CR);
end;


procedure ReadInfo;
const
 cbFillChar = '▒';
Var
 SaveAttr:byte;
 C:byte;
 Found:boolean;
begin
 SaveAttr:= TextAttr;
 TextAttr:= LightBlue;
 WriteStr('Имя: ',Cyan); ReadString(12,Name,cbFillChar,Green);EndL;
 WriteStr('Фамилия: ',Cyan); ReadString(20,FamilyName,cbFillChar,Green);EndL;
 C:=0;
 MemberNum:=0;
 Name:=StrLow(Name);
 FamilyName:=StrLow(FamilyName);
 Name[1]:=UpCase(Name[1]);
 FamilyName[1]:=UpCase(FamilyName[1]);
 Found:=false;
 repeat
  Inc(C);
  If FamilyName = csFamilyNames[C] then if (Name = GetName(C)) or (Name = csShortNames[C]) then
   begin
    MemberNum:=C;
    Found:=true;
   end;
 until ((C = Members) or Found);
 TextAttr:= SaveAttr;
 ENDL;
end;


function Ask_YES_or_NO:byte;forward;

procedure Halting;
begin
 Endl;
 IF HaltFlag Then Halt;
 HaltFlag:=true;
 Inc(ExitCount);
 if ExitCount > 4 then
  if ExitCount = 10 then
   begin
    WriteStr(csIdiot,LightBlue);WriteStr(csIdiot2,LightCyan);EndL;
    Halt;
   end
  else  WriteStr(csRealSure+Digit(ExitCount)+csCount,LightBlue)
 else  WriteStr(csSure,LightBlue);
 if Ask_YES_or_NO = 1 then Halt;
 HaltFlag:=false;
 Dec(Count);
end;


function Ask_YES_or_NO:byte;
Var KeyW:word;
    Key:CharScan absolute KeyW;
    label Recursy;
begin
Recursy:
 KeyW:=GetKey;
 case LowCase(Char(Key.CharCode)) of
  kbYes: begin
           FastWriteLn(csYes);
           Ask_YES_or_NO:=1;
         end;
  kbNo:  begin
          FastWriteLn(csNo);
          Ask_YES_or_NO:=0
         end;
  kbRUYes: begin
            FastWriteLn(csYes);
             Ask_YES_or_NO:=1;
          end;
  kbRUNo: begin
           FastWriteLn(csNo);
           Ask_YES_or_NO:=0
          end;
  kbRYes: begin
            FastWriteLn(csYes);
            Ask_YES_or_NO:=1;
          end;
  kbRNo: begin
          FastWriteLn(csNo);
          Ask_YES_or_NO:=0
         end;


  kbEsc: begin
          Halting;
         end;
  kbCtr: begin
          Halting;
         end;
 else   GOTO Recursy;
 end;
end;



procedure InitPart(Var Typ: byte; StrArr: TAsksArray);
 begin
  WriteStr(csYou,Cyan);EndL;
  Typ:=0;
  FOR Count:=1 TO AsksNum DO
   begin
     CursorXY(GetX+csYouSize,GetY);
     FastWrite(StrArr[Count]+'? ');
     Typ:=Typ + Ask_YES_or_NO;
   end;
 end;

procedure WriteTestHelp;
begin;
 FastWriteln(UpCase(kbYes)+'  = "'+csYes+'"');
 FastWriteln(UpCase(kbNo)+'   = "'+csNo+'"');
 FastWriteln('Esc'+' = '+'"Выход"');
end;


Function  Persents(FB,LB:byte):str6;
Var
 Temp:LongInt;
begin
 Temp:=LongInt(FB)*10000;
 Temp:=Temp div LB;
 Persents:=Digit(Temp div 100)+'.'+Digit(Temp mod 100)+'%';
end;


procedure MakeResult;
Const
 StrColor  = Green;
 CharColor = LightRed;
Var All:byte;
    S:String;
    SaveAttr:byte;
begin
 All:=Flegm+Holer+Melan+Sangv;
 ENDL;
 WriteStr(csResult,LightCyan);EndL;
 ENDL;
 CursorXY(GetX+1,GetY);
 S:=Persents(Holer,All);
 WriteStr(S,StrColor); WriteChar(csHolerik[1],CharColor);
 S:=' + '+Persents(Sangv,All);
 WriteStr(S,StrColor); WriteChar(csSangvinik[1],CharColor);
 S:=' + '+Persents(Flegm,All);
 WriteStr(S,StrColor); WriteChar(csFlegmatik[1],CharColor);
 S:=' + '+Persents(Melan,All);
 WriteStr(S,StrColor);
 WriteChar(csMelanholik[1],CharColor);EndL;EndL;
 SaveAttr:=TextAttr;
 TextAttr:=Cyan;
 WriteChar(csHolerik[1],CharColor); FastWriteLn(' = '+csHolerik);
 WriteChar(csSangvinik[1],CharColor); FastWriteLn(' = '+csSangvinik);
 WriteChar(csFlegmatik[1],CharColor); FastWriteLn(' = '+csFlegmatik);
 WriteChar(csMelanholik[1],CharColor); FastWriteLn(' = '+csMelanholik);
 TextAttr:=SaveAttr;
end;

Procedure MakeFormulaTest;
begin
 WITH BiosArea DO CursorXY(WindMin.X+(MaxColumns - Byte(csTest[0]) - Byte(csFormula[0])) div 2,GetY);
 WriteStr(csTest,Green);
 WriteStr(csFormula,LightMagenta);EndL;
 WriteCenter(GetY,Cyan,csAsks); EndL;EndL;

 InitPart(Holer,HolerArray);
 InitPart(Flegm,FlegmArray);
 InitPart(Sangv,SangvArray);
 InitPart(Melan,MelanArray);
 MakeResult;
end;

procedure Pause;
Var
 SaveAttr:byte;
begin
 SaveAttr:=TextAttr;
 TextAttr:=LightMagenta;
 IvGraph.Pause;
 TextAttr:=SaveAttr;
end;

procedure StartTest;
begin
{ WaitProc:=TheWait;}
 SetPauseStr('Нажмите любую клавишу...');
 WriteTestHelp;
 MakeFormulaTest;
 Pause;
end;


function GetBornYear:Str6;
begin
 if csComments[MemberNum].BornYear = 0 then GetBornYear:=csDontKnow
                  else GetBornYear:=Digit(csComments[MemberNum].BornYear+1900)+'-й';
end;

function GetBornDay:Str2;
begin
 if csComments[MemberNum].BornDay = 0 then GetBornDay:=csDontKnow
                                      else GetBornDay:=Digit(csComments[MemberNum].BornDay);
end;

function GetBornMonth:Str10;
begin
 if csComments[MemberNum].BornMonth = 0 then GetBornMonth:=csDontKnow
                                        else GetBornMonth:=csMonths[csComments[MemberNum].BornMonth];
end;

function GetComment:String;
begin
 if csComments[MemberNum].Comment = '' then GetComment:=csNoComment
                                       else GetComment:=csComments[MemberNum].Comment;
end;

function GetElseName:String;
begin
 if csComments[MemberNum].ElseName = '' then GetElseName:=csNoElseName
                                        else GetElseName:=csComments[MemberNum].ElseName;
end;



procedure WriteExtInfo;
Const
 Shift1 = 5;
 Shift2 = 20;
 begin
  if MemberNum = 0 then Halt;
  EndL;
  WriteStr(csDoYouWant,Cyan);
  if (Ask_YES_or_NO = 1) then
   begin
    EndL;
    CursorXY(GetX+Shift1,GetY); WriteStr(csName_Family,Green);
    CursorXY(WindMin.X+Shift2,GetY); WriteStr(csFamilyNames[MemberNum]+' '+GetName(MemberNum),White);ENDL;

    CursorXY(WindMin.X+Shift1,GetY); WriteStr(csBornYear,Green);
    CursorXY(WindMin.X+Shift2,GetY); WriteStr(GetBornYear,White);ENDL;

    CursorXY(GetX+Shift1,GetY); WriteStr(csBornDay,Green);
    CursorXY(WindMin.X+Shift2,GetY); WriteStr(GetBornDay+'-e '+GetBornMonth,White);ENDL;

    CursorXY(GetX+Shift1,GetY); WriteStr(csElseName,Green);
    CursorXY(WindMin.X+Shift2,GetY); WriteStr(GetElseName,White);ENDL;

    CursorXY(GetX+Shift1,GetY); WriteStr(csA_Comment,Green);
    CursorXY(WindMin.X+Shift2,GetY); WriteStr(GetComment,White);ENDL;
    Pause;
   end else EndL;;
 end;


Begin
 OvrInit('TEST.OVR');
 SetRate_Delay(0,0);
 ReadInfo;
 StartTest;
 WriteExtInfo;
end.
