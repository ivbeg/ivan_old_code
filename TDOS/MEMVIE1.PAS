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


Uses TSystem, Objects, Newdos,IvString;

Type
    TMessage          = System.Word;

    TSystemData_Code  = array[1..2] of System.Char;

    PEnvInfoRec       = ^TEnvInfoRec;
    TEnvInfoRec       = record
      EnvPtr        : PChar;
    End;



Const
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

     mcb_type_Program          = 00;
     mcb_type_DeviceDriver     = 01;
     mcb_type_Sft              = 02;
     mcb_type_SystemData       = 03;
     mcb_type_SystemCode       = 04;
     mcb_type_ProgaramData     = 05;
     mcb_type_DeviceAppendage  = 06;
     mcb_type_FcbTable         = 07;
     mcb_type_Buffers          = 08;
     mcb_type_EmsBuffers       = 09;
     mcb_type_Stacks           = 10;
     mcb_type_FreeMemory       = 11;
     mcb_type_CurrentDir       = 12;
     mcb_type_Environment      = 13;
     mcb_type_IfsDriver        = 14;
     mcb_type_ProgramData      = 15;

     mcb_flag_EndOfChain       = 01;
     mcb_flag_NoName           = 02;
     mcb_flag_StrangeName      = 04;

     mcb_owner_FreeMemory      = $0000;
     mcb_owner_IOSYS           = $0008;

     mcb_name_SystemData       : TSystemData_Code = 'SD';
     mcb_name_SystemCode       : TSystemData_Code = 'SC';

     mcb_error_ErrorInChain    = 01;

     mcb_segm_RamEnd           = $9FFF;

     prg_flag_NoEnvironment    = 01;
     prg_flag_AlienEnvironment = 02;
     prg_flag_CurrentProgram   = 04;


Type
    PEnvirStrsCollection = ^TEnvirStrsCollection;
    TEnvirStrsCollection = object(TCollection)
      Procedure FreeItem(P: Pointer); virtual;
    End;

    PMcbCollection    = ^TMcbCollection;
    TMcbCollection    = object(TCollection)
      Procedure FreeItem(P: Pointer); virtual;
    End;


    PMcbInfoRec       = ^TMcbInfoRec;
    TMcbInfoRec       = record
      Flags         : System.Word;
      Address       : PMcbRec;
      MCB_Type      : System.Word;  {** Why "Word" ? For FUTURE!! **}
    End;

    PMcbObj           = ^TMcbObj;
    TMcbObj           = object(TObject)
      MCB_Info      : TMcbInfoRec;
      Constructor Init(Info: TMcbInfoRec);
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Procedure   ReturnExtendedInfo; virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_ProgramData = ^TMcbObj_ProgramData;
    TMcbObj_ProgramData = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_SystemData = ^TMcbObj_SystemData;
    TMcbObj_SystemData = object(TMcbObj)
      SystemData_List : PMcbCollection;
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_Environment  = ^TMcbObj_Environment;
    TMcbObj_Environment  = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
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
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;

    PMcbObj_FreeMemory = ^TMcbObj_FreeMemory;
    TMcbObj_FreeMemory = object(TMcbObj)
      Constructor Init(Info: TMcbInfoRec);
      Procedure   ReturnExtendedInfo; virtual;
      Procedure   MessagesConvert(Message: TMessage); virtual;
      Destructor  Done; virtual;
    End;


Const
     asPurpose        = 'Memory Viewer Utility';
     asVersion        = '0.01';
     asAuthor         = 'Ivan Begtin';
     asCopyright      = 'Copyright (c) 1996';
     asProgram        = 'MemView';

Var
     gvbUMB_Present     : Boolean;
     gvbAdvancedCheck   : Boolean;
     gvbSystemProgrammer: Boolean;
     gvdCommandLineMode : Boolean;
     gvbFullOptions     : Boolean;
     gvbFirstMCB_Info   : PMcbObj;

