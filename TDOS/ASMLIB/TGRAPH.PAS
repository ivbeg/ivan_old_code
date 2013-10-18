Unit TGraph;


interface
Uses TSystem;

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

type
    TRgbRec     = record
      R,G,B:  Byte;
    End;

    TDacPalette = array[0..$FF] of TRgbRec;


var
   UseBios             : Byte;
   CurrentVideoSeg     : Word;
   PageOffset          : Word;
   ActiveCounter       : Boolean;
   StringCounter       : Byte;
   WindMin             : Word;
   WindMax             : Word;
   TextChar            : Byte;
   TextAttr            : Byte;
   ActiveScreenPtr     : Pointer;
   VirtualScreenActive : Boolean;
   HideCursor          : Boolean;
   VideoBiosType       : Byte;
   WaitProc            : TRepeatFunction;
   PauseProc           : Procedure;


function  GetVideoMode: Byte;
function  GetCurrentVideoPage: Byte;
procedure SetLogicPage(Page: Byte);
function  GetRealPageOffset: Word;
function  GetXY: Word;
function  GetX: Byte;
function  GetY: Byte;
procedure CursorXY(X,Y: Byte);
procedure CursorOff;
procedure CursorOn;
procedure BiosWriteString(Point: TPoint; Page: Byte; Buffer: Pointer;
                          Size: Word; Attr, WriteMode: Byte);
procedure SetCursorShape(Start, Stop: Byte);
procedure SetDoubleScan(Value: Boolean);
procedure SaveVideoState(StateType: Byte; Buffer: Pointer);
procedure RestoreVideoState(StateType: Byte; Buffer: Pointer);
function  GetStateBufferSize(StateType: Byte): Word;
function  GetDCC: Word;
procedure SetDCC(Main, Second: Byte);
function  GetTotalScanLines: Word;
procedure SetStartOffset(Offset: Word);
function  is_DoubleScan: Boolean;
function  is_Blink: Boolean;
function  is_GraphMode: Boolean;
procedure GetVideoInfo(Var Table: Pointer); { Must be changed }
procedure SetCGABorder(Color: Byte);
procedure SetCGAPalette(PalID: Byte);
function  GetOverscanColor: Byte;
procedure SetOverscanColor(Color: Byte);
procedure SetDACPalette(Var Palette: TDacPalette);
procedure GetDACPalette(Var Palette: TDacPalette);
procedure GreySummDAC(StartReg, Count: Word);
procedure SetEgaPalette(Var Palette: TEgaPalette);
procedure GetEgaPalette(Var Palette: TEgaPalette);
procedure SetEgaReg(EgaReg, Value: Byte);
function  GetEgaReg(EgaReg: Byte): Byte;
procedure SetRGB(Reg: Byte;Var RGB: TRgbRec);
procedure GetRGB(Reg: Byte;Var RGB: TRgbRec);

procedure SetVideoMode(Mode: Byte);
procedure SetVideoPage(Page: Byte);

procedure LineFeed;
procedure WriteCharXY(X, Y: Byte; CharCode: Char; Attr: Byte);
procedure WriteChar(CharCode: Char; Attr: Byte);
procedure WriteStr(S: PString; Attr: Byte);
procedure WriteStrXY(X, Y: Byte; S: PString; Attr: Byte);
function  ReadChar: Char;
function  ReadCharXY(X, Y: Byte): Char;
function  ReadAttr: Byte;
function  ReadAttrXY(X, Y: Byte): Char;
procedure FillAttr(Attr, Count: Byte);
procedure FillAttrXY(X, Y: Byte; Attr, Count: Byte);
procedure WriteAttr(Attr: Byte);
procedure PlaneWrite(S: PString);
procedure PlaneWriteXY(X, Y: Byte; S: PString);
procedure ClrScr;
procedure InitTGraph;

procedure FastWrite(S:string);
procedure FastWriteLn(S:string);
procedure SetPauseStr(S:string);

procedure TextColor(Color:byte);
procedure TextBackGround(Color:byte);
function  Attrib(F,B:byte):byte;
Procedure WriteCenter(Y:byte;Attr:byte;St:string);
Procedure CenterPlainWrite(Y:byte;St:string);
Procedure WriteBetween(X1,X2,Y,Attr:byte;St:string);
procedure FillBox(X1, Y1, X2, Y2, Attr:byte);


function  NoneDo: Boolean;

implementation

var
   PauseStr: String;

{$L TGRAPH.OBJ}

function  GetVideoMode: Byte; External;
function  GetCurrentVideoPage: Byte; External;
procedure SetLogicPage(Page: Byte); External;
function  GetRealPageOffset: Word; External;
function  GetXY: Word; External;
function  GetX: Byte; External;
function  GetY: Byte; External;
procedure CursorXY(X,Y: Byte); External;
procedure CursorOff; External;
procedure CursorOn; External;
procedure BiosWriteString(Point: TPoint; Page: Byte; Buffer: Pointer;
                          Size: Word; Attr, WriteMode: Byte); External;
