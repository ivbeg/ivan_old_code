{** Turbo Vision  Device drivers lister **}
Program TVDevLst;

     {** used modules **}
Uses  Objects, Drivers, Views, Menus,
      TSystem, IvString,NewDos,Strings,MsgBox,
      Dialogs,App,ShowTErr;


{$I DevList.INC}
type
  Str7    = string[7];
  Str3    = string[3];
  Str8    = string[8];

const
  asDescription      = ' Address    Name     Strat Intrp Attr  MCB Name ';
  asDescFill         = '------------------------------------------------';



   {** Status line strings **}
  cslNone            = '';
  cslClose           = '~Alt-F3~ Close ';
  cslEscape          = '~Esc~ Close';
  cslExit            = '~Alt-X~ Exit';


   {** Events types **}
  cmDevList          = 101;
  cmGetDriverInfo    = 102;
  cmAbout            = 103;

   {** character device identification **}
  dfCharDevice           = $8000;

   {** copyright string **}
  gcsPurpose             = 'Device Drivers Lister';
  gcsVersion             = 'v0.20';
  gcsAuthor              = 'Ivan Begtin';
  gcsCopyright           = 'Copyright (c) 1996';
  gcsProgram             = 'DevLst';

  csiDevInfo             = 'Device ~I~nfo';
  csiAbout               = '~A~bout';
  cskNone                = '';

  gcsDeviceListName      = 'Device Drivers List';

type
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
    procedure HandleEvent(Var Event: TEvent); virtual;
    function GetText(Item: Integer; MaxLen: Integer): String; virtual;
  end;

     {** Device List Dialog **}
  PDeviceInfoDialog     = ^TDeviceInfoDialog;
  TDeviceInfoDialog     = object(TDialog)
    DeviceListBox: PDeviceInfoListBox;
    DeviceAttrInf: PDeviceAttrInfo;
    constructor Init;
    procedure HandleEvent(Var Event: TEvent);virtual;
    procedure GetDeviceDriverInfo(Device: PDeviceInfoRec);
    destructor Done; virtual;
  end;

     {** TVision Application **}
  PDeviceInfoApplication = ^TDeviceInfoApplication;
  TDeviceInfoApplication = object(TApplication)
    constructor Init;
    procedure InitMenuBar; virtual;
    procedure InitStatusLine; virtual;
    procedure HandleEvent(Var Event: TEvent);virtual;
    procedure DevListWindow;
    destructor Done; virtual;
  end;

const
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



  {** Put Substring in string at specific position **}
procedure PutInStr(Var S: string; S1: string; Pos: byte);
var
  C:byte;
begin
  For C:=1 to Byte(S1[0]) do
  begin
    S[Pos+C-1]:=S1[C];
    if Byte(S[0]) < Byte(S1[0]) + Pos then Byte(S[0]):=Byte(S1[0]) + Pos;
  end;
end;

  {** Return ~True~ if device is character. **}
function CheckForCharDevice(Device: PCharDeviceHeader): Boolean;
begin
  if (Device^.DevAttr and dfCharDevice) <> 0 then  CheckForCharDevice := true
  else CheckForCharDevice:= false;
end;

  {** Return type of character device **}
function GetCharDeviceType(Device: PCharDeviceHeader): Word;
var
  C: Word;
  Found : Boolean;
begin
  C:=0;
  Found:=false;
  repeat
    Inc(C);
    if Device^.Name = gcaCharDeviceNames[C] then Found:= true;
  until (C  = gcwMaxCharDevNames) or Found;
  if not Found then C:= 0;
  GetCharDeviceType:= C;
end;

  {** Return type of block device **}
function GetBlockDeviceType(Device: PBlockDeviceHeader): Word;
var
  C: Word;
  Found : Boolean;
begin
  C:=0;
  Found:=false;
  repeat
    Inc(C);
    if Device^.Name = gcaBlockDeviceNames[C] then Found:= true;
  until (C  = gcwMaxBlockDevNames) or Found;
  if not Found then C:= 0;
  GetBlockDeviceType:= C;
end;

  {** Return number of block device drives **}
function GetBlockDeviceDrives(Device: PBlockDeviceHeader): Str7;
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
function GetDeviceDriversList: PDeviceCollection;
var
  Collection    : PDeviceCollection;
  CurrentDevice : PCharDeviceHeader;
  DeviceInfo    : PDeviceInfoRec;
begin
  Collection:= nil;
  CurrentDevice:= Addr(Sysvars^.NullDevice);
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


  {** Converting Device info to string for output **}
function ConvertDeviceInfoToString(DeviceInfo: PDeviceInfoRec): String;
var
  S: String;
