{ PROJECT               TURBO MEMORY VIEW/CONTROL UTILITIES             }
{                       FREEWARE SOFTWARE                               }
{ LIBRARY               SYSTEM UTILITIES                                }
{ MODULE                BASE CONSTRUCTIONS                              }
{ FILE NAME             MEMVIEW.PAS                                     }
{ PURPOSE               View and Control Different Memory Blocks        }
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
{                       3.Using TVision for output this all.            }
{                       4.MCB View Utility.                             }
{                       5.MCB's and Programs types  analys.             }
{                       6.Full check for any errors.                    }
{ REVISION HISTORY     Ivan Begtin (IB)                                 }
{                                                                       }
{-----------------------------------------------------------------------}





Program Memview;

   {$M 32768, 100000, 100000}

Uses TSystem, Objects, Newdos,IvString,
     Views, Dialogs, App, Strings, MsgBox,
     Drivers, Menus, ShowTErr, Globals, Equ;


Const
     cmGetDescription     = $8000;
     cmAbout              = $8001;

     str_None             = 'none';

     rom_status_Ok        = 0000;
     rom_status_Stealthed = 0001;
     rom_status_Error     = 0002;

     seg_VideoROM         = $C000;
     seg_BiosROM          = $F000;
     seg_BiosData         = $0040;

Type
    TMessage   = System.Word;

    PBlockName = ^TBlockName;
    TBlockName = String[12];

    PBlocksCollection = ^TBlocksCollection;
    TBlocksCollection = object(TCollection)
      procedure FreeItem(Item: Pointer); virtual;
    End;


    TMemviewApp = object(TApplication)
      constructor Init;
      destructor Done; virtual;
    End;

    PBlocksListBox = ^TBlocksListBox;
    TBlocksListBox = object(TListBox)
      procedure HandleEvent(Var Event: TEvent); virtual;
      Function    GetText(Item: Integer; MaxLen: Integer): String; virtual;
    End;


    PBlocksListDialog = ^TBlocksListDialog;
    TBlocksListDialog = object(TDialog)
      ListBox: PBlocksListBox;
      constructor Init(List: PBlocksCollection);
      procedure HandleEvent(Var Event: TEvent); virtual;
      destructor Done; virtual;
    End;


    PBaseObject = ^TBaseObject;
    TBaseObject = object(TDialog)
      Address  : System.Pointer;
      BlockSize: System.Longint;
      Name     : TBlockName;
      BlockType: TBlockName;
      constructor Init;
      destructor Done; virtual;
    End;


    PRomBlock = ^TRomBlock;
    TRomBlock = object(TBaseObject)
      ROMStatus: System.Word;
      constructor Init(Segment: System.Word);
      destructor Done; virtual;
    End;


    PRomBiosBlock = ^TRomBiosBlock;
    TRomBiosBlock = object(TRomBlock)
      constructor Init;
      destructor Done; virtual;
    End;


    PVideoRomBlock = ^TVideoRomBlock;
    TVideoRomBlock = object(TRomBlock)
      constructor Init;
      destructor Done; virtual;
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



function CreateNewList: PBlocksCollection;
Var
   Collection: PBlocksCollection;
   TempBlock: PBaseObject;
Begin
  New(Collection, Init(10, 8));

  TempBlock:= New(PVideoRomBlock, Init);
  Collection^.Insert(TempBlock);

  TempBlock:= New(PRomBiosBlock, Init);
  Collection^.Insert(TempBlock);

  CreateNewList:= Collection;
End;


{TBlocksCollection}
procedure TBlocksCollection.Freeitem(Item: Pointer);
Begin
  Dispose(PBaseObject(Item), Done);
End;


{TBlocksListBox}
procedure TBlocksListBox.HandleEvent(Var Event: TEvent);
begin
  if (Event.What = evKeyDown) and (Event.KeyCode = kbEnter) then
     Message(Owner,evBroadcast,cmGetDescription,List^.At(Focused)) else
     if (Event.What = evMouseDown) and (Event.Double) then
        Message(Owner,evBroadcast,cmGetDescription,List^.At(Focused))
     else inherited HandleEvent(Event);
end;

Function    TBlocksListBox.GetText(Item: Integer; MaxLen: Integer): String;
Var
   S: String;
Begin
  if List = nil then GetText:= '' else
  begin
    S:= CharRep(#32,Sizeof(S)-1);
    with PBaseObject(List^.At(Item))^ do
    Begin
      PutInStr(S, HexPtr(Address), 1);
      PutInStr(S, Name, 12);
      if BlockSize = 0 then PutInStr(S, 'Unknown', 21) else
      PutInStr(S, Digit(BlockSize), 21);
      PutInStr(S, BlockType, 34);
    End;
  GetText:= S;
  End;
End;


{TBlocksListDialog}
constructor TBlocksListDialog.Init(List: PBlocksCollection);
Var
  R : TRect;
  Control : PView;

Begin
  R.Assign(0, 0, 71, 17);
  inherited Init(R, 'Memory Viewer');
  Palette := dpBlueDialog;

  R.Assign(56, 2, 66, 4);
  Control := New(PButton, Init(R, 'O~K~', cmOK, bfDefault));
  Insert(Control);

  R.Assign(2, 5, 46, 15);
  ListBox:= New(PBlocksListBox, Init(R, 1, Nil));
  Control:= ListBox;
  Control^.Options := Control^.Options or ofFramed;
  ListBox^.NewList(List);
  Insert(Control);

  R.Assign(19, 1, 32, 2);
  Insert(New(PLabel, Init(R, '~B~locks table', Control)));

  R.Assign(2, 2, 46, 3);
  Control := New(PStaticText, Init(R, ' Address   Name     Size(bytes)  Typ'+
     'e    '));
  Insert(Control);

  R.Assign(2, 3, 46, 4);
  Control := New(PStaticText, Init(R, '-------------------------------------'+
     '-----------------------------------------------'));
  Insert(Control);

  R.Assign(54, 5, 69, 7);
  Control := New(PButton, Init(R, '~D~escription', cmGetDescription, bfDefault));
  Insert(Control);

  R.Assign(54, 8, 69, 10);
  Control := New(PButton, Init(R, '~A~bout', cmAbout, bfDefault));
  Insert(Control);

  SelectNext(False);
End;

procedure TBlocksListDialog.HandleEvent(Var Event: TEvent);
Begin
  inherited HandleEvent(Event);
  if (Event.What = evCommand) or (Event.What = evBroadcast) then
   Case Event.Command of
     cmGetDescription: Desktop^.ExecView(PBaseObject(Event.InfoPtr));
   else
     Exit;
   End;
End;


destructor TBlocksListDialog.Done;
Begin
  ListBox^.NewList(nil);
  inherited Done;
End;



{TBaseObject}
constructor TBaseObject.Init;
Begin
{  TDialog.Init();
}
End;


destructor TBaseObject.Done;
Begin
  inherited Done;
End;


{TRomBlock}
Constructor TRomBlock.Init(Segment: System.Word);
Begin
  Address:= Ptr(Segment, 0);
  if PRomInfoRec(Address)^.Signature <> ROM_Sign then
    begin
      ROMStatus:=rom_status_Stealthed;
      BlockSize:= 0;
    end
  else
    begin
      ROMStatus:=rom_status_Ok;
      BlockSize:= Longint(PRomInfoRec(Address)^.Size_512) * 512;
    end;
  Name:= 'Unknown ROM';
  ROMStatus:=rom_status_Stealthed;
End;


destructor TRomBlock.Done;
Begin
  inherited Done;
End;


constructor TVideoRomBlock.Init;
Begin
  TRomBlock.Init(seg_VideoROM);
  BlockType:= 'Video ROM';
  Name:= str_None;
End;

destructor TVideoRomBlock.Done;
Begin
  inherited Done;
End;


constructor TRomBiosBlock.Init;
Begin
  TRomBlock.Init(seg_BiosROM);
  BlockType:= 'Bios ROM';
  Name:= str_None;
End;

destructor TRomBiosBlock.Done;
Begin
  inherited Done;
End;


constructor TMemviewApp.Init;
Var
  BlocksDialog: PBlocksListDialog;
Begin
  RegisterObjects;  { registers TStringCollection }
  RegisterGlobals;
  RegisterViews;
  RegisterMenus;
  RegisterDialogs;
  RegisterApp;
  TApplication.Init;
  BlocksDialog:= New(PBlocksListDialog, Init(CreateNewList));
  Desktop^.ExecView(BlocksDialog);
End;


destructor  TMemviewApp.Done;
Begin
  TApplication.Done;
End;


Var
   MyApp: TMemviewApp;

Begin
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
End.