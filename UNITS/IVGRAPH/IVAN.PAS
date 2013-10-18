Uses IvGraph,IvSystem,IvString,IvKbd;

Var S : String;
    VGA :VGAPalette;
Begin
 CursorOff;
 SetVideoPage(6);
 ClrScr;
 bWriteString(Addr(S),5,4,9,BiosArea.CurrentPage);
 S:='This string writed by AsmWriteString';
 GetDacPalette(VGA);
 GreySummDAC(0,256);
 CursorOff;
 S:='This short demonstaration';
 bWriteString(Addr(S),5,5,3,BiosArea.CurrentPage);
 repeat Until KeyPresent;
 SetDACPalette(VGA);
 S:='Presented you by BEGTIN IVAN';
 bWriteString(Addr(S),5,6,9,BiosArea.CurrentPage);
 CursorOn;
 repeat Until KeyPresent;
 SetVideoPage(0);
end.