Uses IvSystem;
Var C:word;
    Arr:Array[1..4000] of byte absolute $B800:4000;
    Time : LongInt;

Const
 Count = 10000;
 Ada   : Array[1..10] of byte = (0,0,0,0,0,0,0,0,0,0);
 
 Procedure SetTimer;
  Begin
   Time:=BiosArea.Timer;
  end;

 Procedure GetTimer;
  Begin
   Writeln('Process Time : ',BiosArea.Timer-Time);Writeln;
  end;

Begin
 Writeln('Fill Byte Procedure...');
 SetTimer;
 For C:=1 to Count do
 FillByte(Ptr($B800,4000),80*25*2,0);
 GetTimer;

 Writeln('Fill Word Procedure...');
 SetTimer;
 For C:=1 to Count do
 FillWord(Ptr($B800,4000),80*25,0);
 GetTimer;

 Writeln('Fill Char Procedure...');
 SetTimer;
 For C:=1 to Count do
 Fillchar(Arr,80*25*2,#0);
 GetTimer;

 Writeln('Fill Dword Procedure...');
 SetTimer;
 For C:=1 to Count do
 FillDword(Ptr($B800,4000),40*25,0);
 GetTimer;

 Writeln('Fill Procedure...');
 SetTimer;
 For C:=1 to Count do
 Fill(Ptr($B800,4000),Addr(Ada),10,40*25);
 GetTimer;
 

end.