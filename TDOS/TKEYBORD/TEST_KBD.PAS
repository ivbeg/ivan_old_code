PROGRAM TEST_TKeyboard;


Uses
   TSystem, TKeyb, TStrings;

var
   Key : System.Word;
   KeyCode: TKeyCode absolute Key;
Begin
  Writeln ('Press any key.');
  Key:= GetKey;
  Writeln ('Char code : ', KeyCode.CharCode);
  Writeln ('Scan code : ', HexByte(KeyCode.ScanCode));
  repeat
  until KeyPresent;
End.
