Type
 TErrorRec = Record
              Error         : Byte;
              LastFunction  : Word;
              UsedInterrupt : Byte;
             end;


      {  **  GLOBAL Types For Everything  **  }

{ ** This Type of Function may be used in some Cycles ** }
{ ** Primes of this Functions:
  Unit       Function
  ----       --------
  IvKbd      KeyPresent

  IvMouse    LeftButton
             RightButton
             CentralButton

  IvGraph    IsCursorEm
             IsWaitDisplay
             IsVideoSysActive
             IsSaveBuffer
             VGABoardActive
             IsGreySumm
             IsDefPalLoad
             IsGraphMode
             IsBlink
             IsDoubleScan

  IvDos      GetVerifyF
             GetBreakF
             CheckKbd

  IvEms      EmsPresent

  IvXms      XmsPresent       ** }




      RepeatFunction = Function:boolean;

      {  **  Unit IVDISK.TPU. **  }

{  ** Bios Parameter Block Type ** }

      BptRecP = ^BptRec;
      BptRec  = record
                 CilsNum          :word;
                 HeadsNum         :byte;
                 XTRedWrite       :word;
                 PreComp          :word;
                 XTMaxECC         :byte;
                 CtrlByte         :byte;
                 XTStTimeOut      :byte;
                 XTFormTimeOut    :byte;
                 XTCheckTimeOut   :byte;
                 CilsNumLandZ     :word;
                 SectorsNum       :byte;
                 Reserved         :byte;
                end;

 { ** Floppy Drive Parameter Table ** }

PDiskParmsRec = ^DiskParmsRec;
DiskParmsRec  =  record
                  SpecW            :word;
                  DelayCount       :byte;
                  BytesPerSector   :byte;
                  SectPerTrack     :byte;
                  GapLen           :byte;
                  DataLen          :byte;
                  FormatGapLen     :byte;
                  FillerByte       :byte;
                  HeadSet          :byte;
                  MotorStart       :byte;
                 end;


       { **   Unit IVDOS.TPU  ** }

  { ** Dos Read/Write Sector Control Packet ** }
 ControlPacket   = record
                    FirstSec :longint;
                    Num      :word;
                    Buff     :pointer;
                   end;

  { ** Dos Time Record ** }
 TimeRecord      = record
                    Hour     :byte;
                    Minute   :byte;
                    Second   :byte;
                    Sec100   :byte;
                   end;

  { ** Dos Date Record ** }
 DateRecord      = record
                    Year     :word;
                    Month    :byte;
                    Day      :byte;
                   end;

  { ** Dos Buffered Input Record ** }
 DosBufferInpRecP= ^DosBufferInpRec;
 DosBufferInpRec = record
                    MaxNum   :byte;
                    ReadNum  :byte;
                    InpBuff  :array[0..255] of Char;
                   end;


 CommStrP      = ^CommStr;
 CommStr       = string[127];
 PathStr       = string[79];
 DirStr        = string[67];
 NameStr       = string[8];
 FileStr       = string[12];
 ExtStr        = string[4];
 FSplitRec     = record
                  Dir  : DirStr;
                  Name : NameStr;
                  Ext  : ExtStr;
                 end;



  { ** Program Execute Record For Functions 'EXEC' and 'FULLEXEC' ** }
 ExecFileBlock = record
                  EnvSeg       :word;
                  CommTail     :CommStrP;
                  Fcb1         :pointer;
                  Fcb2         :pointer;
                 end;

  { Record of Memory Control Block ** }
 McbBlockP     = ^McbBlock;
 McbBlock      = record
                  McbType      :Char;
                  Owner        :word;
                  Size         :word;
                  Reserv       :array[1..3] of byte;
                  Name         :array[1..8] of Char;
                 end;

  { ** Record of Device Driver Header ** }
 DeviceDrvRecP =^DeviceDrvRec;
 DeviceDrvRec  = record
                  NextDevice   :DeviceDrvRecP;
                  DevAttr      :word;
                  DevStrat     :word;
                  DevInterr    :word;
                  Name         :array[1..8] of Char;
                 end;

  { ** Dos Disk Parameter Table Type ** }
 DptRecP       =^DptRec;
 DptRec        = record
                  DrvNum       :byte;
                  UnitNum      :byte;
                  SectorBytes  :word;
                  ClustSectors :byte;
                  ShiftCount   :byte;
                  ResevSectors :word;
                  FATsNum      :byte;
                  RootDirEntry :word;
                  FirstUsedSect:word;
                  MaxClusters  :word;
                  FATSectors   :word;
                  FirstDirSect :word;
                  DriveDevice  :DeviceDrvRecP;
                  MediaID      :byte;
                  Access       :byte;
                  NextDpt      :DptRecP;
                  SearchClust  :word;
                  FreeClustNum :word;
                 end;

  { ** Type of One Block of Opened File ** }
 SftFileRecP   = ^SftFileRec;
 SftFileRec    = record
                  Handles      :word;
                  OpenMode     :word;
                  FileAttr     :byte;
                  DevAttr      :word;
                  DevOrDrvPtr  :pointer;
                  FirstClust   :word;
                  FileTime     :word;
                  FileDate     :word;
                  FileSize     :LongInt;
                  FilePos      :LongInt;
                  RelatClust   :word;
                  DirEntrySect :LongInt;
                  DirEntries   :byte;
                  Name         :array[1..8] of Char;
                  Ext          :array[1..3] of Char;
                  ShareTmp     :array[1..6] of byte;
                  OwnerPspSeg  :word;
                  LastCluster  :word;
                  ShareCode    :word;
                  IfsPtr       :pointer;
                 end;

  { ** System Files and 'FILES' Table ** }
 SftRecP       =^SftRec;
 SftRec        = record
                  NextSft      :SftRecP;
                  FilesNum     :word;
                  Files        :array[1..99] of SftFileRec;
                 end;

  { ** Dos Current Directory Area Type ** }
 CurrDirBlkRec = record
                  Directory    :array[1..67] of char;
                  DriveAttr    :word;
                  DptAddr      :DptRecP;
                  StartClust   :word;
                  Reserv1      :word;
                  Reserv2      :word;
                  CurrDirOfs   :word;
                  Reserv3      :byte;
                  IFSAddr      :pointer;
                  UsedbyIFS    :word;
                 end;

 CurrDirRecP   =^CurrDirArr;
 CurrDirArr    = array[0..25] of CurrDirBlkRec;

 { ** Dos System Variables **}