begin
  S:= CharRep(#32,Sizeof(S)-1);
  With DeviceInfo^ do
  begin
    PutInStr(S,HexPtr(DevicePtr),1);
    PutInStr(S,HexW(DevicePtr^.DevInterr),22);
    PutInStr(S,HexW(DevicePtr^.DevStrat),28);
    PutInStr(S,HexW(DevicePtr^.DevAttr),34);
    if CharDev then
    begin
      PutInStr(S,CharArrayToString(DevicePtr^.Name),12);
      if IsMCB then PutInStr(S,CharArrayToString(PMcbRec(Ptr(Seg(DevicePtr^) - 1,0))^.Name),40);
    end
    else
    begin
      PutInStr(S,GetBlockDeviceDrives(PBlockDeviceHeader(DevicePtr)),12);
    end;
  end;
  ConvertDeviceInfoToString:= S;
end;


{** Return 'Yes' if ~True~ else 'No' **}
function SayNo(Bool: Boolean): Str3;
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
  DeskTop^.Insert(DeviceAttrInf);
end;


constructor TDeviceAttrInfo.Init(Device: PDeviceInfoRec);
var
  R: TRect;
  DevName: Str8;
  Count: Byte;
  DevAttrib: TDeviceAttributes;
begin
With Device^ do
 begin
  R.Assign(20,4,47,22);
  if CharDev then DevName:=CharArrayToString(DevicePtr^.Name)
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
  DevInfo: PDeviceInfoRec;
begin
  if List = nil then GetText:= ''
  else begin
    DevInfo:= PDeviceInfoRec(List^.At(Item));
    GetText:= ConvertDeviceInfoToString(DevInfo);
  end;
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



Constructor TDeviceInfoDialog.Init;
var
  R: TRect;
  ScrollBar: PScrollBar;
begin
  R.Assign(0,0,80,23);
  inherited Init(R, gcsDeviceListName);
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
  R.B.X:= 51;
  R.A.X:= R.B.X - 1;
  Inc(R.A.Y, 2);
  New(ScrollBar,Init(R));
  Insert(ScrollBar);
  R.B.X:= R.A.X;
  R.A.X:= 1;
  New(DeviceListBox,Init(R,1,ScrollBar));
  Insert(DeviceListBox);
             {**  **}
  DeviceListBox^.NewList(GetDeviceDriversList);
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


constructor TDeviceInfoApplication.Init;
begin
  RegisterObjects;
  RegisterViews;
  RegisterMenus;
  RegisterDialogs;
  RegisterApp;
  RegisterType(RDeviceInfoDialog);
  RegisterType(RDeviceAttrInfo);
  RegisterType(RDeviceCollection);
  RegisterType(RDeviceInfoListBox);
  TApplication.Init;
end;


destructor TDeviceInfoApplication.Done;
begin
  TApplication.Done;
end;


function StandardStatusLine(R: TRect): PStatusLine;
begin
  StandardStatusLine:= New(PStatusLine, Init(R,
    NewStatusDef(0, $FFFF,
      NewStatusKey(cslExit, kbAltX, cmQuit,
      NewStatusKey(cslClose, kbAltF3, cmClose,
      NewStatusKey(cslEscape, kbEsc, cmClose,
      nil))),
    nil)));
end;


procedure TDeviceInfoApplication.InitStatusLine;
Var
  R: TRect;
Begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine:= StandardStatusLine(R);
end;


procedure TDeviceInfoApplication.InitMenuBar;
Var
  R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
       NewItem(csiDevInfo,cskNone,kbNoKey,cmDevList,hcNoContext,
       NewItem(csiAbout,cskNone,kbAltF1,cmAbout,hcNoContext,
    nil)))));
end;


procedure DoAbout;
begin
  MessageBox(#3+gcsPurpose+' '+gcsVersion + #13#3+
             gcsCopyright+' '+gcsAuthor,nil,mfInformation);
end;


procedure TDeviceInfoApplication.HandleEvent(Var Event: TEvent);
begin
  inherited HandleEvent(Event);
  if (Event.What = evCommand) or (Event.What = evBroadcast) then
   Begin
     Case Event.Command of
       cmDevList:       DevListWindow;
       cmAbout  :       DoAbout;
     else
       Exit;
     end;
     ClearEvent(Event);
   end;
end;


procedure TDeviceInfoApplication.DevListWindow;
var
  DevLst: PDeviceInfoDialog;
begin
  DevLst:=New(PDeviceInfoDialog,Init);
  DeskTop^.Insert(DevLst);
end;


var
  DevApp: TDeviceInfoApplication;
begin
  DevApp.Init;
  DevApp.Run;
  DevApp.Done;
end.