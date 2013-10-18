{$X+}
Unit IvGraph;

InterFace
Uses IvSystem;

Type
 RGBRec = Record
           R,G,B:byte;
          end;
Var
          UsePorts:boolean;
          CursorBlink:CursorBlinkType;
          UseBios: Boolean;

Procedure WaitRetrace;
Function  GetEgaPaletteReg(Reg:byte):byte;
Procedure SetEgaPaletteReg(Reg,Color:byte);
Procedure SetOverScan(Color:byte);
Function  GetOverScan:byte;
Procedure SetRGBColors(Reg:byte; R,G,B:byte);
Procedure GetRgbColors(Reg:byte;Var RGB:RGBrec);
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
Function  VGABoardActive:boolean;
Function  IsGreySumm:boolean;
Function  IsDefPalLoad:boolean;
Function  GetScanLines:byte;
Function  IsGraphMode:boolean;
Function  IsBlink:boolean;
Function  IsDoubleScan:boolean;

Procedure Circle(X,Y,R:word;Col:Byte);
Procedure Ellipse(X,Y,Xrad,Yrad:word;Col:byte);
Procedure Line(X1,Y1,X2,Y2:word;Color:byte);
procedure LineX(Y,X1,X2:word;Color:byte);
procedure LineY(X,Y1,Y2:word;Color:byte);
Function  ReadPoint(X,Y:word):byte;
Procedure PutPoint(X,Y:word;Color:byte);

Implementation

Procedure WritePort3d5;near;assembler;
asm
 mov dx,3d4h
 out dx,ax
end;

Function  ReadPort3d5:byte;near;assembler;
asm
 mov dx,3d4h
 out dx,al
 inc dl
 in  al,dx
end;

Procedure SetDoubleScan(Scan:boolean);assembler;
 asm
  mov  al,9
  call ReadPort3d5
  mov  ah,Scan
  mov  cl,7
  shl  ah,cl
  or   al,ah
  mov  ah,al
  mov  al,9
  call WritePort3d5
 end;

Procedure SetStartAddress(Adr:word);assembler;
 asm
  mov  dx,3d4h
  mov  al,0Ch
  mov  ah,byte Ptr [Adr]
  out  dx,ax
  mov  ah,byte Ptr [Adr+1]
  Inc  al
  out  dx,ax
 end;

Function  IsDoubleScan:boolean;assembler;
 asm
  mov  al,09h
  call ReadPort3d5
  mov  cl,7
  shr  al,cl
  and  al,1
 end;

Function  TotalScanLines:word;assembler;
 asm
  mov dx,3D4h
  mov al,12h
  out dx,al
  inc dl
  in  al,dx
  mov bl,al
  xor ah,ah
  dec dl
  mov al,7
  out dx,al
  inc dl
  in  al,dx
  mov bh,al
  and al,2
  shr al,1
  or  ah,al
  and bh,64
  mov cl,4
  shr bh,cl
  or  ah,bh
  mov al,bl
  inc ax
 end;

Function  Port3C0(Index:byte):byte;assembler;
  asm
   cli
   mov dx,3DAh
   in  al,dx
   mov dl,192
   mov al,Index
   or  al,32
   out dx,al
   inc dl
   in  al,dx
   sti
  end;

Function  IsBlink:boolean;
Var B:byte;
 Begin
  B:=Port3c0(16);
  IsBlink:=Boolean(B and 8);
 end;

Function  IsGraphMode:boolean;
Var B:byte;
 Begin
  B:=Port3c0(16);
  IsGraphMode:=Boolean(B and 1);
 end;

Procedure SetBlink(B:boolean);assembler;
 asm
  mov  ax,1003h
  mov  bl,B
  int  10h
 end;

Function  IsCursorEm:boolean;
 Begin
  IsCursorEm:=not BitofB(BiosArea.EgaFlags,0);
 end;

