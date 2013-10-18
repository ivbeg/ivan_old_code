{$X+}
Program Monitor_Status;
 Uses Grp,Drive,Crt,Strings,Hardware,Module,Ems;
 type
  Str8 = String[8];

 const
  {** Program Version **}
   Version       =       'Version 2.03 of Monitor Status';

  {** Operand Constants **}
   EmsInfo       =        'ems';
   SetFoneColor  =       'fone';
   TSRMap        =        'tsr';
   DevDrvMap     =        'drv';
   VideoTable    =        'tab';
   SetTextColor  =       'text';
   GetDosVersion =     'dosver';
   ProgramVer    =        'ver';
   DriveInfo     =      'drive';
   TotMemorySize =     'memory';
   SystemInfo    =       'info';
   GetRGBColors  =     'getrgb';
   SetRGBColors  =     'setrgb';
   Reboot        =     'reboot';
   ReadMemByte   =       'dump';
   SetLetterHigh =     'hilett';
   SetMaxStrings =     'maxstr';
   OverScanColor =     'border';
   ClearScreen   =        'cls';
   GetCursorForm =    'getform';
   SetCursorForm =    'setform';
   GetVideoInfo  =    'getmode';
   SetVideoMode  =    'setmode';
   Help          =          '?';
   Quit          =       'quit';
       { ** TSR Map Constants ** }

   A1 = 'M';         A2 = 'Z';
   A3 = 'S';         A4 = 'E';
   A5 = 'D';         A6 = 'F';
   A7 = 'B';         A8 = 'L';
   A9 = 'X';         A10 = 'C';
   A11 = 'I';

   { ** Zero Const ** }
   Z:Char = ' ';


   { ** Program Variables ** }
var   AA1,AA2,AA3,AA4,AA5:byte;
      Segm,Offs,Se,Ofe,Own:word;
      Sega,Ofa:word;Name:string;
      Ivan:String;
      Typ:Char;
      Siz:LongInt;
      String1:array[0..79] of Char;
      A:array[0..79] of Char;
      S:string[79];
      x,y,w,b:word;
      Color,K,I,L:byte;
      Count:word;
      Mode:integer;
      ClearScree,SystemActiv,WaitRetrac,Mon,VGA,Curso,Switc,MDis,GreySumm,LoadPal:Boolean;
      VidSize:integer;
      Bytes,FrClusters,IsClusters,Sectors:LongInt;
      ScanL:integer;

            { *** Main Part *** }

