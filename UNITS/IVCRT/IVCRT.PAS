{$F+}
Unit IvCrt;

InterFace

Uses IvSystem,IvKbd,IvString,IvDos;

Type
 UpDown = (Up,Down);
 ColorRec = array[0..15] of String[12];

Const
  { ** Colors Constants ** }
 Black        = 0;
 Blue         = 1;
 Green        = 2;
 Gyan         = 3;
 Red          = 4;
 Magenta      = 5;
 Brown        = 6;
 LightGrey    = 7;
 DarkGrey     = 8;
 LightBlue    = 9;
 LightGreen   = 10;
 LightGyan    = 11;
 LightRed     = 12;
 LightMagenta = 13;
 Yellow       = 14;
 White        = 15;

Var
    DosOutPut:Boolean;
    OutputHandle:word;
    WaitProc:RepeatFunction;
    TextChar:Char;
    TextAttr:byte;
    UseBios:boolean;
    Hide:boolean;
    WindMin: record
              X,Y:byte
             end;
    WindMax: record
              X,Y:byte
             end;
    SetCounter:boolean;
    Counter:byte;
    CurrVideoSeg:word;


Procedure WriteCharXY(X,Y:byte;Ch:char);
Procedure WriteStrXY(X,Y:byte; S:string);
Procedure WritePcharXY(X,Y:byte; P:Pchar);
Procedure ReadCharXY(X,Y:byte; Var CharCode:char;var Attr:byte);
Procedure FillAttrXY(X,Y:byte; Count:byte;Attr:byte);
Procedure Set_AttrXY(X,Y:byte; Attr:byte);


Procedure Pause(S:string);
Procedure EndL;
Procedure FillAttr(Count:byte;Attr:byte);
Function  GetXY:word;
Procedure SetPage(C:byte);
Procedure CursorXY(X,Y:byte);
Procedure CursorOn;
Procedure CursorOff;
Function  GetX:byte;
Function  GetY:byte;
Procedure TextColor(Color:byte);
Procedure TextBackGround(Color:byte);
Function  GetTextColor:byte;
Function  GetBackGroundColor:byte;
Procedure WriteStr(S:string);
Procedure WritePchar(P:Pchar);
Procedure VideoMode(Mode:byte);
Procedure WriteChar(CharCode:char);
Procedure Set_Attr(Attr:byte);
Procedure ReadLimStr(Size:byte;var S:string; Fill:char;LineF:boolean);
Procedure ReadChar(Var CharCode:char;var Attr:byte);
Procedure ClrScr;
Procedure Window(X1,Y1,X2,Y2:byte);
Procedure WindowScroll(LinesNum:byte; Where:UpDown);
Procedure InsLine;
Procedure InstallCrt;
Procedure DelLine;
Procedure GetVideoSeg;

Implementation

Procedure Pause(S:string);
 Begin
  WriteStr(S);
  Repeat Until WaitProc;
 end;

Function  GetTextColor:byte;assembler;
 asm
  mov  al,TextAttr
  and  al,0Fh
 end;

Function  GetBackGroundColor:byte;assembler;
 asm
  mov  al,TextAttr
  mov  cl,4
  shr  al,cl
  and  al,0Fh
 end;

Procedure MemWriteChar(X,Y:byte;CharCode:char);Near;
 Begin
  Mem[CurrVideoSeg:BiosArea.CurrentPage*(BiosArea.VideoBuffSize)+(X+BiosArea.MaxColumns*Y)*2]:=Byte(CharCode);
  Mem[CurrVideoSeg:BiosArea.CurrentPage*(BiosArea.VideoBuffSize)+(X+BiosArea.MaxColumns*Y)*2+1]:=TextAttr;
 end;

Procedure BiosWriteChar(X,Y:byte;CharCode:char);Near;
Var  X1,Y1:byte;
  Begin
   X1:=GetX;
   Y1:=GetY;
   CursorXY(X,Y);
           asm
            mov   ah,9h
            mov   bh,BiosArea.[CurrentPage]
            mov   al,CharCode
            mov   bl,TextAttr
            mov   cx,1
            int   10h
           end;
   CursorXY(X1,Y1);
   end;

