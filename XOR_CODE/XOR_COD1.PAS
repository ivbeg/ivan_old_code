{** This program is very simple example of XOR cryptyng. **}
{** It is not optimized, adapted and haven't good interface **}
{** But I hope it will usefull for education. **}


PROGRAM   STANDARD_XOR_CODING;


Uses
  TSystem, TDos, TKeyb, TStrings;


Const
  cw_Algorithm_Standard   = $0001;
  cw_Algorithm_Floating   = $0002;
  cw_Algorithm_MultiLevel = $0003;
  cw_Algorithm_MultiBlock = $0004;

  cw_Algorithm_Filekey    = $0100;


  cs_Version            = '0.02';             {** "cs" - Constant, String **}
  cs_StartupString      = 'Xor_Code Utility Version ' + cs_Version + ', Copyright (C) 1997 Ivan Begtin';
  cs_StandardExtension  = 'XOR';
  cw_Zero               = $00000;
  gca_Signature         = 'XEC';          {** Xor EnCoded **}

Type
  TXorHeader    = record
    Signature  : array[1..3] of System.Char;
    Algorithm  : System.Word;
    Password   : System.Word;
  End;

  PBytesArray   =  ^TBytesArray;
  TBytesArray   =  array[0..$0FF80] of System.Byte;


Var
  filename_Input      :  PChar;
  filename_Output     :  PChar;
  str_InputFilename   :  String;
  str_OutputFilename  :  String;
  str_Password        :  String;
  gvb_PasswordSize    :  System.Byte absolute str_Password;
  gvw_Algorithm       :  System.Word;

  gvp_ReadBuffer      :  System.Pointer;
  gvw_ReadBufferSize  :  System.Word;


 procedure  FSplit(Path : TPathStr; var Dir : TDirectoryStr; var Name : TNameStr; var Ext : TExtStr);
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



procedure  _ShowHelpScreen;
Begin
  Writeln ('Usage for encoding: infile [outfile]');
  Writeln ('  infile   - source filename      (def.ext. = ???)');
  Writeln ('  outfile  - destination filename (def.ext. = xor)');
  Writeln;
  Writeln ('Usage for decoding: infile ');
  Writeln ('  infile   - source filename      (def.ext. = xor)');
  Halt;
End;



procedure  _ReadCommandLine;
Var
   str_Directory : TSystem.TDirectoryStr;
   str_Filename  : TSystem.TNameStr;
   str_Extension : TSystem.TExtStr;
Begin
  Writeln (cs_StartupString);
  if ParamCount = 0 then
    _ShowHelpScreen
  else
    Begin  {** if ParamCount <> 0 **}
      str_InputFilename:= ParamStr (1);
      FSplit (str_InputFilename, str_Directory, str_Filename, str_Extension);
      if ParamCount > 1 then
        str_OutputFilename:= ParamStr (2)
      else
        str_OutputFilename:= str_Filename +'.' +cs_StandardExtension;
    End;   {** if ParamCount <> 0 **}

  GetMem (filename_Input, $80);
  GetMem (filename_Output, $80);
  TStrings.StrPCopy (Addr (str_InputFilename), filename_Input);
  TStrings.StrPCopy (Addr (str_OutputFilename), filename_Output);
End;


procedure _ReadPassword;
Begin
  Write ('Please input password: ');
  Readln (str_Password);
End;


procedure _EncodeBuffer (Buffer: PBytesArray; BufferSize: System.Word);
Var
  lvw_Counter       : System.Word;
  lvb_SecondCounter : System.Byte;
Begin
  lvb_SecondCounter:= gvb_PasswordSize;
  Case gvw_Algorithm of
    cw_Algorithm_Standard:
      for lvw_Counter:= 0 to BufferSize do
        Buffer^[lvw_Counter]:= Buffer^[lvw_Counter] xor
            Byte (str_Password[(lvw_Counter + 1) mod gvb_PasswordSize]);
    cw_Algorithm_Floating:
        for lvw_Counter:= 0 to BufferSize do
        Begin
          Inc (lvb_SecondCounter, gvb_PasswordSize);
          Buffer^[lvw_Counter]:= (Buffer^[lvw_Counter] xor lvb_SecondCounter)
             xor Byte (str_Password[(lvw_Counter + 1) mod gvb_PasswordSize]);
        End;
  End;
End;



procedure _Coding;
Const
  lcw_FileAttributes = cw_Zero;   {** "lcw" - Local, Constant, Word **}
Var
  lvw_FReadHandle      : System.Word;  {** "lvw" - Local, Variable, Word **}
  lvw_FWriteHandle     : System.Word;
  lvw_ReadResult       : System.Word;
  lvw_WriteResult      : System.Word;
Begin
  FileOpenMode:= fo_mode_ReadWrite;
  OpenFile (filename_Input, lvw_FReadHandle);
  CreateFile (filename_Output, lcw_FileAttributes, lvw_FWriteHandle);

  gvw_ReadBufferSize:= $100 * Length (str_Password);
  GetMem (gvp_ReadBuffer, gvw_ReadBufferSize);

  {** Encoding **}
  repeat
    ReadFile (lvw_FReadHandle, gvp_ReadBuffer, gvw_ReadBufferSize, lvw_ReadResult);
    _EncodeBuffer (gvp_ReadBuffer, lvw_ReadResult);
    WriteFile (lvw_FWriteHandle, gvp_ReadBuffer, lvw_ReadResult, lvw_WriteResult);
  until (lvw_ReadResult = cw_Zero) or (lvw_ReadResult <> lvw_WriteResult);

  CloseFile (lvw_FReadHandle);
  CloseFile (lvw_FWriteHandle);
End;



Begin
  gvw_Algorithm:= cw_Algorithm_Standard;
  _ReadCommandLine;
  _ReadPassword;
  _Coding;
End.