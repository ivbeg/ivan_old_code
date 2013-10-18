Uses Objects, Drivers, Views, Menus, App, IvSystem, IvString,
     NewDos;


type
  PLineCollection = ^TLineCollection;
  TLineCollection = object(TCollection)
    procedure FreeItem(P:Pointer); virtual;
  end;


  PMyApp = ^TMyApp;
  TMyApp = object(TApplication)
    Constructor Init;
    Procedure InitStatusLine; virtual;
    Procedure InitMenuBar; virtual;
    Procedure HandleEvent(var Event: TEvent);virtual;
    Procedure NewWindow;
    Procedure NewEnvWindow;
    Destructor Done; virtual;
  end;

  PMyWindow = ^TMyWindow;
  TMyWindow = object(TWindow)
     Constructor Init(Bounds: TRect; WinTitle: String; WindowN:Integer);
  end;


  PTextWindow = ^TTextWindow;
  TTextWindow = object(TWindow)
    constructor Init(R: TRect);
  end;


  PMyDeskTop = ^TMyDeskTop;
  TMyDeskTop = object(TDeskTop)
    MyWindow: PMyWindow;
    TextWindow:PTextWindow;
    Constructor Load(var S:TBufStream);
    Procedure  Store(var S:TBufStream); virtual;
  end;


  PEnvScroller = ^TEnvScroller;
  TEnvScroller = object(TScroller)
    EnvLines : PCollection;
    constructor Init(Var Bounds: TRect;AHScrollBar, AVScrollBar: PScrollBar);
    destructor Done; virtual;
    procedure Draw; virtual;
    procedure SetState(AState: Word; Enable: Boolean);virtual;
    procedure ReadEnviroment;
  end;



const
  csfSaveFile        = 'TEST.RES';

        {** Errors Strings **}
  cseSaveStreamError = 'Save Stream Error';
  cseLoadStreamError = 'Load Stream Error';

          {** Menu Items Strings **}
  csiFile            = '~F~ile';
  csiNew             = '~N~ew';
  csiExit            = 'E~x~it';
  csiDeskTop         = '~D~eskTop';
  csiLoadDeskTop     = '~L~oad Desktop';
  csiSaveDeskTop     = '~S~ave Desktop';
  csiInfo            = '~I~nfo';

          {** Keys Strings **}
  cskNew             = 'F4';
  cskExit            = 'Alt-X';
  cskNone            = '';

          {** Status Line Strings **}
  cslNone            = '';
  cslExit            = '~Alt-X~ Exit';
  cslNew             = '~F4~ New';
  cslClose           = '~Alt-F3~ Close';
  cslRevPattern      = '~F9~ Change Pattern';
  cslWriteCircle     = '~F7~ Circle';

  csDemoWindow       = 'Demo Window';
  csTempStr          = 'This string is a test';
  csEnviroment       = 'Environment';
  csNo               = 'No ';

  cmNewWin           = 101;
  cmSaveDesk         = 102;
  cmLoadDesk         = 103;
  cmRevertPattern    = 104;
  cmNewScroller      = 105;

  cwaGreen           = $12;
  cwaCyan            = $13;


  RMyDeskTop: TstreamRec = (
     ObjType : 1001;
     VmtLink : Ofs(Typeof(TMyDeskTop)^);
     Load    : @TMyDeskTop.Load;
     Store   : @TMyDeskTop.Store
  );

  RMyWindow: TstreamRec = (
     ObjType : 1002;
     VmtLink : Ofs(Typeof(TMyWindow)^);
     Load    : @TMyWindow.Load;
     Store   : @TMyWindow.Store
  );

  RTextWindow: TstreamRec = (
     ObjType : 1003;
     VmtLink : Ofs(Typeof(TTextWindow)^);
     Load    : @TTextWindow.Load;
     Store   : @TTextWindow.Store
  );

Procedure SaveDeskStream;
var
  SaveFile: TBufStream;
Begin
  SaveFile.Init(csfSaveFile,stCreate,1024);
  SaveFile.Put(DeskTop);
  if SaveFile.Status <> 0 then
    Write(cseSaveStreamError,SaveFile.Status);
  SaveFile.Done;
End;

Procedure LoadDeskStream;
var
  SaveFile: TBufStream;
begin
  SaveFile.Init(csfSaveFile,stOpen,1024);
  Desktop^.insert(PMyDeskTop(SaveFile.Get));
  if SaveFile.Status <> 0 then
    Write(cseLoadStreamError+' ',SaveFile.Status)
  else
    DeskTop^.ReDraw;
  SaveFile.Done;
end;


Procedure RevertPattern;
begin
  With DeskTop^.BackGround^ DO
   begin
     if Pattern = '²' then Pattern:='°' else Pattern:='²';
     Draw;
   end;
end;

{ TLineCollection }

procedure TLineCollection.FreeItem(P:Pointer);
begin
  DisposeStr(P);
end;

{ TMyScroller }

constructor TEnvScroller.Init(Var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar);
Begin
  inherited Init(Bounds,AHScrollBar, AVScrollBar);
  GrowMode:=gfGrowHiX + gfGrowHiY;
  ReadEnviroment;
end;

destructor TEnvScroller.Done;
begin
  Dispose(EnvLines, Done);
  TScroller.Done;
end;

procedure TEnvScroller.ReadEnviroment;
var
  MaxWidth: Integer;
  Count   : Integer;
  Line    : String;
  EnvSeg  : Word;
