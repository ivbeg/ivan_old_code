Unit Matrix;

interface

const
   MaxNumber = 030;
   MinNumber = 002;


type
      {* Sorry it's little heavy but I haven't time for better constructions *}

   TMatrixRec = record
     Matrix    : array[1..MaxNumber, 1..MaxNumber] of System.Real;
     Size      : System.Integer;
   End;

   TVectorRec = record
     Vector      : array[1..MaxNumber] of System.Real;
     Length      : System.Integer;
   End;




function  GetDeterminant (a_Matrix: TMatrixRec): System.Real;
{* Determinant of NxN matrix *}

procedure MatrixMulConst (a_Matrix: TMatrixRec; _Const: System.Real;
                          Var Result: TMatrixRec);
{* Multiplication matrix (a_Matrix) NxN on constant (_Const) and      *}
{* return result in (Result).                                         *}

procedure MatrixMultipl  (a_Matrix, B_Matrix: TMatrixRec;
                          Var Result: TMatrixRec);
{* Multiplication matrix (A_Matrix) NxN on matrix (B_Matrix) NxN and  *}
{* return result in (Result).                                         *}


procedure MatrixAddition (a_Matrix, B_Matrix: TMatrixRec;
                          Var Result: TMatrixRec);
{* Addition matrix (A_Matrix) NxN and matrix (B_Matrix) NxN. Return   *}
{* result in (Result)                                                 *}

