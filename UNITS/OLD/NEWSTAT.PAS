{$F+}
{$S-}
Program NewStat;
 Uses IvString,IvDos,IvSystem,IvCrt,IvEms,IvMemory,IvXms,ShowTErr,IvWindow,IvGraph;
 Const
  X ='>';
  gbHelpStrColor  = Brown;
  gbHelpDescColor = Gyan;
  gbWinColor      = Gyan;
  gbWinStrColor   = Brown;

 ColorArr:ColorRec =( 'BLACK','BLUE','GREEN','CYAN','RED','MAGENTA','BROWN',
                      'LIGHTGREY','DARKGREY','LIGHTBLUE','LIGHTGREEN',
                      'LIGHTGYAN','LIGHTRED','LIGHTMAGENTA','YELLOW','WHITE');

  Version = 'Version v0.035';
  MaxCount = 34;
  StrArr  :  Array[1..MaxCount] of string[7] = (
   'VER'    ,
   'EMS'    ,
   'FONE'   ,
   'TEXT'   ,
   'BORDER' ,
   'DUMP'   ,
   'SYSINFO',
   'CLS'    ,
   'HELP'   ,
   '?'      ,
   'MODE'   ,
   'SETRGB' ,
   'GETRGB' ,
   'SETREG' ,
   'GETREG' ,
   'QUIT'   ,
   'EXIT'   ,
   'Q'      ,
   'REBOOT' ,
   'MAXSTR' ,
   'SFT'    ,
   'MCB'    ,
   'XMS'    ,
   'PRG'    ,
   'MEM'    ,
   'VEC'    ,
   'D'      ,
   'SV'     ,
   'EXEC'   ,
   'BLINK'  ,
   'DOS'    ,
   'DEV'    ,
   'OW'     ,
   'CW');



  HelpArr : array[1..MaxCount] of String[50] = (
   'Return Program Version',
   'Return Expanded Memory Information',
   'Set Fone Color',
   'Set Text Color',
   'Set Border Color',
   'Dump Memory',
   'Return System Information',
   'Clear Screen',
   'This Help',
   'Else This Help',
   'Set/Get Video Mode',
   'Set RGB Register',
   'Get RGB Register',
   'Set Ega Palette Register',
   'Get Ega Palette Register',
   'Quit from Program',
   'Quit from Program',
   'Quit from Program',
   'Reboot Computer',
   'Set Maximum Strings',
   'List of Opened Files',
   'List of Memory Control Blocks',
   'Xms Memory Information',
   'List of Resident Programs',
   'Memory Information',
   'Return Interrupt Vector',
   'Fast Memory Dumping',
   'Dos System Variables',
   'Execute File',
   'Set Blinking',
   'Dos Information',
   'Device Drivers List',
   'Open  WINDOW! (not Windows)',
   'Close WINDOW!');


 Var
  S:string[8];
  K:str127;
  Num:byte;
  DumpPtr:pointer;
  Blink:boolean;
  TmpStr:string;

 { ** InterNal Procedures ** }

Procedure StartProgram;Far;Forward;

Function ColorCompare(Var S:string):byte;
Var C:byte;
 Begin
  S:=StrUpp(S);
  For C:=0 to 15 do
   Begin
    if S = ColorArr[C] then
     Begin
      ColorCompare:=C;
      Exit;
     End;
   ColorCompare:=$FF;
   end;
 end;

Procedure Dumping;
Const
 Z:char = #0;
Var
    Se,Ofe:word;
    I,K,L:byte;
    Code:integer;
Begin
  Se:=Seg(DumpPtr^);
  Ofe:=Ofs(DumpPtr^);
  For I:=0 to 7 do
   Begin
    IvCrt.WriteStr(HexW(Se)+':'+HexW(Ofe+I*16));
    For K:=0 to 15 do
     Begin
      IvCrt.WriteStr(Z+HexB(Mem[Se+I:Ofe+K]));
     end;
      IvCrt.WriteChar(Z);
    For L:=0 to 15 do
     Begin
      IvCrt.WriteChar(Chr(Mem[Se+I:Ofe+L]));
     end;
     IvCrt.EndL;
   end;
end;

 { ** Table Procedures ** }

Procedure None;
 Begin
  WriteStr('This Command Not Present'); EndL;
 end;

