Program FileCopy;

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
 K    : string[10] = ('FileCopy: ');


Var Infile,
    OutFile     : Word;
    StartPos    : Longint;
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
   WriteFilePtr(OutFile,Buffer,NumberRead,NumberWrite);
  until (NumberRead = 0) or (NumberRead <> NumberWrite);
  FreeMem(Buffer,BuffSize);
 end;

Procedure Help;
 Begin
  Writeln('FileCopy Utility Version ',Ver,', Copyright (C) 1995 Ivan Begtin');
  Writeln('Usage: infile outfile [startpos]');
  Writeln('  infile   - source filename      (def.ext. = dat)');
  Writeln('  outfile  - destination filename (def.ext. = xla)');
  Writeln('  startpos - starting position    (def = 0)');
  Halt;
 end;


Procedure Convert;
Var Result:word;
 Begin
  New(InFilePName);
  StrToPchar(InFileName,InFilePName);
  OpenFile(InFilePName,InFile);
  IsError;
  Writeln('Opening File... ', InFilePName);
  if StartPos <> 0 then
  Begin
   SeekFile(InFile, StartPos);
   Writeln('Seeking File ', InFilePName, ' to ', StartPos);
  end;
  Writeln('Now start file position is ', GetFilePos(InFile));
  New(OutFilePName);
  StrToPchar(OutFileName,OutFilePName);
  CreateFile(OutFilePName,StdAttr,OutFile);
  IsError;
  Writeln('Creating File... ',OutFileName);
  Writeln(K,'Copying File...');
  CopyFile;
  Writeln(K,'Done.');
  CloseFile(InFile);
  CloseFile(OutFile);
  Dispose(InFilePName);
  Dispose(OutFilePName);
 end;


Procedure SetTwo;
 Begin
  InFileName :=ParamStr(1);
  OutFileName:=ParamStr(2);
 end;

Procedure SetThree;
Var
  Code: Integer;
 Begin
  SetTwo;
  Val(ParamStr(3), StartPos, Code);
  if Code <> 0 then Help;
 end;

Begin
  OpenMode:= 2;
  if ParamCount < 3 then
   if ParamCount < 2 then Help
   else SetTwo
   else SetThree;
  Convert;
End.