Uses Module,Misc,Crt;
var Se,Ofe,Sg,Oft:word;

Function DptSeg(Segm,Offs:word):word;
 begin
  DptSeg:=MemW[Segm:Offs+$1B];
 end;

Function DptOfs(Segm,Offs:word):word;
 begin
  DptOfs:=MemW[Segm:Offs+$19];
 end;

Procedure DPTDecoding(Segm,Offs:word);
var FatCopy,Sect,FiSect:byte;
    X:Char;
    RootDir,SeDevHd,OfeDevHd,FiFATsec,DirEntry,Bytes,Clust:word;
 begin
  X:=Chr(Mem[Segm:Offs]+48);
  Bytes:=MemW[Segm:Offs+2];
  Sect:=Mem[Segm:Offs+4];
  FiSect:=MemW[Segm:Offs+6];
  FatCopy:=Mem[Segm:Offs+8];
  DirEntry:=MemW[Segm:Offs+9];
  Clust:=MemW[Segm:Offs+$0D];
  FiFATsec:=MemW[Segm:Offs+$0F];
  RootDir:=MemW[Segm:Offs+$11];
  SeDevHd:=MemW[Segm:Offs+$15];
  OfeDevHd:=MemW[Segm:Offs+$13];
  Writeln('Drive = ',X);
  Writeln('Bytes per Sector = ',Bytes);
  Writeln('Sectors per Cluster = ',Sect-1);
  Writeln('Sectors before FAT = ',FiSect);
  Writeln('FAT Copies = ',FatCopy);
  Writeln('Directory Entries = ',DirEntry);
  Writeln('Total Clusters = ',Clust);
  Writeln('Sectors under First FAT = ',FiFATsec);
  Writeln('Root Directory begin at = ',RootDir,' sector');
  Writeln('Device Driver of Drive = ',HexWord(SeDevHd),':',HexWord(OfeDevHd));

 end;
begin
 DtDPBAdr(Se,Ofe);
 Writeln(HexWord(Se),':',HexWord(Ofe));
 repeat
  DPTDecoding(Se,Ofe);
  Sg:=DptSeg(Se,Ofe);
  Oft:=DptOfs(Se,Ofe);
  Se:=Sg;
  Ofe:=Oft;
  ReadKey;
 Until Ofe=$FFFF;
end.