Procedure WriteStrXY(X,Y:byte; S:string);
Var A,B:byte;
    LastHide:boolean;
 Begin
  LastHide:=Hide;
  Hide:=true;
  A:=GetX;
  B:=GetY;
  CursorXY(X,Y);
  WriteStr(S);
  CursorXY(A,B);
  Hide:=LastHide;
 end;

Procedure WritePcharXY(X,Y:byte; P:Pchar);
Var A,B:byte;
   LastHide:boolean;
 Begin
  LastHide:=Hide;
  Hide:=true;
  A:=GetX;
  B:=GetY;
  CursorXY(X,Y);
  WritePchar(P);
  CursorXY(A,B);
  Hide:=LastHide;
 end;

Procedure ReadCharXY(X,Y:byte; Var CharCode:char;var Attr:byte);
Var A,B:byte;
    LastHide:boolean;
 Begin
  LastHide:=Hide;
  Hide:=true;
  A:=GetX;
  B:=GetY;
  CursorXY(X,Y);
  ReadChar(CharCode,Attr);
  CursorXY(A,B);
  Hide:=LastHide;
 end;

Procedure FillAttrXY(X,Y:byte; Count:byte;Attr:byte);
Var A,B:byte;
    LastHide:boolean;
 Begin
  LastHide:=Hide;
  Hide:=true;
  A:=GetX;
  B:=GetY;
  CursorXY(X,Y);
  FillAttr(Count,Attr);
  CursorXY(A,B);
  Hide:=LastHide;
 end;

Procedure Set_AttrXY(X,Y:byte; Attr:byte);
Var A,B:byte;
    LastHide:boolean;
 Begin
  LastHide:=Hide;
  Hide:=true;
  A:=GetX;
  B:=GetY;
  CursorXY(X,Y);
  Set_Attr(Attr);
  CursorXY(A,B);
  Hide:=LastHide;
 end;

Procedure WriteCharXY(X,Y:byte;Ch:char);
Var A,B:byte;
   LastHide:boolean;
 Begin
  LastHide:=Hide;
  Hide:=true;
  A:=GetX;
  B:=GetY;
  If UseBios then BiosWriteChar(X,Y,Ch)
             else MemWriteChar(X,Y,Ch);
  CursorXY(A,B);
  Hide:=LastHide;
end;

Procedure WritePchar(P:Pchar);
Var C:word;
 Begin
  if PcharSize(P) >0 then
   Begin
    For C:=0 to PcharSize(P)-1 do
     WriteChar(P[C])
   end;
 end;