Procedure Help;
Var C:byte;
    OldAttr:byte;
 Begin
  SetCounter:=True;
  For C:=1 to MaxCount do
   begin
    OldAttr:=TextAttr;
    TextColor(gbHelpStrColor);
    WriteStr('"'+StrArr[C]+'"'); CursorXY(WindMin.X+10,GetY);
    TextAttr:=OldAttr;
    OldAttr:=TextAttr;
    TextColor(gbHelpDescColor);
    WriteStr(HelpArr[C]); EndL;
    TextAttr:=OldAttr;
   end;
  Counter:=0;
  SetCounter:=false;
 end;

Procedure Quit;
 begin
  CloseAllWins;
  Writeln('');
  Writeln('Ok. Program Ended.');
  Halt;
 end;

Procedure PrgVer;
 begin
  WriteStr(Version);EndL;
 end;

Procedure nsSetMode;
Var Mode:byte;

Procedure nsGetMode;
Const
 C:array[0..1] of String[5] = ('Text','Graph');
 Begin
  WriteStr('Current Mode: '+ HexB(BiosArea.CurrentMode)+'h');EndL;
  WriteStr('Mode Type   : '+ C[Byte(IsGraphMode)]);EndL;
  WriteStr('Max Columns : '+ Digit(BiosArea.MaxColumns));EndL;
  WriteStr('Max Strings : '+ Digit(BiosArea.MaxStrings+1));EndL;
  WriteStr('Letter High : '+ Digit(BiosArea.LetterHigh));EndL;
  WriteStr('Video Buffer: '+ Digit(BiosArea.VideoBuffSize));EndL;
  WriteStr('Video Page  : '+ Digit(BiosArea.CurrentPage));EndL;
  WriteStr('Scan  Lines : '+ Digit(TotalScanLines));EndL;

 End;

 Begin
  if CheckHex(ParamStr(1)) then
   Begin
    Mode:=DeHexB(ParamStr(1));
    IvCrt.VideoMode(Mode);
   end else
    nsGetMode;
 end;

Procedure SetMaxStrings;
 Var Code:integer;
     C:byte;
 Begin
  Val(ParamStr(1),C,Code);
  if Code = 0 then  Begin
   BiosArea.MaxStrings:=C;
   Window(WindMin.X,C,WindMax.X,WindMax.Y);
   ClrScr;
   InstallCrt;
  end;
  WriteStr('Max Strings: '+Digit(BiosArea.MaxStrings));EndL;
 end;

Procedure SetTextColor;
Var B    :byte;
    Code :integer;
 Begin
  Val(ParamStr(1),B,Code);
  if Code = 0 then  TextColor(B);
    WriteStr('Text Color :'+ColorArr[GetTextColor]);EndL;
 end;

Procedure SetFoneColor;
Var B:byte;
    Code:integer;
 Begin
  Val(ParamStr(1),B,Code);
  if Code = 0 then  TextBackGround(B);
    WriteStr('Fone Color :'+ColorArr[GetBackGroundColor]);EndL;
 end;

Procedure SysInfo;
 Begin
 end;

Procedure nsReboot;
 Begin
  IvSystem.Reboot;
 End;

Procedure EmsInfo;
 Const
   Bytes = ' bytes';
 Var P:PEmsArr;
     CountEms:word;
     C:word;
     X:LongInt;
     OldAttr:byte;
 Begin
  Str(TotalEmsPages*1024,TmpStr);
  WriteStr('Ems Memory Total = '+TmpStr+Bytes);EndL;
  Str(AvailEmsPages*1024,TmpStr);
  WriteStr('Ems Memory Free  = '+TmpStr+Bytes);EndL;
  WriteStr('Page Frame       = '+HexW(PageFrame));EndL;
  Str(TotalHandles,TmpStr);
  WriteStr('Total  Handles   = '+TmpStr);EndL;
  Str(ActivHandles,TmpStr);
  WriteStr('Active Handles   = '+TmpStr);EndL;
  Str(TotalRawPages,TmpStr);
  WriteStr('Total Raw Pages  = '+TmpStr);EndL;
  Str(FreeRawPages,TmpStr);
  WriteStr('Free Raw Pages   = '+TmpStr);EndL;
  New(P);
  CursorXY(30,GetY);
  OldAttr:=TextAttr;
  TextColor(Gyan);
  WriteStr('Ems Handles Table:'); EndL;
  TextAttr:=OldAttr;
  WriteStr('Handle  Pages   Size      Handle Name');EndL;
  WriteStr('------  -----   ----      -----------');EndL;
  CountEms:=EmsHandleTable(P);
  For C:=1 to CountEms do
   Begin
    X:=P^[C].Pages;
    Str(P^[C].Handle,TmpStr);
    WriteStr(TmpStr);              CursorXY(9,GetY);
    Str(P^[C].Pages,TmpStr);
    WriteStr(TmpStr);          CursorXY(17,GetY);
    Str(X*16384,TmpStr);
    WriteStr(TmpStr);                            CursorXY(27,GetY);
    WriteStr(CheckString(HandleName(P^[C].Handle)));EndL;
   end;
   Dispose(P);
 end;
