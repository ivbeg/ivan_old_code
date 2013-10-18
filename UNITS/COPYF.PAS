{$M 16384,50000,655359}
{$F+}
{$S-}

Uses IvFiles,IvSystem,IvString,ShowTErr,Strings;
Const
 MaxWord = 65000;
type
 RecoP = ^Reco;
 Reco  = array[0..MaxWord] of Char;

Var File1,File2:word;
    NumRead,NumWrite:word;
    S1,S2:PChar;
    S3,S4:string;
    R:RecoP;
    P:pointer;
    Sk:longint;
    Size:word;
    P1:pointer;
 Begin
 If ParamCount <2 then
  Begin
   Writeln('Program File Copy. CopyRight.Ivan Begtin');
   Writeln('COPYF sourse dest');
   Halt;
  end;
  S3:=ParamStr(1);
  S1:=Addr(S3[1]);
  S4:=ParamStr(2);
  S2:=Addr(S4[1]);
  Write('Opening File2..',S1);
  OpenFile(S1,File2);
  Writeln;
  IsError;
  Write('Creating File1..',S2);
  CreateFile(S2,StdAttr,File1);
  Writeln;
  IsError;
  WriteLn('Read&Write File..');
  New(R);
  Writeln('Size of Reco: ',Sizeof(R^));
  repeat
   ReadFile(File2,R^,Sizeof(R^),NumRead);
   Writeln('Bytes Readed: ',NumRead);
   IsError;
   WriteFile(File1,R^,NumRead,NumWrite);
   Writeln('Bytes Writed: ',NumWrite);
   isError;
  until (NumRead = 0) or (NumWrite <> NumRead);
  Write('Close File1..');
  CloseFile(File1);
  Writeln;
  Write('Close File2..');
  CloseFile(File2);
  Writeln;
 end.