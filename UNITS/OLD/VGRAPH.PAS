{$X+}
unit VGraph;

interface

uses Crt,Strings,Misc;
 type
     Str6 = String[240];
     Str8 = String[8];
const
 { Colors }
    BlackG     =  0;
    GreenG     =  2;
    RedG       =  4;
    BlueG      =  1;
    GreyG      =  7;
    DarkGreyG  =  8;
    GyanG      =  3;
    MagentaG   =  5;
    BrownG     =  6;
    YellowG    = 14;
    BrBlueG    =  9;
    BrGreenG   = 10;
    BrRedG     = 11;
    BrGyanG    = 12;
    BrWhiteG   = 15;
    BrMagentaG = 13;

 {** constants Using (ONLY!) With bSetMode **}
    Mode40x25x16  =  1;
    Mode40x25x8   =  0;
    Mode80x25x8   =  2;
    Mode80x25x16  =  3;
    Mode80x25x2   =  7;
    Mode80x43x16  =  81;
    Mode80x60x16  =  82;
    Mode100x25x16 =  84;
    Mode100x60x16 =  85;
    Mode132x60x16 = 86;
    Mode132x25x16 = 83;
    Mode132x43x16 = 87;
var
    Segment:word;
   CurrentPage:byte absolute $40:$62;
            {**  GRAPHIC PART  **}

Procedure bPutPoint(X,Y:integer; Color:byte; Page:word);
 { Put Point on Screen in Graphic MOde by Bios Interrupt }

Procedure mPutPoint(X,Y:word; Color:byte);
 { Put Point on Screen in Graphic MOde by Memory Adressing }

Procedure bLineY(X,Y1,Y2:integer;Color:byte;Delay:integer);
 { Make Vertical Line by bPutPoint }

Procedure bLineX(Y,X1,X2:integer;Color:byte;Delay:integer);
 { Make Horizontal Line by bPutPoint }

Procedure mLineY(X,Y1,Y2:integer;Color:byte;Delay:integer);
 { Make Vertical Line by mPutPoint }

Procedure mLineX(Y,X1,X2:integer;Color:byte;Delay:integer);
 { Make Horizontal Line by mPutPoint }

Procedure Line (X1,Y1,X2,Y2:integer;Col:byte);
 { Make Standart Line by mPutPoint }

Procedure bCircle (oX,oY,rad:integer;Col:Byte);
 { Make Circle by bPutPoint }

Procedure mCircle (oX,oY,rad:integer;Col:Byte);
 { Make Circle by mPutPoint }

Procedure bBox(X1,Y1,X2,Y2:integer;Color:Byte);
 { Make Box by bPutPoint }

Procedure bReadPoint(X,Y:integer;var Color:byte);
 { Read Point In the Position X,Y }

     { ** SETTING - GETTING MODE PART ** }

Procedure bGraphMode;
 { Set Graphics Mode Al=$13 }

Procedure bTextMode;
 { Set Text Mode Al=$3 }

Procedure bSetMode( Mode: Byte );
 { Set Mode  0 - 255 }

Procedure bReadMode(var Mode,Col,Page:word);
 { Reading Mode by Bios }

Procedure bSetVideoPage(Page:word);
Procedure pLetterHigh(High:byte);
Function  mGetStrings:byte;
 { Getting Max Strings on Screen from Memory }

Function  mGetColumns:byte;
 { Getting Max Columns on Screen from Memory }

Function  mGetVideoPage:byte;
 { Getting Current Video Page from Memory }

Function  mGetMode:byte;
 { Reading Mode from Memory }

Function  mGetAddress6845:word;
Function  mGetCTRMode:byte;
Function  mGetCTRPal:byte;
Function  mGetLettHigh:word;



      { ** CURSOR SET - GET PART ** }

Procedure bCursorForm(Str,Column: byte);
Procedure mCursorForm(Str,Column: byte);
Procedure bCursorPos(X,Y:byte;Page:word);
Procedure mCursorPos(X,Y:byte;Page:byte);
Procedure bHideCursor;
Procedure bReadCursor(Page:byte;var X,Y,Beg,Ends:byte);




Procedure bScrollUp(I:byte);
Procedure bScrollDown(I:byte);
Procedure mClrTxtScr;

           { ** OUTPUT IN TEXT MODE ** }
