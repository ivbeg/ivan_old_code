    //*  From DOS.H

#define MK_FP( seg,ofs )( (void _seg * )( seg ) +( void near * )( ofs ))
#define FP_SEG( fp )( (unsigned )( void _seg * )( void far * )( fp ))
#define FP_OFF( fp )( (unsigned )( fp ))


const  unsigned char   CD_Sign[4] = {'M','S','C','D'};
const  unsigned int    ROM_Sign = 0xAA55;
const  unsigned int    PSP_Sign = 0x20CD;
const  unsigned int    End_of_Chain = 0xFFFF;
const  unsigned int    EXE_Sign = 0x5A4D;
const  unsigned int    Last_MCB = 0x5A;
const  unsigned int    Std_MCB = 0x4D;


typedef void far *pointer;

typedef   unsigned char       BYTE;
typedef   BYTE                BOOLEAN;
typedef   unsigned int        WORD;
typedef   unsigned long       DWORD;
typedef   char*               PCHAR;
typedef   BOOLEAN*            PBOOLEAN;
typedef   BYTE*               PBYTE;
typedef   WORD*               PWORD;
typedef   DWORD*              PDWORD;

const   BOOLEAN    BOOL_FALSE   =   0;
const   BOOLEAN    BOOL_TRUE    =   1;




typedef unsigned char  tEgaPalette[16];

typedef unsigned char  sDirectoryBuffer[64];



struct TFunctionResult
{
  WORD          Function;
  BYTE          Interrupt;
  pointer       CalledAddr;
  WORD          Result;
  pointer       ErrorProc;
};

         /*  Bios Area Types */

struct sPhoenixID
{
    unsigned char             Zero;
    unsigned int              Version;
    unsigned char             ID;
};

typedef unsigned char  tQuadramID[17];

union  sBiosIdentifity
{
    sPhoenixID                PhoenixID;
    tQuadramID                QuadramID;
};

struct sBiosFeature1
{
    unsigned char             is_Dual_Bus            : 1;
    unsigned char             is_Micro_Channel_Bus   : 1;
    unsigned char             is_EBDA_Used           : 1;
    unsigned char             is_Wait_Event          : 1;
    unsigned char             is_INT9_Emulation      : 1;
    unsigned char             is_RealTime_Clock      : 1;
    unsigned char             is_Second_8259         : 1;
    unsigned char             is_DMA3_Used           : 1;
};

struct sBiosFeature2
{
    unsigned char             Reserved_1             : 1;
    unsigned char             is_Data_Streaming      : 1;
    unsigned char             is_non8042             : 1;
    unsigned char             PS2_Commands           : 4;
    unsigned char             Reserved_2             : 1;
};

struct sBiosFeature3
{
    unsigned char             is_SCSI_IML_Supported      : 1;
    unsigned char             is_IML_System              : 1;
    unsigned char             is_Info_Panel_Inst         : 1;
    unsigned char             is_SCSI_System_Supported   : 1;
    unsigned char             Reseved_1                  : 4;
};


struct sBiosConfigTable
{
    unsigned int              Size;
    unsigned char             Model;
    unsigned char             SubModel;
    unsigned char             Revision;
    sBiosFeature1             Feature1;
    sBiosFeature2             Feature2;
    sBiosFeature3             Feature3;
    unsigned char             Feature4;
    unsigned char             Feature5;
    sBiosIdentifity           BiosIdentifity;
};


struct sPoint
{
    unsigned char             Y, X;
};

struct sKeyFlags
{
    unsigned int is_Left_Ctrl           : 1;
    unsigned int is_Right_Ctrl          : 1;
    unsigned int is_SysReq              : 1;
    unsigned int is_Pause_Active        : 1;
    unsigned int is_ScrollLock_Pressed  : 1;
    unsigned int is_NumLock_Pressed     : 1;
    unsigned int is_CapsLock_Pressed    : 1;
    unsigned int is_Insert_Pressed      : 1;
    unsigned int is_Right_Shift         : 1;
    unsigned int is_Left_Shift          : 1;
    unsigned int is_Alt                 : 1;
    unsigned int is_Ctrl                : 1;
    unsigned int is_ScrollLock_Active   : 1;
    unsigned int is_NumLock_Active      : 1;
    unsigned int is_CapsLock_Active     : 1;
    unsigned int is_Insert_Active       : 1;
};

