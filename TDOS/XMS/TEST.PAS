Uses TSystem, TXms, ShowTErr;

var
   Buffer: array[0..$7FFF] of System.Byte;
   F: file;
   NumberWrite: System.Word;
begin
  MoveEMSUsers (02, 01, 00, 00, 00, Longint(Addr(Buffer)), Sizeof(Buffer));
  Writeln (TXms.EMS_Result.Result);
  Assign(F, 'newfile.dat');
  Rewrite(F, 1);
  BlockWrite(F, Buffer, Sizeof(Buffer), NumberWrite);
  Close(F);
end.