Procedure mDispChar(X,Y:integer;Chrac:Char;Attr:byte);
Procedure mDispCharT(Chrac:Char);
Procedure bTextWindow(X1,Y1,X2,Y2:integer;Color:byte;Typ:byte;Stri:String;Attr:Byte);
Procedure bReadChar(var Chrac:char;var Attr:byte);
Procedure bDispChar(Chrac:Char;Attr:byte;Num:integer;Page:byte);
Procedure bDispCharT(Chrac:Char);
Procedure bDispString(Str1:string;Attr:byte);
Procedure bExDispString(Str1:string;Attr:byte;Snd:integer;Dela:integer);
Procedure mDispString(X,Y:Integer;Str1:string;Attr:byte);
      { ** COLORS PART ** }

Procedure pSetRGBColors(Color,R,G,B:byte);
Procedure bSetColor(Reg,Color:byte);
Procedure pGetRGBColors( Color:BYTE;VAR R,G,B:byte);
Procedure ReadColor(Reg:byte; var Color:byte);
Procedure bSetFone(Color:byte);
Procedure bSetText(Color:byte);
Procedure bReadOverscan(var Color:byte);
Procedure bBorderTxt(Color:byte);
Procedure bBorderGrph(Palette:byte);
Procedure bOverScan(Color:byte);
Procedure SetBlink(Bool:Boolean);

      { ** VIDEO SYSTEM INFO ** }

Function VidSegment:word;
Function VidBufSize:WORD;
Function VideoStart:word;





implementation

procedure bPutPoint(X,Y:integer; Color:byte;Page:word);
var Pag:byte;
 begin
  asm
   mov    bh,Pag
   mov    dx,Y
   mov    cx,X
   mov    al,Color
   mov    ah,0Ch;
   int    10h
  end;
  Page:=Pag;
 end;

Procedure mPutPoint(X,Y:word; Color:byte);
 begin
  Mem[$A000:Y*320+X]:=Color;
  end;

procedure bLineY(X,Y1,Y2:integer;Color:byte;Delay:integer);
begin
if Y1 > Y2 then
 begin
  repeat
    bPutPoint(X,Y2,Color,0);
    Crt.Delay(Delay);
    Y2 := Y2 + 1;
  until (Y2 = Y1);
 end;

if Y1 <= Y2 then
 begin
  repeat
    bPutPoint(X,Y1,Color,0);
    Crt.Delay(Delay);
    Y1:=Y1+1;
  until (Y1 = Y2);
 end;
end;

procedure bLineX(Y,X1,X2:integer;Color:byte;Delay:integer);

begin
 if X1 > X2  then
   begin
    repeat
     bPutPoint(X2,Y,Color,0);
      Crt.Delay(Delay);
      X2 := X2 +1 ;
    until (X2 = X1);
   end;
 if X1 <= X2  then
   begin
    repeat
      bPutPoint(X1,Y,Color,0);
      Crt.Delay(Delay);
      X1 := X1 + 1;
    until ( X1 = X2 );
   end;
end;

Procedure Line (X1,Y1,X2,Y2:integer;Col:byte);
VAR x,y,xlength,ylength,dx,dy:integer;
    xslope,yslope:real;
BEGIN
  xlength:=Abs (x1-x2);
  if (x1-x2)<0 then dx:=-1;
  if (x1-x2)=0 then dx:=0;
  if (x1-x2)>0 then dx:=+1;
  ylength:=Abs (y1-y2);
  if (y1-y2)<0 then dy:=-1;
  if (y1-y2)=0 then dy:=0;
  if (y1-y2)>0 then dy:=+1;
  if (dy=0) then BEGIN
    if dx<0 then
      mLineX(Y1,X1,X2,Col,0);
    {for x:=x1 to x2 do
      mPutPoint (x,y1,col);}
    if dx>0 then
     mLineX(Y1,X2,X1,Col,0);
    {for x:=x2 to x1 do
      mPutPoint (x,y1,col);}
    exit;
  END;
  if (dx=0) then BEGIN
    if dy<0 then mLineY(X1,Y1,Y2,Col,0);
    {for y:=y1 to y2 do}
      {mPutPoint (x1,y,col);}
    if dy>0 then
     mLineY(X1,Y2,Y1,Col,0);
    {for y:=y2 to y1 do}
      {mPutPoint (x1,y,col);}
    exit;
  END;
  xslope:=xlength/ylength;
  yslope:=ylength/xlength;
  if (yslope/xslope<1) and (yslope/xslope>-1) then BEGIN
    if dx<0 then for x:=x1 to x2 do BEGIN
                   y:= round (yslope*x);
                   mPutPoint (x,y,col);
                 END;
    if dx>0 then for x:=x2 to x1 do BEGIN
                   y:= Round (yslope*x);
                   mPutPoint (x,y,col);
                 END;
  END
  ELSE
  BEGIN
    if dy<0 then for y:=y1 to y2 do BEGIN
                   x:= Round (xslope*y);
                   mPutPoint (x,y,col);
                 END;
    if dy>0 then for y:=y2 to y1 do BEGIN
                   x:= Round (xslope*y);
                   mPutPoint (x,y,col);
                 END;
  END;
