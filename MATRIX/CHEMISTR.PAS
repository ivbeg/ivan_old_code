PROGRAM  CHEMISTRY_CALCULATING;

Uses
   TSystem, TKeyb;


Const
   cs_Version   = '0.01';
   cs_Copyright = 'Copyright (C)';
   cw_Year      = 1997;
   cs_Name      = 'Begtin Ivan';

   scancode_1   = $02;
   scancode_2   = $03;
   scancode_3   = $03;
   scancode_4   = $03;
   scancode_X   = $2D;


Var
   Result: System.Real;
   Info: record
           Time: System.Word;
           Subs: System.Real;
         End;

function NlogX (X, N: System.Real): System.Real;
Begin
  NlogX:= Ln(X) / Ln(N);
End;



procedure ShowProgramInfo;
Begin
  Writeln ('Chemistry program v', cs_Version, ', ', cs_Copyright,
           ' ', ' ', cw_Year, ' ', cs_Name);

  Writeln ('Note: Please insert numbers correctly. I will add string check');
  Writeln ('      as soon as possible. But now it is not present.');
End;



procedure InitProgram;
Var
   Counter_A, Counter_B: System.Integer;
Begin
  Write  ('Time: ');
  Readln (Info.Time);
  Write ('Subs: ');
  Readln (Info.Subs);
End;



procedure CalculateResult;
Begin
  Result:= (2.3/Info.Time)*NLogX((20.7/Info.Subs),10);
End;


procedure ShowResult;
Begin
  Writeln ('Result (K):= ', Result);
  Write ('_Press any key..._');
  Writeln;
End;


procedure StartCalculus;
Begin
  InitProgram;
  CalculateResult;
  ShowResult;
End;


Begin
  ShowProgramInfo;
  repeat
    StartCalculus;
  until Result = $FFFF;
End.
