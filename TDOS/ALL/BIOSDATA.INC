BiosDataSeg SEGMENT AT 0040h
  COM                DW 3 DUP (?)
  LPT                DW 3 DUP (?)
  EquirmentFlag      DW ?
  PostInstFlag       DB ?
  MemorySize         DW ?
  PostTimeArea       DW ?
  KeyFlag            DW ?
  InputCode          DB ?
  KbdBuffStart       DW ?
  KbdBuffEnd         DW ?
  KbdBuffer          DW 16 DUP (?)
  FloppyFlag         DB ?
  FloppyMotorState   DB ?
  FloppyMotorCount   DB ?
  FloppyStatus       DB ?
  DrvStatusArr       DW 7 DUP (?)
  CurrentMode        DB ?
  MaxColumns         DB ?
  VideoBuffSize      DW ?
  PageAddr           DW ?
  CursorPos          DW 8 DUP (?)
  CursorSizeXY       DW ?
  CurrentPage        DB ?
  Addr6845           DW ?
  CRTModeReg         DB ?
  CGAPalette         DB ?
  PostSelfCheck      DD ?
  PostInterrupt      DB ?
  Timer              DD ?
  TimerFlag          DB ?
  CtrBreakFlag       DB ?
  RebootFlag         DW ?
  HardStatus         DB ?
  HardsNum           DB ?
  Reserved1          DW ?
  LPT_TimeWait       DB 4 DUP (?)
  COM_TimeWait       DB 4 DUP (?)
  KbdBuffS           DW ?
  KbdBuffE           DW ?
  MaxStrings         DB ?
  LetterHigh         DW ?
  EgaFlags           DB ?
  EgaSwitches        DB ?
  VgaFlags           DB ?
  MainDCC            DB ?
  FloppySpeed        DB ?
  HardContrStatus    DB ?
  HardContrError     DB ?
  HardContrInterrupt DB ?
  Floppy_HardFlag    DB ?
  FloppySStatus      DB 4 DUP (?)
  FloppyTrack        DW ?
  ExtKbdFlag         DB ?
  KbdIndicators      DB ?
  ProcessEndFlag     DD ?
  TimerOut           DD ?
  TimeStopFlag       DB ?
  Reserved2          DB 7 DUP (?)
  VideoTableAddr     DD ?
  Reserved3          DB 72 DUP (?)
  ICABuffer          DB 16 DUP (?)
BiosDataSeg ENDS