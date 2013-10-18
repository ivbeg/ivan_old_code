Uses Module,Misc,Crt,IvString;
var Se,Ofe,Segm,Ofs,Segs,Offs:word;
    Z,K:word;
    Date,Time,BegClust,EndClust,ClustNum,Drive:Word;
    PSPSeg:word;
    CountH,OpHand,Attr,DevAttr:byte;
    Size,FilePos:LongInt;
    Name,Ext:string;
begin
DtSFTAdr(Se,Ofe);
Writeln('System Files Table = ',HexWord(Se),':',HexWord(Ofe));
Repeat
Segm:=Se;
Ofs:=Ofe+6;
Z:=MemW[Se:Ofe+4];
Writeln('First Descriptor = ',HexWord(Segm),':',HexWord(Ofs));
 for K:=1 to Z do
  begin
   CountH:=Mem[Segm:Ofs];
   OpHand:=Mem[Segm:Ofs+1];
   Attr:=MemW[Segm:Ofs+5];
   Drive:=Mem[Segm:Ofs+3];
   Name:=GetString(Segm,Ofs+$20,8);
   Ext:=GetString(Segm,Ofs+$28,3);
   Size:=MemL[Segm:Ofs+$11];
   Date:=MemW[Segm:Ofs+$0D];
   Time:=MemW[Segm:Ofs+$0D];
   DevAttr:=Mem[Segm:Ofs+$1B];
   BegClust:=MemW[Segm:Ofs+$1C];
   EndClust:=MemW[Segm:Ofs+$1E];
   ClustNum:=MemW[Segm:Ofs+$20];
   FilePos:=MemL[Segm:Ofs+$15];
   PSPSeg:=MemL[Segm:Ofs+$31];
   Ofs:=Ofs+59;
   if (Drive div 128) = 1 then
    begin
     Writeln('Type = Char Device.');
     Writeln('Pointer to Device = ',HexWord(EndClust),':',HexWord(BegClust));
    end
   else
    begin
     Writeln('Type = File or Block Device.');
     Writeln('Begin at Cluster = ',BegClust);
    end;
   Writeln('FCB Name = ',Name,'.',Ext);
   Writeln('Size = ',Size);
   Writeln('Date = ',Date);
   Writeln('Time = ',Time);
   Writeln('Date = ',Date);
   Writeln('File Position = ',FilePos);
   Writeln('Owner of File = ',HexWord(PSPSeg));
   Writeln('Owner Name = ',McbName(PSPSeg-1));
   ReadKey;
end;
Segs:=MemW[Se:Ofe+2];
Offs:=MemW[Se:Ofe];
Se:=Segs;
Ofe:=Offs;
until Ofe = $FFFF;
end.