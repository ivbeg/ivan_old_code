Program  MakingResources;

Uses Objects, Drivers, Dialogs, App, StdDlg,
     Views, Menus, TSystem, NewDos, ShowTErr, Globals, Equ;

{$I DEVLIST.INC}

const
     kbNone     = 0000;

Procedure MakeStringsList;
Var
   P: PStrListMaker;
Begin
  P:= New(PStrListMaker, Init(16384, 100));
  with P^ do
  Begin
    Put(hcInformation, 'Different Information');
    Put(hcSysInfo, 'Return System Information');
    Put(hcMcbList, 'Memory Control Blocks List');
    Put(hcUmbList, 'UMB Memory Control Blocks List');
    Put(hcDevList, 'Device Drivers List');
    Put(hcAbout, 'About Window');
  End;

  RezFile.Put(P, 'Strings');
  Dispose(P, Done);
End;

Procedure MakeStatusLine;
Var
   P: PHCStatusLine;
   R: TRect;
Begin
  R.Assign(0, 24, 80, 25);
  P := New(PHCStatusLine, Init(R,
    NewStatusDef(0, 0,
      NewStatusKey('~Alt-X~ Exit', kbAltX, cmQuit,
      NewStatusKey('', kbAltF3, cmClose,
      nil)),
    NewStatusDef(1, $FFFF,
        NewStatusKey('~Alt-X~ Exit', kbAltX, cmQuit,
        nil),
    nil))));
  RezFile.Put(P, 'StatusLine');
  Dispose(P, Done);
End;


Procedure MakeMenuBar;
Var
   R: TRect;
   M: PMenuBar;
Begin
  R.Assign(0,0,80,1);
  M := New(PMenuBar, Init(R, NewMenu(
  NewSubMenu('~I~nformation', hcInformation, NewMenu(
    NewItem('~S~ystem Info', '', kbNone, cmSysInfo, hcSysInfo,
    NewItem('~M~CB List', '', kbNone, cmMcbList, hcMcbList,
    NewItem('~U~MB List', '', kbNone, cmUmbList, hcUmbList,
    NewItem('~D~evice List', '', kbNone, cmDevList, hcDevList,
    nil))))),
  NewItem('~A~bout', '',kbNone, cmAbout, hcAbout,
  nil)))));
  RezFile.Put(M, 'MainMenu');
  Dispose(M, Done);
End;


Procedure MakeCharDeviceDriversNamesList;
Var
   List: PCharDeviceCollection;
   C:    Word;
   P:    ^TDosName;
Begin
  List := New(PCharDeviceCollection, Init(8, 10));
  for C:= 0 to gcwMaxCharDevNames do
  Begin
    GetMem(P, Sizeof(TDosName));
    P^:= gcaCharDeviceNames[C];
    List^.Insert(P);
  End;
  RezFile.Put(List, 'CharDevNames');
  Dispose(List, Done);
End;

Procedure MakeBlockDeviceDriversNamesList;
Var
   List: PBlockDeviceCollection;
   C:    Word;
   P:    ^TBlockDevName;
Begin
  List := New(PBlockDeviceCollection, Init(8, 10));
  for C:= 0 to gcwMaxBlockDevNames do
  Begin
    GetMem(P, Sizeof(TBlockDevName));
    P^:= gcaBlockDeviceNames[C];
    List^.Insert(P);
  End;
  RezFile.Put(List, 'BlockDevNames');
  Dispose(List, Done);
End;

Procedure MakeCharDeviceDriversDescrList;
Var
   List: PLineCollection;
   C:    Word;
Begin
  List := New(PLineCollection, Init(8, 10));
  for C:= 0 to gcwMaxCharDevNames do
  Begin
    List^.Insert(NewStr(gcaCharDeviceDesc[C]));
  End;
  RezFile.Put(List, 'CharDevTypes');
  Dispose(List, Done);
End;


Procedure MakeBlockDeviceDriversDescrList;
Var
   List: PLineCollection;
   C:    Word;
Begin
  List := New(PLineCollection, Init(8, 10));
  for C:= 0 to gcwMaxBlockDevNames do
  Begin
    List^.Insert(NewStr(gcaBlockDeviceDesc[C]));
  End;
  RezFile.Put(List, 'BlockDevTypes');
  Dispose(List, Done);
End;

Procedure MakeMcbTypesList;
Var
   P: PStrListMaker;
Begin
  P:= New(PStrListMaker, Init(16384, 100));
  with P^ do
  Begin
    Put(mcb_type_Program, 'TSR Program');
    Put(mcb_type_DeviceDriver, 'Device Driver');
    Put(mcb_type_DeviceAppendage, 'Device Appendage');
    Put(mcb_type_Stacks, 'Dos STACKS');
    Put(mcb_type_Sft, 'Dos FILES');
    Put(mcb_type_SystemData, 'System Data');
    Put(mcb_type_SystemCode, 'System Code');
    Put(mcb_type_ProgramData, 'Program Data');
    Put(mcb_type_FcbTable, 'FCB Table');
    Put(mcb_type_Buffers, 'Buffers');
    Put(mcb_type_EmsBuffers, 'EMS Buffers');
    Put(mcb_type_FreeMemory, 'Free Memory');
    Put(mcb_type_CurrentDir, 'Current Directory');
    Put(mcb_type_Environment, 'Environment');
    Put(mcb_type_IfsDriver, 'IFS Driver');
  End;
  RezFile.Put(P, 'McbTypes');
  Dispose(P, Done);
End;



Begin
  RezStream := New(PBufStream, Init('MEMVIEW.RES', stCreate, 4096));
  RezFile.Init(RezStream);

  RegisterObjects;  { registers TStringCollection }
  RegisterViews;
  RegisterMenus;
  RegisterDialogs;
  RegisterStdDlg;

  RegisterType(RStrListMaker);
  RegisterGlobals;

  MakeStringsList;
  MakeMenuBar;
  MakeStatusLine;

  MakeMcbTypesList;
  MakeCharDeviceDriversDescrList;
  MakeBlockDeviceDriversDescrList;
  MakeCharDeviceDriversNamesList;
  MakeBlockDeviceDriversNamesList;

  RezFile.Done;
End.