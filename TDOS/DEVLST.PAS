Program DevLst;

{$R-}
{$S-}

{** used modules **}
Uses TSystem,IvString,NewDos,IvKbd,Strings;



const
  gcsNameTypes           = ' Address     Name    Strat Intr  Attr  MCB Name  Description';
  gcsUnderline           = '------------------------------------------------------------';

   {** character device identification **}
  dfCharDevice           = $8000;

   {** copyright string **}
  gcsPurpose             = 'Device Drivers Lister';
  gcsVersion             = 'v0.12';
  gcsAuthor              = 'Ivan Begtin';
  gcsCopyright           = 'Copyright (c) 1996';
  gcsProgram             = 'DevLst';

  gcwDeviceMaxCount      = 50;


type
  Str7                = String[7];

  PDeviceInfoRec      = ^TDeviceInfoRec;
  TDeviceInfoRec      = record
    CharDev      : Boolean;
    DeviceType   : Word;
    DevicePtr    : PCharDeviceHeader;
  end;

  PDevicePointers     = ^TDevicePointers;
  TDevicePointers     = array[1..gcwDeviceMaxCount] of PDeviceInfoRec;

{$I DevList.INC }

const
  gcbOutputStrSize       = 79;

var
  CurrentDevice  : PCharDeviceHeader;
  DevCount       : Byte;
  DevicePointers : PDevicePointers;

function CharArrayToPchar(A:array of Char):PChar;
var
  Count:byte;
  P: PChar;
begin
  Count:=0;
  repeat
    Inc(Count);
  until (A[Count-1] < #33) or (Count =Sizeof(A));
  GetMem(P,Count);
  MovePtr(Addr(A),P,Count);
  P[Count]:=#0;
  CharArrayToPChar:=P;
end;


function CharArrayToString(A:array of Char):String;
var
  Count:byte;
begin
  Count:=0;
  repeat
    Inc(Count);
    CharArrayToString[Count]:=A[Count-1];
  until (A[Count-1] < #33) or (Count = $FF) or  (Count =Sizeof(A));
  CharArrayToString[0]:=Char(Count);
end;


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


function CheckForCharDevice(Device: PCharDeviceHeader): Boolean;
begin
  if (Device^.DevAttr and dfCharDevice) <> 0 then  CheckForCharDevice := true
  else CheckForCharDevice:= false;
end;


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


procedure InitDevList;
begin
  DevCount:= 0;
  New(DevicePointers);
  CurrentDevice:= Addr(Sysvars^.NullDevice);
end;


procedure FreeDevListMemory;
var
  C: Byte;
begin
  For C:=1 to DevCount do
    Dispose(DevicePointers^[C]);
  Dispose(DevicePointers);
end;


procedure OutputDeviceList;
var
  S: String;
  C: Byte;
begin
  Writeln(gcsNameTypes);
  Writeln(gcsUnderline);
  For C:=1 To DevCount Do
  With DevicePointers^[C]^ Do
  begin
    S:=CharRep(#32,gcbOutputStrSize);
    PutInStr(S,HexPtr(DevicePtr),1);
    PutInStr(S,HexW(DevicePtr^.DevInterr),22);
    PutInStr(S,HexW(DevicePtr^.DevStrat),28);
    PutInStr(S,HexW(DevicePtr^.DevAttr),34);
    if CharDev then
    begin
      PutInStr(S,CharArrayToString(DevicePtr^.Name),12);
      if PMcbRec(Ptr(Seg(DevicePtr^) - 1,0))^.Owner = Seg(DevicePtr^) then
      PutInStr(S,CharArrayToString(PMcbRec(Ptr(Seg(DevicePtr^) - 1,0))^.Name),40);
      PutInStr(S,PCharToStr(gcaCharDeviceDesc[DeviceType]),50);
    end
    else
    begin
      PutInStr(S,GetBlockDeviceDrives(PBlockDeviceHeader(DevicePtr)),12);
      PutInStr(S,PCharToStr(gcaBlockDeviceDesc[DeviceType]),50);
    end;
    Writeln(S);
  end;
end;



procedure CreateDeviceList;
begin
  repeat
    Inc(DevCount);
    New(DevicePointers^[DevCount]);
    With DevicePointers^[DevCount]^ do
      begin
        DevicePtr:=CurrentDevice;
        CharDev:=CheckForCharDevice(DevicePtr);
        if CharDev then DeviceType:= GetCharDeviceType(DevicePtr)
        else DeviceType:= GetBlockDeviceType(PBlockDeviceHeader(DevicePtr));
      end;
    CurrentDevice:=CurrentDevice^.Next;
  until Word(CurrentDevice) = gcwEndOfChain;
end;

procedure WriteCopyright;
begin
  Writeln(gcsPurpose+' '+gcsVersion+' '+gcsCopyright+' '+gcsAuthor);
  Writeln;
end;

begin
  WriteCopyright;
  InitDevList;
  CreateDeviceList;
  OutputDeviceList;
  Write('press any key');
  repeat until Keypresent;
end.