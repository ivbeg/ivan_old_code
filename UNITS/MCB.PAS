Unit Mcb;

Uses IvString,IvSystem,IvDos,IvEms,IvFiles,IvMouse,IvKbd,IvCrt,IvGraph,IvWindow;

Type
 McbOutputBlockP = ^McbOutputBlock;
 McbOutputBlock  = record
                    Address    : McbBlockP;
                    McbType    : string[14];
                    Name       : str8;
                    Parent     : str8;
                  end;
 PMcbPointers    = ^McbPointers;
 McbPointers     = array[1..100] of McbOutputBlockP;


Const
 SystemBlock:array[Boolean] of Str4 = ('Code','Data');
 SysBlock      = 'SysBlock';
 DosSystem     = 'System ';
 IoSys         = 'IO.SYS';
 Enviroment    = 'Enviroment';
 FreeMemory    = 'Free Memory';
 ProgData      = ' Data';
 ProgramType   = 'TSR Program';
 DeviceDriver  = 'Device ';
 DevDrvApp     = 'Dev. Drv. App.';
 DosFcbTable   = 'FCB Table';
 DosBuffers    = 'BUFFERS';
 DosFiles      = 'FILES';
 DosStacks     = 'STACKS';
 Driver        = 'Driver';
 DosEmsStacks  = 'EMS ';
 DosCurrDir    = 'Current Dirs';
 Unknown       = 'Unknown';
 None          = 'None';
 DosData       = 'DOS';
 PspMask       = $20CD;
 NoPsp         = 'No PSP';
 MsdosSys      = 'MSDOS.SYS';


PMcbList = McbList;
Mcblist = object
    UmbPresent:boolean;
    UmbCheck  :boolean;
    Count:byte;
    FindLast:boolean;
    Data:boolean;
    CurrMcb:McbBlockP;
    SegOfe:SegOfs absolute CurrMcb;
    Pointers:McbPointers;
    CurrPchar:PChar;
    LastCount:byte;




end.
