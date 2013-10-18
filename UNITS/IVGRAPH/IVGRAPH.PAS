{$X+}
Unit IvGraph;

InterFace
Uses IvSystem;

Const
 Black        =  0;
 Blue         =  1;
 Green        =  2;
 Cyan         =  3;
 Red          =  4;
 Magenta      =  5;
 Brown        =  6;
 LightGrey    =  7;
 DarkGrey     =  8;
 LightBlue    =  9;
 LightGreen   = 10;
 LightCyan    = 11;
 LightRed     = 12;
 LightMagenta = 13;
 Yellow       = 14;
 White        = 15;

Var
          UsePorts        : Boolean;
          UseBios         : Boolean;
          Hide            : Boolean;
          SetCounter      : Boolean;
          Counter         : Byte;
          TextChar        : Byte;
          TextAttr        : Byte;
          CurrentVideoSeg : Word;
          PageOffset      : Word;
          WindMin,WindMax : TWinPos;
          WaitProc        : RepeatFunction;
          PauseProc       : Procedure;
          ActiveScreenPtr : Pointer;
          VirtualScreenActive: Boolean;


Procedure TextColor(Color:byte);
procedure Window(X1,Y1,X2,Y2: byte);
Procedure TextBackGround(Color:byte);
Procedure WriteChar(CharCode:char;Attr:byte);
Procedure WriteStr(St:Pstring;Attr:byte);
Procedure WriteStrXY(X,Y,Attr:byte;St:Pstring);
Procedure WriteCenter(Y:byte;Attr:byte;St:string);
Procedure WriteBetween(X1,X2,Y,Attr:byte;St:string);
Procedure WriteAttr(Attr:byte);
Procedure FillAttr(Attr,Count:byte);
Procedure FillAttrXY(X,Y,Attr,Count:byte);
Procedure FillBox(X1,Y1,X2,Y2,Attr:byte);
Procedure PlaneWrite(St:PString);
Procedure PlaneWriteXY(X,Y:byte;St:PString);
Procedure CenterPlainWrite(Y:byte;St:string);
Function  Attrib(F,B:byte):byte;
Procedure FastWrite(S:string);
Procedure FastWriteLn(S:string);


Procedure SetPauseStr(S:string);
Procedure Pause;

Function  NoneDo:Boolean;

Procedure EndL;
Procedure SetRealPage;
Procedure SetLogicPage(Page:byte);
Procedure InitIvGraph;
 {Reinstall All Parameters}

Procedure  ClrScr;
 { Clear Logical Screen }

Procedure ClearWindow;


Procedure CursorOff;
Procedure CursorOn;
Function  GetX:byte;
Function  GetY:byte;
Function  GetCurrentPage:byte;
Function  GetPageOffset:Word;
Procedure SetVideoPage(Page:byte);
Procedure SaveVideoState(StateType:Word;Var Buffer);
Procedure RestoreVideoState(StateType:Word;Var Buffer);
Function  GetStateBufferSize(StateType:Word):Word;
Procedure CursorXY(X,Y:byte);
Procedure SetCgaPalette(PalID:byte);
Procedure SetCgaBorder(Color:byte);
Procedure SetDCC(Main,Second:byte);
Function  GetDCC:word;

Procedure GreySummDAC(StartReg,Count:Word);
Procedure GetDACPalette(Var Palette:VGAPalette);
Procedure SetDACPalette(Var Palette:VGAPalette);

Procedure Scroll(X1,Y1,X2,Y2,Num,Attr:byte;Stype:TScroll);
Procedure SetVideoMode(Mode:byte);
Function  GetVideoMode:byte;

Procedure WriteCharTTY(Ch:char;Attr,Page:byte);
Function  ReadChar(X,Y:byte):char;
Function  ReadAttr(X,Y:byte):byte;
Procedure bWriteString(S:Pstring;X,Y,Attr,Page:byte);

Procedure WaitRetrace;
Function  GetEgaReg(Reg:byte):byte;
Procedure SetEgaReg(Reg,Color:byte);
Procedure SetOverScanColor(Color:byte);
Function  GetOverScanColor:byte;
Procedure SetRGB(Reg:byte; R,G,B:byte);
Procedure GetRGB(Reg:byte;Var RGB:TRgb);
Procedure SetBlink(B:boolean);