begin
 CheckBreak:=False;          { ** If you want to exit ,insert 'Q' ** }
 repeat
 Write('>');
 Readln(S);
 StrPCopy(A,S);
 S:=StrPas(StrLower(A));
 if  S = Help then begin
 Writeln( ' Help ');
 Writeln('        ',StrUpper(OverScanColor),  ' Set OverScan Color ');
 Writeln('        ',StrUpper(SetFoneColor),   ' Set BackGround Color');
 Writeln('        ',StrUpper(GetDosVersion),  ' Return Dos Version');
 Writeln('        ',StrUpper(ProgramVer),     ' Version of Monitor Status');
 Writeln('        ',StrUpper(Quit),           ' Exit from Monitor Status');
 Writeln('        ',StrUpper(TSrMap),         ' Show TSR Programs');
 Writeln('        ',StrUpper(ClearScreen),    ' Clear Screen');
 Writeln('        ',StrUpper(Reboot),         ' Reboot Computer');
 Writeln('        ',StrUpper(SetTextColor),   ' Set Text Color ');
 Writeln('        ',StrUpper(TotMemorySize),  ' Return Total Memory Size' );
 Writeln('        ',StrUpper(DriveInfo),      ' Disk Information');
 Writeln('        ',StrUpper(SystemInfo),     ' System Information');
 Writeln('        ',StrUpper(GetRGBColors),   ' Getting Colors(Red,Green,Blue)');
 Writeln('        ',StrUpper(SetRGBColors),   ' Getting Colors(Red,Green,Blue)');
 Writeln('        ',StrUpper(ReadMemByte),    ' Reading and Decoding Byte From Memory');
 Writeln('        ',StrUpper(SetLetterHigh),  ' Set High of Letters');
 Writeln('        ',StrUpper(SetMaxStrings),  ' Set Max Strings on the Screen');
 Writeln('        ',StrUpper(GetCursorForm),  ' Get Form Of Cursor');
 Writeln('        ',StrUpper(SetCursorForm),  ' Set Form Of Cursor');
 Writeln('        ',StrUpper(GetVideoInfo),    ' Information About Current Video Status ');
 Writeln('        ',StrUpper(Help),           ' This Help');
  end;
 if S = ClearScreen then begin
  mClrTxtScr;
  end;
 if S = Reboot then begin
    mReboot;
 end;
 if S = SetMaxStrings then begin
    Write(StrUpper(SetMaxStrings),'> ', 'Count = ');
    Readln(Count);
    mSetMaxStrings(Count);
 end;
 if S = TotMemorySize then begin
    Writeln(StrUpper(TotMemorySize),'> ',pGetLowMemSize,' KB  ' ,pGetExtMemSize,' KB');
 end;
 if S = SetVideoMode then begin
     Write(StrUpper(SetVideoMode),'> ', ' Mode = ');
     Readln(Mode);
     bSetMOde(MOde);
 end;
 if S = GetDosVersion then begin
    Writeln(StrUpper(GetDosVersion),'> ','Dos Version: ',DosVer);
    end;
 if S = ProgramVer then begin
     Writeln(StrUpper(ProgramVer),'> ',Version);
     end;
 if S = OverScanColor then begin
    Write(StrUpper(OverScanColor),'> ', 'Color = ');
    Readln(Color);
    bOverScan(Color);
    end;
 if S = Quit then
    begin
     Halt(0);
     end;
 if S = SetTextColor then
  Begin
   Write(SetTextColor,'> ','Color = ');
   Readln(Color);
   bSetColor(7,Color);
   end;
 if S = SetFoneColor then
  Begin
   Write(StrUpper(SetFoneCOlor),'> ','Color = ');
   Readln(Color);
   bSetColor(0,Color);
   end;
 if S = GetVideoInfo then
  begin
   mReadVideoStatus(ClearScree,SystemActiv,WaitRetrac,Mon,Curso,VidSize);
   mReadVGAflags(ScanL,Switc,LoadPal,Mdis,GreySumm,Vga);

   Writeln(StrUpper(GetVideoInfo),'> ',' Mode         = ',mReadMode    ,'           ClearScreen: ',SayNo(ClearScree));
   Writeln(StrUpper(GetVideoInfo),'> ',' MaxStrings   = ',mGetStrings   ,'          SystemActive:',SayNo(SystemActiv));
   Writeln(StrUpper(GetVideoInfo),'> ',' MaxColumns   = ',mGetColumns   ,'          WaitRetrace: ',SayNo(WaitRetrac));
   Writeln(StrUpper(GetVideoInfo),'> ',' VideoPage    = ',mGetVideoPage,'           Mono:        ',SayNo(Mon));
   Writeln(StrUpper(GetVideoInfo),'> ',' Address6845 = ',mGetAddress6845 ,'          Cursor Em.:  ',SayNo(Curso));
   Writeln(StrUpper(GetVideoInfo),'> ',' CTR_Mode     = ', mGetCTRMode ,'           VGA Active:  ',SayNo(VGA));
   Writeln(StrUpper(GetVideoInfo),'> ',' CTR_PALETTE  = ',mGetCTRPal    ,'          Disp.Switch: ',SayNo(Switc));
   Writeln(StrUpper(GetVideoInfo),'> ',' VideoBuffer  = ',VidBufSize   ,'        GreySumm:    ',SayNo(GreySumm));
   Writeln(StrUpper(GetVideoInfo),'> ',' VideoMemSize = ',VidSize       ,'           Mono Disp.:  ',SayNo(MDis));
   Writeln(StrUpper(GetVideoInfo),'> ',' ScanLines    = ',ScanL           ,'         LoadPal:     ',SayNo(LoadPal));
   Writeln(StrUpper(GetVideoInfo),'> ',' LetterHigh   = ',mGetLettHigh   ,'          VideoStart = ',VideoStart);
  end;
 if S = SystemInfo then
  begin
   Writeln(StrUpper(SystemInfo),'> ','Computer Type :  ',mGetCompType);
   Writeln(StrUpper(SystemInfo),'> ','Computer Date :  ',mCompDate);
   Writeln(StrUpper(SystemInfo),'> ','Monitor  Date :  ',mVideoDate);
   Writeln(StrUpper(SystemInfo),'> ','Floppy Drives  = ',mFloppyNum);
   Writeln(StrUpper(SystemInfo),'> ','Floppy Drive 1 = ',pFloppyType1);
   Writeln(StrUpper(SystemInfo),'> ','Floppy Drive 2 = ',pFloppyType2);
   Writeln(StrUpper(SystemInfo),'> ','Printers       = ',mNumPrinters);
   Writeln(StrUpper(SystemInfo),'> ','VideoRam Size  = ',mVideoRam);
   Writeln(StrUpper(SystemInfo),'> ','RS - 232 Ports = ',mRS232);
   Writeln(StrUpper(SystemInfo),'> ','Start Mode     = ',mStartMode);
   Writeln(StrUpper(SystemInfo),'> ','CoProcessor    = ',SayNo(mCoProc));
   Writeln(StrUpper(SystemInfo),'> ','Game Adapter   = ',SayNo(mGameAd));
  end;
 if S = DriveInfo then
  begin
   Write(DriveInfo,'> ', 'Drive Number = ');
   Readln(Count);
   GetDrvInfo(Count,Bytes,FrClusters,IsClusters,Sectors);
   if Sectors = 65535 then
    begin
     Writeln(StrUpper(DriveInfo),'> ','Error in Drive Number or Drive not ready.');
     end
     else
     begin

   Writeln(StrUpper(DriveInfo),'> ',' TotalClusters = ',IsClusters);
   Writeln(StrUpper(DriveInfo),'> ',' FreeClusters  = ',FrClusters);
   Writeln(StrUpper(DriveInfo),'> ',' Sectors in Cluster = ',Sectors);
   Writeln(StrUpper(DriveInfo),'> ',' Bytes in Sector = ',Bytes);
   Writeln(StrUpper(DriveInfo),'> ',' Total Drive Space = ',Bytes*Sectors*ISClusters, ' bytes');
   Writeln(StrUpper(DriveInfo),'> ',' Free  Drive Space = ',Bytes*Sectors*FrClusters, ' bytes');
  end;
  end;
 if S = TsrMap then