end;

Procedure nsDump;
Var
    Se,Ofe:word;
 Begin
  IvCrt.WriteStr('Pointer = ');
  WriteStr('±±±±:±±±±');
  CursorXY(GetX-9,GetY);
  IvCrt.ReadLimStr(4,TmpStr,'±',False);
  Se:= IvString.DeHexW(TmpStr);
  CursorXY(WindMin.X+6+9,GetY);
  IvCrt.ReadLimStr(4,TmpStr,'±',True);
  Ofe:= IvString.DeHexW(TmpStr);
  DumpPtr:=Ptr(Se,Ofe);
  Dumping;
  DumpPtr:=Ptr(Se,OFe+$80);
end;

Procedure nsFastDump;
 Begin
  Dumping;
  DumpPtr:=Ptr(Seg(DumpPtr^),Ofs(DumpPtr^)+$80);
 end;

Procedure nsSftList;
Var SftArr:PSftArrT;
    ECount:word;
    CountSft:word;
    Count:word;
 begin
   New(SftArr);
  CountSft:=BuildSftList(SftArr);
  SetCounter:=true;
   For Count:=1 to CountSft do
    begin
    CursorXY(20,GetY);
     WriteStr('System File Table Num:');
     Str(Count,TmpStr);
     WriteStr(TmpStr);
     WriteStr(' Total Descriptors :');
     Str(SftArr^[Count].TotDesc,TmpStr);
     WriteStr(TmpStr);EndL;
    CursorXY(20,GetY);
     WriteStr('Address ');
     WriteStr(HexW(SftArr^[Count].Segm));
     WriteChar(':');
     WriteStr(HexW(SftArr^[Count].Offs));EndL;
     WriteStr(' Name         Handles   Size    Owner Name');EndL;
     WriteStr(' ----         -------   ----    ----------');EndL;
     ECount:=0;
     Repeat
      Inc(ECount);
      Begin
       Case SftArr^[Count].Arr[ECount].Free of
        False: Begin
                WriteStr(' '+SftArr^[Count].Arr[ECount].FileName);    CursorXY(15,GetY);
                Str(SftArr^[Count].Arr[ECount].Handles,TmpStr);
                WriteStr(TmpStr);                                     CursorXY(25,GetY);
                Str(SftArr^[Count].Arr[ECount].Size,TmpStr);
                WriteStr(TmpStr);          CursorXY(33,GetY);
                WriteStr(SftArr^[Count].Arr[ECount].OwnerName);EndL;
               End;
        True:  Begin
                WriteStr('Free Descriptors = ');
                Str(SftArr^[Count].TotDesc-ECount,TmpStr);
                WriteStr(TmpStr);EndL;
                ECount:=SftArr^[Count].TotDesc;
               End;
       end;
      end;
     Until ECount = SftArr^[Count].TotDesc;
      end;
     SetCounter:=false;
     Counter:=0;

      DisPose(SftArr);
    end;

Procedure nsMcbList;
var McbArr:PMcbArrT;
    CountMcb,Count:word;
 begin
  New(McbArr);
  CountMcb:=BuildMcbList(McbArr);
  SetCounter:=True;
   WriteStr('Segm:Offs   Name     Owner   Size     Type of Block   Parent ');EndL;
   WriteStr('---------   ----     -----   ----     -------------   ------ ');EndL;
   for Count:=1 to CountMcb do
    begin
     WriteStr(HexW(McbArr^[Count].Segm)+':'+HexW(0));
      CursorXY(13,GetY);
     WriteStr(McbArr^[Count].Name);
      CursorXY(22,GetY);
     WriteStr(HexW(McbArr^[Count].Owner));
      CursorXY(30,GetY);
      Str(McbArr^[Count].Size*16,TmpStr);
     WriteStr(TmpStr);
      CursorXY(39,GetY);
     WriteStr(McbArr^[Count].Typ);
      CursorXY(55,GetY);
     WriteStr(McbArr^[Count].Parent);EndL;
      end;
  SetCounter:= false;
  Counter:=0;
 Dispose(McbArr);
 end;

