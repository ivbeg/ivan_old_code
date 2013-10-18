
Uses Ems,Misc,Ivstring;
type
 Str9 = string[9];
 EmsBlock  = record
 Handle:word;
 Pages:word;
end;
 var EmsArr:array[1..255] of EmsBlock;
     Segm,Offs:word;
     UsHandle:word;
     Count:byte;
     Name:array[1..9] of Str9;
Function HandleName(Handl:word):str9;
var AA:array[0..8] of Char;
    Se,Ofe:word;
    i:byte;
 begin
 begin
 Se:=Seg(AA);
 Ofe:=Ofs(AA);
 asm
  push di
  mov es,Se
  mov di,Ofe
  mov dx,Handl
  mov ax,5300h
  int 67h
  pop di
 end;
 end;
for i :=1 to Sizeof(AA) do
begin
 HandleName[I]:=AA[i-1];
end;
HandleName[0]:=Chr(9);
if Handl = 0 then HandleName := 'SYSTEM';
 end;
begin
Segm := SEG(EmsArr);
Offs := Ofs(EmsArr);
 asm
  push di
  mov  es,Segm
  mov  di,Offs
  mov  ah,4Dh
  int  67h
  pop  di
  mov  UsHandle,bx
 end;
 Writeln('Ems Version = ',EmsVersion);
 Writeln('Ems Total Size = ',TotalEmsPages * 1024,' bytes');
 Writeln('Ems Avail Size = ',AvailEmsPages*1024,' bytes');
 Writeln('Page Frame = ',HexWord(PageFrame));
 WRITELN('Free Handles = ',TotalHandles-UsHandle);
 WRITELN('Total Handles = ',TotalHandles);
 Writeln('Handle   Pages   Name ');
 for Count:=1 to UsHandle do
 WRITELN('  ',EmsArr[Count].Handle,'      ',EmsArr[Count].Pages,'      ',CheckString(HandleName(EmsArr[Count].Handle)));


 end.