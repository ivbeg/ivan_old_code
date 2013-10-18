PROGRAM  TEST_MATRIX_UNIT;

{* This program used to test functions and procedures in unit Matrix. *}


Uses
   Matrix, TSystem, TKeyb;


Const
   cs_Version   = '0.01';
   cs_Copyright = 'Copiright (C)';
   cw_Year      = 1997;
   cs_Name      = 'Begtin Ivan';

   scancode_1   = $02;
   scancode_2   = $03;
   scancode_3   = $03;
   scancode_4   = $03;
   scancode_X   = $2D;


Var
   TestMatrix : TMatrixRec;
   Determinant: System.Real;



procedure ShowProgramInfo;
Begin
  Writeln ('Matrix test program v', cs_Version, ', ', cs_Copyright,
           ' ', ' ', cw_Year, ' ', cs_Name);

  Writeln ('Note: Please insert numbers correctly. I will add string check');
  Writeln ('      as soon as possible. But now it is not present.');
End;



procedure InitMatrix;
Var
   Counter_A, Counter_B: System.Integer;
Begin
  Write  ('Number of rows: ');
  Readln (TestMatrix.Size);
  if (TestMatrix.Size > MaxNumber) or (TestMatrix.Size < MinNumber) then
   Begin
     Writeln ('Sorry, but valid numbers only in range [2..30].');
     Halt;
   End;
  for Counter_B:= 1 to TestMatrix.Size do
   for Counter_A:= 1 to TestMatrix.Size do
    Begin
      Write ('Matrix[', Counter_B, ', ', Counter_A, ']:= ');
      Readln (TestMatrix.Matrix[Counter_B, Counter_A]);
    End;

End;


function  CalculateBiggest (Matrix: TMatrixRec): System.Real;
Var
  Temp:    System.Real;
  Counter: System.Byte;
Begin
  Temp:= 0;
  for Counter:= 1 to Matrix.Size do
    if Abs (Matrix.Matrix[Counter, Counter]) > Temp then
       Temp:= Abs (Matrix.Matrix[Counter, Counter]);

  CalculateBiggest:= Temp;
End;



procedure CalculateDeterminant;
Begin
  Determinant:= GetDeterminant (TestMatrix);
End;




procedure ShowMatrixInfo;
Begin
  Writeln ('Determinant:= ', Determinant);

  Write ('_Press any key..._');
  repeat
  until KeyPresent;
  Writeln;
End;


Begin
  ShowProgramInfo;
  InitMatrix;
  CalculateDeterminant;
  ShowMatrixInfo;
End.