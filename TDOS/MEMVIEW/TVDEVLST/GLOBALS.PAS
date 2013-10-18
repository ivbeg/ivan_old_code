Unit Globals;

interface

Uses Objects, TSystem, Views, Dialogs, App,
     Strings, MsgBox, Drivers, Menus;

Var
   RezFile: TResourceFile;
   RezStream: PStream;
   RezStrings: PStringList;

Type
    PCharDeviceCollection = ^TCharDeviceCollection;
    TCharDeviceCollection = object(TCollection)
      procedure  FreeItem(Item: Pointer); virtual;
      procedure  PutItem(var S: TStream; Item: Pointer); virtual;
      function   GetItem(var S: TStream): Pointer; virtual;
    End;

    PBlockDeviceCollection = ^TCharDeviceCollection;
    TBlockDeviceCollection = object(TCollection)
      procedure  FreeItem(Item: Pointer); virtual;
      procedure  PutItem(var S: TStream; Item: Pointer); virtual;
      function   GetItem(var S: TStream): Pointer; virtual;
    End;

    PLineCollection = ^TLineCollection;
    TLineCollection = object(TCollection)
      procedure  FreeItem(Item: Pointer); virtual;
      procedure  PutItem(var S: TStream; Item: Pointer); virtual;
      function   GetItem(var S: TStream): Pointer; virtual;
    End;

  { THCStatusLine is a help context sensitive status line }

    PHCStatusLine = ^THCStatusLine;
    THCStatusLine = object(TStatusLine)
      function   Hint(AHelpCtx: Word): String; virtual;
    End;




procedure RegisterGlobals;

const
  RLineCollection: TStreamRec = (
    ObjType: $100;
    VmtLink: Ofs(TypeOf(TLineCollection)^);
    Load: @TLineCollection.Load;
    Store: @TLineCollection.Store);

const
  RCharDeviceCollection: TStreamRec = (
    ObjType: $101;
    VmtLink: Ofs(TypeOf(TCharDeviceCollection)^);
    Load: @TCharDeviceCollection.Load;
    Store: @TCharDeviceCollection.Store);

const
  RBlockDeviceCollection: TStreamRec = (
    ObjType: $102;
    VmtLink: Ofs(TypeOf(TBlockDeviceCollection)^);
    Load: @TBlockDeviceCollection.Load;
    Store: @TBlockDeviceCollection.Store);

const
  RHCStatusLine : TStreamRec = (
    ObjType : $103;
    VmtLink : Ofs(TypeOf(THCStatusLine)^);
    Load    : @THCStatusLine.Load;
    Store   : @THCStatusLine.Store
  );



function CharArrayToString(A:array of Char):String;


implementation

   {** Convert DOS Limited PChar Array To String **}
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



procedure RegisterGlobals;
begin
  RegisterType(RLineCollection);
  RegisterType(RCharDeviceCollection);
  RegisterType(RBlockDeviceCollection);
  RegisterType(RHCStatusLine);
end;

procedure  TLineCollection.FreeItem(Item: Pointer);
Begin
  DisposeStr(Item);
End;


function TLineCollection.GetItem(var S: TStream): Pointer;
begin
  GetItem := S.ReadStr;
end;

procedure TLineCollection.PutItem(var S: TStream; Item: Pointer);
begin
  S.WriteStr(Item);
end;

    {** TCharDeviceCollection **}
procedure  TCharDeviceCollection.FreeItem(Item: Pointer);
begin
  FreeMem(Item, Sizeof(TDosName));
end;

procedure  TCharDeviceCollection.PutItem(var S: TStream; Item: Pointer);
begin
  S.Write(Item^, Sizeof(TDosName));
end;

function   TCharDeviceCollection.GetItem(var S: TStream): Pointer;
Var
   P: ^TDosName;
begin
  GetMem(P, Sizeof(TDosName));
  S.Read(P^, Sizeof(TDosName));
  GetItem := P;
end;

    {** TBlockDeviceCollection **}
procedure  TBlockDeviceCollection.FreeItem(Item: Pointer);
begin
  FreeMem(Item, Sizeof(TBlockDevName));
end;

procedure  TBlockDeviceCollection.PutItem(var S: TStream; Item: Pointer);
begin
  S.Write(Item^, Sizeof(TBlockDevName));
end;

function   TBlockDeviceCollection.GetItem(var S: TStream): Pointer;
Var
   P: ^TDosName;
begin
  GetMem(P, Sizeof(TBlockDevName));
  S.Read(P^, Sizeof(TBlockDevName));
  GetItem := P;
end;


{ THCStatusLine }

function THCStatusLine.Hint(AHelpCtx: Word) :String;
begin
  Hint := RezStrings^.Get(AHelpCtx);
end;


End.
