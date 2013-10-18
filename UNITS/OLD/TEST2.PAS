uses Module,Misc,Crt,IvString;
type
 Str8 = String[8];
var Segm,Offs,Se,Own:word;
    Ivan:String;
    Typ:Char;
    Siz:LongInt;
Procedure BuildInfoBlock;
Const
 A1 = 'M';         A2 = 'Z';
 A3 = 'S';         A4 = 'E';
 A5 = 'D';         A6 = 'F';
 A7 = 'B';         A8 = 'L';
 A9 = 'X';         A10 = 'C';
 A11 = 'I';
 var Sega,Ofa:word;Name:string;
begin
 DosTableAdr(Segm,Offs);
 Se:=MemW[Segm:Offs-2]+1;
repeat
GetMCB(Se,Typ,Own,Siz,Ivan);
Writeln('Type of Block = ',BlockType(Typ));
Writeln('Owner of Block = ',HexWord(Own));
Writeln('Size of Block = ',Siz);


if Typ = A1 then
 begin
 end;
if Typ = A2 then
 begin
 end;
if Typ = A3 then
 begin
 end;
if Typ = A4 then
 begin
 end;
if Typ = A5 then
 begin
  Writeln('Name of Block = ',Ivan);
  Writeln('Device Driver Name = ',GetString(Se+1,$A,8));

 end;
if Typ = A6 then
 begin
 end;
if Typ = A7 then
 begin
 end;
if Typ = A8 then
 begin
 end;
if Typ = A9 then
 begin
 end;
if Typ = A10 then
 begin
 end;
if Typ = A11 then
 begin
 end;

ReadKey;
Se:=Se + MemW[Se:0003]+1;
until (Se=$A000) or (Own=$0);
end;

begin
 BuildInfoBlock;
 end.