{
Function ConvertEnvironment(Address: PMcbRec): PEnvirStrsCollection;
Var
   C: Byte;
Begin
  For C:=1 to  EnvCount do
End;
}

{** TEnvirStrsCollection **}
Procedure TEnvirStrsCollection.FreeItem(P: Pointer);
Begin
  Dispose(PEnvInfoRec(P));
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

{** TMcbObj **}
Constructor TMcbObj.Init(Info: TMcbInfoRec);
Begin
  MCB_Info:= Info;
End;

Procedure TMcbObj.MessagesConvert(Message: TMessage);
Begin
  Case Message of
    mcb_mess_GetExtendedInfo : ReturnExtendedInfo;
  End;
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

Procedure   TMcbObj_SystemData.MessagesConvert(Message: TMessage);
Begin
  inherited MessagesConvert(Message);
End;

Procedure   TMcbObj_SystemData.ReturnExtendedInfo;
Begin
  Writeln('System Data.');
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_SystemData.Done;
Begin
 { Dispose(SystemData_List);}
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

Procedure TMcbObj_Environment.ReturnExtendedInfo;
Begin
  Writeln('Environment.');
  inherited ReturnExtendedInfo;
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

Procedure TMcbObj_ProgramData.ReturnExtendedInfo;
Begin
  Writeln('Program Data.');
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

Procedure TMcbObj_SystemCode.ReturnExtendedInfo;
Begin
  Writeln('System Code.');
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
  Writeln('Device Driver.');
  inherited MessagesConvert(Message);
End;

Procedure TMcbObj_DeviceDriver.ReturnExtendedInfo;
Begin
  inherited ReturnExtendedInfo;
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
  Writeln('Ifs Driver.');
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
  Writeln('Device Driver Appendage.');
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
  Writeln('FILES');
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
  Writeln('Stacks.');
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
  Writeln('Buffers');
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
  Writeln('EMS Buffers.');
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
  Writeln('Current Directories.');
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
  Writeln('FCB Table.');
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
  Writeln('Program.');
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

Procedure   TMcbObj_FreeMemory.ReturnExtendedInfo;
Begin
  Writeln('Free Memory.');
  inherited ReturnExtendedInfo;
End;

Destructor  TMcbObj_FreeMemory.Done;
Begin
End;

   {** Convert DOS Limited PChar Array To String **}
function CharArrayToString(A:array of Char):String;
var
  Count:byte;
begin
  Count:=0;
  repeat
    Inc(Count);
    CharArrayToString[Count]:=A[Count-1];
  until (A[Count] < #33) or (A[Count] > #127) or (Count = $FF) or  (Count =Sizeof(A));
  CharArrayToString[0]:=Char(Count);
end;


Procedure OutputMcb(Info: PMcbObj);
Begin
  Write('Address: ', HexPtr(Info^.MCB_Info.Address), '; Type: ');
  Info^.ReturnExtendedInfo;
  Writeln('MCB_Name: ', CharArrayToString(Info^.MCB_Info.Address^.Name));
End;


Var
    McbList : PMcbCollection;
    C       : Integer;
Begin
  Writeln('Start Segment: ',HexW(Sysvars^.FirstMcbSeg));
  McbList:= CreateMcbList(Sysvars^.FirstMcbSeg ,mcb_segm_RamEnd);
  Writeln('Mcb Number: ',McbList^.Count);
  for C:=0 to McbList^.Count - 1  do OutputMcb(PMcbObj(McbList^.At(C)));
  Dispose(McbList, Done);
  Writeln;

  Writeln('Start Segment: ',HexW(mcb_segm_RamEnd));
  McbList:= CreateMcbList(mcb_segm_RamEnd, $FFFF);
  Writeln('Mcb Number: ',McbList^.Count);
  for C:=0 to McbList^.Count - 1  do OutputMcb(PMcbObj(McbList^.At(C)));
  Dispose(McbList, Done);
End.