SysVarsRecP = ^SysVarsRec;
SysVarsRec=record
            CurrDiskBuff   :pointer;
            UnreadCONSeg   :word;
            FirstMCBSeg    :word;
            FirstDPT       :DptRecP;
            FirstSFT       :SftRecP;
            ClockAddr      :DeviceDrvRecP;
            CONAddr        :DeviceDrvRecP;
            SectorSize     :word;
            DosDiskBuffer  :pointer;
            CurrDirAddr    :CurrDirRecP;
            FcbTableAddr   :pointer;
            ProtectedFcbs  :word;
            BlockDevicesNum:byte;
            MaxDrives      :byte;
            NullDevice     :DeviceDrvRec;
            JoinedDrvs     :byte;
            SpecPrgNamesSeg:word;
            SetVerListAddr :pointer;
            DosHighOfs     :word;
            PspSeg         :word;
            BuffersNum     :word;
            HidBuffersNum  :word;
            BootDrive      :byte;
            Use386         :boolean;
            ExtMemSize     :word;
           end;

  { ** Prefix of Program Segment Type ** }
 PspRecP      = ^PspRec;
 PspRec       = record
                 RetComm          : word;
                 PrgMemSize       : word;
                 Reserv2          : array[1..6] of byte;
                 Int22Ptr         : pointer;
                 Int23Ptr         : pointer;
                 Int24Ptr         : pointer;
                 PrgOwnerSeg      : word;
                 JobFileTable     : array[1..20] of byte;
                 PrgEnvSeg        : word;
                 LastSS_SP        : pointer;
                 JftEntries       : word;
                 JftPointer       : pointer;
                 Reserv4          : array[1..72] of byte;
                 CommandLine      : String[127];
                end;

         { **    Unit IVSYSTEM.TPU    ** }

Pstring    = ^String;
PLongInt   = ^LongInt;
Pbyte      = ^byte;
PWord      = ^word;

PLongWord  = ^LongWord;
LongWord     = array[0..1] of Word;


SegOfs  = record
           O,S :word;
          end;