Function  IsWaitDisplay:boolean;
 Begin
  IsWaitDisplay:=BitofB(BiosArea.EgaFlags,2);
 end;

Function  IsVideoSysActive:boolean;
 Begin
  IsVideoSysActive:=BitofB(BiosArea.EgaFlags,3);
 end;

Function  VideoMemSize:word;
 Begin
  VideoMemSize:=Word((((BiosArea.EgaFlags shr 5) and 3 ) +1)) shl 6;
 end;

Function  IsSaveBuffer:boolean;
 Begin
  IsSaveBuffer:=BitofB(BiosArea.EgaFlags,7);
 end;

Function  VGABoardActive:boolean;
 Begin
  VGABoardActive:=BitofB(BiosArea.VgaFlags,0);
 end;

Function  IsGreySumm:boolean;
 Begin
  IsGreySumm:=BitofB(BiosArea.VgaFlags,1);
 end;

Function  IsDefPalLoad:boolean;
 Begin
  IsDefPalLoad:=BitofB(BiosArea.VgaFlags,3);
 end;

Function  GetScanLines:byte;
Var B:byte;
 Begin
  GetScanLines:=Byte(BitofB(BiosArea.VgaFlags,3))+ (Byte(BitofB(BiosArea.VgaFlags,3)) shl 1);
 end;


Procedure SetScanLines(Scan:byte);assembler;
 asm
  mov  ah,12h
  mov  bl,30h
  mov  al,Scan
  int  10h
 end;

Procedure DisableDefPalLoad(B:boolean);assembler;
 asm
  mov  ah,12h
  mov  bl,31h
  mov  al,B
  int  10h
 end;

Procedure DisableVideoAddr(B:boolean);assembler;
 asm
  mov  ah,12h
  mov  bl,32h
  mov  al,B
  int  10h
 end;

Procedure DisableGreySumm(B:boolean);assembler;
 asm
  mov  ah,12h
  mov  bl,33h
  mov  al,B
  int  10h
 end;

Procedure DisableCursorEm(B:boolean);assembler;
 asm
  mov  ah,12h
  mov  bl,34h
  mov  al,B
  int  10h
 end;

Procedure DisableVideoRefr(B:boolean);assembler;
 asm
  mov  ah,12h
  mov  bl,36h
  mov  al,B
  int  10h
 end;

Procedure CursorForm(Start,Stop:byte);assembler;
 asm
  mov   ch,CursorBlink
  mov   cl,5
  shl   ch,cl
  add   ch,Start
  mov   cl,Stop
  and   cl,1Fh
  mov   ah,01h
  int   10h
 end;


Function  GetEgaPaletteReg(Reg:byte):byte;assembler;
  asm
   mov   ah,10h
   mov   al,7
   mov   bl,Reg
   int   10h
   mov   al,bh
  end;

Procedure SetEgaPaletteReg(Reg,Color:byte);assembler;
 asm
   mov ah,10h
   mov al,0
   mov bl,Reg
   mov bh,Color
   int 10h
 end;

Procedure SetOverScan(Color:byte);assembler;
  asm
   mov   ah,10h
   mov   al,1
   mov   bh,COlor
   int   10h
  end;

Function  GetOverScan:byte;assembler;
  asm
   mov   ah,10h
   mov   al,8
   int   10h
   mov   al,bh
  end;

Procedure pSetRgb(Reg:byte;RGB:RGBrec);
Begin
 asm
  cli
  end;
  Port[$3C8]:=Reg;
  Port[$3C9]:=RGB.R;
  Port[$3C9]:=RGB.G;
  Port[$3C9]:=RGB.B;
   asm
    Sti
   end;
end;

Procedure bSetRgb(Reg:byte;RGB:RGBrec);assembler;
  asm
   les  di,RGB
   mov  dh,[di]
   mov  cl,[di+1]
   mov  ch,[di+2]
   mov  ax,1010h
   int  10h
  end;

