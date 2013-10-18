uses Ivstring;

type
 Str5      = String[5];

const
 CRTC      = $3D4;
 SEQU      = $3C4;
 GRPH      = $3CE;
 MOR       = $3CC;
 ISR0_0    = $3DA;
 ISR0_1    = $3C2;
 FCR       = $3CA;
 ATTR      = $3C0;

 CRTC_regs = $FF;
 SEQU_regs = $FF;
 GRPH_regs = $FF;
 ATTR_regs = $FF;

 csCRTC       = 'CRTC ';
 csSEQU       = 'SEQUENCER ';
 csGRPH       = 'GRAPH ';
 csIndex      = 'Index: ';
 csValue      = ' Value: ';
 csMOR        = 'MISC. OUTPUT ';
 csISR0_0     = 'INPUT STATUS 0 ';
 csISR0_1     = 'INPUT STATUS 1 ';
 csFCR        = 'FEATURE CONTROL ';
 csATTR       = 'ATTRIBUTE CONTROLLER ';


Function HexByte(B: Byte): Str5;
 Begin
  HexByte:=HexB(B)+'h';
 end;

Function ReadIndexPort(PortN: Word; Index: Byte): Byte; assembler;
 asm
  MOV AL,Index
  MOV DX,PortN
  OUT DX,AL
  INC DL
  IN  AL,DX
 end;

Function ReadPort_3C0(Index: Byte): Byte; assembler;
 asm
  CLI
  MOV DX,ISR0_0
  IN  AL,DX
  MOV DX,ATTR
  MOV AL,Index
  OR  AL,32
  OUT DX,AL
  INC DL
  IN  AL,DX
  STI
 end;

Procedure WriteIndexPort(PortN: Word; Regs: Byte; Name: String);
var
  Count,
  Value: Byte;
 Begin
  FOR Count:=0 TO Regs DO
   Begin
    Value:=ReadIndexPort(PortN,Count);
    Writeln(Name,csIndex,HexByte(Count),csValue,HexByte(Value));
   end;
 end;

Procedure WritePort(PortN:Word;Name:String);
var
  Value: Byte;
 Begin
  Value:=Port[PortN];
  Writeln(Name,csValue,HexByte(Value));
 end;

Procedure WriteAttrPort;
var
  Count,
  Value: Byte;
 Begin
  FOR Count:=0 TO ATTR_regs DO
   Begin
    Value:=ReadPort_3C0(Count);
    Writeln(csAttr,csIndex,HexByte(Count),csValue,HexByte(Value));
   end;
 end;

Begin
 WritePort(MOR,csMOR);
 WritePort(ISR0_0,csISR0_0);
 WritePort(ISR0_1,csISR0_1);
 WritePort(FCR,csFCR);
 WriteIndexPort(CRTC,CRTC_regs,csCRTC);
 WriteIndexPort(SEQU,SEQU_regs,csSEQU);
 WriteIndexPort(GRPH,GRPH_regs,csGRPH);
 WriteAttrPort;
end.