END;


procedure mLineY(X,Y1,Y2:integer;Color:byte;Delay:integer);
begin
if Y1 > Y2 then
 begin
  repeat
    mPutPoint(X,Y2,Color);
    Crt.Delay(Delay);
    Y2 := Y2 + 1;
  until (Y2 = Y1);
 end;

if Y1 <= Y2 then
 begin
  repeat
    mPutPoint(X,Y1,Color);
    Crt.Delay(Delay);
    Y1:=Y1+1;
  until (Y1 = Y2);
 end;
end;

procedure mLineX(Y,X1,X2:integer;Color:byte;Delay:integer);

begin
 if X1 > X2  then
   begin
    repeat
     mPutPoint(X2,Y,Color);
      Crt.Delay(Delay);
      X2 := X2 +1 ;
    until (X2 = X1);
   end;
 if X1 <= X2  then
   begin
    repeat
      mPutPoint(X1,Y,Color);
      Crt.Delay(Delay);
      X1 := X1 + 1;
    until ( X1 = X2 );
   end;
end;

Procedure mCircle (oX,oY,rad:integer;Col:Byte);
     VAR deg:real;
         X,Y:integer;
     BEGIN
       deg:=0;
       repeat
         X:=Round(rad*COS (deg));
         Y:=Round(rad*sin (deg));
         mPutPoint(x+ox,y+oy,Col);
         deg:=deg+0.005;
        until (deg>6.4);
     END;

Procedure bCircle (oX,oY,rad:integer;Col:Byte);
     VAR deg:real;
         X,Y:integer;
     BEGIN
       deg:=0;
       repeat
         X:=Round(rad*COS (deg));
         Y:=Round(rad*sin (deg));
         mPutPoint(x+ox,y+oy,Col);
         deg:=deg+0.005;
       until (deg>6.4);
     END;

Procedure bBox(X1,Y1,X2,Y2:integer;Color:Byte);
 var X3,Y3,X4,Y4:integer;
begin
 if X1 > X2 then  begin
   X2:=X3;
   X1:=X4;
   end
   else  begin
   X1:=X3;
   X2:=X4;
   end;
 if Y1 > Y2 then Begin
    Y2:=Y3;
    Y1:=Y4;
    end
    else begin
    Y1:=Y3;
    Y2:=Y4;
    end;
  bLineX(Y4,X3,X4,Color,0);
  bLineX(Y3,X3,X4,Color,0);
  bLineY(X3,Y3,Y4,Color,0);
  bLineY(X4,Y3,Y4,Color,0);
 end;
{Procedure mBox(X1,Y1,X1,Y2:integer;Color:Byte);}

procedure bGraphMode;
begin
 asm
   mov    ax,0013h
   int    10h
 end;
end;

procedure bTextMode;
 begin
  asm
   mov    ax,0003h
   int    10h
 end;
end;

Procedure bSetMode ( Mode: Byte );
begin
  asm
    mov    al,Mode
    mov    ah,00
    int    10h
  end;
end;

Function  mGetMode:byte;
var Memo:byte Absolute $40:$49;
 begin
 mGetMode:=Memo;
 end;


Procedure bCursorForm(Str,Column:byte);
 begin
  asm
   mov    ch,Str
   mov    cl,Column
   mov    ah,01h
   int    10h
  end;
 end;

Procedure mCursorForm(Str,Column:byte);
begin
 Mem[$40:$60]:=Str;
 Mem[$40:$61]:=Column;
 end;

Procedure bCursorPos(X,Y:byte;Page:word);
var Pag:byte;
 begin
  Pag:=Page;
  asm
    mov   ah,2
    mov   bh,Pag
    mov   dh,Y
    mov   dl,X
    int   10h
  end;
 end;