Procedure SetScanLines(Scan:byte);
Procedure DisableVideoAddr(B:boolean);
Procedure DisableGreySumm(B:boolean);
Procedure DisableCursorEm(B:boolean);
Procedure DisableVideoRefr(B:boolean);
Procedure DisableDefPalLoad(B:boolean);
Procedure CursorForm(Start,Stop:byte);
Procedure SetStartAddress(Adr:word);
Procedure GetVideoInfo(Var TabLe:VideoInfoTab);
Procedure SetDoubleScan(Scan:boolean);

Function  TotalScanLines:word;
Function  IsCursorEm:boolean;
Function  IsWaitDisplay:boolean;
Function  IsVideoSysActive:boolean;
Function  VideoMemSize:word;
Function  IsSaveBuffer:boolean;
Function  IsVGABoardActive:boolean;
Function  IsGreySumm:boolean;
Function  IsDefPalLoad:boolean;
Function  GetScanLines:byte;
Function  IsGraphMode:boolean;
Function  IsBlink:boolean;
Function  IsDoubleScan:boolean;


procedure FillGraphBox(X1,Y1,X2,Y2: Word; Color: Byte);
Procedure FillEllipse(X,Y,Xrad,Yrad:word;Col:byte);
Procedure Circle(X,Y,R:word;Col:Byte);
Procedure Ellipse(X,Y,Xrad,Yrad:word;Col:byte);
Procedure Line(X1,Y1,X2,Y2:word;Color:byte);
Procedure LineX(X1,X2,Y:word;Color:byte);
Procedure LineY(X,Y1,Y2:word;Color:byte);
Function  ReadPoint(X,Y:word):byte;
Procedure PutPoint(X,Y:word;Color:byte);

Implementation

Var PauseStr : String;

{$L IVGRAPH.OBJ}
Function  NoneDo:Boolean;External;
{Procedure ClearText;External;}
Procedure LineFeed;Near;External;
Procedure SetRealPage;External;
Procedure SetLogicPage(Page:byte);External;
Procedure PlaneWriteXY(X,Y:byte;St:PString);External;
Procedure PlaneWrite(St:PString);External;
Procedure FillAttrXY(X,Y,Attr,Count:byte);External;
Procedure FillAttr(Attr,Count:byte);External;
Procedure WriteAttr(Attr:byte);External;
Procedure WriteChar(CharCode:char;Attr:byte);External;
Procedure WriteStr(St:Pstring;Attr:byte);External;
Procedure WriteStrXY(X,Y,Attr:byte;St:Pstring);External;
Procedure ClrScr;External;
Procedure InitIvGraph;External;
Procedure CursorOff;External;
Procedure CursorOn;External;
Function  GetCurrentPage:byte;External;
Function  GetPageOffset:Word;External;
Procedure SetVideoPage(Page:byte);External;
Procedure SaveVideoState(StateType:Word;Var Buffer);External;
Procedure RestoreVideoState(StateType:Word;Var Buffer);External;
Function  GetStateBufferSize(StateType:Word):Word;External;
Procedure CursorXY(X,Y:byte);External;
Procedure SetCgaPalette(PalID:byte);External;
Procedure SetCgaBorder(Color:byte);External;
Procedure SetDCC(Main,Second:byte);External;
Function  GetDCC:word;External;

Procedure GreySummDAC(StartReg,Count:Word);External;
Procedure GetDACPalette(Var Palette:VGAPalette);External;
Procedure SetDACPalette(Var Palette:VGAPalette);External;

Procedure Scroll(X1,Y1,X2,Y2,Num,Attr:byte;Stype:TScroll);External;
Procedure SetVideoMode(Mode:byte);External;
Function  GetVideoMode:byte;External;

Procedure WriteCharTTY(Ch:char;Attr,Page:byte);External;
Procedure bWriteString(S:Pstring;X,Y,Attr,Page:byte);External;


Procedure WaitRetrace;External;
Function  GetEgaReg(Reg:byte):byte;External;
Procedure SetEgaReg(Reg,Color:byte);External;
Procedure SetOverScanColor(Color:byte);External;
Function  GetOverScanColor:byte;External;
Procedure bSetRGB(Reg:byte; R,G,B:byte);External;
Procedure bGetRGB(Reg:byte;Var RGB:TRGB);External;
Procedure pSetRGB(Reg:byte; R,G,B:byte);External;
Procedure pGetRGB(Reg:byte;Var RGB:TRGB);External;
Procedure SetBlink(B:boolean);External;

