Unit MemLists;


Uses
 Drivers,Objects,Views,Dialogs;


{
     ** Consts Shorts  **
     mt  -  MCB Type
     mc  -  MCB_ID Char
     dt  -  Drive Type
}

const
 gceMCBChainError   =    -1;

 MaxMcbs       = 100;
 TruePSPSign   = $20CD; { INT 20h }

 mtUnknown      =  0;
 mtTSRProgram   =  1;
 mtEnviroment   =  2;
 mtDeviceDriver =  3;
 mtSTACKS       =  4;
 mtBUFFERS      =  5;
 mtLASTDRIVE    =  6;
 mtDevDrvApp    =  7;
 mtIFS          =  8;
 mtFILES        =  9;
 mtFCBS         = 10;
 mtSystemCode   = 11;
 mtSystemData   = 12;
 mtProgramData  = 13;
 mtNonPSP_TSR   = 14;
 mtParent       = 15;
 mtEMS_BUFFERS  = 16;
 mtTransident   = 17;
 mtFreeMemory   = 18;

 mcDevDrvApp    = 'E';
 mcDeviceDriver = 'D';
 mcIFS          = 'I';
 mcFILES        = 'F';
 mcFCBS         = 'X';
 mcEMS_BUFFERS  = 'C';
 mcBUFFERS      = 'B';
 mcLASTDRIVE    = 'L';
 mcSTACKS       = 'S';
 mcTransident   = 'T';
 mcEndBlock     = 'Z';
 mcMiddleBlock  = 'M';

 moFreeMemory   = 00;
 moIOSYS        = 08;

 dtSUBSTed        = $1000;
 dtPhysical       = $4000;
 dtASSIGNed       = $5000;
 dtJOINed         = $7000;
 dtNetwork        = $8000;




type
 TCommandStr        = String[127];
 TDosNameStr        = String[8];

 TFileExt           = aray[1..3] of Char;
 TDosName           = aray[1..8] of Char;
 TBlockDevName      = aray[1..7] of Char;
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
    CommandLine      : TComandStr;
 end;

 PDeviceHeader = ^TDeviceHeader;
 TDeviceHeader =  record
    Next      : PDeviceHeader
    DevAttr   : Word;
    DevStrat  : Word;
    DevInterr : Word;
    Name      : TDosName;
 end;

 PCurrDirDesc = ^TCurrDir;
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


 PMcb_Psp = ^TMcb_Psp;
 TMcb_Psp = record
    MCB:  TMCBRec;
    PSP:  TPSPRec;
 end;

 PMcb_DevHdrRec  = ^TMcb_DevHdrRec;
 TMcb_DevHdrRec = record
    MCB: TMcbRec;
    Header: TDeviceHeader;
 end;

 PMcb_SftRec = ^TMcb_SftRec;
 TMcb_SftRec = record
    MCB: TMcbRec;
    SFT: TSftRec;
 end;

 PMcbRecord = record
               MCB : TMcbRec;
              end;

 PMcb_LastDrvRec = ^TMcb_LastDrvRec;
 TMcb_LastDrvRec = record
    MCB: TMcbRec;
    CurrDirs: TCurrentDirectory;
 end;

 PMcbDescriptor = ^TMcbDescriptor;
 TMcbDescriptor = record
  McbName: TDosNameStr;
   Case McbType:Byte of
    mtTSRProgram:
      (Address: PMcb_PspRec);
    mtDeviceDriver:
      (Address: PMcb_DevHdrRec;
       DeviceType: Byte;
       DeviceName: TDosNameStr);
    mtFILES:
      (Address: PMcb_SftRec);
    mtLASTDRIVE:
      (Address: PMcb_LastDrvRec)
    else (Address: PMcbRecord);
 end;

 PMcbBlocks = ^TMcbBlocks;
 TMcbBlocks = array[1..MaxMcbs] of PMcbDescriptor;


 PMcbList = ^TMcbList;
 TMcbList = object
    StartSegment: Word;
    McbArray:  PMcbBlocks;
    NumEntries: Byte;

    constructor Init(StartSeg: Word);
    destructor Done;
    procedure CreateMCBArray;
    procedure SelectMcb(Num: Byte);
    procedure LoadExtendedInfo(Num: Byte);
    procedure Error(Code: Integer);virtual;
    procedure CheckMCB_Chain(Se: Word);
  end;


begin

procedure TMCBList.CheckMCB_Chain(Se: Word);assembler;
asm
   PUSH   DS
   MOV    AX,Se
   MOV    DS,AX
   MOV    SI,0
   LODSB
   POP    DS
   CMP    AL,'A'
   JB     @@01
   CMP    AL,'Z'
   JBE    @@02
@@01:
   LES    DI,Self
   MOV    AL,gceMCBChainError
   PUSH   AX
   CALL   TMCBList.Error
@@02:
end;


Function ReallyMCB(Se: Word):Boolean;assembler;
asm
   PUSH   DS
   MOV    CL,0
@@04:
   MOV    AX,Se
   MOV    DS,AX
   MOV    SI,0
   LODSB
   CMP    AL,'A'
   JB     @@01
   CMP    AL,'Z'
   JBE    @@02
@@01:
   MOV    AL,False
   JMP    SHORT  @@03
@@02:
   LODSW
   MOV    DS,AX
   INC    CL
   CMP    CL,1
   JE     @@04;
   MOV    AL,True
@@03:
   POP    DS
end;


Function PSP_Present(Se: Word):Boolean;assembler;
asm
   PUSH  DS
   MOV   AX,Se
   MOV   DS,AX
   MOV   SI,0
   LODSW
   SUB   AX,TruePSPSign
   JZ    @@01
@@01:
   MOV   AL,True
   JMP   SHORT @@03
@@02:
   MOV   AL,False
@@03:
   POP   DS
end;


procedure _CheckMiddleBlock;
begin


end;


procedure SortMCBInformation(MCB:PMcbDescriptor);
begin
 WITH MCB^.DO
 Case MCB^.Signature of
  mcDevDrvApp:    McbType:=mtDevDrvApp
  mcDeviceDriver: McbType:=mtDeviceDriver;
  mcIFS:          McbType:=mtIFS;
  mcFILES:        McbType:=mtFILES;
  mcEMS_BUFFERS:  McbType:=mtEMS_BUFFERS;
  mcBUFFERS:      McbType:=mtBUFFERS;
  mcLASTDRIVE:    McbType:=mtLASTDRIVE;
  mcSTACKS:       McbType:=mtSTACKS;
  mcTransident:   McbType:=mtTransident;
  mcEndBlock,
  mcMiddleBlock:  _CheckMiddleBlock;
  else Error();
end;


procedure TMcbList.CreateMCBArray;
var
  FindLast: Boolean;
  CurrentMcb: PMcbRec;
  MCB_SegOfs: SegOfs absolute CurrentMcb;
begin
  FindLast:=false;
  CurrentMcb:=Ptr(StartSegment,0);
  repeat
   CheckMCB(MCB_SegOfs.S);
   Inc(NumEntries);
     New(MCBArray^[NumEntries]);
   WITH MCBArray^[NumEntries]^ DO
   Begin
    Address:=Pointer(CurrentMCB);
    McbName:=CharArrayToStr(CurrentMCB^.Name);
    IF McbName[0] = #0 THEN McbName:=None;
   end;
    SortMCBInformation(MCBArray^[NumEntries]);
    FindLast:=(CurrentMCB^.Signature = mcEndBlock);
    MCB_SegOfs.S:= MCB_SegOfs.S + CurrentMCB^.Size + 1;
  until FindLast;
end;

end.