Uses IvMisc;

Var
    PauseDelay,SoundValue : Word;

Procedure SingleSound;
 Begin
  Writeln('Sound..');
  Sound(SoundValue);
  Delay(PauseDelay);
  NoSound;
 end;

Procedure DoubleSound;
 Begin
  Sound(SoundValue);
  Delay(PauseDelay div 2);
  NoSound;
  SingleSound;
 end;

Procedure Music;
 Begin
  SingleSound;
  SingleSound;
  DoubleSound;
  SingleSound;
  DoubleSound;
  DoubleSound;
  DoubleSound;
 end;

Begin
 PauseDelay:=10;
 SoundValue:=140;
 Music;
end.