PROGRAM TEST_TKeyboard;


Uses
   TSystem, TKeyb, TStrings;

Const
   key_Escape  = 01;

Var
   Key : System.Word;
   KeyCode: TKeyCode absolute Key;
Begin
  Writeln ('Press any key.');
  repeat
  Key:= GetKey;
  Write ('Char code : ', KeyCode.CharCode);
  Writeln ('  Scan code : ', HexByte(KeyCode.ScanCode));
  until KeyCode.ScanCode = key_Escape;
End.