Procedure SetScanLines(Scan:byte);External;
Procedure DisableVideoAddr(B:boolean);External;
Procedure DisableGreySumm(B:boolean);External;
Procedure DisableCursorEm(B:boolean);External;
Procedure DisableVideoRefr(B:boolean);External;
Procedure DisableDefPalLoad(B:boolean);External;
Procedure CursorForm(Start,Stop:byte);External;
Procedure SetStartAddress(Adr:word);External;
Procedure GetVideoInfo(Var TabLe:VideoInfoTab);External;
Procedure SetDoubleScan(Scan:boolean);External;

Function  TotalScanLines:word;External;
Function  IsCursorEm:boolean;External;
Function  IsWaitDisplay:boolean;External;
Function  IsVideoSysActive:boolean;External;
Function  VideoMemSize:word;External;
Function  IsSaveBuffer:boolean;External;
Function  IsVGABoardActive:boolean;External;
Function  IsGreySumm:boolean;External;
Function  IsDefPalLoad:boolean;External;
Function  GetScanLines:byte;External;
Function  IsGraphMode:boolean;External;
Function  IsBlink:boolean;External;
Function  IsDoubleScan:boolean;External;

Function  bReadPoint(X,Y:word):byte;Far;External;
Procedure bPutPoint(X,Y:word;Color:byte);Far;External;
Function  mReadPoint(X,Y:word):byte;Far;External;
Procedure mPutPoint(X,Y:word;Color:byte);Far;External;
Function  ReadChar(X,Y:byte):Char;External;
Function  ReadAttr(X,Y:byte):Byte;External;

Function GetX:byte;External;
Function GetY:byte;External;

Procedure Pause;
 Begin
  PauseProc;
  FastWrite(PauseStr);
  Repeat Until WaitProc;
  LineFeed;
 end;

Procedure SetPauseStr(S:string);
 Begin
  PauseStr:=S;
 end;

Procedure EndL;
 Begin
  LineFeed;
  if SetCounter then
   if (Counter >= (WindMax.Y-WindMin.Y)-3)  then
    Begin
     Pause;
     Counter:=0;
    end
    else
     Inc(Counter);
 end;

Procedure CenterPlainWrite(Y:byte;St:string);
 Begin
  With BiosArea DO
  PlaneWriteXY((MaxColumns - Byte(St[0])) div 2,Y,Addr(St));
 end;

Procedure WriteBetween(X1,X2,Y,Attr:byte;St:string);
 Begin
  WriteStrXY((X2 - X1 - Byte(St[0])) div 2,Y,Attr,Addr(St));
 end;


Procedure FastWrite(S:string);
 Begin
  WriteStr(Addr(S),TextAttr);
 end;

Procedure FastWriteLn(S:string);
 Begin
  FastWrite(S);
  ENDL;
 end;

Procedure TextColor(Color:byte);assembler;
 asm
  MOV  AL,Color
  AND  AL,00001111b
  AND  TextAttr,11110000b
  OR   TextAttr,AL
 end;

Procedure TextBackGround(Color:byte);assembler;
 asm
  MOV  AL,Color
  AND  AL,00001111b
  MOV  CL,4
  SHL  AL,CL
  AND  TextAttr,00001111b
  OR   TextAttr,AL
 end;


Function Attrib(F,B:byte):byte;
 Begin
  Attrib:=(B Shl 4) or F;
 end;

Procedure WriteCenter(Y:byte;Attr:byte;St:string);
 Begin
  With BiosArea DO
  WriteStrXY((MaxColumns - Byte(St[0])) div 2,Y,Attr,Addr(St));
 end;

Procedure FillBox(X1,Y1,X2,Y2,Attr:byte);
Var C:byte;
 Begin
  FOR C:=Y1 TO Y2 DO
   FIllAttrXY(X1,C,Attr,X2-X1);
 end;



Procedure SetRGB(Reg:byte; R,G,B:byte);
 Begin
  if UsePorts Then bSetRgb(Reg,R,G,B) else pSetRgb(Reg,R,G,B);
 end;

Procedure GetRGB(Reg:byte;Var RGB:TRgb);
 Begin
  if UsePorts Then bGetRgb(Reg,RGB) else pGetRgb(Reg,RGB);
 end;


Function  ReadPoint(X,Y:word):byte;
 Begin
  if UseBios Then bReadPoint(X,Y) else mReadPoint(X,Y);
 end;