begin
  EnvSeg:=PPspRec(Ptr(PPspRec(Ptr(PSPAddr^.PrgOwnerSeg,0))^.PrgOwnerSeg,0))^.PrgEnvSeg;
  EnvLines := New(PLineCollection,Init(5,5));
  MaxWidth := 0;
  For Count := 1 To GetEnvCount(EnvSeg) Do
  begin
    Line := PCharToStr(EnvPChar(EnvSeg,Count));
    if Length(Line) >  MaxWidth then MaxWidth := Length(Line);
    EnvLines^.Insert(NewStr(Line));
  end;
  Limit.X := MaxWidth;
  Limit.Y := EnvLines^.Count;
end;

procedure TEnvScroller.Draw;
var
  B: TDrawBuffer;
  C: Byte;
  I: Integer;
  S: String;
  P: PString;
begin
  C := GetColor(1);
  for I:=0 To Size.Y - 1 Do
  begin
    MoveChar(B, ' ', C, Size.X);
    if Delta.Y + I < EnvLines^.Count Then
    begin
      P := EnvLines^.At(Delta.Y + I);
      if P <> nil Then S := Copy(P^, Delta.X + 1, Size.X)
      else S := '';
      MoveStr(B,S,C);
    end;
    WriteLine(0, I, Size.X, 1, B);
  end;
end;

procedure TEnvScroller.SetState(AState: Word; Enable: Boolean);
begin
  TScroller.SetState(AState, Enable);
  if Enable and (AState and sfExposed <> 0) then
     SetLimit(Limit.X, Limit.Y);
end;



constructor TTextWindow.Init(R: TRect);
begin
  inherited Init(R,csEnviroment,wnNoNumber);
  Options:=Options or ofTileable;
  GetExtent(R);
  R.Grow(-1,-1);
  Insert(New(PEnvScroller, Init(R,
    StandardScrollBar(sbHorizontal + sbHandleKeyBoard),
    StandardScrollBar(sbVertical + sbHandleKeyBoard)
    )));
end;


Constructor TMyApp.Init;
begin
  TApplication.Init;
  RegisterType(RMyDesktop);
  RegisterType(RDesktop);
  RegisterType(Rwindow);
  RegisterType(RMywindow);
  RegisterType(RTextWindow);
  RegisterType(RFrame);
  RegisterType(RMenuBar);
  RegisterType(RStatusLine);
  RegisterType(RBackground);
end;

Destructor TMyApp.Done;
Begin
  TApplication.Done;
End;

Procedure TMyApp.InitMenuBar;
Var
  R: TRect;
Begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu(csiFile, hcNoContext, NewMenu(
     NewItem(csiNew,cskNew, kbF4, cmNewWin, hcNoContext,
     NewItem(csiInfo,cskNone, kbF6, cmNewScroller, hcNoContext,
    NewLine(
       NewItem(csiExit,cskExit, kbAltX, cmQuit, hcNoContext,
       Nil))))),
    NewSubMenu(csiDeskTop, hcNoContext, NewMenu(
       NewItem(csiSaveDesktop,cskNone,kbF2,cmSaveDesk,hcNoContext,
       NewItem(csiLoadDesktop,cskNone,kbF3,cmLoadDesk,hcNoContext,
    nil))),nil)))));
End;

Procedure TMyApp.InitStatusLine;
Var
  R: TRect;
Begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine := New(PStatusLine, Init(R,
  NewStatusDef(0, $FFFF,
    NewStatusKey(cslNone, kbF10, cmMenu,
    NewStatusKey(cslExit, kbAltX, cmQuit,
    NewStatusKey(cslNew, kbF4, cmNewWin,
    NewStatusKey(cslClose, kbAltF3, cmClose,
    NewStatusKey(cslRevPattern, kbF9, cmRevertPattern,
    NewStatusKey(cslNone ,kbF5 ,cmZoom,
    nil)))))),
  nil)));
End;

Procedure TMyApp.HandleEvent(var Event: TEvent);
Begin
  TApplication.HandleEvent(Event);
  if Event.What = evCommand then
    Begin
      Case Event.Command of
        cmNewWin:        NewWindow;
        cmSaveDesk:      SaveDeskStream;
        cmLoadDesk:      LoadDeskStream;
        cmRevertPattern: RevertPattern;
        cmNewScroller:   NewEnvWindow;
      else
        Exit;
      End;
      ClearEvent(Event);
    End;
End;

Procedure TMyApp.NewWindow;
Var
  Window:PMyWindow;
  R: TRect;
Begin
  R.Assign(0, 0, 30, 10);
  R.Move(Random(55), Random(16));
  Window := New(PMyWindow, Init(R,csDemoWindow,1));
  DeskTop^.Insert(Window);
End;


Procedure TMyApp.NewEnvWindow;
var
  R: TRect;
  Window: PTextWindow;
begin
  R.Assign(0, 0, 40, 20);
  Window := New(PTextWindow, Init(R));
  Desktop^.Insert(Window);
end;


{ ** MyDeskTop **}
Constructor TMyDeskTop.Load(Var S: TBufStream);
Begin
  TDeskTop.Load(S);
End;

Procedure TMyDeskTop.Store(Var S: TBufStream);
Begin
  TDeskTop.Store(S);
End;

{ ** MyWindow **}
Constructor TMyWindow.Init(Bounds: TRect; WinTitle: String; WindowN: Integer);
Begin
  TWindow.init(Bounds,WinTitle,WindowN);
End;



{ Main Program }
Var
  MyTApp:TMyApp;

Begin
  MyTApp.Init;
  MyTApp.Run;
  MyTApp.Done;
End.