Procedure nsXmsInfo;
Var Count,CountXms:word;
     XmsArr:PXmsArrT;
 begin

 if XmsPresent then
  begin
  New(XmsArr);
  WriteStr('Testing Xms Memory...');
  CountXms:=BuildXmsList(XmsArr);
  EndL;
    WriteStr('Block   Handle   Size    Lock');EndL;
    WriteStr('-----   ------   ----    ----');EndL;
  For Count:=0 to CountXms do
     begin
      WriteStr(Digit(Count));             CursorXY(9,GetY);
      WriteStr(Digit(XmsArr^[Count].Handle));             CursorXY(18,GetY);
      WriteStr(Digit(XmsArr^[Count].Size));             CursorXY(26,GetY);
      WriteStr(Digit(XmsArr^[Count].Lock)); EndL;
     end;
    Dispose(XmsArr);
  end
  else
   begin
    WriteStr('High Memory Maneger not Present.'); EndL;
   end;
 end;

Procedure nsPrgList;
Var PrgArr:PPrgArrT;
    CountPrg,Count:word;
    Tmp:string[25];
 begin
  New(PrgArr);
   CountPrg:=BuildProgramsList(PrgArr);
   WriteStr('Segm:Offs   Name     Envir   Size     Parent   FullName ');EndL;
   WriteStr('---------   ----     -----   ----     ------   -------- ');EndL;
   For Count:=1 to CountPrg do
    begin
     WriteStr(HexW(PrgArr^[Count].Segm)+':'+HexW(0));
      CursorXY(13,GetY);
     WriteStr(PrgArr^[Count].Name);
      CursorXY(22,GetY);
     WriteStr(HexW(PrgArr^[Count].Envir));
      CursorXY(30,GetY);
     WriteStr(Digit(PrgArr^[Count].Size*16));
      CursorXY(39,GetY);
     WriteStr(PrgArr^[Count].Parent);
      CursorXY(48,GetY);
      Tmp:=PrgArr^[Count].FullName;
     WriteStr(Tmp);  EndL;
    end;
    DisPose(PrgArr);
 end;

Procedure nsIntVec;
Var B:byte;
    P:pointer;
 Begin
  B:=DeHexB(ParamStr(1));
  WriteStr('Int '+HexB(B)+'h Vector: '+HexPtr(IvSystem.GetIntVector(B))); EndL;
 end;


Procedure nsMemory;
Const BB = ' bytes';
 Begin
  WriteStr('Conventional Memory:'); CursorXY(26,GetY);
  WriteStr(Digit(LongInt(LowMem)*1024));
  WriteStr(BB);EndL;
  WriteStr('Free Memory:');CursorXY(26,GetY);
  WriteStr(Digit(MemAvail));
  WriteStr(BB);EndL;
  WriteStr('Extended(not Ems) Memory: ');CursorXY(26,GetY); WriteStr(Digit(ExtMem));EndL;
  WriteStr('Ems Present: '+SayNo(EmsPresent));EndL;
  WriteStr('Xms Present: '+SayNo(XmsPresent));EndL;
 end;

Procedure nsDos;
 Begin
  WriteStr('Dos Version: '+Digit(Lo(GetDosVersion))+'.'+Digit(Hi(GetDosVersion)));EndL;
  WriteStr('Current Drive: '+Char(GetCurrDrv+65)+':');EndL;
  WriteStr('Current Dir  : '+PchartoStr(CurrentDir(0)));EndL;
  WriteStr('Extended C-Break Check: '+SetOn(GetBreakF));EndL;
  WriteStr('Verify Flag: '+SetOn(GetVerifyF));EndL;
  WriteStr('System Variables: '+HexPtr(DosVarsTab));EndL;
  WriteStr('Dos Switch Char: '+GetSwitchChar);EndL;
 end;