begin

 DosTableAdr(Segm,Offs);
 Se:=MemW[Segm:Offs-2]+1;

repeat

GetMCB(Se,Typ,Own,Siz,Ivan);
Writeln('');
Writeln(StrUpper(TSrMap),'> ','Address = ',HexWord(Se+1));
Writeln(StrUpper(TSrMap),'> ','Type of Block = ',BlockType(Typ));
Writeln(StrUpper(TSrMap),'> ','Owner of Block = ',HexWord(Own));
Writeln(StrUpper(TSrMap),'> ','Size of Block = ',Siz);


if Typ = A1 then
 begin
  if HexWord(Se+1) = HexWord(Own) then
   begin
  Writeln(StrUpper(TSrMap),'> ','Enviroment Addr = ',HexWord(PspEnvSeg(Se+1)));
  Writeln(StrUpper(TSrMap),'> ','Owner = ',HexWord(PspOwner(Se+1)));
  Writeln(StrUpper(TSrMap),'> ','Memory Top = ',HexWord(PspMemTop(Se+1)));
  Writeln(StrUpper(TSrMap),'> ','Name of Program = ',GetString(Se,$8));
  Writeln(StrUpper(TSrMap),'> ','Type = ','Com or Exe Program.');
   end
  else
   begin
    Writeln(StrUpper(TSrMap),'> ','Type = ','Enviroment.');
   end;
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
  Writeln(StrUpper(TSrMap),'> ','Name of Block = ',Ivan);
  Writeln(StrUpper(TSrMap),'> ','Device Driver Name = ',GetString(Se+1,$A));

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
Writeln('Any Key to Continue..');
ReadKey;
Se:=Se + MemW[Se:0003]+1;
until (Se=$A000) or (Own=$0);
end;
if S = DevDrvMap then
 begin
  DosTableAdr(Segm,Offs);
  Sega:=MemW[Segm:Offs+$24];
  Ofa:=MemW[Segm:Offs+$22];
 repeat
  Se:=Sega;
  Ofe:=Ofa;
  Ivan:=GetString(Se,Ofe+$0A);
  Writeln(StrUpper(DevDrvMap),'> ','Address = ',HexWord(Se),':',HexWord(Ofe));
  if Mem[Se:Ofe+$0A] < 32 then
   begin
    Writeln(StrUpper(DevDrvMap),'> ','Device Block of ',Mem[Se:Ofe+$0A],' Drivers.');
   end
   else
   begin
  Writeln(StrUpper(DevDrvMap),'> ','Device Name = ',Ivan);
  end;
  Sega:=MemW[Se:Ofe+$2];
  Ofa:=MemW[Se:Ofe];
  Writeln(StrUpper(DevDrvMap),'> ','Any key to continue..');
  Readkey;
 until (Ofa = $FFFF) or KeyPressed;
