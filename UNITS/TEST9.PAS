Uses IvString,IvBios,IvDos,IvSystem;
Var P:pointer;

Procedure CheckRom;
Const
 BiosSeg = $F000;
 RomSign : Word = $AA55;

type
 PRomRec  = ^TRomRec;
 TRomRec  = record
             Sign : word;
             Size : byte;
            end;
Var
 RomPtr : PRomRec;
 RomSeg : SegOfs absolute RomPtr;
 Begin
{  RomSeg.S:=$C000;
   RomSeg.O:=$0000;}
 RomPtr:=Ptr($C000,0);
  repeat
   if RomPtr^.Sign = RomSign then
    Begin
     Writeln('Rom At ',HexPtr(RomPtr),'; Rom Size: ',LongInt(RomPtr^.Size)*512,' bytes');
     RomSeg.S:=Word(RomPtr^.Size)*32+RomSeg.S-$80;
    end;
   RomSeg.S:=RomSeg.S+$80;
  Until RomSeg.S = BiosSeg;
 end;


Begin
 Writeln(ArrChToStr(BiosStartText));
 Writeln(ArrChToStr(BiosCopyright));
end.