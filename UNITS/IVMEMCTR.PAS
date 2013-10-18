Unit IvMemCtr;
INTERFACE
uses IvString,IvSystem;
type
 Str8 = String[8];
 Str12 = String[12];





Procedure DosTableAdr(var Segm,Offs:word);

 { ** GetMCB Functions (so as GetMCB) ** }
Function McbName(Sega:word):string;
Function McbTipe(Sega:word):char;
Function McbOwner(Sega:word):word;
Function McbSize(Sega:word):word;

     { ** PSP Info Block ** }
Function PspMemTop(Segm:word):word;
Function PspEnvSeg(Segm:word):word;
{Function PspTail(Segm:word):string;}
Function PspOwner(Segm:word):word;

  { ** Dos Table Info Block ** }
Function DtExtMem:Word;
Function DtFirstMCBSeg:word;
Function DtNumJoindDr:byte;
Function DtValidDr:byte;
Function DtLastDrive:byte;
Function DtBootDrive:byte;
Procedure DtDPBAdr (var Segm,Offs:word);
Procedure DtDirListAdr (var Segm,Offs:word);
Procedure DtSFTAdr (var Segm,Offs:word);
Procedure DtFCBAdr (var Segm,Offs:word);
Procedure DtSysDrvAdr (var Segm,Offs:word);
Procedure DtDevDrvAdr (var Segm,Offs:word);
 { ** Drives Parameter Table ** }






IMPLEMENTATION





Procedure DosTableAdr(var Segm,Offs:word);
var Se,Ofs:word;
begin
  asm
   mov    ah,52h
   int    21h
   mov    Se,es
   mov    Ofs,bx
  end;
Segm:=Se;
Offs:=Ofs;
end;



Function McbName(Sega:word):string;
 begin
    McbName:=GetString(Ptr(Sega,$08),8);
    McbName[0]:=#8;
 end;

Function McbTipe(Sega:word):char;
 begin
  McbTipe:=Char(Mem[Sega:0]);
 end;

Function McbOwner(Sega:word):word;
 begin
  McbOwner:=MemW[Sega:1];
 end;

Function McbSize(Sega:word):Word;
 begin
  McbSize:=MemW[Sega:3];
 end;

Function PspMemTop(Segm:word):word;

 begin
  PspMemTop:=MemW[Segm:$2];
 end;

Function PspEnvSeg(Segm:word):word;
 begin
  PspEnvSeg:=MemW[Segm:$2C];
 end;

{Function PspTail(Segm:word):string;
 begin

 end;}

Function PspOwner(Segm:word):word;
 begin
  PspOwner:=MemW[Segm:$16];
 end;

Function DtExtMem:Word;
var A1,A2:word;
 begin
  DosTableAdr(A1,A2);
  DtExtMem:=MemW[A1:A2+$45];
 end;

Function DtFirstMCBSeg:word;
var A1,A2:word;
 begin
  DosTableAdr(A1,A2);
  DtFirstMCBSeg:=MemW[A1:A2-$2];
 end;

Function DtNumJoindDr:byte;
var A1,A2:word;
 begin
  DosTableAdr(A1,A2);
  DtNumJoindDr:=Mem[A1:A2+$34];
 end;

Function DtValidDr:byte;
var A1,A2:word;
 begin
  DosTableAdr(A1,A2);
  DtValidDr:=Mem[A1:A2+$20];
 end;

Function DtLastDrive:byte;
var A1,A2:word;
 begin
  DosTableAdr(A1,A2);
  DtLastDrive:=Mem[A1:A2+$21];
 end;

Function DtBootDrive:byte;
var A1,A2:word;
 begin
  DosTableAdr(A1,A2);
  DtBootDrive:=Mem[A1:A2+$43];
 end;

Procedure DtDPBAdr(var Segm,Offs:word);
var A1,A2:word;
 begin
 DosTableAdr(A1,A2);
 Segm:=MemW[A1:A2+2];
 Offs:=MemW[A1:A2+0];
 end;
Procedure DtDirListAdr (var Segm,Offs:word);
var A1,A2:word;
 begin
 DosTableAdr(A1,A2);
 Segm:=MemW[A1:A2+$18];
 Offs:=MemW[A1:A2+$16];
 end;

Procedure DtSFTAdr (var Segm,Offs:word);
var A1,A2:word;
 begin
 DosTableAdr(A1,A2);
 Segm:=MemW[A1:A2+$6];
 Offs:=MemW[A1:A2+$4];
 end;

Procedure DtFCBAdr (var Segm,Offs:word);
var A1,A2:word;
 begin
 DosTableAdr(A1,A2);
 Segm:=MemW[A1:A2+$1C];
 Offs:=MemW[A1:A2+$1A];
 end;

Procedure DtSysDrvAdr (var Segm,Offs:word);
var A1,A2:word;
 begin
 DosTableAdr(A1,A2);
 Segm:=MemW[A1:A2+$3D];
 Offs:=MemW[A1:A2+$3B];
 end;

Procedure DtDevDrvAdr (var Segm,Offs:word);
var A1,A2:word;
 begin
 DosTableAdr(A1,A2);
 Segm:=MemW[A1:A2+$24];
 Offs:=MemW[A1:A2+$22];
 end;
end.