SecondTextCharsSetOvrRecP = ^SecondTextCharsSetOvrRec;
SecondTextCharsSetOvrRec  = record
                              Size         : byte;
                              RAMbank      : byte;
                              Reserv       : byte;
                              FontTable    : pointer;
                              ModesValues  : array[0..65000] of byte;
                             end;

DccTabRecP = ^DccTabRec;
DccTabRec  = record
              NumEntries  : byte;
              VersionNum  : byte;
              MaxTypeCode : byte;
              Reserv      : byte;
              DCCTable    : Array[0..255] of record
                                              Main   : byte;
                                              Second : byte;
                                             end;
             end;

PalProfileTabRecP = ^PalProfileTabRec;
PalProfileTabRec  = record
                     UnderLine             : byte;
                     Reserv1               : byte;
                     Reserv2               : word;
                     EgaColorsNum          : word;
                     EgaColorsIndex        : word;
                     EgaColorsTable        : pointer;
                     DacNumber             : word;
                     DacIndex              : word;
                     DacRegsTable          : pointer;
                     ModesValues           : array[0..65000] of byte;
                    end;
SecondVgaTabRecP = ^SecondVgaTabRec;
SecondVgaTabRec  = record
                    Size                   : word;
                    DCCTable               : DccTabRecP;
                    SecondTextCharsSetOvr  : SecondTextCharsSetOvrRecP;
                    PalProfileTable        : PalProfileTabRecP;
                   end;

DynamicSaveAreaRecP = ^DynamicSaveAreaRec;
DynamicSaveAreaRec  = record
                       EgaPalette  : array[0..15] of byte;
                       Overscan    : byte;
                       Reserv      : array[17..255] of byte;
                      end;

TextCharsSetOverrideRecP = ^TextCharsSetOverrideRec;
TextCharsSetOverrideRec  = record
                            CharSize      : byte;
                            RAMbank       : byte;
                            CharsNumber   : word;
                            FirstCharCode : word;
                            FontTable     : pointer;
                            MaxRows       : byte;
                            ModesValues   : array[0..65000] of byte;
                           end;

GraphCharsSetOverrideRecP = ^GraphCharsSetOverrideRec;
GraphCharsSetOverrideRec  = record
                             MaxRows      : byte;
                             CharSize     : word;
                             FontTable    : pointer;
                             ModesValues  : array[0..65000] of byte;
                            end;



VideoSavePtrTableRecP = ^VideoSavePtrTableRec;
VideoSavePtrTableRec = record
                        VideoParTab           : pointer;
                        DynamicSaveArea       : DynamicSaveAreaRecP;
                        TextCharsSetOverride  : TextCharsSetOverrideRecP;
                        GraphCharsSetOverride : GraphCharsSetOverrideRecP;
                        SecondVGATable        : SecondVgaTabRecP;
                        Reserved              : array[0..1] of pointer;
                       end;



BiosAreaRec = record
              UsedCOM  :array[1..4] of word;
              UsedLPT1 :array[1..4] of word;
              EquirFlag           :word;
              PostInstFlags       :byte;
              MemorySize          :word;
              PostTimeArea        :word;
              KeyFlag             :word;
              InputCode           :byte;
              KbdBuffStart        :word;
              KbdBuffEnd          :word;
              KbdBuffer           :Array[1..16] of record
                                                    CharCode:Char;
                                                    ScanCode:byte;
                                                   end;
              FloppyFlag          :byte;
              FloppyMotor         :byte;
              MotorCount          :byte;
              FloppyStatus        :byte;
              DrvStatusArr        :array[1..7] of byte;
              CurrentMode         :byte;
              MaxColumns          :word;
              VideoBuffSize       :word;
              PageAddr            :word;
              CursorPos           :array[0..7] of record
                                                   X,Y:byte;
                                                  end;
              CursorSizeY         :byte;
              CursorSizeX         :byte;
              CurrentPage         :byte;
              CRTAddr             :word;
              CRTModeReg          :byte;
              CGAPalette          :byte;
              PostSelfCheck       :LongInt;
              PostInterrupt       :byte;
              Timer               :LongInt;
              TimerFlag           :byte;
              CtrBreakFlag        :byte;
              RebootFlag          :word;
              HardStatus          :byte;
              HardNum             :byte;
              Reserved1           :word;
              LPTTimeWait         :array[1..4] of byte;
              COMTimeWait         :array[1..4] of byte;
              KbdBuffS            :word;
              KbdBuffE            :word;
              MaxStrings          :byte;
              LetterHigh          :word;
              EgaFlags            :byte;
              EgaSwitches         :byte;
              VgaFlags            :byte;
              MainDCC             :byte;
              FloppySpeed         :byte;
              HardContrStatus     :byte;
              HardContrError      :byte;
              HardContrInterrupt  :byte;
              FloppyHardFl        :byte;
              FloppySStatus       :array[1..4] of byte;
              FloppyTrack         :word;
              ExtKbdFlag          :byte;
              KbdIndicators       :byte;
              ProcessEndFlag      :pointer;
              TimerOut            :longint;
              TimeStopFlag        :byte;
              Reserved2           :array[1..7] of byte;
              VideoTabAddr        :VideoSavePtrTableRecP;
              Reserved3           :array[1..72] of byte;
              ICABuffer           :array[0..15] of byte;
             end;

       { ** Unit IVSTRING.TPU ** }
{** Special String ** }
ExtStringP = ^ExtString;
ExtString  = record
              BuffSize   : word;
              RealSize   : word;
              S          : PChar;
             end;


 { ** Strings and Pchar Types  ** }
