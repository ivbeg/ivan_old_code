Program Dat2Xla;

Uses IvDos,IvString,IvSystem,ShowTErr;

Type
 PathStr     =   string[79];
 DirStr      =   string[67];
 FileStr     =   string[12];
 NameStr     =   string[8];
 ExtStr      =   string[4];

 Arr3Chars   = Array[0..3] of Char;
 TFileName   = Array[1..12] of Char;

Const
 Ver  : string[4] = ('1.00');
 K    : string[10] = ('Any2Xor: ');


Var Infile,
    OutFile     : Word;
    InFileName,
    OutFileName : PathStr;
    InFilePName,
    OutFilePName : PChar;

 procedure  FSplit(Path : PathStr; var Dir : DirStr; var Name : NameStr; var Ext : ExtStr);
  { splits a file name into its three components. }
  var
    I  :  byte;
  begin
    Dir := '';
    Name := '';
    Ext := '';
    I := Pos('\',Path);
    if (I = 0)  then  I := Pos(':',Path);
    while  (I <> 0)  do  begin
      Dir := Dir + Copy(Path,1,I);
      Delete(Path,1,I);
      I := Pos('\',Path);
    end;  { while }
    I := Pos('.',Path);
    Dec(I);
    Name := Copy(Path,1,I);
    Delete(Path,1,I);
    Ext := Path;
  end;



Procedure StrToArrCh(S:string;Var Arr:array of Char);
Var Slen : byte absolute S;
    C    : byte;
 Begin
  if Slen > 0 then
   Begin
    C:=0;
    repeat
     Inc(C);
     Arr[C]:=S[C];
    Until (C = Slen) or (C = Sizeof(Arr));
   end;
 end;


Procedure CopyFile;
Const
 BuffSize = 65000;
Type
 PBuffer = ^TBuffer;
 TBuffer = array[1..BuffSize] of Char;
Var Buffer:PBuffer;
    NumberRead,NumberWrite:Word;
 Begin
  GetMem(Buffer,BuffSize);
  repeat
   ReadFilePtr (Infile ,Buffer,BuffSize,NumberRead);
   asm
    les bx, Buffer
    mov cx, NumberRead
    @JumpPos:
    MOV  AL, byte ptr es:[bx]
    ROR  AL, 4
    MOV  byte ptr es:[bx], AL
    inc bx
    loop @JumpPos
   
{
    les bx, Buffer
    mov cx, NumberRead
    mov al, $00
    @JumpPos:
    xor byte ptr es:[bx], al
    inc al
    inc bx
    loop @JumpPos
}
   end;
   WriteFilePtr(OutFile,Buffer,NumberRead,NumberWrite);
  until (NumberRead = 0) or (NumberRead <> NumberWrite);
  FreeMem(Buffer,BuffSize);
 end;

Procedure Help;
 Begin
  Writeln('Any2Xor Utility Version ',Ver,', Copyright (C) 1995 Ivan Begtin');
  Writeln('Usage: infile [outfile]');
  Writeln('  infile   - source filename      (def.ext. = any)');
  Writeln('  outfile  - destination filename (def.ext. = xor)');
  Halt;
 end;



Procedure Convert;
Var Result:word;
 Begin
  New(InFilePName);
  StrToPchar(InFileName,InFilePName);
  OpenFile(InFilePName,InFile);
  IsError;
  Writeln('Opening file... ',InFilePName);
  New(OutFilePName);
  StrToPchar(OutFileName,OutFilePName);
  CreateFile(OutFilePName,StdAttr,OutFile);
  IsError;
  Writeln('Creating file... ',OutFileName);
  Writeln(K,'XOR and copy file...');
  CopyFile;
  Writeln(K,'Done.');
  CloseFile(InFile);
  CloseFile(OutFile);
  Dispose(InFilePName);
  Dispose(OutFilePName);
 end;

Procedure SetOne;
Var Dir  : DirStr;
    Name : NameStr;
    Ext  : ExtStr;
 Begin
  InFileName :=ParamStr(1);
  FSplit(InFileName,Dir,Name,Ext);
  OutFileName:=Name+'.XOR';
 end;

Procedure SetTwo;
 Begin
  InFileName :=ParamStr(1);
  OutFileName:=ParamStr(2);
 end;

Begin
 OpenMode:=2;
 if ParamCount < 2 then
 if ParamCount = 0 then Help
 else SetOne
 else SetTwo;
 Convert;
end.