function  MatrixInvers   (a_Matrix: TMatrixRec;
                          Var InvertedMatrix: TMatrixRec): System.Boolean;
{* Inversion matrix (a_Matrix) NxN. Return false in matrix can't be   *}
{* inverted.                                                          *}

procedure TransposeMatrix (Var a_Matrix: TMatrixRec);
{* Transposition of matrix (a_Matrix) NxN.                            *}


procedure CreateE_Matrix (Var a_Matrix: TMatrixRec);
{* Create (E) Matrix  NxN                                             *}

procedure MatrixMulVector (a_Matrix: TMatrixRec; A: TVectorRec; Var Result: TVectorRec);
{* Multilication vector (A) on  matrix (a_Matrix) and return result   *}
{* vector in (Result)                                                 *}


function  VectorDistance (A, B: TVectorRec): System.Real;
{* Euclide method of calculating distance between two vectors         *}


function  ScalarVectors (A, B: TVectorRec): System.Real;
{* Scalar multiplication of vectors (A) and (B)                       *}

function  VectorLength (A: TVectorRec): System.Real;
{* Length of (A) vector                                               *}

implementation


function  GetDeterminant (a_Matrix: TMatrixRec): System.Real;
Var
   Counter_A, Counter_B, Counter_C : System.Integer;
   _Determinant: System.Real;
Begin {* GetDeterminant *}
  for Counter_A:= 1 to Pred (a_Matrix.Size) do
   Begin {* for Counter_A *}
     if Abs (a_Matrix.Matrix[Counter_A, Counter_A]) < 1E-10 then
      Begin
        GetDeterminant:= 0.0;
        Exit;
      End;
     for Counter_B:= Succ (Counter_A) to a_Matrix.Size do
      Begin {* for Counter_B *}
        _Determinant:= a_Matrix.Matrix[Counter_B, Counter_A] / a_Matrix.Matrix[Counter_A, Counter_A];
        for Counter_C:= Counter_A to a_Matrix.Size do
         a_Matrix.Matrix[Counter_B, Counter_C]:= a_Matrix.Matrix[Counter_B, Counter_C] -
                       _Determinant * a_Matrix.Matrix[Counter_A, Counter_C]
      End; {* for Counter_B *}
    End; {* for Counter_A *}
    _Determinant:= 1.0;
    for Counter_A:= 1 to a_Matrix.Size do
     _Determinant:= _Determinant * a_Matrix.Matrix[Counter_A, Counter_A];
  GetDeterminant:= _Determinant;
End; {* GetDeterminant *}


procedure MatrixMulConst (a_Matrix: TMatrixRec; _Const: System.Real;
                          Var Result: TMatrixRec);
Var
   Counter_A, Counter_B: System.Integer;
Begin
  for Counter_A:= 1 to a_Matrix.Size do
   for Counter_B:= 1 to a_Matrix.Size do
     Result.Matrix[Counter_A, Counter_B]:= _Const * a_Matrix.Matrix[Counter_A, Counter_B];
  Result.Size:= a_Matrix.Size;
End;

procedure MatrixMultipl  (A_Matrix, B_Matrix: TMatrixRec;
                          Var Result: TMatrixRec);

Var
   Counter_A, Counter_B, Counter_C: System.Integer;
   Temp: System.Real;
Begin
  for Counter_A:= 1 to A_Matrix.Size do
   for Counter_B:= 1 to A_Matrix.Size do
    Begin
      Temp:= 0.0;
      for Counter_C:= 1 to A_Matrix.Size do
       Temp:= Temp + A_Matrix.Matrix[Counter_A, Counter_C] * B_Matrix.Matrix[Counter_C, Counter_B];
       Result.Matrix[Counter_A, Counter_B]:= Temp;
    End;
  Result.Size:= A_Matrix.Size;
End;

procedure MatrixAddition (A_Matrix, B_Matrix: TMatrixRec;
                          Var Result: TMatrixRec);
Var
   Counter_A, Counter_B: System.Integer;

Begin
  for Counter_A:= 1 to A_Matrix.Size do
   for Counter_B:= 1 to A_Matrix.Size do
     Result.Matrix[Counter_A, Counter_B]:= A_Matrix.Matrix[Counter_A, Counter_B] + B_Matrix.Matrix[Counter_A, Counter_B];
  Result.Size:= A_Matrix.Size;
End;


procedure MatrixMulVector (a_Matrix: TMatrixRec; A: TVectorRec; Var Result: TVectorRec);
Var
   Counter_A, Counter_B: System.Integer;
   Temp: System.Real;
Begin
  for Counter_A:= 1 to A.Length do
  Begin
    Temp:= 0.0;
    for Counter_B:= 1 to A.Length do
      Temp:= Temp + a_Matrix.Matrix[Counter_A, Counter_B] * A.Vector[Counter_B];
    Result.Vector[Counter_A]:= Temp;
  End;
End;



function  MatrixInvers   (a_Matrix: TMatrixRec;
                          Var InvertedMatrix: TMatrixRec): System.Boolean;
Var
  temp_Matrix: TMatrixRec;
Begin
End;


procedure TransposeMatrix (Var a_Matrix: TMatrixRec);
Var
   Counter_A, Counter_B: System.Integer;
   Temp: System.Real;
Begin
  for Counter_A:= 1 to a_Matrix.Size do
   for Counter_B:= Counter_A + 1  to a_Matrix.Size do
   Begin
     Temp:= a_Matrix.Matrix[Counter_A, Counter_B];
     a_Matrix.Matrix[Counter_A, Counter_B]:= a_Matrix.Matrix[Counter_B, Counter_A];
     a_Matrix.Matrix[Counter_B, Counter_A]:= Temp;
   End;
End;


procedure CreateE_Matrix (Var a_Matrix: TMatrixRec);
Var
  Counter: System.Byte;
Begin
  FillChar (a_Matrix.Matrix, Sizeof (a_Matrix.Matrix), 0);
  for Counter:= 1 to a_Matrix.Size do
    a_Matrix.Matrix[Counter, Counter]:= 1.0;
End;


function  VectorDistance (A, B: TVectorRec): System.Real;
Var
  Temp: System.Real;
  Counter: System.Byte;
Begin
  Temp:= 0.0;
  if A.Length = B.Length then
    for Counter:= 1 to A.Length do
     Temp:= Temp + Sqr (A.Vector[Counter] - B.Vector[Counter]);
  VectorDistance:= Sqrt (Temp);
End;


function  ScalarVectors (A, B: TVectorRec): System.Real;
Var
  Temp: System.Real;
  Counter: System.Byte;
Begin
  Temp:= 0.0;
  if A.Length = B.Length then
    for Counter:= 1 to A.Length do
     Temp:= Temp + A.Vector[Counter] * B.Vector[Counter];
  ScalarVectors:= Temp;
End;


function  VectorLength (A: TVectorRec): System.Real;
Var
  Temp: System.Real;
  Counter: System.Byte;
Begin
  Temp:= 0.0;
  for Counter:= 1 to A.Length do
   Temp:= Temp + System.Sqr (A.Vector[Counter]);
  Temp:= System.Sqrt (Temp);
  VectorLength:= Temp;
End;



end.

