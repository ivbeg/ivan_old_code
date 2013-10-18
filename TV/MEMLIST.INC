 TCommandStr        = String[127];
 TDosNameStr        = String[8];
 TDirectoryStr      = array[1..67] of Char;

 TFileExt           = array[1..3] of Char;
 TDosName           = array[1..8] of Char;
 TBlockDevName      = array[1..7] of Char;
 TBlockDevRec       = record
                       NumUnits : Byte;
                       Name     : TBlockDevName
                      end;


 PMcbRec    = ^TMcbRec;
 TMcbRec    = record
    Signature: Byte;
    Owner    : Word;
    Size     : Word;
    Reserved : Array[1..3] of Byte;
    Name     : TDosName;
  end;

 PPspRec    = ^TPspRec;
 TPspRec    = record
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
    CommandLine      : TCommandStr;
 end;

 PDeviceHeader = ^TDeviceHeader;
 TDeviceHeader =  record
    Next      : PDeviceHeader;
    DevAttr   : Word;
    DevStrat  : Word;
    DevInterr : Word;
    Name      : TDosName;
 end;

 PDptRec = ^TDptRec;
 TDptRec = record
    DrvNum        : Byte;
    UnitNum       : Byte;
    SectorBytes   : Word;
    ClustSectors  : Byte;
    ShiftCount    : Byte;
    ReservSectors : Word;
    FATsNum       : Byte;
    RootDirEntry  : Word;
    FirstUsedSect : Word;
    MaxClusters   : Word;
    FATSectors    : Word;
    FirstDirSect  : Word;
    DriveDevice   : PDeviceHeader;
    MediaID       : Byte;
    Access        : Byte;
    Next          : PDptRec;
    SearchClust   : Word;
    FreeClustsNum : Word;
 end;


 PCurrDirDesc = ^TCurrDirDesc;
 TCurrDirDesc = record
    Directory  : TDirectoryStr;
    DriveAttr  : Word;
    DptAddr    : PDptRec;
    StartClust : Word;
    Reserv1    : Word;
    Reserv2    : Word;
    CurrDirOfs : Word;
    Reserv3    : Byte;
    IFSAddr    : Pointer;
    UsedbyIFS  : Word;
 end;

 PCurrentDirectory = ^TCurrentDirectory;
 TCurrentDirectory = array[0..25] of TCurrDirDesc;


 PSFTDescRec = ^TSFTDescRec;
 TSFTDescRec = record
    Handles      : Word;
    OpenMode     : Word;
    FileAttr     : Byte;
    DevAttr      : Word;
    DevOrDrvPtr  : Pointer;
    FirstClust   : Word;
    FileTime     : Word;
    FileDate     : Word;
    FileSize     : Longint;
    FilePos      : Longint;
    RelatClust   : Word;
    DirEntrySect : Longint;
    DirEntryes   : Byte;
    Name         : TDosName;
    Ext          : TFileExt;
    ShareTmp     : array[1..6] of byte;
    OwnerPSPSeg  : Word;
    LastCluster  : Word;
    ShareCode    : Word;
    IFSPtr       : Pointer;
 end;

 PSftRec = ^TSftRec;
 TSftRec = record
            Next      : PSftRec;
            FilesNum  : Word;
            Files     : array[0..98] of TSFTDescRec;
           end;

 PSysVars = ^TSysVars;
 TSysVars = record
    NetWorkCX      : Word;
    OpenFCB_LRU    : Word;
    CacheFCB_LRU   : Word;
    OEMHandler     : Pointer;
    Int21RetOffset : Word;
    ShareRetCount  : Word;
    ShareRetDelay  : Word;
    CurrDiskBuff   : Pointer;
    UnreadCONSeg   : Word;
    FirstMCBSeg    : Word;
    FirstDPT       : PDptRec;
    FirstSFT       : PSftRec;
    ClockAddr      : PDeviceHeader;
    CONAddr        : PDeviceHeader;
    SectorSize     : Word;
    DosDiskBuffer  : Pointer;
    CurrentDirs    : PCurrentDirectory;
    DosFCBTable    : Pointer;
    ProtectedFCBs  : Word;
    BlockDevicesNum: Byte;
    MaxDrives      : Byte;
    NullDevice     : TDeviceHeader;
    JoinedDrvs     : Byte;
    SpecPrgNamesSeg: Word;
    SetVerListAddr : Pointer;
    DosHighOfs     : Word;
    PspSeg         : Word;
    BuffersNum     : Word;
    HidBuffersNum  : Word;
    BootDrive      : Byte;
    Use386         : Boolean;
    ExtMemSize     : Word;
 end;