Procedure PutPoint(X,Y:word;Color:byte);
 Begin
  if UseBios Then bPutPoint(X,Y,Color) else mPutPoint(X,Y,Color);
 end;


Procedure Circle(X,Y,R:word;Col:Byte);
     Begin
      Ellipse(X,Y,R,R,Col);
     End;

Procedure Ellipse(X,Y,Xrad,Yrad:word;Col:byte);
     Var deg:real;
         oX1,oY1:word;
         oX2,oY2:word;
     Begin
       deg:=0;
       repeat
         oX1:=Round(XRad*COS (deg));
         oY1:=Round(YRad*sin (deg));
         oX2:=Round(XRad*sin (deg));
         oY2:=Round(YRad*cos (deg));
         PutPoint(x+oX1,y+oY1,Col);
         PutPoint(x-oX1,y+oY1,Col);
         PutPoint(x+oX1,y-oY1,Col);
         PutPoint(x-oX1,y-oY1,Col);
         PutPoint(x+oX2,y+oY2,Col);
         PutPoint(x-oX2,y+oY2,Col);
         PutPoint(x+oX2,y-oY2,Col);
         PutPoint(x-oX2,y-oY2,Col);
         deg:=deg+0.005;
        Until (deg>0.8);
     End;

procedure FillGraphBox(X1,Y1,X2,Y2: Word; Color: Byte);
var
  C : Byte;
begin
 if (Y1 < Y2) and (X1 < X2) then
 FOR C:=1 TO (Y2 - Y1) div 2+1 DO
  begin
   LineX(X1,X2,Y1+C,Color);
   LineX(X1,X2,Y2-C,Color);
  end;
end;

Procedure FillEllipse(X,Y,Xrad,Yrad:word;Col:byte);
     Var deg:real;
         oX1,oY1:word;
         oX2,oY2:word;
     Begin
       deg:=0;
       repeat
         oX1:=Round(XRad*COS (deg));
         oY1:=Round(YRad*sin (deg));
         oX2:=Round(XRad*sin (deg));
         oY2:=Round(YRad*cos (deg));
         LineX(x-oX2,x+oX2,y+oY2,Col);
         LineX(x-oX2,x+oX2,y-oY2,Col);
         LineY(x-oX1,y-oY1,y+oY1,Col);
         LineY(x+oX1,y-oY1,y+oY1,Col);
          deg:=deg+0.005;
       Until (deg>0.8);
        FillGraphBox(x-oX2,y-oY2,x+oX2,y+oY2,Col);
     End;


procedure LineY(X,Y1,Y2:word;Color:byte);External;

procedure LineX(X1,X2,Y:word;Color:byte);External;

Procedure Line(X1,Y1,X2,Y2:word;Color:byte);
Var X,Y,XSize,YSize:word;
    Xreal,Yreal:real;
 Begin
  if X1 >X2 then SwapW(X1,X2);
  if Y1 >Y2 then SwapW(Y1,Y2);
  XSize:=X2 - X1;
  YSize:=Y2 - Y1;
  if YSize = 0 then
   Begin
    if XSize > 0 then LineX(Y1,X1,X2,Color);
    Exit;
   end;
  if XSize = 0 then
   Begin
    if YSize >0 then LineY(X1,Y1,Y2,Color);
    Exit;
   end;
  XReal:=XSize/YSize;
  YReal:=YSize/XSize;
  if (YReal/XReal <1) and (YReal/XReal >-1) then
  Begin
  For X:=X1 to X2 do
   Begin
    Y:=Round(YReal*X);
    PutPoint(X,Y,Color);
   end;
  end
  else Begin
  For Y:=Y1 to Y2 do
   Begin
    X:=Round(XReal*Y);
    PutPoint(X,Y,Color);
   end;
  end;
 end;

procedure Window(X1,Y1,X2,Y2: byte);assembler;
asm
 MOV AH,X1
 MOV AL,Y1
 MOV WindMin,AX
 MOV AH,X2
 MOV AL,Y2
 MOV WindMax,AX
end;

Procedure ClearWindow;
begin
 Scroll(WindMin.X,WindMin.Y,WindMax.X,WindMax.Y,0,TextAttr,Up);
 CursorXY(WindMin.X,WindMin.Y);
end;

Begin
 InitIvGraph;
 ActiveScreenPtr:=Ptr(CurrentVideoSeg,PageOffset);
 WaitProc:=NoneDo;
 PauseProc:=DoNone;
 PauseStr:='Press any key to continue...';
end.