Procedure mCursorPos(X,Y:byte;Page:byte);
 begin
  Mem[$40:$50+mGetVideoPage*2]:=X;
  Mem[$40:$50+mGetVideoPage*2+1]:=Y;
  end;



Procedure bBorderTxt(Color:byte);
 begin
  asm
   mov   bh,0
   mov   bl,Color
   mov   ah,0Bh
   int   10h
  end;
 end;

Procedure bBorderGrph(Palette:byte);
 begin
  asm
   mov   bh,0
   mov   bl,Palette
   mov   ah,0Bh
   int   10h
  end;
 end;

Procedure mClrTxtScr;
 begin
  asm

                mov     ax,0B800h
                mov     es,ax
                mov     di,0
                mov     ax,720h
                mov     cx,7D0h
                rep     stosw
end;
end;

Procedure bScrollUp(I:byte);
 begin
  asm
   mov  ah,06h
   mov  bh,Black
   mov  al,I
   mov  cx,0
   mov  dh,25
   mov  dl,80
   int  10h
  end;
 end;
Procedure bScrollDown(I:byte);
 begin
  asm
   mov  ah,07h
   mov  bh,Black
   mov  al,I
   mov  cx,0
   mov  dh,25
   mov  dl,80
   int  10h
  end;
 end;




Procedure bReadPoint(X,Y:integer;var COlor:byte);

var Col:byte;

 begin
  asm
    mov   dx,Y
    mov   cx,X
    mov   ah,0Dh
    int   10h
    mov   Col,al
  end;
   Color:=cOl;
 end;


Procedure bReadMode(var Mode,Col,Page:word);
var Mo,Co,pag:byte;
 begin
  asm
   mov    ah,0Fh
   int    10h
   mov    Co,ah
   mov    Mo,al
   mov    Pag,bh
  end;

Col:= Co;
Page:= Pag;
Mode:= Mo;
end;

Procedure bHideCursor;
 begin
  asm
   mov  ah,2
   mov  bh,0
   mov  dh,25
   mov  dl,25
   int  10h
  end;
 end;

Procedure bSetVideoPage(Page:word);
var Pag:byte;
 begin
 Pag:=Page;
  asm
   mov   ah,5
   mov   al,Pag
   int   10h
  end;
 end;

Function mGetVideoPage:byte;
var Pag:byte absolute $40:$62;
  begin
   mGetVideoPage:=Pag;
  end;


Function mGetStrings:byte;      { return Number of Strings at display }
var  Srr:byte absolute $40:$84;
 begin
 mGetStrings:=Srr+1;
  end;

Function mGetColumns:byte;
var Srr:byte absolute $40:$4A;
 begin
 mGetColumns:=Srr;
  end;

Procedure bDispChar(Chrac:Char;Attr:byte;Num:integer;Page:byte);
 begin
  asm
   mov    ah,9
   mov    al,Chrac
   mov    cx,Num
   mov    bh,Page
   mov    bl,Attr
   int    10h

  end;
 end;

Procedure bReadChar(var Chrac:char;var Attr:byte);
var  xxx:char;
     arr:byte;
 begin
  asm
   mov   ah,8
   int   10h
   mov   xxx,al
   mov   arr,ah
   end;
 Chrac:=XXX;
 Attr:=arr;
 end;


Procedure bDispCharT(Chrac:Char);
 begin
  asm
    mov    ah,0Eh
    mov    al,Chrac
    int    10h
  end;
 end;

Procedure bDispString(Str1:string;Attr:byte);
var C:integer;
 begin
  for C:=1 to Length(Str1) do
   begin
    bDispChar(Str1[C],Attr,1,0);
    GotoXY(WhereX+1,WhereY);
   end;
 end;

Procedure bExDispString(Str1:string;Attr:byte;Snd:integer;Dela:integer);
var C:integer;
    X:integer;
 begin
  X:=(Snd div 10) + 5;
  for C:=1 to Length(Str1) do
   begin
    bDispChar(Str1[C],Attr,1,0);
    GotoXY(WhereX+1,WhereY);
    Sound(Snd);
    Delay(Dela);
    NoSound;
    Snd:=Snd+X;
   end;
 end;