Procedure nsSysVars;
 Begin
  WriteStr('First MCB: '+HexPtr(Ptr(SysVars^.FirstMcbSeg,0)));Endl;
  WriteStr('First Dpt: '+HexPtr(SysVars^.FirstDpt));Endl;
  WriteStr('First Sft: '+HexPtr(SysVars^.FirstSft));Endl;
  WriteStr('Disk Buff: '+HexPtr(SysVars^.DosDiskBuffer));EndL;
  WriteStr('Curr. Dir: '+HexPtr(SysVars^.CurrDirAddr));Endl;
  WriteStr('Fcb Table: '+HexPtr(SysVars^.FcbTableAddr));Endl;
  WriteStr('Drives   : '+Chr(1+64)+':- '+Chr(SysVars^.MaxDrives+64)+':');EndL;
  WriteStr('Boot Disk: '+Chr(SysVars^.BootDrive+64)+':');Endl;
  WriteStr('Using 386: '+SayNo(SysVars^.Use386));Endl;
  WriteStr('Ext. Mem.: '+Digit(LongInt(SysVars^.ExtMemSize)*1024)+' bytes');Endl;
 end;

Procedure nsExec;
Var P1:^PChar;
 Begin
  StrToPChar(ParamStr(1),P1^);
  FullExec(P1^,ParamStr(2));
  IsError;
 end;

Procedure nsBlink;
 Begin
 TmpStr:=StrUpp(ParamStr(1));
 if TmpStr = 'ON'  then Blink:= True  else
 if TmpStr = 'OFF' then Blink:= False;
 SetBlink(Blink);
  WriteStr('Blink Now: '+SayNo(Blink));EndL;
 end;

Procedure nsDev;
 Var CurrDev:DeviceDrvRecP;
  Begin
   SetCounter:=True;
   Counter:=0;
   CurrDev:=Addr(SysVars^.NullDevice);
   WriteStr('Segm:Offs  DevName  Attr');EndL;
   WriteStr('---------  -------  ----');EndL;
   repeat
    WriteStr(HexPtr(CurrDev)); CursorXY(WindMin.X+11,GetY);
    if BitofW(CurrDev^.DevAttr,15) then
     WriteStr(Digit(Ord(CurrDev^.Name[1]))+' units') else
    WriteStr(MemS(Addr(CurrDev^.Name),Sizeof(CurrDev^.Name)));CursorXY(WindMin.X+20,GetY);
    WriteStr(HexW(CurrDev^.DevAttr));EndL;
    CurrDev:=CurrDev^.NextDevice;
   Until Ofs(CurrDev^) = $FFFF;
   SetCounter:=False;
   Counter:=0;
  end;

Procedure nsClose;
 Begin
  CloseWindow;
 end;

Procedure nsOpen;
 Begin
  OpenWindow(WindMin.X+2,WindMin.Y+1,WindMax.X-2,WindMax.Y-1,gbWinStrColor,gbWinColor,Double,Digit(CurrWin+1));
 end;

 Const
  ProcArr :  Array[1..MaxCount] of procedure = (
    PrgVer    ,
    EmsInfo   ,
    SetFoneColor,
    SetTextColor,
    None      ,
    nsDump    ,
    None      ,
    ClrScr    ,
    Help      ,
    Help      ,
    nsSetMode ,
    None      ,
    None      ,
    None      ,
    None      ,
    Quit      ,
    Quit      ,
    Quit      ,
    Reboot    ,
    SetMaxStrings,
    nsSftList,
    nsMcbList,
    nsXmsInfo,
    nsPrgList,
    nsMemory,
    nsIntVec,
    nsFastDump,
    nsSysVars,
    nsExec,
    nsBlink,
    nsDos,
    nsDev,
    nsOpen,
    nsClose);



 Procedure CallProc;
  Var
   C:byte; Bool:boolean;
  Begin
    Bool:=True;
    For C:=1 to MaxCount do
     Begin
      If S = StrArr[C] then
       Begin
        Num:=C;
        ProcArr[C];
        Bool:=False;
        Exit;
       End;
     End;
     if Bool then
      WriteStr('Error Command');EndL;
  End;

Procedure StartProgram;
Var Count:byte;
Begin
  UseBios:=True;
  TextChar:=' ';
 Repeat
   WriteStr(X);
   ReadlimStr(WindMax.X-GetX,TmpStr,' ',true);
   DelChars(TmpStr,0,31);
   DelChars(TmpStr,123,255);
   S:=TmpStr;
   S:=StrUpp(S);
   Count:=Pos(' ',S);
   if Count > 0 then Byte(S[0]):= Count - 1 else Count:= 8;
   Delete(TmpStr,1,Count);
   K:=TmpStr;
   StrToParamStr(K);
   CallProc;
 Until TextChar = 'Z';
End;

Begin
 StartProgram;
end.