struct sEquipmentByte
{
    unsigned int  is_Boot_Floppy        : 1;
    unsigned int  is_Coprocessor        : 1;
    unsigned int  is_PS_Mouse           : 1;
    unsigned int  Reserved_1            : 1;
    unsigned int  Start_Video_Mode      : 2;
    unsigned int  Floppy_Number         : 2;
    unsigned int  Reserved_2            : 1;
    unsigned int  COM_Number            : 3;
    unsigned int  is_Game_Port          : 1;
    unsigned int  is_PS_Modem           : 1;
    unsigned int  LPT_Number            : 2;
};

struct sKeyCode
{
    unsigned char     CharCode;
    unsigned char     ScanCode;
};

struct sCRT_ModeReg
{
    unsigned char  is_Text_Mode80x25     : 1;
    unsigned char  is_Graphics           : 1;
    unsigned char  is_Monochrome         : 1;
    unsigned char  is_Video_Signal_On    : 1;
    unsigned char  is_Mono_Mode6         : 1;
    unsigned char  is_Blink_On           : 1;
    unsigned char  Reserved_1            : 2;
};

struct sCGAPalette
{
    unsigned char  Blue                  : 1;
    unsigned char  Green                 : 1;
    unsigned char  Red                   : 1;
    unsigned char  Intense_Mode5         : 1;
    unsigned char  Intense_Textmode      : 1;
    unsigned char  Palette               : 1;
    unsigned char  Reserved_1            : 2;
};

struct sCtrlBreakFlag
{
    unsigned char  Reserved_1            : 7;
    unsigned char  Flag                  : 1;
};

struct sEgaFlags
{
    unsigned char  is_Cursor_Off         : 1;
    unsigned char  is_Mono_Monitor       : 1;
    unsigned char  is_Wait_For_Diplay_On : 1;
    unsigned char  is_Video_System_Off   : 1;
    unsigned char  Reserved_1            : 1;
    unsigned char  Video_RAM_Size        : 2;
    unsigned char  is_RAM_Clear          : 1;
};

struct sEgaSwitches
{
    unsigned char FeatureConnector       : 4;
    unsigned char Switches               : 4;
};

struct sVgaFlags
{
    unsigned char is_VGA_Active          : 1;
    unsigned char is_Grey_Summing_On     : 1;
    unsigned char is_Mono_Display        : 1;
    unsigned char is_Def_Pal_Load_Off    : 1;
    unsigned char Scanlines_LSB          : 1;
    unsigned char Reserved_1             : 1;
    unsigned char Display_Switch_On      : 1;
    unsigned char Scanlines_MSB          : 1;
};

struct sExtKbdFlags
{
    unsigned int is_Last_Code_E1         : 1;
    unsigned int is_Last_Code_E0         : 1;
    unsigned int is_Right_Ctrl           : 1;
    unsigned int is_Right_Alt            : 1;
    unsigned int is_Echanced_Keyboard    : 1;
    unsigned int is_Force_Numlock        : 1;
    unsigned int is_Last_Code_ID         : 1;
    unsigned int is_Read_ID              : 1;
    unsigned int LED_ScrollLock          : 1;
    unsigned int LED_NumLock             : 1;
    unsigned int LED_CapsLock            : 1;
    unsigned int Reserved_1              : 1;
    unsigned int is_ACK_Received         : 1;
    unsigned int is_RESEND_Received      : 1;
    unsigned int is_LED_Update           : 1;
    unsigned int Transmit_Error_Flag     : 1;
};

