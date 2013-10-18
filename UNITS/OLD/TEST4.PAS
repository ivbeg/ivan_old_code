Uses Misc,Crt;

 var  Segm,Offs:word;
      Se,Ofe:word;
      x,y,z,b:word;
      AA1,AA2,AA3,AA4,AA5:byte;
      I,K:byte;
begin
  Segm:=MemW[$40:$AA];
  Offs:=MemW[$40:$A8];
  Se:=MemW[Segm:Offs+2];
  Ofe:=MemW[Segm:Offs];
 Writeln(HexWord(Segm),':',HexWord(Offs));
 Writeln(HexWord(Se),':',HexWord(Ofe));
 Write('Video Mode = ');
 Readln(I);
 Se:=Se+I*4;
 x:=Mem[Se:Ofe];
 y:=Mem[Se:Ofe+1];
 z:=Mem[Se:Ofe+2];
 b:=MemW[Se:Ofe+3];
 AA1:=Mem[Se:Ofe+5];
 AA2:=Mem[Se:Ofe+6];
 AA3:=Mem[Se:Ofe+7];
 AA4:=Mem[Se:Ofe+8];
 AA5:=Mem[Se:Ofe+9];
 Writeln('Mode = ',I);
 Writeln('Columns = ',x);
 Writeln('Strings = ',y+1);
 Writeln('Lett High = ',z);
 Writeln('Video Buffer Size = ',b);
 Writeln('Sequencer Regs = ',AA1,' ',AA2,' ',AA3,' ',AA4);
 Writeln('Misc. OutPut = ',AA5);
 Write('CRTC Regs :');
 for K:=0 TO 23 DO
  begin
   Write(Mem[Se:Ofe+10+K],' ');
  end;
   Writeln(Mem[Se:Ofe+10+24],' ');
 Write('Attr. Controller Regs :');
 for K:=0 TO 18 DO
  begin
   Write(Mem[Se:Ofe+$23+K],' ');
  end;
   Writeln(Mem[Se:Ofe+$23+19],' ');
 Write('Graph. Controller Regs :');
 for K:=0 TO 7 DO
  begin
   Write(Mem[Se:Ofe+$37+K],' ');
  end;
   Writeln(Mem[Se:Ofe+$37+8],' ');

 ReadKey;
 Se:=Se+4;
end.
