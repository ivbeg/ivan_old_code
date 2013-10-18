{$X+}

PROGRAM  SHOW_DIFFERENT_HARDWARE_AND_SOFTWARE_INFORMATION;


USES
   TSystem, TDos, TXms, TStrings, TDisk;


TYPE
   TProcedureCallRecord = record
      _Command        : System.PChar;
      _CommandLine    : System.PChar;
      _CommandAddress : System.Pointer;
   End;


CONST
   cs_start_Standard            = '>';

   cs_command_ShowHelp: PChar          = 'help';
   cs_command_ShowXmsInfo: PChar       = 'xmsinfo';
   cs_command_ShowEmsInfo: PChar       = 'emsinfo';
   cs_command_ShowDosInfo: PChar       = 'dosinfo';
   cs_command_MemoryMap: PChar         = 'memmap';
   cs_command_MemoryDump: PChar        = 'dump';
   cs_command_AboutProgram: PChar      = 'about';
   cs_command_SystemInfo: PChar        = 'sysinfo';
   cs_command_Exit: PChar              = 'exit';
   cs_command_Quit: PChar              = 'quit';
   cs_command_DeviceList: PChar        = 'devlist';
   cs_command_Options: PChar           = 'options';

   cb_CommandsNumber            = 12;


VAR
   ds_StartString: System.PChar;
   ds_Command    : System.PChar;
   ds_LastCommand: System.PChar;
   db_Exit       : System.Boolean;



PROCEDURE LowCaseString (VAR _Str: String);
VAR
   temp_Counter: System.Byte;
BEGIN
  IF System.Byte (_Str[0]) <> 0 THEN
  FOR temp_Counter:=1 TO System.Byte (_Str[0]) DO
    _Str[temp_Counter]:=Russian_LowCase (_Str[temp_Counter]);
END;



PROCEDURE IdentifityCommand (Command: String);
VAR
   _Command: System.PChar;
BEGIN
  New (_Command);
  StrPCopy (Addr (Command), _Command);
  IF (_Command = cs_command_Exit) OR (_Command = cs_command_Quit) THEN
    db_Exit:= True
  ELSE
    Writeln ('Still don'+#39+'t work.');
END;


PROCEDURE  Init_Status;
Var
   string__Command: String;
Begin
  New(ds_StartString);
  ds_StartString:= cs_start_Standard;
  New(ds_Command);
  db_Exit:= False;
   repeat
     Write (ds_StartString);
     ReadLn (string__Command);
     LowCaseString (string__Command);
     IdentifityCommand (string__Command);
   until db_Exit;
End;




BEGIN
  Init_Status;
END.