Procedure SetRGBColors(Reg:byte; R,G,B:byte);
Var RGB:rgbrec;
 Begin
   RGB.R:=R;
   RGB.G:=G;
   RGB.B:=B;
   if UsePorts then pSetRgb(Reg,RGB)
               else bSetRgb(Reg,RGB);
 end;

Procedure pGetRgb(Reg:byte;Var RGB:RGBrec);
 Begin
 asm
  Cli
  end;
  Port[$3C7]:=Reg;
  Rgb.R:=Port[$3C9];
  Rgb.G:=Port[$3C9];
  Rgb.B:=Port[$3C9];
  asm
   Sti
  end;
 end;

Procedure bGetRgb(Reg:byte;Var RGB:RGBrec);assembler;
 asm
  mov ax,1015h
  int 10h
  les di,RGB
  mov [di],dh
  mov [di+1],cl
  mov [di+2],ch
 end;

Procedure GetRgbColors(Reg:byte;Var RGB:RGBrec);
 Begin
  if UsePorts then pGetRGB(Reg,RGB)
              else bGetRGB(Reg,RGB);
 end;

procedure bPutPoint(X,Y:word; Color:byte);assembler;
  asm
   mov    bh,biosArea.[CurrentPage]
   mov    dx,Y
   mov    cx,X
   mov    al,Color
   mov    ah,0Ch;
   int    10h
  end;

Procedure mPutPoint(X,Y:word; Color:byte);
 begin
  Mem[$A000:Y*320+X]:=Color;
  end;

Procedure PutPoint(X,Y:word;Color:byte);
 Begin
   if  UseBios then bPutPoint(X,Y,Color)
               else mPutPoint(X,Y,Color);
 end;

Function bReadPoint(X,Y:word):byte;assembler;
  asm
    mov   dx,Y
    mov   cx,X
    mov   ah,0Dh
    int   10h
  end;

Function mReadPoint(X,Y:word):byte;
 Begin
  mReadPoint:=Mem[$A000:Y*320+X];
 end;

Function  ReadPoint(X,Y:word):byte;
 Begin
  if UseBios then ReadPoint:=bReadPoint(X,Y)
             else ReadPoint:=mReadPoint(X,Y);
 end;



Procedure Circle(X,Y,R:word;Col:Byte);
     Begin
      Ellipse(X,Y,R,R,Col);
     End;

Procedure Ellipse(X,Y,Xrad,Yrad:word;Col:byte);
     Var deg:real;
         oX,oY:word;
     Begin
       deg:=0;
       repeat
         oX:=Round(XRad*COS (deg));
         oY:=Round(YRad*sin (deg));
         PutPoint(x+ox,y+oy,Col);
         PutPoint(x-ox,y+oy,Col);
         PutPoint(x+ox,y-oy,Col);
         PutPoint(x-ox,y-oy,Col);
         deg:=deg+0.005;
        Until (deg>1.6);
     End;



procedure LineY(X,Y1,Y2:word;Color:byte);
begin
 if Y1 > Y2 then SwapW(Y1,Y2);
  repeat
    PutPoint(X,Y1,Color);
    Y1 := Y1 + 1;
  until (Y1 = Y2);
 end;

procedure LineX(Y,X1,X2:word;Color:byte);
begin
 if X2 > X1 then SwapW(X1,X2);
    repeat
     PutPoint(X2,Y,Color);
      X2 := X2 +1 ;
    until (X2 = X1);
end;

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

Procedure WaitRetrace; assembler; asm
  mov dx,03dah;  @vert1: in al,dx;  test al,8;  jnz @vert1
  @vert2: in al,dx;  test al,8;  jz @vert2;
  end;

Procedure GetVideoInfo(Var TabLe:VideoInfoTab);assembler;
 asm
  MOV  AX,1B1Bh
  MOV  BX,0
  LES  DI,TABLE
  INT  10H
 end;

Begin
 UsePorts:=true;
 UseBios:=true;
end.