Procedure EndL;
 Procedure LineFeed;
  Begin
   if OutputHandle < $FFFF then
    Begin
     WriteStrInFile(OutputHandle,#13#10);
    end else
     if DosOutPut then DosWriteStr(#13#10+'$') else
    Begin
    if GetY >= WindMax.Y then
     Begin
      WindowScroll(1,Up);
      CursorXY(WindMin.X,WindMax.Y);
     end
      else CursorXY(WindMin.X,GetY+1);
    end;
  end;

 Begin
   LineFeed;
   if SetCounter then
    if (Counter >= (WindMax.Y-WindMin.Y)-2)  then
    Begin
     Pause('Press any key...');LineFeed;
     Counter:=0;
    end else Inc(Counter);
 end;

Procedure SetPage(C:byte);assembler;
  asm
   mov  ah,5
   mov  al,C
   int  10h
  end;

Procedure FillAttr(Count:byte;Attr:byte);
Var C:byte;
    X,Y:byte;
 Begin
 if Count > 0 then
  Begin
   X:=GetX;
   Y:=GetY;
   C:=0;
   Repeat
    Set_Attr(Attr);
    Inc(C);
    CursorXY(X+C-1,Y);
   Until (C = Count) or (X = WindMax.X);
  end;
 end;

Procedure Set_Attr(Attr:byte);
Var CharCode:char; Att:byte;
 Begin
   if UseBios then
          Begin
            ReadChar(CharCode,Att);
            Att:=TextAttr;
            TextAttr:=Attr;
            WriteChar(CharCode);
            TextAttr:=Att;
           end
              else
   Mem[CurrVideoSeg:BiosArea.CurrentPage*(BiosArea.VideoBuffSize+1)+(GetX+BiosArea.MaxColumns*GetY)*2+1]:=Attr;
end;


Procedure CursorOff;
Var X,Y:byte;
 Begin
  X:=GetX;
  Y:=GetY;
  CursorXY(25,25);
  Hide:=True;
  CursorXY(X,Y);
 end;

Procedure CursorOn;
 Begin
  Hide:=False;
  CursorXY(GetX,GetY);
 end;

Procedure ReadChar(Var CharCode:char;var Attr:byte);
Var Ch:char;
    Color:byte;
 Begin
 if UseBios then
  Begin
   asm
    mov  ah,8
    int  10h
    mov  Ch,al
    mov  Color,ah
   end;
   CharCode:=Ch;
   Attr:=Color;
   end
  else
   Begin
   Byte(CharCode) :=Mem[CurrVideoSeg:BiosArea.CurrentPage*(BiosArea.VideoBuffSize+1)+(GetX+BiosArea.MaxColumns*GetY)*2];
   Attr     :=Mem[CurrVideoSeg:BiosArea.CurrentPage*(BiosArea.VideoBuffSize+1)+(GetX+BiosArea.MaxColumns*GetY)*2+1];
   end;
 end;

Procedure CursorXY(X,Y:byte);
Var Page:byte;
 begin
  Page:=BiosArea.CurrentPage;
  if not Hide then
   Begin
    asm
     mov  ah,02h
     mov  bh,Page
     mov  dl,X
     mov  dh,Y
     int  10h
    end;
   end        else
   Begin
    BiosArea.CursorPos[BiosArea.CurrentPage].X:=X;
    BiosArea.CursorPos[BiosArea.CurrentPage].Y:=Y;
   end;
 end;

Function  GetX:byte;
 begin
  GetX:= BiosArea.CursorPos[BiosArea.CurrentPage].X;
 end;

Function  GetY:byte;
 begin
  GetY:= BiosArea.CursorPos[BiosArea.CurrentPage].Y;
 end;

Function  GetXY:word;
 Begin
  GetXY:= (BiosArea.CursorPos[BiosArea.CurrentPage].Y shl 4) + BiosArea.CursorPos[BiosArea.CurrentPage].X;
 end;

Procedure TextColor(Color:byte);
 begin
  asm
   mov   al,Color
   and   al,00001111b
   and   TextAttr,11110000b
   or    TextAttr,al
  end;
 end;

Procedure TextBackGround(Color:byte);
 Begin
  asm
   mov   al,Color
   and   al,00001111b
   mov   cl,4
   shl   al,cl
   and   TextAttr,00001111b
   or    TextAttr,al
  end;
 end;


Procedure WriteChar(CharCode:char);
Var Page:byte;
    X,Y:byte;
 Begin
 if OutputHandle < $FFFF then
  WriteStrInFile(OutPutHandle,CharCode) else
   Begin
  if DosOutPut then DosWriteStr(CharCode+'$') else
   Begin
 if UseBios then BiosWriteChar(GetX,GetY,CharCode)
            else MemWriteChar(GetX,GetY,CharCode);
  X:=GetX;
  Y:=GetY;
  if  X < WindMax.X then X:=X+1
                    else
      Begin
         X:=WindMin.X;
       if (Y < WindMax.Y)  then Y:=Y+1 else
         WindowScroll(1,Up);
       end;
     CursorXY(X,Y);
   end;
  end;
end;

Procedure WriteStr(S:string);
Var C:byte;
 begin
  if Byte(S[0]) > 0 then
  Begin;
  if OutputHandle < $FFFF then
   Begin
    WriteStrinFile(OutPutHandle,S)
   end else
   Begin
    if DosOutput then DosWriteStr(S+'$') else
    For C:=1 to Byte(S[0]) do
     WriteChar(S[C]);
   end;
   end;
 end;

Procedure InstallCrt;
 Begin
  WindMin.X:=00;
  WindMin.Y:=00;
  WindMax.X:=BiosArea.MaxColumns-1;
  WindMax.Y:=BiosArea.MaxStrings;
 end;

Procedure VideoMode(Mode:byte);
 Begin
  asm
   mov  ah,00h
   mov  al,Mode
   int  10h
  end;
  InstallCrt;
  GetVideoSeg;
 end;


Procedure ReadLimStr(Size:byte;var S:string; Fill:char;LineF:boolean);
 Const
   { ** ScanCodes ** }
  BS  = 8;
  CR  = 13;
  SP  = 32;

  LeftKey  = 75;  HomeKey = 71;
  RightKey = 77;  EndKey  = 79;
  InsKey   = 82;  DelKey  = 83;

 Var
  Slen:byte absolute S;
  X,Y,CurrPos:byte;
  Insert:boolean;
  I:byte;
  Key:CharScan;
  Ch:char;
 Begin
  Insert:=True;
  X:=GetX;
  Y:=GetY;
  Slen:=0;
  CurrPos:=0;
  Repeat
    CursorXY(X,Y);
    WriteStr(S);
    CursorOff;
    For I:=Slen+1 to Size do
     WriteChar(Fill);
    CursorOn;
   CursorXY(X+CurrPos,Y);
   Word(Key):=GetKey;
   if Key.CharCode = 0 then
    begin
     Case  Key.Scancode of
      LeftKey  : if CurrPos > 0 then Dec(CurrPos);
      RightKey : if (CurrPos < SLen) and (CurrPos < Size) then Inc(CurrPos);
      InsKey   : Insert:= NOT Insert;
      HomeKey  : CurrPos:=0;
      EndKey   : CurrPos:=Slen;
      DelKey   : if Slen > CurrPos then
                  Begin
                   For I:=CurrPos+1 To Slen-1 Do
                    S[I]:=S[I+1];
                  End
    End
   End
  Else
   Begin
    Case Key.CharCode of
     BS       :if CurrPos >0 then
                Begin
                 For I:=CurrPos To Slen Do
                  S[I]:=S[I+1];
                 Dec(CurrPos);
                 Dec(SLen);
                end;
     SP..Ord('~')  : if Slen < Size Then
                 Begin
                  Inc(CurrPos);
                  if Insert Then
                   Begin
                    For I:=Slen DownTo CurrPos Do
                     S[I+1]:=S[i];
                    Inc(Slen);
                   end;
                   S[CurrPos]:=Char(Key.CharCode);
                  end;
                 end;
                end;
     Until Key.CharCode = CR;
     if LineF then EndL;
 End;

Procedure ClrScr;
begin
 WindowScroll(WindMax.Y - WindMin.Y+1,Up);
 CursorXY(WindMin.X,WindMin.Y);
end;

Procedure Window(X1,Y1,X2,Y2:byte);
 Begin
  asm
   mov  dl,X1
   mov  dh,Y1
   mov  ch,Y2
   mov  cl,X2
   mov  WindMin,dx
   mov  WindMax,cx
  end;
  CursorXY(WindMin.X,WindMin.Y);
 End;

Procedure Scroll;near;assembler;
 asm
  Push bx
  Push dx
  Push cx
  Push ax
  mov  bh,TextAttr
  Call GetY
  mov  ch,al
  mov  dh,al
  mov  dl,WindMin.[X]
  mov  cl,WindMax.[X]
  pop  ax
  int  10h
  Pop  cx
  Pop  dx
  Pop  bx
 end;


Procedure InsLine;assembler;
 asm
  mov  ax,0701h;
  call Scroll
 end;

Procedure DelLine;assembler;
 asm
  mov  ax,0701h;
  call Scroll
 end;

Procedure WindowScroll(LinesNum:byte; Where:UpDown);
Var C:byte;
    AA:byte;
    D1,D2:byte;
 Begin

  if Where = Down then    AA:=7
                  else    AA:=6;
 For C:=1 to LinesNum do
 Begin
  asm
   mov  cx,WindMin
   mov  dx,WindMax
   mov  ah,AA
   mov  al,1
   mov  bh,TextAttr
   int  10h
  end;
 end;
 end;

Procedure GetVideoSeg;
 Begin
  CurrVideoSeg:=$B800;
  if BiosArea.CurrentMode = 7 then
     CurrVideoSeg:=$B000;
 end;

Begin
 DosOutPut:=false;
 OutputHandle:=$FFFF;
 WaitProc:=KeyPresent;
 GetVideoSeg;
 TextChar:=' ';
 TextAttr:=7;
 UseBios:=False;
 Hide:=False;
 Counter:=0;
 SetCounter:=false;
 InstallCrt;
end.
