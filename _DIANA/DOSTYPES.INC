CONST
     CD_Sign          = 'MSCD';
     ROM_Sign         = $AA55;
     PSP_Sign         = $20CD;
     End_of_Chain     = $FFFF;
     EXE_Sign         = $5A4D;
     Last_MCB         = $5A;
     Std_MCB          = $4D;


TYPE
  TString4           = String[4];
  TString8           = String[8];

  TCpuVendor         = array[1..12] of System.Char;

  PRomInfoRec        = ^TRomInfoRec;
  TRomInfoRec        = record
    Signature          : System.Word;
    Size_512           : System.Byte;
  end;

  PCmosRec           = ^TCmosRec;
  TCmosRec           = record

  end;

  TVGA_Memory        = array[0..319,0..199] of System.Byte;
  TTextPoint         = record
    Attribute           : System.Byte;
    Character           : System.Char;
  end;

  TStdText_Memory    = array[0..7,0..79,0..24] of TTextPoint;


  PExeHeader         = ^TExeHeader;
  TExeHeader         = record
    Signature           : System.Word;
    PartialPage         : System.Word;
    PageCount           : System.Word;
    RelocateCount       : System.Word;
    HeaderSize          : System.Word;
    MinMem              : System.Word;
    MaxMem              : System.Word;
    ReloSS              : System.Word;
    ExeSP               : System.Word;
    Checksum            : System.Word;
    ExeIP               : System.Word;
    ReloCS              : System.Word;
    TableOffset         : System.Word;
    Overlay             : System.Word;
  end;

  PBorlandDebugInfo  = ^TBorlandDebugInfo;
  TBorlandDebugInfo  = record
    Signature           : System.Word;
    Version             : System.Word;
    NamePool_Size       : System.Longint;
    Names               : System.Word;
    TypeEntries         : System.Word;
    StructureMembers    : System.Word;
    Symbols             : System.Word;
    GlobalSymbols       : System.Word;
    Modules             : System.Word;
    Locals              : System.Word;
    ScopesInTable       : System.Word;
    Line_Number         : System.Word;
    IncludeFiles        : System.Word;
    SegmentRecords      : System.Word;
    FileCorellations    : System.Word;
    LoadImage_Size      : System.Longint;
    DebuggerHook        : System.Pointer;
    ProgramFlags        : System.Byte;
    Unused_1            : System.Word;
    DataPool_Size       : System.Word;
    Padding_1           : System.Byte;
    FollowExt_Size      : System.Word;
    Classes             : System.Word;
    Parents             : System.Word;
    GlobalClasses       : System.Word;
    Overloads           : System.Word;
    ScopeClasses        : System.Word;
    ModuleClasses       : System.Word;
    CoverageOffsets     : System.Word;
    SymbolBaseOffset    : System.Longint;
    BrowserInfoRecords  : System.Word;
    DebuggingFlags      : System.Word;
  end;

  TSectorBuffer      = array[1..512] of System.Byte;

  TInterruptTable    = array[0..255] of System.Pointer;

  TSegOfs            = record
    O,S                  : System.Word;
  end;

  PByte              = ^Byte;
  PWord              = ^Word;
  PLongInt           = ^Longint;
  PString            = ^String;

  PProcedure         = ^TProcedure;
  TProcedure         = Procedure;

  PPathStr           = ^TPathStr;
  TPathStr           = string[79];

  PCommandStr        = ^TCommandStr;
  TCommandStr        = string[127];

  PDirectoryStr      = ^TDirectoryStr;
  TDirectoryStr      = string[67];

  PNameStr           = ^TNameStr;
  TNameStr           = string[8];

  PFileStr           = ^TFileStr;
  TFileStr           = string[12];

  PExtStr            = ^TExtStr;
  TExtStr            = string[4];

  TStr8              = string[8];


  TFileExt           = array[1..3] of System.Char;
  TDosName           = array[1..8] of System.Char;
  TDosPath           = array[1..64] of System.Char;
  TDosCanonPath      = array[1..128] of System.Char;
  TBlockDevName      = array[1..7] of System.Char;
  TVolumeLabel       = array[1..11] of System.Char;


  TBiosIntsTable   = array[0..$1F] of System.Word;
  TBiosDate        = array[1..8] of System.Char;

  PBiosConfigTable = ^TBiosConfigTable;
  TBiosConfigTable = record
    Size     : System.Word;
    Model    : System.Byte;
    SubModel : System.Byte;
    Revision : System.Byte;
    Feature1 : System.Byte;
    Feature2 : System.Byte;
    Feature3 : System.Byte;
    Feature4 : System.Byte;
    Feature5 : System.Byte;
  end;


  TEgaPalette        = array[0..15] of System.Byte;

  PVideoFont8x8      = ^TVideoFont8x8;
  TVideoFont8x8      = array[#$80..#$FF] of array[1..8] of System.Byte;

  PVideoSaveTable   = ^TVideoSaveTable;
  TVideoSaveTable   = record
    CRT_RegsFor00_01h    : array[1..16] of System.Byte;
    CRT_RegsFor02_03h    : array[1..16] of System.Byte;
    CRT_RegsFor04_05h    : array[1..16] of System.Byte;
    CRT_RegsFor06_07h    : array[1..16] of System.Byte;
    VideoBuffer00_01h    : System.Word;
    VideoBuffer02_03h    : System.Word;
    VideoBuffer04_05h    : System.Word;
    VideoBuffer06_07h    : System.Word;
    ModesColumns         : array[0..7] of System.Byte;
    CRT_Modes            : array[0..7] of System.Byte;
  end;

  PDynamicSaveArea  = ^TDynamicSaveArea;
  TDynamicSaveArea  = record
    EgaPalette           : TEgaPalette;
    Overscan             : System.Byte;
    Reserved_1           : array[$11..$FF] of System.Byte;
  end;

  PPalProfileTable  = ^TPalProfileTable;
  TPalProfileTable  = record
    UnderLine            : System.Byte;
    Reserved_1           : System.Byte;
    Reserved_2           : System.Word;
    EgaColors_Number     : System.Word;
    EgaColors_Index      : System.Word;
    EgaColors_Table      : System.Pointer;
    DAC_Number           : System.Word;
    DAC_Index            : System.Word;
    DAC_Table            : System.Pointer;
    ModesValues          : array[0..65000] of System.Byte;
  end;

  PDccTable         = ^TDccTable;
  TDccTable         = record
    NumEntries           : System.Byte;
    VersionNum           : System.Byte;
    MaxTypeCode          : System.Byte;
    Reserved_1           : System.Byte;
    DCCTable             : array[0..255] of record
                                              Main   : System.Byte;
                                              Second : System.Byte;
                                            end;
  end;

  PSecondTextCharsSetOvr = ^TSecondTextCharsSetOvr;
  TSecondTextCharsSetOvr = record
    Size                 : System.Byte;
    RAMbank              : System.Byte;
    Reserved_1           : System.Byte;
    FontTable            : System.Pointer;
    ModesValues          : array[0..65000] of System.Byte;
  end;

  PSecondVgaTable   = ^TSecondVgaTable;
  TSecondVgaTable   = record
    Size                 : System.Word;
    DCCTable             : PDccTable;
    SecondTextCharsSetOvr: PSecondTextCharsSetOvr;
    PalProfileTable      : PPalProfileTable
  end;

  PTextCharsSetOverride = ^TTextCharsSetOverride;
  TTextCharsSetOverride = record
    CharSize             : System.Byte;
    RAMbank              : System.Byte;
    CharsNumber          : System.Word;
    FirstCharCode        : System.Word;
    FontTable            : System.Pointer;
    MaxRows              : System.Byte;
    ModesValues          : array[0..65000] of System.Byte;
  end;

  PGraphCharsSetOverride = ^TGraphCharsSetOverride;
  TGraphCharsSetOverride = record
    MaxRows              : System.Byte;
    CharSize             : System.Word;
    FontTable            : System.Pointer;
    ModesValues          : array[0..65000] of System.Byte;
  end;


  PVideoPtrsTable   = ^TVideoPtrsTable;
  TVideoPtrsTable   = record
    VideoParmsTable      : System.Pointer;
    DynamicSaveArea      : PDynamicSaveArea;
    TextCharsSetOverride : PTextCharsSetOverride;
    GraphCharsSetOverride: PGraphCharsSetOverride;
    SecondVgaTable       : PSecondVgaTable;
    Reserved_1           : array[0..1] of System.Pointer;
  end;


  PHardDiskParmsTable = ^THardDiskParmsTable;
  THardDiskParmsTable = record
    Cyllinders           : System.Word;
    Heads                : System.Byte;
    Reserved_1           : System.Word;
    StartPrecompCyll     : System.Word;
    Reserved_2           : System.Byte;
    ControlByte          : System.Byte;
    Reserved_3           : array[1..3] of System.Byte;
    LandingZone          : System.Word;
    SectorsInTrack       : System.Byte;
    Reserved_4           : System.Byte;
  end;


  PFloppyParmsTable  = ^TFloppyParmsTable;
  TFloppyParmsTable  = record
    FirstSpecify         : System.Byte;
    SecondSpecify        : System.Byte;
    MotorDelay           : System.Byte;
    BytesInSector        : System.Byte;
    SectorsInTrack       : System.Byte;
    GapLength            : System.Byte;
    DataLength           : System.Byte;
    FormatGapLength      : System.Byte;
    FormatFiller         : System.Byte;
    HeadSettleTime       : System.Byte;
    MotorStartTime       : System.Byte;
  end;


  TPartitionRec   = record
    BootIndicator        : System.Byte;   {** 80 = active partition **}
    StartHead            : System.Byte;
    StartSector          : System.Byte;   {** Bits 0-5 **}
    StartTrack           : System.Byte;   {** Bits 8,9 in bits 6,7 if sectors **}
    OSIndicator          : System.Byte;
    EndHead              : System.Byte;   {** Bits 0-5 **}
    EndSector            : System.Byte;   {** Bits 8,9 in bits 6,7 if sectors **}
    EndTrack             : System.Byte;
    PrecedingSectors     : System.Longint;
    Length_in_sectors    : System.Longint;
  end;

  PMbrRec         = ^TMbrRec;
  TMbrRec         = record
    BootCode             : array[1..446] of System.Byte;
    Partitions           : array[1..4] of TPartitionRec;
    Signature            : System.Word;
  end;


  PBootSectorRec  = ^TBootSectorRec;
  TBootSectorRec  = record
    JumpCode             : array[1..3] of System.Byte;
    OEM_Name             : TDosName;
    SectorSize           : System.Word;
    ClusterSize          : System.Byte;
    ResSectors           : System.Word;
    FatCount             : System.Byte;
    RootSize             : System.Word;
    Old_TotalSectors     : System.Word;
    MediaDescriptor      : System.Byte;
    FatSize              : System.Word;
    TrackSectors         : System.Word;
    HeadCount            : System.Word;
    HiddenSectors        : System.Longint;
    TotalSectors         : System.Longint;
    DriveNumber          : System.Byte;
    Reserved_1           : System.Byte;
    ExtBootSignature     : System.Byte;
    SerialNumber         : System.Longint;
    VolumeLabel          : TVolumeLabel;
    Reserved_2           : array[1..8] of System.Byte;
    BootCode             : array[1..450] of System.Byte;
  end;


  PDirEntry       = ^TDirEntry;
  TDirEntry       = record
    FileName             : TDosName;
    Ext                  : TFileExt;
    Attribute            : System.Byte;
    Reserved_3           : array[1..10] of System.Byte;
    Time                 : System.Word;
    Date                 : System.Word;
    StartCluster         : System.Word;
    FileSize             : System.Longint;
  end;


  PKeyCode        = ^TKeyCode;
  TKeyCode        = record
    CharCode             : System.Char;
    ScanCode             : System.Byte;
  end;


  PPoint          = ^TPoint;
  TPoint          = record
    X,Y                  : System.Word;
  end;


  PBiosAreaRec    = ^TBiosAreaRec;
  TBiosAreaRec    = record
    UsedCOM              : array[1..4] of Word;
    UsedLPT              : array[1..4] of Word;
    EquirmentFlag        : System.Word;
    PostInstFlag         : System.Byte;
    MemorySize           : System.Word;
    PostTempArea         : System.Word;
    KeyFlags             : System.Word;
    TempCodeSave         : System.Byte;

    Kbd_BuffStart        : System.Word;
    Kbd_BuffEnd          : System.Word;
    KbdBuffer            : array[1..16] of TKeyCode;

    Floppy_Flag          : System.Byte;
    Floppy_Motor         : System.Byte;
    Floppy_MotorCount    : System.Byte;
    Floppy_State         : System.Byte;
    DrivesStates         : array[1..7] of System.Byte;

    CurrentVideoMode     : System.Byte;
    MaxColumns           : System.Word;
    VideoBufferSize      : System.Word;
    PageOffset           : System.Word;
    CursorPosition       : array[0..7] of TPoint;
    CursorSizeY          : System.Byte;
    CursorSizeX          : System.Byte;
    CurrentVideoPage     : System.Byte;
    CRT_Port             : System.Word;
    CRT_ModeReg          : System.Byte;
    CGAPalette           : System.Byte;

    PostSelfCheck        : System.Longint;
    PostInterrupt        : System.Byte;
    Timer                : System.Longint;
    TimerFlag            : System.Byte;
    CtrlBreakFlag        : System.Byte;
    RebootState          : System.Word;

    HardState            : System.Byte;
    HardsNumber          : System.Byte;
    Reserved_1           : System.Word;

    LPT_WaitTime         : array[1..4] of System.Byte;
    COM_WaitTime         : array[1..4] of System.Byte;
    Kbd_BufferS          : System.Word;
    Kbd_BufferE          : System.Word;

    MaxRows              : System.Byte;
    LetterSize           : System.Word;
    EgaFlags             : System.Byte;
    EgaSwitches          : System.Byte;
    VgaFlags             : System.Byte;
    MainDCC              : System.Byte;

    FloppySpeed          : System.Byte;
    HardController_State : System.Byte;
    HardController_Error : System.Byte;
    HardController_IntFl : System.Byte;
    Floppy_HardFlag      : System.Byte;
    FloppyStates         : array[0..3] of System.Byte;
    Floppy_CurrentTrack  : array[0..1] of System.Byte;

    ExtKbdFlags          : System.Byte;
    KbdIndicators        : System.Byte;
    ProcessEndFlagPtr    : System.Pointer;
    TimeOut              : System.Longint;
    TimeStopFlags        : System.Byte;
    Reserved_2           : array[1..7] of System.Byte;
    VideoPtrsTable       : PVideoPtrsTable;
    Reserved_3           : array[1..72] of System.Byte;
    ICA_Buffer           : array[0..15] of System.Byte;

    PrintScreenState     : System.Byte;
    BASIC_Reserved_1     : array[1..3] of System.Byte;
    CurrentFloppy        : System.Byte;
    BASIC_Reserved_2     : array[1..25] of System.Byte;
    Dos_FloppyTable      : TFloppyParmsTable;
    Reserved_4           : array[1..3] of System.Byte;
    ModeBytes            : array[1..4] of System.Byte;
  end;

  PExecParBlock      = ^TExecParBlock;
  TExecParBlock      = record
    EnvSeg           : System.Word;
    CommandTail      : PCommandStr;
    FirstFCB         : System.Pointer;
    SecondFCB        : System.Pointer;
  end;


  PPspRec    = ^TPspRec;
  TPspRec    = record
    RetComm          : System.Word;
    PrgMemSize       : System.Word;
    Reserv2          : array[1..6] of System.Byte;
    Int22Ptr         : System.Pointer;
    Int23Ptr         : System.Pointer;
    Int24Ptr         : System.Pointer;
    PrgOwnerSeg      : System.Word;
    JobFileTable     : array[1..20] of System.Byte;
    PrgEnvSeg        : System.Word;
    LastSS_SP        : System.Pointer;
    JftEntries       : System.Word;
    JftPointer       : System.Pointer;
    Reserv4          : array[1..72] of System.Byte;
    CommandLine      : TCommandStr;
  end;

  PMcbRec    = ^TMcbRec;
  TMcbRec    = record
    Signature: System.Byte;
    Owner    : System.Word;
    Size     : System.Word;
    Reserved : Array[1..3] of System.Byte;
    Name     : TDosName;
  end;

  PMcb_PspRec = ^TMcb_PspRec;
  TMcb_PspRec = record
    MCB      : TMcbRec;
    PSP      : TPspRec;
  end;

  PCharDeviceHeader = ^TCharDeviceHeader;
  TCharDeviceHeader =  record
    Next      : PCharDeviceHeader;
    DevAttr   : System.Word;
    DevStrat  : System.Word;
    DevInterr : System.Word;
    Name      : TDosName;
  end;

  PBlockDeviceHeader = ^TBlockDeviceHeader;
  TBlockDeviceHeader =  record
    Next      : PCharDeviceHeader;
    DevAttr   : System.Word;
    DevStrat  : System.Word;
    DevInterr : System.Word;
    NumUnits  : System.Byte;
    Name      : TBlockDevName;
  end;

  PMSCDexDeviceHeader = ^TBlockDeviceHeader;
  TMSCDexDeviceHeader =  record
    Next      : PCharDeviceHeader;
    DevAttr   : System.Word;
    DevStrat  : System.Word;
    DevInterr : System.Word;
    Name      : TDosName;
    Reserved  : System.Word;
    Drive     : System.Char;
    CD_Units  : System.Byte;
    Signature : array[1..4] of System.Char; { "MSCD" }
    CD_Version: array[1..2] of System.Char;
  end;

  PDptRec = ^TDptRec;
  TDptRec = record
    DrvNum        : System.Byte;
    UnitNum       : System.Byte;
    SectorBytes   : System.Word;
    ClustSectors  : System.Byte;
    ShiftCount    : System.Byte;
    ReservSectors : System.Word;
    FATsNum       : System.Byte;
    RootDirEntry  : System.Word;
    FirstUsedSect : System.Word;
    MaxClusters   : System.Word;
    FATSectors    : System.Word;
    FirstDirSect  : System.Word;
    DriveDevice   : PBlockDeviceHeader;
    MediaID       : System.Byte;
    Access        : System.Byte;
    Next          : PDptRec;
    SearchClust   : System.Word;
    FreeClustsNum : System.Word;
  end;

  PCurrDirDesc = ^TCurrDirDesc;
  TCurrDirDesc = record
    Directory  : TDirectoryStr;
    DriveAttr  : System.Word;
    DptAddr    : PDptRec;
    StartClust : System.Word;
    Reserv1    : System.Word;
    Reserv2    : System.Word;
    CurrDirOfs : System.Word;
    Reserv3    : System.Byte;
    IFSAddr    : System.Pointer;
    UsedbyIFS  : System.Word;
  end;

  PCurrentDirectory = ^TCurrentDirectory;
  TCurrentDirectory = array[0..25] of TCurrDirDesc;

  PSFTDescRec = ^TSFTDescRec;
  TSFTDescRec = record
    Handles      : System.Word;
    OpenMode     : System.Word;
    FileAttr     : System.Byte;
    DevAttr      : System.Word;
    DevOrDrvPtr  : System.Pointer;
    FirstClust   : System.Word;
    FileTime     : System.Word;
    FileDate     : System.Word;
    FileSize     : System.Longint;
    FilePos      : System.Longint;
    RelatClust   : System.Word;
    DirEntrySect : System.Longint;
    DirEntryes   : System.Byte;
    Name         : TDosName;
    Ext          : TFileExt;
    ShareTmp     : array[1..6] of System.Byte;
    OwnerPSPSeg  : System.Word;
    LastCluster  : System.Word;
    ShareCode    : System.Word;
    IFSPtr       : System.Pointer;
  end;

  PSftRec = ^TSftRec;
  TSftRec = record
    Next      : PSftRec;
    FilesNum  : System.Word;
    Files     : array[0..98] of TSFTDescRec;
  end;

  PSysVars = ^TSysVars;
  TSysVars = record
    NetWorkCX      : System.Word;
    OpenFCB_LRU    : System.Word;
    CacheFCB_LRU   : System.Word;
    OEMHandler     : System.Pointer;
    Int21RetOffset : System.Word;
    ShareRetCount  : System.Word;
    ShareRetDelay  : System.Word;
    CurrDiskBuff   : System.Pointer;
    UnreadCONSeg   : System.Word;
    FirstMCBSeg    : System.Word;
    FirstDPT       : PDptRec;
    FirstSFT       : PSftRec;
    ClockAddr      : PCharDeviceHeader;
    CONAddr        : PCharDeviceHeader;
    SectorSize     : System.Word;
    DosDiskBuffer  : System.Pointer;
    CurrentDirs    : PCurrentDirectory;
    DosFCBTable    : PSftRec;
    ProtectedFCBs  : System.Word;
    BlockDevicesNum: System.Byte;
    MaxDrives      : System.Byte;
    NullDevice     : TCharDeviceHeader;
    JoinedDrvs     : System.Byte;
    SpecPrgNamesSeg: System.Word;
    SetVerListAddr : System.Pointer;
    DosHighOfs     : System.Word;
    PspSeg         : System.Word;
    BuffersNum     : System.Word;
    HidBuffersNum  : System.Word;
    BootDrive      : System.Byte;
    Use386         : System.Boolean;
    ExtMemSize     : System.Word;
  end;


      { ** Dos Time Record ** }
  TDosTime = record
    Hour,
    Minute,
    Second,
    Sec100   : System.Byte;
  end;

      { ** Dos Date Record ** }
  TDosDate = record
    Year   : System.Word;
    Month,
    Day    : System.Byte;
  end;


  PDosBuffInputRec = ^TDosBuffInputRec;
  TDosBuffInputRec = record
    MaxNum   : System.Byte;
    ReadNum  : System.Byte;
    InpBuff  : array[0..255] of System.Char;
  end;


  PFsplitRec = ^TFsplitRec;
  TFsplitRec = record
    Dir    : TDirectoryStr;
    Name   : TNameStr;
    Ext    : TExtStr;
  end;


  PDriveInfo = ^TDriveInfo;
  TDriveInfo = record
    TotalClusters   : System.Word;
    Sector_Bytes    : System.Word;
    Cluster_Sectors : System.Byte;
    MediaIDByte     : System.Byte;
  end;


  PDriveFreeInfo = ^TDriveFreeInfo;
  TDriveFreeInfo = record
    TotalClusters   : System.Word;
    FreeClusters    : System.Word;
    Cluster_Sectors : System.Word;
    Sector_Bytes    : System.Word;
  end;


  PBpbRec = ^TBPBRec;
  TBpbRec = record
    Sector_Bytes    : System.Word;
    Cluster_Sectors : System.Byte;
    ReservedSectors : System.Word;
    FATS_Number     : System.Byte;
    RootDirEntries  : System.Word;
    OldSectorsNum   : System.Word;
    MediaID         : System.Byte;
    Track_Sectors   : System.Word;
    Heads_Number    : System.Word;
    HiddenSectors   : System.Longint;
    TotalSectors    : System.Word;
    Reserved_1      : array[1..6] of System.Byte;
    Cyllinders_Num  : System.Word;
    DeviceType      : System.Byte;
    DeviceAttributes: System.Word;
  end;

  PSearchRec = ^TSearchRec;
  TSearchRec = record
    SearchAttr      : System.Byte;
    DriveLetter     : System.Char;
    Template        : Array[1..11] of System.Byte;
    EntryCount      : System.Byte;
    DTAPtr          : System.Pointer;
    ParentDirCluster: System.Word;
    FileAttr        : System.Byte;
    FileTime        : System.Word;
    FileDate        : System.Word;
    FileSize        : System.Longint;
    FileName        : Array[1..13] of System.Char;
  end;


  PFunctionResult = ^TFunctionResult;
  TFunctionResult = record
    _Function    : System.Word;       {* number of function *}
    Interrupt    : System.Byte;       {* equal zero if unused *}
    CalledAddr   : System.Pointer;    {* equal zero if unused *}
    Result       : System.Word;       {* Error code *}
    ErrorProc    : TProcedure;        {* Error function *}
  end;

  TRepeatFunction = function: Boolean;