Str2  = String[2];
Str3  = String[3];
Str4  = String[4];
Str5  = String[5];
Str8  = String[8];
Str9  = String[9];
Str16 = String[16];
Str78 = String[78];
Str64 = String[64];
Str80 = String[80];
Str127= String[127];
AnyString = string[255];
PcharEntry = ^Pchar;

            { ** Unit IVMOUSE.TPU ** }

 PMouseInfo = ^MouseInfo;
 MouseInfo = record
              ButtonState,
              Count,
              LastX,
              LastY       :word;
             end;
 PMouseGraphBlock = ^MouseGraphBlock;
 MouseGraphBlock  = array[0..1] of array[0..15] of Word;

            { ** Unit IVKBD.TPU ** }
 PCharScan = ^CharScan;
 CharScan = record
             CharCode :byte;
             ScanCode :byte;
            end;

            { ** Unit IVGRAPH.TPU ** }

 TScroll    = (Up,Down);
 TRgb       = Record
               R,G,B:byte;
              end;

 VGAPalette = Array[0..255] of TRgb;
 TPoint     = Record
               X,Y:word;
              end;
 TWinPos    = record
               Y,X:Byte
              end;

 ScanType = (Scan200,Scan350,Scan400);

 CursorBlinkType = (Normal,Hidden,Wild,Slow);

 VideoInfoTab    = record
                    StatTable      : pointer;
                    CurrMode       : byte;
                    MaxColumns     : word;
                    VideoPageSize  : word;
                    StartAddr      : word;
                    CursorPos      : array[0..7] of record
                                                     X,Y:byte;
                                                    end;
                    CursorStart    : byte;
                    CursorEnd      : byte;
                    CRTCport       : word;
                    CrtModeSet     : byte;
                    Crt_Palette    : byte;
                    MaxStrings     : byte;
                    LetterSize     : byte;
                    FirstDCC       : byte;
                    SecondDCC      : byte;
                    MaxColors      : byte;
                    MaxPages       : byte;
                    ScanLines      : byte;
                    Block1         : byte;
                    Block2         : byte;
                    MiscInfo       : byte;
                    Reserv1        : array[$2E..$30] of byte;
                    InstalledMem   : byte;
                    SaveAreaStatus : byte;
                    Reserv2        : array[$33..$3F] of byte;
                   end;

            { ** Unit IVEMS.TPU ** }

TEmsHandleName = Array[1..8] of Char;
EmsHardWareInfoRec = record
                      RawPagesSize        : word;
                      AltRegsSet          : word;
                      SaveContextBuffSize : word;
                      DMAregs             : word;
                      DMAOperationType    : word;
                     end;
 EmsBlock = record
  Handle:word;
  Pages:word;
 end;
PEmsArr =^EmsArr;
EmsArr  = array[1..128] of EmsBlock;

         { ** Unit IVWINDOW.TPU ** }

  FrameArr = array[1..8] of Char;
  WindowPtr = ^WindowRec;
  WindowRec = record
   X1,Y1       : byte;
   X2,Y2       : byte;
   ForeGround  : byte;
   BackGround  : byte;
   OldX        : byte;
   OldY        : byte;
   Frame       : FrameArr;
   Buff        : pointer;
   BuffSize    : Word;
  end;