struct    sWaitActiveFlag
{
    unsigned char is_Wait_Time_Elapsed   : 1;
    unsigned char Reserved_1             : 6;
    unsigned char is_AH86h_Occurred      : 1;
};


struct    sDccCode
{
    unsigned char              Main;
    unsigned char              Second;
};

struct    sDccTable
{
    unsigned char              NumEntries;
    unsigned char              Version;
    unsigned char              MaxTypeCode;
    unsigned char              Reserved_1;
    sDccCode                   Table[256];
};

struct sSecondTextCharsSetOvr
{
    unsigned char              Size;
    unsigned char              RAMBank;
    unsigned char              Reserved_1;
    pointer                    FontTable;
    unsigned char              ModesValues[32000];
};

struct sPalProfileTable
{
    unsigned char              UnderLine;
    unsigned char              Reserved_1;
    unsigned int               Reserved_2;
    unsigned int               EgaColors_Number;
    unsigned int               EgaColors_Index;
    pointer                    EgaColors_Table;
    unsigned int               DAC_Number;
    unsigned int               DAC_Index;
    pointer                    DAC_Table;
    unsigned char              ModesValues[32000];
};

struct sSecondVgaTable
{
    unsigned int               Size;
    sDccTable                 *DccTable;
    sSecondTextCharsSetOvr    *SecondTextCharsSetOvr;
    sPalProfileTable          *PalProfileTable;
};

struct sDynamicSaveArea
{
    tEgaPalette                EgaPalette;
    unsigned char              Overscan;
    unsigned char              Reserved_1[239];
};

struct sTextCharsSetOverride
{
   unsigned char               CharSize;
   unsigned char               RAMBank;
   unsigned int                CharsNumber;
   unsigned int                FirstCharCode;
   pointer                     FontTable;
   unsigned char               MaxRows;
   unsigned char               ModesValues[32000];
};

struct sGraphCharsSetOverride
{
   unsigned char               MaxRows;
   unsigned int                CharSize;
   pointer                     FontTable;
   unsigned char               ModesValues[32000];
};


struct sVideoPtrsTable
{
    unsigned long              VideoParmsTable;
    sDynamicSaveArea           DynamicSaveArea;
    sTextCharsSetOverride      TextCharsSetOverride;
    sGraphCharsSetOverride     GraphCharsSetOverride;
    sSecondVgaTable           *SecondVgaTable;
    unsigned long              Reserved_1[2];
};

struct sFloppyParmsTable
{
    unsigned char              FirstSpecify;
    unsigned char              SecondSpecify;
    unsigned char              MotorDelay;
    unsigned char              BytesInSector;
    unsigned char              SectorsInTrack;
    unsigned char              GapLength;
    unsigned char              DataLength;
    unsigned char              FormatGapLength;
    unsigned char              FormatFiller;
    unsigned char              HeadSettleTime;
    unsigned char              MotorStartTime;
};

struct sHardDiskParmsTable
{
    unsigned int               Cyllinders;
    unsigned char              Heads;
    unsigned int               Reserved_1;
    unsigned int               StartPrecompCyll;
    unsigned char              Reserved_2;
    unsigned char              ControlByte;
    unsigned char              Reserved_3[3];
    unsigned int               LandingZone;
    unsigned char              SectorsInTrack;
    unsigned char              Reserved_4;
};


struct sBiosArea
{
    unsigned int               UsedCOM[4];
    unsigned int               UsedLPT[4];
    sEquipmentByte             EquipmentByte;
    unsigned char              PostInstFlag;
    unsigned int               MemorySize;
    unsigned int               PostTempArea;
    sKeyFlags                  KeyFlags;
    unsigned char              TempCodeSave;

    unsigned int               Kbd_BuffStart;
    unsigned int               Kbd_BuffEnd;
    sKeyCode                   Kbd_Buffer[16];

