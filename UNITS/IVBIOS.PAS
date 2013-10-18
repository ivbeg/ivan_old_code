{$G+}
Unit IvBios;

Interface

{Uses IvSystem;}

Type
 TBiosIntsTable   = Array[0..$1F] of word;
 TBiosDate        = Array[1..8] of Char;
 
 PBiosConfigTable = ^TBiosConfigTable;
 TBiosConfigTable = record
                     Size     : Word;
                     Model    : Byte;
                     SubModel : Byte;
                     Revision : Byte;
                     Feature1 : Byte;
                     Feature2 : Byte;
                     Feature3 : Byte;
                     Feature4 : Byte;
                     Feature5 : Byte;
                    end;


Const
 RomBiosSeg   = $F000;
 VideoBiosSeg = $C000;

 RealInt02    : LongInt = $F000E2C3;
 RealInt05    : LongInt = $F000FF54;
 RealInt08    : LongInt = $F000FEA5;
 RealInt09    : LongInt = $F000E987;
 RealInt0E    : LongInt = $F000EF57;
 RealInt10    : LongInt = $F000F065;
 RealInt11    : LongInt = $F000F84D;
 RealInt12    : LongInt = $F000F841;
 RealInt13    : LongInt = $F000EC59;
 RealInt14    : LongInt = $F000E737;
 RealInt15    : LongInt = $F000F859;
 RealInt16    : LongInt = $F000E823;
 RealInt17    : LongInt = $F000EFD2;
 RealInt18    : LongInt = $F000F600;
 RealInt19    : LongInt = $F000E6F2;
 RealInt1A    : LongInt = $F000FE6E;
 RealInt1D    : LongInt = $F000F0A4;
 RealInt1E    : LongInt = $F000EFC7;

 VideoReset   : LongInt = $C0000003;
 ResetAddr    : LongInt = $FFFF0000;

{$F-}
Var
 VideoRomInit  : Procedure Absolute VideoReset;
 Reboot        : Procedure Absolute ResetAddr;
 RealIntsOffs  : TBiosIntsTable Absolute $F000:$FEE3;
 Identifity    : Byte           Absolute $F000:$FFFE;
 Model         : Byte           Absolute $F000:$FFFF;
 BiosDate      : TBiosDate      Absolute $F000:$FFF5;

 RomConfig     : PBiosConfigTable;

{$F+}
Implementation

Function  GetRomConfigTable:pointer;assembler;
  asm
   MOV    AH,0C0h
   PUSHF
   CALL   RealInt15
   MOV    DX,ES
   MOV    AX,BX
  end;

Procedure InitIvBios;
 Begin
  RomConfig:=GetRomConfigTable;
 end;

Begin
 InitIvBios;
end.