Procedure mDispChar(X,Y:integer;Chrac:Char;Attr:byte);
 begin
  Mem[$B800:(Y*80+X)*2]:=Ord(Chrac);
  Mem[$B800:(Y*80+X)*2+1]:=Attr;
 end;

Procedure mDispCharT(Chrac:Char);
 begin
  mDispChar(WhereX-1,WhereY-1,Chrac,7);
  if WhereX = 80 then
   begin
    GotoXY(0,WhereY+1);
   end
   else
    begin
     GotoXY(WhereX+1,WhereY);
    end;
 end;


Procedure mDispString(X,Y:Integer;Str1:string;Attr:byte);
var Offs:WORD;
    x1,x2:word;
    Arra:array[0..509] of Byte;
    Point:Pointer;
 begin
  if Length(Str1) > 0 then
   begin
    Offs:=VideoStart+((Y-1)*mGetColumns+X-1)*2;
    Point:=Ptr($B800,Offs);
    X1:=0;
    for X2:=1 to Length(Str1) do
     begin
      Arra[X1]:=Ord(Str1[X2]); Inc(X1);
      Arra[X1]:=Attr;          Inc(X1);
     end;
      Move(Arra,Point^,Length(Str1)*2);
     end;
  end;

Procedure bTextWindow(X1,Y1,X2,Y2:integer;Color:byte;Typ:byte;Stri:String;Attr:Byte);
const
    { *** Constants of Frames For bTextWindow and mTextWindow *** }
      Double1:Char = 'Í'; Single1:Char = 'Ä'; Block1:Char = 'Ü';
      Double2:Char = '¼'; Single2:Char = '¿'; Block2:Char = 'Ý';
      Double3:Char = 'È'; Single3:Char = '³'; Block3:Char = 'ß';
      Double4:Char = 'º'; Single4:Char = 'Ú'; Block4:Char = 'Þ';
      Double5:Char = 'É'; Single5:Char = 'Ù'; Block5:Char = 'Û';
      Double6:Char = '»'; Single6:Char = 'À';



var      X:byte;
  Y3:integer;
 begin
 X:=mGetVideoPage;
  if Typ = 2 then begin
  GotoXY(X1,Y1);
  bDispChar(Double5,Color,1,X);
  GotoXY(X1+1,Y1);
  bDispChar(Double1,Color,X2-X1-1,X);
  GotoXY(X2,Y1);
  bDispChar(Double6,Color,1,X);
  for Y3:=Y1+1 to Y2-1 do
   begin
    GotoXY(X2,Y3);
    bDispChar(Double4,Color,1,X);
   end;
 GotoXY(X2,Y2);
 bDispChar(Double2,Color,1,X);
 GotoXY(X1+1,Y2);
 bDispChar(Double1,Color,X2-X1-1,X);
 GotoXY(X1,Y2);
 bDispChar(Double3,Color,1,X);
  for Y3:=Y1+1 to Y2-1 do
   begin
    GotoXY(X1,Y3);
    bDispChar(Double4,Color,1,X);
   end;
  GotoXY(((X2 - X1) div 2)-(Length(Stri) div 2),Y1);
  bDispString(Stri,Attr);
end;

 if Typ = 1 then begin
  GotoXY(X1,Y1);
  bDispChar(Single4,Color,1,X);
  GotoXY(X1+1,Y1);
  bDispChar(Single1,Color,X2-X1-1,X);
  GotoXY(X2,Y1);
  bDispChar(Single2,Color,1,X);
  for Y3:=Y1+1 to Y2-1 do
   begin
    GotoXY(X2,Y3);
    bDispChar(Single3,Color,1,X);
   end;
 GotoXY(X2,Y2);
 bDispChar(Single5,Color,1,X);
 GotoXY(X1+1,Y2);
 bDispChar(Single1,Color,X2-X1-1,X);
 GotoXY(X1,Y2);
 bDispChar(Single6,Color,1,X);
  for Y3:=Y1+1 to Y2-1 do
   begin
    GotoXY(X1,Y3);
    bDispChar(Single3,Color,1,X);

  GotoXY(((X2 - X1) div 2)-(Length(Stri) div 2),Y1);
  bDispString(Stri,Attr);