    unsigned char              Floppy_Flag;
    unsigned char              Floppy_Motor;
    unsigned char              Floppy_MotorCount;
    unsigned char              Floppy_State;
    unsigned char              DrivesStates[7];

         /*  First Video Area  */

    unsigned char              CurrentVideoMode;
    unsigned int               MaxColumns;
    unsigned int               VideoBufferSize;
    unsigned int               VideoPageOffset;
    sPoint                     CursorPosition[8];
    unsigned char              CursorSizeY;
    unsigned char              CursorSizeX;
    unsigned char              CurrentVideoPage;
    unsigned int               CRT_Port;
    sCRT_ModeReg               CRT_ModeReg;
    sCGAPalette                CGAPalette;

    unsigned long              PostSeflCheck;
    unsigned char              PostInterrupt;
    unsigned long              Timer;
    unsigned char              TimerFlag;
    sCtrlBreakFlag             CtrlBreakFlag;
    unsigned int               RebootState;

    unsigned char              FixedDiskStatus;
    unsigned char              FixedDisksNumber;
    unsigned int               Reserved_1;

    unsigned char              LPT_TimeWait[4];
    unsigned char              COM_TimeWait[4];
    unsigned int               Kbd_BufferS;
    unsigned int               Kbd_BufferE;

         /*  Second Video Area  */

    unsigned char              MaxRows;
    unsigned int               LetterSize;
    sEgaFlags                  EgaFlags;
    sEgaSwitches               EgaSwitches;
    sVgaFlags                  VgaFlags;
    unsigned char              MainDCC;

    unsigned char              DisksInformation[11];

    sExtKbdFlags               ExtKbdFlags;
    unsigned char             *UserWaitFlag;
    unsigned long              UserWaitCount;
    sWaitActiveFlag            WaitActiveFlag;
    unsigned char              Reserved_2[7];
    sVideoPtrsTable           *VideoPtrsTable;
    unsigned char              Reserved_3[72];
    unsigned char              ICABuffer[16];

    unsigned char              PrintScreenState;
    unsigned char              Reserved_4[3];
    unsigned char              CurrentFlopppyDrive;
    unsigned char              Reserved_5[25];
    sFloppyParmsTable          DosFloppyTable;
    unsigned char              Reserved_6[3];
    unsigned char              DosModeBytes[4];
};


typedef   unsigned char        tCpuVendor[12];

struct sRomInfoRec
{
    unsigned int               Signature;
    unsigned char              Size_512;
};

struct sExeHeader
{
    unsigned int               Signature;
    unsigned int               PartialPage;
    unsigned int               PageCount;
    unsigned int               RelocateCount;
    unsigned int               HeaderSize;
    unsigned int               MinMem;
    unsigned int               MaxMem;
    unsigned int               Start_SS;
    unsigned int               Start_SP;
    unsigned int               Checksum;
    pointer                    StartAddress;
    unsigned int               TableOffset;
    unsigned int               Overlay;
};

typedef   unsigned char        tVGA_Memory[320][200];

struct sTextPoint
{
    unsigned char              Attribute, Character;
};

typedef   sTextPoint           tStdText_Memory[8][80][25];

struct sSegOfs
{
    unsigned int               O, S;
};



typedef   unsigned char        tVgaPalette[256];
typedef   pointer              tInterruptTable[256];
typedef   unsigned char        tSectorBuffer[512];


typedef   unsigned char        tFileExt[3];
typedef   unsigned char        tDosName[8];
typedef   unsigned char        tDosPath[64];
typedef   unsigned char        tDosCanonPath[128];
typedef   unsigned char        tBlockDevName[7];
typedef   unsigned char        tVolumeLabel[11];

typedef   unsigned int         tBiosIntsTable[32];
typedef   unsigned char        tBiosDate[8];


struct sDirEntry
{
    tDosName                   FileName;
    tFileExt                   Ext;
    unsigned char              Attribute;
    unsigned char              Reserved_3[10];
    unsigned int               Time;
    unsigned int               Date;
    unsigned int               StartCluster;
    unsigned long              FileSize;
};

