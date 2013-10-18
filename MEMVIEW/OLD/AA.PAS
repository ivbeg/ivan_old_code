{$M $2000,0,16000}
Uses Dos,IvGraph;
Var
 TimeVect:procedure;
{$F+}
 Procedure CheckKey; Interrupt;
  Var
   Key1:byte absolute $40:$17;
  Begin
   if ((Key1 and 1) > 0) and ((Key1 and 2) > 0) then
    Begin
     mClrTxtScr;
    End;
   TimeVect;
  End;
{$F-}
Begin
 GetIntVec(8,@TimeVect);
 SetIntVec(8,Addr(CheckKey));
 Keep(0);
End.