end;
end;
 if Typ = 3 then begin
  GotoXY(X1,Y1);
  bDispChar(Block5,Color,1,X);
  GotoXY(X1+1,Y1);
  bDispChar(Block3,Color,X2-X1-1,X);
  GotoXY(X2,Y1);
  bDispChar(Block5,Color,1,X);
  for Y3:=Y1+1 to Y2-1 do
   begin
    GotoXY(X2,Y3);
    bDispChar(Block4,Color,1,X);
   end;
 GotoXY(X2,Y2);
 bDispChar(Block5,Color,1,X);
 GotoXY(X1+1,Y2);
 bDispChar(Block1,Color,X2-X1-1,X);
 GotoXY(X1,Y2);
 bDispChar(Block5,Color,1,X);
  for Y3:=Y1+1 to Y2-1 do
   begin
    GotoXY(X1,Y3);
    bDispChar(Block2,Color,1,X);

  GotoXY(((X2 - X1) div 2)-(Length(Stri) div 2),Y1);
  bDispString(Stri,Attr);
end;
end;
end;

Procedure pLetterHigh(High:byte);
var S:byte;
begin
 Port[$3D4]:=9;
 S:=Port[$3D5];
 Port[$3D5]:=(S div 64) * 64+High;
 end;

Procedure bReadCursor(Page:byte;var X,Y,Beg,Ends:byte);
var Stri,Cols,Begi,Ende:byte;
begin
  asm
     mov  ah,3
     mov  bh,Page
     int  10h
     mov  Stri,dh
     mov  Cols,dl
     mov  Begi,ch
     mov  Ende,cl
  end;
  Y:=Stri;
  X:=Cols;
   Beg:=Begi;
  Ends:=Ende;
  end;

Procedure bSetColor(Reg,Color:byte);
Var C : byte;
 begin
  asm
   mov ah,10h
   mov al,0
   mov bl,Reg
   mov bh,Color
   int 10h
  end;
 end;

Procedure pSetRGBColors(Color,R,G,B:byte);

BEGIN
 asm
  cli
  end;
  Port[$3C8]:=Color;
  Port[$3C9]:=R;
  Port[$3C9]:=G;
  Port[$3C9]:=B;
   asm
    Sti
   end;

END;
Procedure pGetRGBColors(Color:BYTE; var R,G,B:byte);
 begin
 asm
  Cli
  end;
  Port[$3C7]:=Color;
  R:=Port[$3C9];
  G:=Port[$3C9];
  B:=Port[$3C9];
  asm
   Sti
   end;
   end;

Procedure bOverScan(Color:byte);
 begin
  asm
   mov   ah,10h
   mov   al,1
   mov   bh,COlor
   int   10h
  end;
end;

Procedure bReadOverScan(var Color:byte);
var Col:byte;
 begin
  asm
   mov   ah,10h
   mov   al,8
   int   10h
   mov   Col,bh
  end;
 Color:=Col;
end;

Procedure ReadColor(Reg:byte; var Color:byte);
var Col:byte;
 begin
  asm
   mov   ah,10h
   mov   al,7
   mov   bl,Reg
   int   10h
   mov   Col,bh
   end;
  Color:=Col;
 end;

Procedure SetBlink(Bool:Boolean);
 Begin
  asm
   mov ax,1003h
   mov bl,Bool
   int 10h
  end;
 end;



Procedure bSetFone(Color:byte);
 begin
  bSetColor(0,Color);
 end;

Procedure bSetText(Color:byte);
 begin
  bSetColor(7,Color);
 end;

Function  mGetAddress6845:word;
 var Memo:word absolute $40:$63;
  begin
   mGetAddress6845:=Memo;
  end;

Function  mGetCTRMode:byte;
 var Memo:byte absolute $40:$65;
  begin
   mGetCTRMode:=Memo;
  end;

Function  mGetCTRPal:byte;
 var Memo:byte absolute $40:$66;
  begin
   mGetCTRPal:=Memo;
  end;

Function  mGetLettHigh:word;
 var Memo:byte absolute $40:$85;
  begin
   mGetLettHigh:=Memo;
  end;


Function VidSegment:word;
var Mode:byte absolute $40:$49;
 begin
  case Mode of
 1..6:  VidSegment := SegB800;
    7:  VidSegment := SegB000;
 8..13: VidSegment := SegA000;
end;
end;

Function VidBufSize:WORD;
var Size:word absolute $40:$4C;
 begin
  VidBufSize:=Size;
 end;



Function VideoStart:word;
 var Start:word absolute $40:$4E;
 begin
   VideoStart := Start;
 end;

end.
