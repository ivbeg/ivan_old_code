Uses TSystem, TDos, TKeyb;

type
    TString2 = String[2];
    TString4 = String[4];
    TString9 = String[9];

var
   Handle: System.Word;

Function  HexB(Bt:byte):TString2;
 Const
  HexArr:array[0..$F] of Char = '0123456789ABCDEF';
 begin
    HexB[1]:=HexArr[bt shr 4];
    HexB[2]:=HexArr[bt and $F];
    HexB[0]:=#2;
 end;

Function  HexW(Wrd:word):TString4;
 begin
  HexW:=HexB(Hi(Wrd))+HexB(Lo(Wrd));
 end;

Function  HexPtr(P:pointer):TString9;
 begin
  HexPtr:=HexW(SEG(P^))+ ':' + HexW(OFS(P^))
 end;


procedure ErrorControl;far;
begin
  Writeln('Dos error: ', HexW(DosResult.Result));
  RunError(DosResult.Result);
end;

Var
   TestString: String;

Begin
  Write ('Input string: ');
  Readln (TestString);
  CapitalizeString (TestString);
  Writeln ('Capitalized string: ', TestString);
  repeat until KeyPresent;


  DosResult.ErrorProc:= ErrorControl;
  Writeln('Sysvars Ptr: ', HexPtr(TDos.SysVars));
  Writeln('Prefix Segment: ', HexW(TDos.PrefixSeg),'h');
  Writeln('Current DOS drive: ', Char(TDos.GetDefaultDrive + $041));
{  TDos.CreateDirectory('newdir'); }
{  TDos.ChangeDirectory('newdir'); }
{  TDos.ChangeDirectory('..');     }

End.