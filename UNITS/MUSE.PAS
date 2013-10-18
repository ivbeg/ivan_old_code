Uses IvString,IvCrt,IvDos,IvSystem,IvMouse,IvKbd;
Var Y:byte;
    Max:byte;
    W:byte;
     S:string;
    Label Rep;
{$F+}
Procedure Wait;
Var B,C:byte;
 Begin
  repeat until KeyPresent;
  GetKey(B,C);
 end;

Procedure CurrDir;
 Begin
  CursorXY(WindMin.X+Length(TmpStr),GetY);
  TextColor(Green);
  WritePchar(CurrentDir(0));EndL;
  TextAttr:=OldAttr;
 end;

Procedure CurrDrive;
 Begin
  CursorXY(WindMin.X+Length(S),GetY);
  TextColor(Red);
  WriteStr(Char(GetCurrDrv+65)+':');EndL;
  TextAttr:=OldAttr;
 end;

Procedure Ende;
 Begin
  Halt;
 end;


Const
 ProcArr: array[1..3] of procedure = (CurrDrive,CurrDir,Ende);
{$F-}
 Begin
  HideCursor;
  Y:=10;
  Max:=3;
  ShowMouse;
  ClrScr;
Rep:
  Repeat
   CursorXY(WindMin.X,Y);
   S:='Current Drive: ';
   WriteStr(S);EndL;
   TmpStr:='Current Directory: ';
   WriteStr(TmpStr);EndL;
   WriteStr('Exit');EndL;
  until GetMouseButtons >0;

   CursorXY(WindMin.X,Y);
   if ((GetMouseY div 8) >= Y) and ((GetMouseY div 8) < Y+Max) then
    Begin
     W:=(GetMouseY div 8)-Y+1;
     CursorXY(WindMin.X,W+Y-1);
     ProcArr[W];
    end;
  Goto Rep;
 end.