{ PROJECT               TURBO MEMORY VIEW/CONTROL UTILITIES             }
{                       FREEWARE SOFTWARE                               }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             MEMVIEW.PAS                                     }
{ PURPOSE               View and Control Dos  MCB blocks                }
{                       else return extended information about them     }
{ VERSION               0.01                                            }
{ DATE                  30-Mar-96                                       }
{ DESIGN                Begtin Ivan                                     }
{ IMPLEMENTATION        Begtin Ivan                                     }
{ COMPANY               None                                            }

{ COPYRIGHT NOTICE      Copyright (C) 1995-1996, Begtin Ivan            }
{ RESTRICTED RIGHTS     AVAILABLE ONLY FOR FREE DISTRIBUTION,           }
{                       NOT FOR COMMERCIAL PURPOSE                      }
{ COMPUTER              IBM PC or compatible                            }
{ OPERATING SYSTEM      MS/PC-DOS Version 3.30 or higher                }
{ COMPILER              Turbo Pascal Version 7.0                        }
{                       (Borland International Inc.)  or compatible     }
{ ASSEMBLY LANGUAGE     Turbo Assember 3.2 or compatible                }
{ LINKER                Turbo Pascal internal                           }
{ ARGUMENTS                                                             }
{                                                                       }
{                                                                       }
{ RETURN                None                                            }
{ REQUIRES              None                                            }
{ NATURAL LANGUAGE      English Language                                }
{ SECOND LANGUAGE       Russian Language                                }
{ SPECIAL               Works only on 386+ processors                   }
{ DESCRIPTION           1.BIOS and CPU Identification.                  }
{                       2.All BIOS Static information in variables.     }
{                       3.Different assembler tools.                    }
{                       4.Using TVision for output this all.            }
{                       5.MCB View/Edit Utility.                        }
{                       6.Environment View.                             }
{                       7.Memory Dump.                                  }
{                       8.MCB's and Programs types  analys.             }
{                       9.Full check for any errors.                    }
{ REVISION HISTORY     Ivan Begtin (IB)                                 }
{                                                                       }
{                                                                       }
{ THANKS TO            Dmitry Stefankov for style lessons               }
{                      Victor Begtin for first Pascal lessons           }
{-----------------------------------------------------------------------}

Program Memview;
{$M 32768, 100000,100000}

Uses TSystem, Objects, Newdos,IvString,
     Views, Dialogs, App, Strings, MsgBox,
     Drivers, Menus, ShowTErr, Globals, Equ;

Type
    TMessage          = System.Word;

    TSystemData_Code  = array[1..2] of System.Char;
    TString7          = String[7];
    TString3          = String[3];


Const
     gcaDevAttrNames    : array[1..16] of String[19] =
       ('STDIN device       ',
        'STDOUT device      ',
        'NUL device         ',
        'CLOCK device       ',
        'Special device     ',
        'Reserved(5)        ',
        'Generic IOCTL call ',
        'Generic IOCTL check',
        'Reserved(8)        ',
        'Reserved(9)        ',
        'Reserved(10)       ',
        'OPEN/CLOSE/RemMedia',
        'Reserved(12)       ',
        'Output until busy  ',
        'IOCTL supported    ',
        'Character device   ');

     gcsDescription            = ' Address     Name   Owner  Size   Type of Block';
     gcsDescFill               = '-----------------------------------------------';
     asDescription             = ' Address    Name     Strat Intrp Attr  MCB Name      Short Description      ';
     asDescFill                = '----------------------------------------------------------------------------';

     gcsMcbListName            = 'MCB List';
     gcsUmbListName            = 'UMB List';
     gcsDeviceListName         = 'Device Drivers List';

     gcsPurpose                = 'Memory Viewer Utility';
     gcsVersion                = '0.12';
     gcsAuthor                 = 'Ivan Begtin';
     gcsCopyright              = 'Copyright (c) 1995';
     gcsProgram                = 'MemView';

        {** Events types **}
     cmAbout                   = 101;
     cmGetMcbList              = 102;
     cmGetUmbList              = 103;
     cmDevList                 = 104;
     cmGetDriverInfo           = 105;

        {** character device identification **}
     dfCharDevice              = $8000;

     gcwEndOfChain             = $FFFF;
     gcsUnits                  = ' Units';

     csiAbout                  = '~A~bout';
     csiMcbList                = '~M~CB List';
     csiUmbList                = '~U~MB List';
     csiDevInfo                = '~D~evices Info';
     csiNone                   = '';
     cskNone                   = '';

     cslNone                   = '';
     cslClose                  = '~Alt-F3~ Close ';
     cslEscape                 = '~Esc~ Close';
     cslExit                   = '~Alt-X~ Exit';

     prg_type_Mouse            = 00;
     prg_type_COMMAND          = 01;
     prg_type_4DOS             = 02;
     prg_type_NDOS             = 03;
     prg_type_WIN              = 04;
     prg_type_DN               = 05;
     prg_type_NC               = 06;
     prg_type_SMARTDRV         = 07;
     prg_type_KEYB             = 08;
     prg_type_MSCDEX           = 09;
     prg_type_PRINT            = 10;

     mcb_mess_GetExtendedInfo  = $0100;

     mcb_sign_DeviceDriver     = $44;
     mcb_sign_FilesTable       = $46;
     mcb_sign_Buffers          = $58;
     mcb_sign_FcbTable         = $40;
     mcb_sign_EmsBuffers       = $43;
     mcb_sign_Stacks           = $53;
     mcb_sign_CurrentDir       = $4C;
     mcb_sign_IfsDriver        = $49;
     mcb_sign_DeviceAppendage  = $45;

     mcb_flag_NoName           = 01;
     mcb_flag_StrangeName      = 02;
     mcb_flag_EndOfChain       = 04;

     mcb_owner_FreeMemory      = $0000;
     mcb_owner_IOSYS           = $0008;

     mcb_name_SystemData       = 'SD';
     mcb_name_SystemCode       = 'SC';
     mcb_name_None             = 'none';

     mcb_error_ErrorInChain    = 01;

     mcb_segm_RamEnd           = $9FFF;

     prg_flag_NoEnvironment    = 01;
     prg_flag_AlienEnvironment = 02;
     prg_flag_CurrentProgram   = 04;


Type
    PDeviceAttributes   = ^TDeviceAttributes;
    TDeviceAttributes   = array[1..16] of Boolean;

       {** Device driver info record **}
    PDeviceInfoRec      = ^TDeviceInfoRec;
    TDeviceInfoRec      = record
      IsMCB        : Boolean;
      CharDev      : Boolean;
      DeviceType   : Word;
      DevicePtr    : PCharDeviceHeader;
    end;


     {** Collection of DeviceInfoRec **}
    PDeviceCollection     = ^TDeviceCollection;
    TDeviceCollection     = object(TCollection)
      procedure FreeItem(P: Pointer); virtual;
    end;

    PDeviceAttrInfo = ^TDeviceAttrInfo;
    TDeviceAttrInfo = object(TDialog)
      constructor Init(Device: PDeviceInfoRec);
    end;


    PDeviceInfoListBox    = ^TDeviceInfoListBox;
    TDeviceInfoListBox    = object(TListBox)
      CharDeviceTypes : PLineCollection;
      CharDeviceNames : PCharDeviceCollection;
      BlockDeviceTypes: PLineCollection;
      BlockDeviceNames: PBlockDeviceCollection;
      constructor Init(var Bounds: TRect; ANumCols: Word;
         AScrollBar: PScrollBar);
      procedure     HandleEvent(Var Event: TEvent); virtual;
      function      GetText(Item: Integer; MaxLen: Integer): String; virtual;
      function      GetCharDeviceType(Device: PCharDeviceHeader): Word;
      function      GetBlockDeviceType(Device: PBlockDeviceHeader): Word;
      function      GetDeviceDriversList(StartDevice: PCharDeviceHeader): PDeviceCollection;
      destructor    Done; virtual;
    end;

     {** Device List Dialog **}
    PDeviceInfoDialog     = ^TDeviceInfoDialog;
    TDeviceInfoDialog     = object(TDialog)
      DeviceListBox   : PDeviceInfoListBox;
      DeviceAttrInf   : PDeviceAttrInfo;
      constructor   Init(StartDevice: PCharDeviceHeader; Name: TTitleStr);
      procedure     HandleEvent(Var Event: TEvent);virtual;
      procedure     GetDeviceDriverInfo(Device: PDeviceInfoRec);
      destructor    Done; virtual;
    end;


    PEnvirStrsCollection = ^TEnvirStrsCollection;
    TEnvirStrsCollection = object(TCollection)
      Procedure     FreeItem(P: Pointer); virtual;
    End;

    PMcbCollection    = ^TMcbCollection;
    TMcbCollection    = object(TCollection)
      Procedure     FreeItem(P: Pointer); virtual;
    End;

    PMcbInfoRec       = ^TMcbInfoRec;
    TMcbInfoRec       = record
      Flags         : System.Word;
      Address       : PMcbRec;
      MCB_Type      : System.Word;  {** Why "Word" ? For FUTURE!! **}
    End;

    PMcbExtendedInfo   = ^TMcbExtendedInfo;
    TMcbExtendedInfo   = object(TDialog)
      Constructor Init(Info: Pointer);
    End;

    PMcbObj           = ^TMcbObj;
    TMcbObj           = object(TObject)
      MCB_Info      : TMcbInfoRec;
      InfoDialog    : PDialog;
      Constructor Init(Info: TMcbInfoRec);
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Function    GetMCB_Name: TString8; virtual;
      Procedure   ReturnExtendedInfo; virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_ProgramData = ^TMcbObj_ProgramData;
    TMcbObj_ProgramData = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Function    GetMCB_Name: TString8; virtual;
      Procedure   ReturnExtendedInfo; virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_SystemData = ^TMcbObj_SystemData;
    TMcbObj_SystemData = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Function    GetMCB_Name: TString8; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_Environment  = ^TMcbObj_Environment;
    TMcbObj_Environment  = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Function    GetMCB_Name: TString8; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_DeviceDriver = ^TMcbObj_DeviceDriver;
    TMcbObj_DeviceDriver = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_IfsDriver    = ^TMcbObj_IfsDriver;
    TMcbObj_IfsDriver    = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_Sft          = ^TMcbObj_Sft;
    TMcbObj_Sft          = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_Stacks       = ^TMcbObj_Stacks;
    TMcbObj_Stacks       = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_Buffers      = ^TMcbObj_Buffers;
    TMcbObj_Buffers      = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_EmsBuffers   = ^TMcbObj_EmsBuffers;
    TMcbObj_EmsBuffers   = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_Program      = ^TMcbObj_Program;
    TMcbObj_Program      = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_CurrentDir   = ^TMcbObj_CurrentDir;
    TMcbObj_CurrentDir   = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_FcbTable     = ^TMcbObj_FcbTable;
    TMcbObj_FcbTable     = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_DeviceAppendage = ^TMcbObj_DeviceAppendage;
    TMcbObj_DeviceAppendage = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_SystemCode = ^TMcbObj_SystemCode;
    TMcbObj_SystemCode = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Function    GetMCB_Name: TString8; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_FreeMemory = ^TMcbObj_FreeMemory;
    TMcbObj_FreeMemory = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Function    GetMCB_Name: TString8; virtual;
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMemviewApplication = ^TMemviewApplication;
    TMemviewApplication = object(TApplication)
      Constructor Init;
      Procedure   InitMenuBar; virtual;
      Procedure   InitStatusLine; virtual;
      Procedure   HandleEvent(Var Event: TEvent); virtual;
      Procedure   CreateMemList;
      Procedure   CreateUmbMemList;
      Procedure DevListWindow;
      Destructor  Done; virtual;
    End;


    PMcbInfoListBox    = ^TMcbInfoListBox;
    TMcbInfoListBox    = object(TListBox)
      Procedure   HandleEvent(Var Event: TEvent); virtual;
      Function    GetText(Item: Integer; MaxLen: Integer): String; virtual;
    end;

    PMcbInfoDialog     = ^TMcbInfoDialog;
    TMcbInfoDialog     = object(TDialog)
      McbListBox: PMcbInfoListBox;
      Constructor Init(List: PMcbCollection; Name: TTitleStr);
      Procedure   HandleEvent(Var Event: TEvent);virtual;
      Destructor  Done; virtual;
    End;

    PEnvScroller = ^TEnvScroller;
    TEnvScroller = object(TScroller)
      EnvLines : PEnvirStrsCollection;
      Constructor Init(Var Bounds: TRect;AHScrollBar, AVScrollBar: PScrollBar; Info: PMcbObj);
      Destructor Done; virtual;
      Procedure Draw; virtual;
      Procedure SetState(AState: Word; Enable: Boolean);virtual;
    end;


Const
     asPurpose        = 'Memory Viewer Utility';
     asVersion        = '0.01';
     asAuthor         = 'Ivan Begtin';
     asCopyright      = 'Copyright (c) 1996';
     asProgram        = 'MemView';

  RDeviceCollection: TstreamRec = (
     ObjType : 1001;
     VmtLink : Ofs(Typeof(TDeviceCollection)^);
     Load    : @TDeviceCollection.Load;
     Store   : @TDeviceCollection.Store
  );
  RDeviceAttrInfo: TstreamRec = (
     ObjType : 1002;
     VmtLink : Ofs(Typeof(TDeviceAttrInfo)^);
     Load    : @TDeviceAttrInfo.Load;
     Store   : @TDeviceAttrInfo.Store
  );
  RDeviceInfoDialog: TstreamRec = (
     ObjType : 1003;
     VmtLink : Ofs(Typeof(TDeviceInfoDialog)^);
     Load    : @TDeviceInfoDialog.Load;
     Store   : @TDeviceInfoDialog.Store
  );
  RDeviceInfoListBox: TstreamRec = (
     ObjType : 1004;
     VmtLink : Ofs(Typeof(TDeviceInfoListBox)^);
     Load    : @TDeviceInfoListBox.Load;
     Store   : @TDeviceInfoListBox.Store
  );




Var
     gvbUMB_Present     : Boolean;
     gvbAdvancedCheck   : Boolean;
     gvbSystemProgrammer: Boolean;
     gvdCommandLineMode : Boolean;
     gvbFullOptions     : Boolean;
     gvbFirstMCB_Info   : PMcbObj;


Function ConvertEnvironment(Address: PMcbRec): PEnvirStrsCollection;
Var
   C: Byte;
   Collection: PEnvirStrsCollection;
Begin
  New(Collection, Init(10, 8));
  for C:=1 to  GetEnvCount(Seg(Address^) + 1) do
  Begin
    Collection^.Insert(EnvPChar(Seg(Address^) + 1, C));
  End;
  ConvertEnvironment:= Collection;
End;

  {** Put Substring in string at specific position **}
Procedure PutInStr(Var S: string; S1: string; Pos: byte);
Var
   C:byte;
Begin
  for C:=1 to Byte(S1[0]) do
  Begin
    S[Pos+C-1]:=S1[C];
    if Byte(S[0]) < Byte(S1[0]) + Pos then Byte(S[0]):=Byte(S1[0]) + Pos;
  End;
End;

   {** Convert DOS Limited PChar Array To String **}
function CharArrayToString(A:array of Char; Size: Word):String;assembler;
asm
  PUSH  DS
  LES   DI, @Result
  MOV   DX, DI
  LDS   SI, A
  MOV   CX, Size
  XOR   CH ,CH
  JCXZ  @@004
  MOV   BL, CL
  XOR   AL, AL
  STOSB
@@001:
  LODSB
  CMP   AL, 00h
  JE    @@003
  CMP   AL, 20h
  JB    @@004
  CMP   AL, 80h
  JA    @@004
  STOSB
  LOOP  @@001
@@003:
  MOV   AL, BL
  SUB   AL, CL
  JMP   @@005
@@004:
  XOR   AL, AL
@@005:
  MOV   DI, DX
  STOSB
  POP   DS
end;

{var
  Count:byte;
begin
  Count:=0;
  repeat
    Inc(Count);
    CharArrayToString[Count]:=A[Count-1];
  until (A[Count-1] < #32) or (A[Count-1] > #127) or (Count = $FF) or  (Count = Sizeof(A));
  CharArrayToString[0]:=Char(Count);
end;}


Function IsValidChar(Ch: Char): Boolean;
Begin
  IsValidChar:= ((Byte(CH) > 127) or ((Byte(CH) < 32)));
End;

Function GetMCB_Type(Info: PMcbObj): String;
Begin
  Case Info^.MCB_Info.MCB_Type of
    mcb_type_Stacks         : GetMCB_Type:= 'Dos STACKS';
    mcb_type_DeviceDriver   : GetMCB_Type:= 'Device Driver';
    mcb_type_DeviceAppendage: GetMCB_Type:= 'Device Appendage';
    mcb_type_Program        : GetMCB_Type:= 'TSR Program';
    mcb_type_Sft            : GetMCB_Type:= 'Dos FILES';
    mcb_type_SystemData     : GetMCB_Type:= 'System Data';
    mcb_type_SystemCode     : GetMCB_Type:= 'System Code';
    mcb_type_ProgramData    : GetMCB_Type:= 'Program Data';
    mcb_type_FcbTable       : GetMCB_Type:= 'FCB Table';
    mcb_type_Buffers        : GetMCB_Type:= 'Buffers';
    mcb_type_EmsBuffers     : GetMCB_Type:= 'EMS Buffers';
    mcb_type_FreeMemory     : GetMCB_Type:= 'Free Memory';
    mcb_type_CurrentDir     : GetMCB_Type:= 'Current Directory';
    mcb_type_Environment    : GetMCB_Type:= 'Environment';
    mcb_type_IfsDriver      : GetMCB_Type:= 'IFS Driver';
  End;
End;

Function GetMCB_TypeAddr(Info: PMcbObj): String;
Begin
  GetMCB_TypeAddr:= GetMCB_Type(Info) + ' at ' + HexPtr(Info^.MCB_Info.Address);
End;


Procedure SendMessage(McbObj: PMcbObj; Code: Word);
Begin
  MCbObj^.MessagesConvert(Code);
End;


{** TEnvirStrsCollection **}
Procedure TEnvirStrsCollection.FreeItem(P: Pointer);
Begin
End;


{** TMcbCollection **}
Procedure TMcbCollection.FreeItem(P: Pointer);
Begin
  Dispose(PMcbObj(P), Done);
End;


Function Error(Code: Word; Info: Pointer): Boolean;
Begin

End;


Function  CreateMcbList(FirstSeg, LastSeg: Word): PMcbCollection;
Var
   Collection     : PMcbCollection;
   McbObj         : PMcbObj;
   EndOfChain     : Boolean;
   CurrentMcb_Info: TMcbInfoRec;
   CurrentMcb     : PMcbRec;
   CurrMcbSegOfs  : TSegOfs absolute CurrentMcb;

Begin
  CurrentMcb:= Ptr(FirstSeg, 0);
  EndOfChain:= false;
  New(Collection, Init(10, 8));
  repeat
    if (CurrentMcb^.Signature = Std_Mcb) or (CurrentMcb^.Signature = Last_Mcb) Then
    Begin
      if (CurrentMcb^.Signature = Last_Mcb) then
      Begin
        CurrentMcb_Info.Flags:= CurrentMcb_Info.Flags and mcb_flag_EndOfChain;
        EndOfChain:= True;
      End;
      if (CurrentMcb^.Owner = mcb_owner_FreeMemory) then
        CurrentMCb_Info.Mcb_Type:= mcb_type_FreeMemory
      else if (CurrentMcb^.Owner <> CurrMcbSegOfs.S + 1) then
             if (CurrentMcb^.Owner = mcb_owner_IOSYS) then
             if (CurrentMcb^.Name[1] = 'S') and (CurrentMcb^.Name[2] = 'C') then
               CurrentMCb_Info.Mcb_Type:= mcb_type_SystemCode
             else if (CurrentMcb^.Name[1] = 'S') and (CurrentMcb^.Name[2] = 'D') then
               CurrentMCb_Info.Mcb_Type:= mcb_type_SystemData
             else CurrentMcb_Info.Mcb_Type:= mcb_type_ProgramData
             else if (PPspRec(Ptr(CurrentMcb^.Owner, 0))^.PrgEnvSeg = CurrMcbSegOfs.S + 1) then
               CurrentMCb_Info.Mcb_Type:= mcb_type_Environment
             else
               CurrentMCb_Info.Mcb_Type:= mcb_type_ProgramData
             else if (PMcb_PspRec(CurrentMcb)^.Psp.RetComm = PSP_Sign) then
               CurrentMCb_Info.Mcb_Type:= mcb_type_Program
             else
               CurrentMCb_Info.Mcb_Type:= mcb_type_ProgramData;
      CurrentMcb_Info.Address:= CurrentMcb;
      Case CurrentMcb_Info.Mcb_Type of
        mcb_type_ProgramData : McbObj:= New(PMcbObj_ProgramData, Init(CurrentMcb_Info));
        mcb_type_Environment  : McbObj:= New(PMcbObj_Environment, Init(CurrentMcb_Info));
        mcb_type_Program     : McbObj:= New(PMcbObj_Program, Init(CurrentMcb_Info));
        mcb_type_SystemData  : McbObj:= New(PMcbObj_SystemData, Init(CurrentMcb_Info));
        mcb_type_SystemCode  : McbObj:= New(PMcbObj_SystemCode, Init(CurrentMcb_Info));
        mcb_type_FreeMemory  : McbObj:= New(PMcbObj_FreeMemory, Init(CurrentMcb_Info));
      End;
    End
    else Error(mcb_error_ErrorInChain, CurrentMcb);
    Collection^.Insert(McbObj);
    CurrMcbSegOfs.S:=CurrMcbSegOfs.S + CurrentMcb^.Size + 1;
  Until (CurrMcbSegOfs.S = LastSeg) or EndOfChain;
  CreateMcbList:= Collection;
End;


Function  CreateSysDataList(FirstSeg, LastSeg: Word): PMcbCollection;
Var
   CurrentMcb     : PMcbRec;
   CurrentMcb_Info: TMcbInfoRec;
   CurrMcbSegOfs  : TSegOfs absolute CurrentMcb;
   McbObj         : PMcbObj;
   Collection     : PMcbCollection;

Begin
  CurrentMcb:= Ptr(FirstSeg, 0);
  New(Collection, Init(10, 8));
  repeat
    Case CurrentMcb^.Signature of
      mcb_sign_DeviceDriver    : CurrentMcb_Info.Mcb_Type:= mcb_type_DeviceDriver;
      mcb_sign_IfsDriver       : CurrentMcb_Info.Mcb_Type:= mcb_type_IfsDriver;
      mcb_sign_DeviceAppendage : CurrentMcb_Info.Mcb_Type:= mcb_type_DeviceAppendage;
      mcb_sign_FcbTable        : CurrentMcb_Info.Mcb_Type:= mcb_type_FcbTable;
      mcb_sign_FilesTable      : CurrentMcb_Info.Mcb_Type:= mcb_type_Sft;
      mcb_sign_Stacks          : CurrentMcb_Info.Mcb_Type:= mcb_type_Stacks;
      mcb_sign_EmsBuffers      : CurrentMcb_Info.Mcb_Type:= mcb_type_EmsBuffers;
      mcb_sign_Buffers         : CurrentMcb_Info.Mcb_Type:= mcb_type_Buffers;
      mcb_sign_CurrentDir      : CurrentMcb_Info.Mcb_Type:= mcb_type_CurrentDir;
      else Error(mcb_error_ErrorInChain, CurrentMcb);
    End;
    CurrentMcb_Info.Address:= CurrentMcb;
    Case CurrentMcb_Info.Mcb_Type of
      mcb_type_DeviceDriver    : McbObj:= New(PMcbObj_DeviceDriver, Init(CurrentMcb_Info));
      mcb_type_IfsDriver       : McbObj:= New(PMcbObj_IfsDriver, Init(CurrentMcb_Info));
      mcb_type_DeviceAppendage : McbObj:= New(PMcbObj_DeviceAppendage, Init(CurrentMcb_Info));
      mcb_type_Sft             : McbObj:= New(PMcbObj_FcbTable, Init(CurrentMcb_Info));
      mcb_type_FcbTable        : McbObj:= New(PMcbObj_Sft, Init(CurrentMcb_Info));
      mcb_type_Stacks          : McbObj:= New(PMcbObj_Stacks, Init(CurrentMcb_Info));
      mcb_type_Buffers         : McbObj:= New(PMcbObj_Buffers, Init(CurrentMcb_Info));
      mcb_type_CurrentDir      : McbObj:= New(PMcbObj_CurrentDir, Init(CurrentMcb_Info));
      mcb_type_EmsBuffers      : McbObj:= New(PMcbObj_EmsBuffers, Init(CurrentMcb_Info));
    End;
    Collection^.Insert(McbObj);
    CurrMcbSegOfs.S:=CurrMcbSegOfs.S + CurrentMcb^.Size + 1;
  Until (CurrMcbSegOfs.S = LastSeg);
  CreateSysDataList:= Collection;
End;

function ConvertMcbInfoToString(Info: PMcbObj): String;
var
  S: String;
  TempStr: TString8;
begin
  S:= CharRep(#32,Sizeof(S)-1);
  PutInStr(S, HexPtr(Info^.MCB_Info.Address), 1);
  TempStr:= Info^.GetMCB_Name;
  if TempStr = '' then TempStr:= mcb_name_None;
  PutInStr(S, TempStr, 12);
  PutInStr(S, HexW(Info^.MCB_Info.Address^.Owner), 22);
  PutInStr(S, Digit(LongInt(Info^.MCB_Info.Address^.Size) * 16), 28);
  PutInStr(S, GetMCB_Type(Info), 36);
  ConvertMcbInfoToString:= S;
end;

  {** Return ~True~ if device is character. **}
function CheckForCharDevice(Device: PCharDeviceHeader): Boolean;
begin
  if (Device^.DevAttr and dfCharDevice) <> 0 then  CheckForCharDevice := true
  else CheckForCharDevice:= false;
end;

  {** Return type of character device **}
function TDeviceInfoListBox.GetCharDeviceType(Device: PCharDeviceHeader): Word;
type
    PDosName = ^TDosName;
var
  C: Word;
  Found : Boolean;
begin
  C:=0;
  Found:=false;
  repeat
    Inc(C);
    if Device^.Name = PDosName(CharDeviceNames^.At(C))^ then Found:= true;
  until (C  = CharDeviceNames^.Count) or Found;
  if not Found then C:= 0;
  GetCharDeviceType:= C;
end;

  {** Return type of block device **}
function TDeviceInfoListBox.GetBlockDeviceType(Device: PBlockDeviceHeader): Word;
type
    PBlockDevName = ^TBlockDevName;
var
  C: Word;
  Found : Boolean;
begin
  C:=0;
  Found:=false;
  repeat
    Inc(C);
    if Device^.Name = PBlockDevName(BlockDeviceNames^.At(C))^  then Found:= true;
  until (C  = BlockDeviceNames^.Count) or Found;
  if not Found then C:= 0;
  GetBlockDeviceType:= C;
end;

  {** Return number of block device drives **}
function GetBlockDeviceDrives(Device: PBlockDeviceHeader): TString7;
var
  CurrDpt : PDptRec;
  Found   : Boolean;
  Count   : Byte;
begin
  CurrDpt:=Sysvars^.FirstDPT;
  Count:=0;
  Found:= false;
  repeat
    Inc(Count);
    If Device = CurrDpt^.DriveDevice then Found:= true;
    CurrDpt:= CurrDpt^.Next;
  until Found or (Word(CurrDpt) = gcwEndOfChain);
  if Found Then  GetBlockDeviceDrives:=Char(Count + 64)+': - ' + Char(Count+ 64 + Device^.NumUnits - 1) + ':'
  else GetBlockDeviceDrives:= Digit(Device^.NumUnits) + gcsUnits;
end;

  {** Return device drivers list **}
function TDeviceInfoListBox.GetDeviceDriversList(StartDevice: PCharDeviceHeader): PDeviceCollection;
var
  Collection    : PDeviceCollection;
  CurrentDevice : PCharDeviceHeader;
  DeviceInfo    : PDeviceInfoRec;
begin
  Collection:= nil;
  CurrentDevice:= StartDevice;
  New(Collection,Init(10,8));
  repeat
    New(DeviceInfo);
    With DeviceInfo^ do
    begin
      DevicePtr:= CurrentDevice;
      IsMCB:= (PMcbRec(Ptr(Seg(DevicePtr^) - 1, 0))^.Owner = Seg(DevicePtr^));
      CharDev:=CheckForCharDevice(DevicePtr);
      if CharDev then DeviceType:=GetCharDeviceType(DevicePtr)
      else DeviceType:=GetBlockDeviceType(PBlockDeviceHeader(DevicePtr));
    end;
    Collection^.Insert(DeviceInfo);
    CurrentDevice:=CurrentDevice^.Next;
  until Word(CurrentDevice) =gcwEndOfChain;
  GetDeviceDriversList:= Collection;
end;


{** Return 'Yes' if ~True~ else 'No' **}
function SayNo(Bool: Boolean): TString3;
begin
  if Bool then SayNo:= 'Yes' else SayNo:= 'No';
end;

  {**  **}
procedure GetDeviceAttr(Attr: Word; Var DevAttr: TDeviceAttributes);
var
  Count: Byte;
begin
  For Count:=0 to 15 do
  DevAttr[Count+1]:=Boolean((Attr SHR Count) and 1) ;
end;


procedure TDeviceInfoDialog.GetDeviceDriverInfo(Device: PDeviceInfoRec);
begin
  DeviceAttrInf:= New(PDeviceAttrInfo,Init(Device));
  DeskTop^.ExecView(DeviceAttrInf);
end;


constructor TDeviceAttrInfo.Init(Device: PDeviceInfoRec);
var
  R: TRect;
  DevName: TString8;
  Count: Byte;
  DevAttrib: TDeviceAttributes;
begin
With Device^ do
 begin
  R.Assign(20,4,47,22);
  if CharDev then DevName:=CharArrayToString(DevicePtr^.Name, Sizeof(DevicePtr^.Name))
  else DevName:=GetBlockDeviceDrives(PBlockDeviceHeader(DevicePtr));
  inherited Init(R,DevName);
  GetDeviceAttr(DevicePtr^.DevAttr,DevAttrib);
  For Count:= 1 to 16 do
  begin
    R.Assign(1,Count,26,17);
    Insert(New(PStaticText,Init(R,gcaDevAttrNames[Count]+' : '+ SayNo(DevAttrib[Count]))));
  end;
 end;
end;


{** TDeviceInfoListBox **}
function TDeviceInfoListBox.GetText(Item: Integer; MaxLen: Integer): String;
var
  S: String;
begin
  if List = nil then GetText:= '' else
  begin
    S:= CharRep(#32,Sizeof(S)-1);
    with PDeviceInfoRec(List^.At(Item))^ do
    begin
      PutInStr(S,HexPtr(DevicePtr),1);
      PutInStr(S,HexW(DevicePtr^.DevInterr),22);
      PutInStr(S,HexW(DevicePtr^.DevStrat),28);
      PutInStr(S,HexW(DevicePtr^.DevAttr),34);
      if CharDev then
      begin
        PutInStr(S,CharArrayToString(DevicePtr^.Name, Sizeof(DevicePtr^.Name)),12);
        if IsMCB then PutInStr(S,CharArrayToString(PMcbRec(Ptr(Seg(DevicePtr^) - 1,0))^.Name,
        Sizeof(TDosName)), 40);
        PutInStr(S, PString(CharDeviceTypes^.At(DeviceType))^, 50);
      end
      else
      begin
        PutInStr(S,GetBlockDeviceDrives(PBlockDeviceHeader(DevicePtr)), 12);
        PutInStr(S, PString(BlockDeviceTypes^.At(DeviceType))^, 50);
      end;
    end;
  end;
  GetText:= S;
end;

procedure EndProgram(Error: Integer);
begin
  Writeln('Error number ', Error);
  Halt;
end;

constructor TDeviceInfoListBox.Init(var Bounds: TRect; ANumCols: Word; AScrollBar: PScrollBar);
begin
  CharDeviceNames:= PCharDeviceCollection(RezFile.Get('CharDevNames'));
  CharDeviceTypes:= PLineCollection(RezFile.Get('CharDevTypes'));
  BlockDeviceNames:= PBlockDeviceCollection(RezFile.Get('BlockDevNames'));
  BlockDeviceTypes:= PLineCollection(RezFile.Get('BlockDevTypes'));
  inherited Init(Bounds, ANumCols, AScrollBar);
end;

destructor TDeviceInfoListBox.Done;
begin
  Dispose(CharDeviceNames, Done);
  Dispose(CharDeviceTypes, Done);
  Dispose(BlockDeviceNames, Done);
  Dispose(BlockDeviceTypes, Done);
end;


procedure TDeviceInfoListBox.HandleEvent(Var Event: TEvent);
begin
  if (Event.What = evKeyDown) and (Event.KeyCode = kbEnter) then
     Message(Owner,evBroadcast,cmGetDriverInfo,List^.At(Focused)) else
     if (Event.What = evMouseDown) and (Event.Double) then
        Message(Owner,evBroadcast,cmGetDriverInfo,List^.At(Focused))
     else inherited HandleEvent(Event);
end;


{** TDeviceCollection **}
procedure TDeviceCollection.FreeItem(P: Pointer);
begin
  Dispose(PDeviceInfoRec(P));
end;



Constructor TDeviceInfoDialog.Init(StartDevice: PCharDeviceHeader; Name: TTitleStr);
var
  R: TRect;
  ScrollBar: PScrollBar;
begin
  R.Assign(0,0,80,23);
  inherited Init(R, Name);
  GetExtent(R);
  Inc(R.A.X, 2);
  Dec(R.B.X);
  Inc(R.A.Y);
  R.B.Y:=R.A.Y + 1;
  Insert(New(PStaticText, Init(R, asDescription)));
  Inc(R.A.Y,1);   Inc(R.B.Y,1);
  Insert(New(PStaticText, Init(R, asDescFill)));
  GetExtent(R);
  R.Grow(-1, -1);
  R.A.X:= R.B.X - 1;
  Inc(R.A.Y,2);
  New(ScrollBar,Init(R));
  Insert(ScrollBar);
  R.B.X:= R.A.X;
  R.A.X:= 1;
  New(DeviceListBox,Init(R,1,ScrollBar));
  Insert(DeviceListBox);
             {**  **}
  DeviceListBox^.NewList(DeviceListBox^.GetDeviceDriversList(StartDevice));
             {** Stop selection of next button **}
  SelectNext(False);
end;


procedure TDeviceInfoDialog.HandleEvent(Var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evCommand) or (Event.What = evBroadcast) then
   Case Event.Command of
     cmGetDriverInfo: GetDeviceDriverInfo(PDeviceInfoRec(Event.InfoPtr))
   else
     Exit;
   end;
end;


destructor TDeviceInfoDialog.Done;
begin
  DeviceListBox^.NewList(Nil);
{  Message(DeviceListBox,evCommand,cmClose,nil);}
  inherited Done;
end;


Constructor TMcbExtendedInfo.Init(Info: Pointer);
Var
   R: TRect;
Begin
  Desktop^.Last^.GetExtent(R);
  Inc(R.A.X);
  Inc(R.A.Y);
  inherited Init(R, GetMCB_TypeAddr(PMcbObj(Info)));
End;


{** TMcbObj **}
Constructor TMcbObj.Init(Info: TMcbInfoRec);
Var
   S: TString8;
Begin
  MCB_Info:= Info;
  S:= GetMCB_Name;
  if S = '' Then MCB_Info.Flags:= MCB_Info.Flags and mcb_flag_NoName
  else if IsValidChar(S[Byte(S[0])]) Then
  Begin
    Dec(Byte(S[0]));
    MCB_Info.Flags:= MCB_Info.Flags and mcb_flag_StrangeName;
  End;
End;

Procedure TMcbObj.MessagesConvert(Message: TMessage);
Begin
  Case Message of
    mcb_mess_GetExtendedInfo : ReturnExtendedInfo;
  End;
End;

Function  TMcbObj.GetMCB_Name: TString8;
Begin
  GetMCB_Name:= CharArrayToString(MCB_Info.Address^.Name, Sizeof(MCB_Info.Address^.Name));
End;

Procedure TMcbObj.ReturnExtendedInfo;
Begin
End;

Destructor TMcbObj.Done;
Begin
End;

{** TMcbObj_SystemData **}
Constructor TMcbObj_SystemData.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure TMcbObj_SystemData.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Function  TMcbObj_SystemData.GetMCB_Name: TString8;
Begin
  GetMCB_Name:= mcb_name_SystemData;
End;

Procedure   TMcbObj_SystemData.ReturnExtendedInfo;
Begin
 InfoDialog:= New(PMcbInfoDialog, Init(CreateSysDataList(Seg(MCB_Info.Address^) + 1,
   Seg(MCB_Info.Address^)+ MCB_Info.Address^.Size + 1), GetMCB_TypeAddr(@Self)));

 Desktop^.ExecView(InfoDialog);
 { inherited ReturnExtendedInfo; }
End;

Destructor  TMcbObj_SystemData.Done;
Begin
End;

{** TMcbObj_Environment **}
Constructor TMcbObj_Environment.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_Environment.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Function  TMcbObj_Environment.GetMCB_Name: TString8;
Begin
  GetMCB_Name:= CharArrayToString(PMcbRec(Ptr(MCB_Info.Address^.Owner - 1 , 0))^.Name,
    Sizeof(TDosName));
End;

Procedure TMcbObj_Environment.ReturnExtendedInfo;
Var
   R: TRect;
Begin
  inherited ReturnExtendedInfo;
  InfoDialog:= New(PMcbExtendedInfo, Init(@Self));
  InfoDialog^.GetExtent(R);
  InfoDialog^.Options:= InfoDialog^.Options or ofTileable;
  R.Grow(-1, -1);
  InfoDialog^.Insert(New(PEnvScroller, Init(R,
    InfoDialog^.StandardScrollBar(sbHorizontal + sbHandleKeyBoard),
    InfoDialog^.StandardScrollBar(sbVertical + sbHandleKeyBoard),
    @Self)));
  Desktop^.ExecView(InfoDialog);
End;

Destructor  TMcbObj_Environment.Done;
Begin
End;

{** TMcbObj_ProgramData **}
Constructor TMcbObj_ProgramData.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_ProgramData.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Function    TMcbObj_ProgramData.GetMCB_Name: TString8;
Begin
  GetMCB_Name:= CharArrayToString(PMcbRec(Ptr(MCB_Info.Address^.Owner - 1, 0))^.Name,
                  Sizeof(TDosName));
End;

Procedure TMcbObj_ProgramData.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_ProgramData.Done;
Begin
End;

{** TMcbObj_SystemCode **}
Constructor TMcbObj_SystemCode.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_SystemCode.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Function  TMcbObj_SystemCode.GetMCB_Name: TString8;
Begin
  GetMCB_Name:= mcb_name_SystemCode;
End;

Procedure TMcbObj_SystemCode.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_SystemCode.Done;
Begin
End;

{** TMcbObj_DeviceDriver **}
Constructor TMcbObj_DeviceDriver.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_DeviceDriver.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure TMcbObj_DeviceDriver.ReturnExtendedInfo;
var
  DevLst: PDeviceInfoDialog;
begin
  DevLst:=New(PDeviceInfoDialog, Init(Ptr(Seg(MCB_Info.Address^) + 1, 0), GetMCB_TypeAddr(@Self)));
  Desktop^.ExecView(DevLst);
End;

Destructor  TMcbObj_DeviceDriver.Done;
Begin
End;

{** TMcbObj_IfsDriver **}
Constructor TMcbObj_IfsDriver.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_IfsDriver.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure   TMcbObj_IfsDriver.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_IfsDriver.Done;
Begin
End;

{** TMcbObj_DeviceAppendage **}
Constructor TMcbObj_DeviceAppendage.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_DeviceAppendage.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure   TMcbObj_DeviceAppendage.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_DeviceAppendage.Done;
Begin
End;

{** TMcbObj_Sft **}
Constructor TMcbObj_Sft.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_Sft.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure   TMcbObj_Sft.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_Sft.Done;
Begin
End;

{** TMcbObj_Stacks **}
Constructor TMcbObj_Stacks.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_Stacks.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure   TMcbObj_Stacks.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_Stacks.Done;
Begin
End;

{** TMcbObj_Buffers **}
Constructor TMcbObj_Buffers.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_Buffers.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure   TMcbObj_Buffers.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_Buffers.Done;
Begin
End;

{** TMcbObj_EmsBuffers **}
Constructor TMcbObj_EmsBuffers.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_EmsBuffers.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure   TMcbObj_EmsBuffers.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_EmsBuffers.Done;
Begin
End;

{** TMcbObj_FreeMemory **}
Constructor TMcbObj_CurrentDir.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_CurrentDir.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure   TMcbObj_CurrentDir.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_CurrentDir.Done;
Begin
End;

{** TMcbObj_FcbTable **}
Constructor TMcbObj_FcbTable.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_FcbTable.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure   TMcbObj_FcbTable.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_FcbTable.Done;
Begin
End;

{** TMcbObj_Program **}
Constructor TMcbObj_Program.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_Program.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure   TMcbObj_Program.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_Program.Done;
Begin
End;

{** TMcbObj_FreeMemory **}
Constructor TMcbObj_FreeMemory.Init(Info: TMcbInfoRec);
Begin
  TMcbObj.Init(Info);
End;

Procedure   TMcbObj_FreeMemory.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Function  TMcbObj_FreeMemory.GetMCB_Name: TString8;
Begin
  GetMCB_Name:='';
End;

Procedure   TMcbObj_FreeMemory.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_FreeMemory.Done;
Begin
End;

{** TMcbInfoListBox **}
Function TMcbInfoListBox.GetText(Item: Integer; MaxLen: Integer): String;
Var
  McbInfo: PMcbObj;
Begin
  if List = nil then GetText:= ''
  else Begin
         McbInfo:= PMcbObj(List^.At(Item));
         GetText:= ConvertMcbInfoToString(McbInfo);
       End;
End;

Procedure TMcbInfoListBox.HandleEvent(Var Event: TEvent);
Begin
   if ((Event.What = evKeyDown) and (Event.KeyCode = kbEnter)) or
      ((Event.What = evMouseDown) and (Event.Double)) then
     SendMessage(PMcbObj(List^.At(Focused)), mcb_mess_GetExtendedInfo)
   else
     inherited HandleEvent(Event);
End;

{** TMemviewApplication **}
Constructor TMemviewApplication.Init;
Begin
  RezStream := New(PBufStream, Init('MEMVIEW.RES', stOpenRead, 4096));
  if RezStream^.Status <> stOK then
  begin
    PrintStr('Unable to open resource file.');
    Halt(1);
  end;
  RezFile.Init(RezStream);

  RegisterObjects;  { registers TStringCollection }
  RegisterGlobals;
  RegisterViews;
  RegisterMenus;
  RegisterDialogs;
  RegisterApp;
  RegisterType(RStringList);

  RezStrings := PStringList(RezFile.Get('Strings'));
  if RezStrings = nil then
  begin
    PrintStr('Unable to read resources from resource file.');
    Halt(1);
  end;
  TApplication.Init;
End;

Destructor TMemviewApplication.Done;
Begin
  TApplication.Done;
End;

Function StandardStatusLine(R: TRect): PStatusLine;
begin
  StandardStatusLine:= New(PStatusLine, Init(R,
    NewStatusDef(0, $FFFF,
      NewStatusKey(cslExit, kbAltX, cmQuit,
      NewStatusKey(cslClose, kbAltF3, cmClose,
      NewStatusKey(cslEscape, kbEsc, cmClose,
      nil))),
    nil)));
end;

Procedure TMemviewApplication.InitStatusLine;
Var
  R: TRect;
Begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine:= StandardStatusLine(R);
end;

Procedure TMemviewApplication.InitMenuBar;
Var
  R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
       NewItem(csiAbout, cskNone, kbAltF1, cmAbout, hcNoContext,
       NewItem(csiMcbList, cskNone, kbCtrlF1, cmGetMcbList, hcNoContext,
       NewItem(csiUmbList, cskNone, kbCtrlF2, cmGetUmbList, hcNoContext,
       NewItem(csiDevInfo, cskNone, kbCtrlF3, cmDevList, hcNoContext,
    nil)))))));
end;

Procedure DoAbout;
begin
  MessageBox(#3+gcsPurpose+' '+gcsVersion + #13#3+
             gcsCopyright+' '+gcsAuthor,nil,mfInformation);
end;

Procedure TMemviewApplication.CreateMemList;
Var
  McbLst: PMcbInfoDialog;
Begin
  McbLst:=New(PMcbInfoDialog, Init(CreateMcbList(Sysvars^.FirstMcbSeg ,mcb_segm_RamEnd), gcsMcbListName));
  Desktop^.ExecView(McbLst);
End;

Procedure TMemviewApplication.CreateUmbMemList;
Var
  McbLst: PMcbInfoDialog;
Begin
  McbLst:=New(PMcbInfoDialog, Init(CreateMcbList(mcb_segm_RamEnd, $FFFF), gcsUmbListName));
  Desktop^.ExecView(McbLst);
End;

procedure TMemviewApplication.DevListWindow;
var
  DevLst: PDeviceInfoDialog;
begin
  DevLst:=New(PDeviceInfoDialog,Init((Addr(Sysvars^.NullDevice)),
    gcsDeviceListName));
  Desktop^.ExecView(DevLst);
end;



Procedure TMemviewApplication.HandleEvent(Var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evCommand) or (Event.What = evBroadcast) then
   Begin
     Case Event.Command of
       cmAbout     :       DoAbout;
       cmGetMcbList:       CreateMemList;
       cmGetUmbList:       CreateUmbMemList;
       cmDevList   :       DevListWindow;
     else
       Exit;
     end;
     ClearEvent(Event);
   end;
end;

  {** TMcbInfoDialog **}
Constructor TMcbInfoDialog.Init(List: PMcbCollection; Name: TTitleStr);
Var
  R: TRect;
  ScrollBar: PScrollBar;
Begin
  R.Assign(0,0,80,23);
  inherited Init(R, Name);
  GetExtent(R);
  Inc(R.A.X, 2);
  Dec(R.B.X);
  Inc(R.A.Y);
  R.B.Y:=R.A.Y + 1;
  Insert(New(PStaticText, Init(R, gcsDescription)));
  Inc(R.A.Y,1);   Inc(R.B.Y,1);
  Insert(New(PStaticText, Init(R, gcsDescFill)));
  GetExtent(R);
  R.Grow(-1, -1);
  R.A.X:= R.B.X - 1;
  Inc(R.A.Y,2);
  New(ScrollBar,Init(R));
  Insert(ScrollBar);
  R.B.X:= R.A.X;
  R.A.X:= 1;
  New(McbListBox,Init(R,1, ScrollBar));
  Insert(McbListBox);
  McbListBox^.NewList(List);
             {** Stop selection of next button **}
  SelectNext(False);
End;


Procedure TMcbInfoDialog.HandleEvent(Var Event: TEvent);
Begin
  inherited HandleEvent(Event);
{  if (Event.What = evCommand) or (Event.What = evBroadcast) then
   Case Event.Command of
     cmGetDriverInfo: GetDeviceDriverInfo(PDeviceInfoRec(Event.InfoPtr))
   else
     Exit;
   end;}
End;

Destructor TMcbInfoDialog.Done;
begin
  McbListBox^.NewList(Nil);
  inherited Done;
end;


constructor TEnvScroller.Init(Var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar; Info: PMcbObj);
Var
   MaxWidth: Integer;
   Count   : Integer;
   SSize   : Integer;
Begin
  inherited Init(Bounds,AHScrollBar, AVScrollBar);
  GrowMode := gfGrowHiX + gfGrowHiY;
  EnvLines := ConvertEnvironment(Info^.MCB_Info.Address);
  MaxWidth := 0;
  for Count:= 0 to EnvLines^.Count - 1 do
  Begin
    SSize := StrLen(EnvLines^.At(Count));
    if SSize > MaxWidth then MaxWidth:= SSize;
  End;
  Limit.Y  := EnvLines^.Count;
  Limit.X  := MaxWidth;
end;

destructor TEnvScroller.Done;
begin
  Dispose(EnvLines, Done);
  TScroller.Done;
end;

procedure TEnvScroller.Draw;
var
  B: TDrawBuffer;
  C: Byte;
  I: Integer;
  P,S: String;
  N: PChar;
  K: Byte;
Begin
  C := GetColor(1);
  for I:=0 To Size.Y - 1 Do
  Begin
    MoveChar(B, ' ', C, Size.X);
    if Delta.Y + I < EnvLines^.Count Then
    Begin
      N := EnvLines^.At(Delta.Y + I);
      P := StrPas(N);
      S := Copy(P, Delta.X + 1, Size.X);
      MoveStr(B,S,C);
    End;
      WriteLine(0, I, Size.X, 1, B);
  End;
End;

procedure TEnvScroller.SetState(AState: Word; Enable: Boolean);
begin
  TScroller.SetState(AState, Enable);
  if Enable and (AState and sfExposed <> 0) then
     SetLimit(Limit.X, Limit.Y);
end;



Var
    McbList    : PMcbCollection;
    C          : Integer;
    Application: TMemviewApplication;

Begin
  Application.Init;
  Application.Run;
  Application.Done;
End.
