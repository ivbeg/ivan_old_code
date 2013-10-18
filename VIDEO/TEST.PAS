uses Ivsystem;

var
 Count,
 Value: Byte;

type
 Str5      = String[5];

const
 CRTC      = $3D4;
 SEQU      = $3C4;
 GRPH      = $3CE;

 CRTC_regs = $18;
 SEQU_regs = $04;
 GRPH_regs = $08;

 CRTC_table: array[0..CRTC_regs] of Byte =
              ($2D,$27,$28,$90,$2B,$A0,
               $BF,$1F,$00,$4F,$00,$0F,
               $00,$00,$00,$78,$9C,$8E,
               $8F,$14,$1F,$96,$B9,$A3,$FF);
 SEQU_table:  array[0..SEQU_regs] of Byte =
               ($03,$08,$03,$00,$02);

 GRPH_table:  array[0..GRPH_regs] of Byte =
               ($00,$00,$00,$00,
                $00,$10,$0E,$00,$FF);

Procedure WriteInIndexPort(PortN: Word; Var Buff:Array of Byte; Regs: Byte);
 Begin
  FOR Count:=0 TO Regs DO
   Begin
    Port[PortN]:=Count;
    Port[PortN+1]:=Buff[Count];
   end;
 end;

Begin
 WriteInIndexPort(CRTC,CRTC_table,CRTC_regs);
 WriteInIndexPort(SEQU,SEQU_table,SEQU_regs);
 WriteInIndexPort(GRPH,GRPH_table,GRPH_regs);
 BiosArea.Maxcolumns:=40;
 BiosArea.VideoBuffSize:=2048;
end.