struct sCommandLine
{
    unsigned char              Size;
    unsigned char              Line[127];
};

struct sPspRec
{
    unsigned int               ReturnCommand;
    unsigned int               MemorySize;
    unsigned char              Reserved_1[6];
    pointer                    Int22Ptr;
    pointer                    Int23Ptr;
    pointer                    Int24Ptr;
    unsigned int               OwnerSeg;
    unsigned char              JobFileTable[20];
    unsigned int               EnvironentSeg;
    pointer                    LastSS_SP;
    unsigned int               JftEntries;
    pointer                    JftPointer;
    unsigned char              Reserved_2[72];
    sCommandLine               CommandLine;
};

struct sMcbRec
{
    unsigned char              Signature;
    unsigned int               Owner;
    unsigned int               Size;
    unsigned char              Reserved;
    tDosName                   Name;
};

struct sBlockDeviceName
{
    unsigned char              NumUnits;
    tBlockDevName              Name;
};

struct sDeviceDriverAttributes
{
    unsigned int               Reserved_1      : 15;
    unsigned int               is_Char_Device  : 1;

};

struct sDeviceHeader
{
    sDeviceHeader*             Next;
    sDeviceDriverAttributes    Attribute;
    unsigned int               Strategy;
    unsigned int               Interr;
    union
    {
        tDosName               CharName;
        sBlockDeviceName       BlockName;
    };
};

struct sDptRec
{
    unsigned char              DriveNum;
    unsigned char              UnitNum;
    unsigned int               SectorBytes;
    unsigned char              ClustSectors;
    unsigned char              ShiftCount;
    unsigned int               ReservSectors;
    unsigned char              FATsNum;
    unsigned int               RootDirEntry;
    unsigned int               FirstUsedSector;
    unsigned int               MaxClusters;
    unsigned int               FATSectors;
    unsigned int               FirstDirSector;
    sDeviceHeader             *DriveDevice;
    unsigned char              MediaID;
    unsigned char              Access;
    sDptRec                    *Next;
    unsigned int               SearchCluster;
    unsigned int               FreeClustersNum;
};

struct sCurrDirDesc
{
    unsigned char              Directory[67];
    unsigned int               DriveAttr;
    sDptRec                   *DptAddr;
    unsigned int               StartCluster;
    unsigned int               Reserved_1;
    unsigned int               Reserved_2;
    unsigned int               CurrDirOfs;
    unsigned char              Reserved_3;
    pointer                    IFSAddr;
    unsigned int               UsedbyIFS;
};

typedef sCurrDirDesc    sCurrentDirectory[26];

struct sSftDescRec
{
    unsigned int               Handles;
    unsigned int               OpenMode;
    unsigned char              FileAttr;
    unsigned int               DevAttr;
    pointer                    DriveOrDevice;
    unsigned int               FirstCluster;
    unsigned int               FileTime;
    unsigned int               FileDate;
    unsigned long              FileSize;
    unsigned long              FilePos;
    unsigned int               RelatCluster;
    unsigned long              DirEntrySector;
    unsigned char              DirEntries;
    tDosName                   Name;
    tFileExt                   Ext;
    unsigned char              ShareTmp[6];
    unsigned int               OwnerPSPSeg;
    unsigned int               LastCluster;
    unsigned int               ShareCode;
    pointer                    IFSPtr;
};

struct sSftRec
{
    sSftRec                  *Next;
    unsigned int              FilesNum;
    sSftDescRec               Files[100];
};



