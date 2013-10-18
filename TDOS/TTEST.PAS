uses NewDos;

Var
   InStr      : String;
   ReleaseSegm: Word;
   Code       : Integer;

Begin
  Writeln('MCB Releaser v0.01 by Begtin Ivan.');
  Write('Segment: '); ReadLn(InStr);
  Val(InStr, ReleaseSegm, Code);
  ReleaseMemory(ReleaseSegm);
End.