end;
 if S = EmsInfo then
  begin
   Writeln(StrUpper(EmsInfo),'> ','Ems Driver Version = ',EmsVersion);
   Writeln(StrUpper(EmsInfo),'> ','Total Expanded Memory = ',TotalEmsSize,'kb');
   Writeln(StrUpper(EmsInfo),'> ','Available Expanded Memory = ',AvailEmsSize,'kb');
   Writeln(StrUpper(EmsInfo),'> ','Handles Count = ',ActivHandles);
  end;
 if S = ReadMemByte then
begin
 Write(StrUpper(ReadMemByte),'> ','Segment = ');
 Readln(Se);
 Write(StrUpper(ReadMemByte),'> ','Offset = ');
 Readln(Ofe);
 Nosound;
  for I:=0  to 7 do
   begin
    Write(HexWord(Se),':',HexWord(Ofe+I*16));
     for K:=0 to $0F do
      begin
       Write(Z,HexByte(Mem[Se+I:Ofe+K]));
      end;
       Write(Z);
     for L:=0 to $0E do
      begin
       mDispCharT(Chr(Mem[Se+I:Ofe+L]));
      end;
     Writeln(Chr(Mem[Se+I:Ofe+$0F]));
   end;
end;

if S = VideoTable then
 begin
  Segm:=MemW[$40:$AA];
  Offs:=MemW[$40:$A8];
  Se:=MemW[Segm:Offs+2];
  Ofe:=MemW[Segm:Offs];
 Write('Video Mode = ');
 Readln(I);
 Se:=Se+I*4;
 x:=Mem[Se:Ofe];
 y:=Mem[Se:Ofe+1];
 w:=Mem[Se:Ofe+2];
 b:=MemW[Se:Ofe+3];
 AA1:=Mem[Se:Ofe+5];
 AA2:=Mem[Se:Ofe+6];
 AA3:=Mem[Se:Ofe+7];
 AA4:=Mem[Se:Ofe+8];
 AA5:=Mem[Se:Ofe+9];
 Writeln(StrUpper(VideoTable),'> ','Mode = ',I);
 Writeln(StrUpper(VideoTable),'> ','Columns = ',x);
 Writeln(StrUpper(VideoTable),'> ','Strings = ',y+1);
 Writeln(StrUpper(VideoTable),'> ','Lett High = ',w);
 Writeln(StrUpper(VideoTable),'> ','Video Buffer Size = ',b);
 Writeln(StrUpper(VideoTable),'> ','Sequencer Regs = ',AA1,' ',AA2,' ',AA3,' ',AA4);
 Writeln(StrUpper(VideoTable),'> ','Misc. OutPut = ',AA5);
 Write(StrUpper(VideoTable),'> ','CRTC Regs :');
 for K:=0 TO 23 DO
  begin
   Write(Mem[Se:Ofe+10+K],' ');
  end;
   Writeln(Mem[Se:Ofe+10+24],' ');
 Write(StrUpper(VideoTable),'> ','Attr. Controller Regs :');
 for K:=0 TO 18 DO
  begin
   Write(Mem[Se:Ofe+$23+K],' ');
  end;
   Writeln(Mem[Se:Ofe+$23+19],' ');
 Write(StrUpper(VideoTable),'> ','Graph. Controller Regs :');
 for K:=0 TO 7 DO
  begin
   Write(Mem[Se:Ofe+$37+K],' ');
  end;
   Writeln(Mem[Se:Ofe+$37+8],' ');

 ReadKey;
 Se:=Se+4;

 end;







until KeyPressed;
end.