struct sSystemVariables
{
    pointer                    CurrentDiskBuffer;
    unsigned int               UnreadCONSeg;
    unsigned int               FirstMCBSeg;
    sDptRec                   *FirstDPT;
    sSftRec                   *FirstSFT;
    sDeviceHeader             *ClockAddr;
    sDeviceHeader             *CONAddr;
    unsigned int               SectorSize;
    pointer                    DosDiskBuffer;
    sCurrentDirectory         *CurrDirAddr;
    pointer                    FcbTableAdde;
    unsigned int               ProtectedFcbs;
    unsigned char              BlockDevicesNum;
    unsigned char              MaxDrives;
    sDeviceHeader              NullDevice;
    unsigned char              JoinedDrives;
    unsigned int               SpecDrvNamesSeg;
    pointer                    SetVerListAddr;
    unsigned int               DosHighOfs;
    unsigned int               PspSeg;
    unsigned int               BuffersNumber;
    unsigned char              BootDrive;
    unsigned char              Use386;
    unsigned int               ExtendedMemorySize;
};



struct sPartition
{
    unsigned char              BootIndicator;
    unsigned char              StartHead;
    unsigned char              StartSector;
    unsigned char              StartTrack;
    unsigned char              OSIndicator;
    unsigned char              EndHead;
    unsigned char              EndSector;
    unsigned char              EndTrack;
    unsigned long              PrecedingSectors;
    unsigned long              LengthInSectors;
};

struct sMbrRec
{
    unsigned char              BootCode[446];
    sPartition                 Partitions[4];
    unsigned int               Signature;
};

struct sBootSectorRec
{
    unsigned char              JumpCode[3];
    tDosName                   OEM_Name;
    unsigned int               SectorSize;
    unsigned char              ClusterSize;
    unsigned int               ReservedSectors;
    unsigned char              FATCount;
    unsigned int               RootSize;
    unsigned int               Old_TotalSectors;
    unsigned char              MediaDescriptor;
    unsigned int               FATSize;
    unsigned int               TrackSectors;
    unsigned int               HeadCount;
    unsigned long              HiddenSectors;
    unsigned long              TotalSectors;
    unsigned char              DriveNumber;
    unsigned char              Reserved_1;
    unsigned char              ExtBootSignature;
    unsigned long              SerialNumber;
    tVolumeLabel               VolumeLabel;
    unsigned char              Reserved_2[8];
    unsigned char              BootCode[450];
};

struct sDosTime
{
    unsigned char              Hour;
    unsigned char              Minute;
    unsigned char              Second;
    unsigned char              Sec100;
};

struct sDosDate
{
    unsigned int               Year;
    unsigned char              Month;
    unsigned char              Day;

};

struct sDosBuffInputRec
{
    unsigned char              MaxNum;
    unsigned char              ReadNum;
    unsigned char              InpBuff[256];
};

struct sDriveInfo
{
    unsigned int               TotalSectors;
    unsigned int               Sector_Bytes;
    unsigned char              Cluster_Sectors;
    unsigned char              MediaID;
};

struct sDriveFreeInfo
{
    unsigned int               TotalSectors;
    unsigned int               FreeSectors;
    unsigned int               Cluster_Sectors;
    unsigned int               MediaID;
};

struct sBptRec
{
    unsigned int               Sector_Bytes;
    unsigned char              Cluster_Sectors;
    unsigned int               ReservedSectors;
    unsigned char              FATs_Number;
    unsigned int               RootDirEntries;
    unsigned int               OldSectorsNum;
    unsigned char              MediaID;
    unsigned int               Track_Sectors;
    unsigned int               HeadsNumber;
    unsigned long              HiddenSectors;
    unsigned int               TotalSectors;
    unsigned char              Reserved_1[6];
    unsigned int               Cyllindrs_Num;
    unsigned char              DeviceType;
    unsigned int               DeviceAttributes;
};

struct sSearchRec
{
   unsigned char               SearchAttr;
   unsigned char               DriveLetter;
   unsigned char               Template[11];
   unsigned char               EntryCount;
   pointer                     DTAPtr;
   unsigned int                ParentDirCluster;
   unsigned char               FileAttr;
   unsigned int                FileTime;
   unsigned int                FileDate;
   unsigned long               FileSize;
   unsigned char               FileName;
};