procedure SetCursorShape(Start, Stop: Byte); External;
procedure SetDoubleScan(Value: Boolean); External;
procedure SaveVideoState(StateType: Byte; Buffer: Pointer); External;
procedure RestoreVideoState(StateType: Byte; Buffer: Pointer); External;
function  GetStateBufferSize(StateType: Byte): Word; External;
function  GetDCC: Word; External;
procedure SetDCC(Main, Second: Byte); External;
function  GetTotalScanLines: Word; External;
procedure SetStartOffset(Offset: Word); External;
function  is_DoubleScan: Boolean; External;
function  is_Blink: Boolean; External;
function  is_GraphMode: Boolean; External;
procedure GetVideoInfo(Var Table: Pointer); External; { Must be changed }
procedure SetCGABorder(Color: Byte); External;
procedure SetCGAPalette(PalID: Byte); External;
function  GetOverscanColor: Byte; External;
procedure SetOverscanColor(Color: Byte); External;
procedure SetDACPalette(Var Palette: TDacPalette); External;
procedure GetDACPalette(Var Palette: TDacPalette); External;
procedure GreySummDAC(StartReg, Count: Word); External;
procedure SetEgaPalette(Var Palette: TEgaPalette); External;
procedure GetEgaPalette(Var Palette: TEgaPalette); External;
procedure SetEgaReg(EgaReg, Value: Byte); External;
function  GetEgaReg(EgaReg: Byte): Byte; External;
procedure SetRGB(Reg: Byte;Var RGB: TRgbRec); External;
procedure GetRGB(Reg: Byte;Var RGB: TRgbRec); External;

procedure SetVideoMode(Mode: Byte); External;
procedure SetVideoPage(Page: Byte); External;

procedure LineFeed; External;
procedure WriteCharXY(X, Y: Byte; CharCode: Char; Attr: Byte); External;
procedure WriteChar(CharCode: Char; Attr: Byte); External;
procedure WriteStr(S: PString; Attr: Byte); External;
procedure WriteStrXY(X, Y: Byte; S: PString; Attr: Byte); External;
function  ReadChar: Char; External;
function  ReadCharXY(X, Y: Byte): Char; External;
function  ReadAttr: Byte; External;
function  ReadAttrXY(X, Y: Byte): Char; External;
procedure FillAttr(Attr, Count: Byte); External;
procedure FillAttrXY(X, Y: Byte; Attr, Count: Byte); External;
procedure WriteAttr(Attr: Byte); External;
procedure PlaneWrite(S: PString); External;
procedure PlaneWriteXY(X, Y: Byte; S: PString); External;
procedure ClrScr; External;
procedure InitTGraph; External;


procedure FastWrite(S:string);
begin
  WriteStr(Addr(S), TextAttr);
end;

procedure FastWriteLn(S:string);
begin
  FastWrite(S);
  LineFeed;
end;


procedure Pause; far;
begin
  PauseProc;
  FastWrite(PauseStr);
  Repeat Until WaitProc;
  LineFeed;
end;


procedure SetPauseStr(S:string);
begin
  PauseStr:= S;
end;


procedure TextColor(Color:byte);assembler;
asm
  MOV  AL,Color
  AND  AL,00001111b
  AND  TextAttr,11110000b
  OR   TextAttr,AL
end;

procedure TextBackGround(Color:byte);assembler;
asm
  MOV  AL,Color
  AND  AL,00001111b
  MOV  CL,4
  SHL  AL,CL
  AND  TextAttr,00001111b
  OR   TextAttr,AL
end;


function  Attrib(F,B:byte):byte;
begin
  Attrib:=(B Shl 4) or F;
end;


procedure WriteCenter(Y:byte;Attr:byte;St:string);
begin
  With BiosArea DO
  WriteStrXY((MaxColumns - Byte(St[0])) div 2, Y, Addr(St), Attr);
end;

procedure CenterPlainWrite(Y:byte;St:string);
begin
  With BiosArea DO
  PlaneWriteXY((MaxColumns - Byte(St[0])) div 2,Y,Addr(St));
end;

Procedure WriteBetween(X1,X2,Y,Attr:byte;St:string);
begin
  WriteStrXY((X2 - X1 - Byte(St[0])) div 2, Y, Addr(St), Attr);
end;


procedure FillBox(X1, Y1, X2, Y2, Attr:byte);
Var
   C:byte;
begin
  for C:=Y1 to Y2 do
   FillAttrXY(X1, C, Attr, X2-X1);
end;



function  NoneDo: Boolean; assembler;
asm
  MOV     AL, True
end;


Begin
  InitTGraph;
  WaitProc:= NoneDo;
  PauseProc:= DoNone;
End.