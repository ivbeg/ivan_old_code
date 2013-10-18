Unit IvWindow;

{ ** Creating Multi-Windows Interface look like TVision ** }
Interface
Uses IvGraph,IvSystem,IvString;

Const
  MaxWin = 30;
  Single:FrameArr =('Ä','³','Ä','³','Ú','¿','Ù','À');
  Double:FrameArr =('Í','º','Í','º','É','»','¼','È');
  Block :FrameArr =('ß','Ý','Ü','Þ','Û','Û','Û','Û');


Var WinArr:array[1..MaxWin] of WindowRec;
    CurrWin:byte;
    SaveAttr:byte;

Procedure CloseWindow;
Procedure CloseAllWins;
Procedure FillWindow(Sym:char);
Procedure RestoreWindowBuff;
Procedure SaveWindowBuff;
Procedure InstallWindow;
Procedure OpenWindow(WX1,WY1,WX2,WY2:byte; ForeG,BackG:byte;Fr:FrameArr;Titul:string);

Implementation

procedure WriteCharXY(X,Y: byte; Ch: char);
Var SavedX: byte;
    SavedY: byte;
begin
 SavedX:=GetX;
 SavedY:=GetY;
 CursorXY(X,Y);
 WriteChar(Ch,TextAttr);
 CursorXY(SavedX,SavedY);
end;


Procedure FillWindow(Sym:char);
Var W:word;
    C:word;
 Begin
{  With WinArr[CurrWin] do
   Begin
  W:=((X1)+(Y1)*BiosArea.MaxColumns)*2;
  W:=((X2)+(Y2)*BiosArea.MaxColumns)*2-W+2;
  C:=Byte(Sym) shl 4 +TextAttr;
  FillWord(AddPtr(Buff,(1+BiosArea.MaxColumns)*2)^,W,C);
   end;}
 end;

Procedure CloseAllWins;
 Begin
  While CurrWin >0 do CloseWindow;
 end;

Procedure InstallWindow;
Var Cnt:byte;
    W:byte;
 Begin
  If CurrWin < 1 then Exit;
  With WinArr[CurrWin] do
   Begin
    TextBackGround(BackGround);
    TextColor(ForeGround);
    Window(X1,Y1,X2,Y2);
   end;
 end;

Procedure SaveWindowBuff;
Var P:pointer;
    W:word;
 Begin
  If CurrWin < 1 then Exit;
  P:=WinArr[CurrWin].Buff;
  With WinArr[CurrWin] do
   Begin
    W:=((X1-1)+(Y1-1)*BiosArea.MaxColumns)*2;
    P:=AddPtr(ActiveScreenPtr,W);
    W:=((X2+4)+(Y2+2)*BiosArea.MaxColumns)*2-W;
    MovePtr(P,Buff,W);
   end;
 end;

Procedure RestoreWindowBuff;
Var P:pointer;
    W:word;
 Begin
  If CurrWin < 1 then Exit;
  P:=WinArr[CurrWin].Buff;
  With WinArr[CurrWin] do
   Begin
    W:=((X1-1)+(Y1-1)*BiosArea.MaxColumns)*2;
    P:=AddPtr(ActiveScreenPtr,W);
    W:=((X2+4)+(Y2+1)*BiosArea.MaxColumns)*2-W;
    MovePtr(Buff,P,W);
  end;
 end;

Procedure CloseWindow;
 Begin
  if CurrWin < 1 then Exit;
  RestoreWindowBuff;
  With WinArr[CurrWin] Do FreeMem(Buff,BuffSize);
  Dec(CurrWin);
  if CurrWin = 0 then   TextAttr:=SaveAttr;
  WITH BiosArea DO Window(0,0,MaxColumns-1,MaxStrings);
  InsTallWindow;
  With WinArr[CurrWin+1] do
  CursorXY(OldX,OldY);
 end;

Procedure OpenWindow(WX1,WY1,WX2,WY2:byte; ForeG,BackG:byte;Fr:FrameArr;Titul:string);
Var W:word;
    Cnt:byte;

Procedure MakeTitul;
Var C:byte;
 Begin
  C:=(WindMax.X - WindMin.X) - 2;
  if Length(Titul) >C then Byte(Titul[0]):=C;
  CursorXY(WindMin.X+1+(C div 2)-(byte(Titul[0]) div 2),WindMin.Y-1);
  FastWrite(Titul);
 end;

 Begin
  if CurrWin = MaxWin then Exit;
  Inc(CurrWin);
  if CurrWin = 1 then  SaveAttr:=TextAttr;
  With WinArr[CurrWin] Do
   Begin
    X1:=WX1;
    X2:=WX2;
    Y1:=WY1;
    Y2:=WY2;
    ForeGround:=ForeG;
    BackGround:=BackG;
    Frame:=Fr;
    W:=((X1-1)+(Y1-1)*BiosArea.MaxColumns)*2;
    W:=((X2+1)+(Y2+1)*BiosArea.MaxColumns)*2-W+2;
    BuffSize:=W;
    if BuffSize > MaxAvail then Exit;
    GetMem(Buff,BuffSize);
    SaveWindowBuff;
    WinArr[CurrWin].OldX:=GetX;
    WinArr[CurrWin].OldY:=GetY;
    InstallWindow;
    For Cnt:=X1 to X2 do WriteCharXY(Cnt,Y1-1,Frame[1]);
    For Cnt:=X1 to X2 do WriteCharXY(Cnt,Y2+1,Frame[3]);
    For Cnt:=Y1 to Y2 do WriteCharXY(X1-1,Cnt,Frame[2]);
    For Cnt:=Y1 to Y2 do WriteCharXY(X2+1,Cnt,Frame[4]);
    WriteCharXY(X1-1,Y1-1,Frame[5]);
    WriteCharXY(X2+1,Y1-1,Frame[6]);
    WriteCharXY(X1-1,Y2+1,Frame[8]);
    WriteCharXY(X2+1,Y2+1,Frame[7]);
    MakeTitul;
    ClearWindow;
    CursorXY(WindMin.X,WindMin.Y);
   end;
 end;
 Begin
  CurrWin:=0;
 end.