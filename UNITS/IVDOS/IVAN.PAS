
Var Error:byte;
{$L DOSINOUT.OBJ}
Procedure DosWriteChar(CharCOde:char);Far;External;
{$L DOSINTER.OBJ}
Procedure DosIo;Near;External;

Begin
DosWriteChar('A');
end.