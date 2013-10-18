Uses IvSystem,IvString,IvCrt,IvKbd;
Var S:string;
    Rate,Delay:byte;
    Code:integer;
    label Rep,Rep1;

Begin
Rep:
 GetRate_Delay(Rate,Delay);
 WriteStr('Current  Rate: '+DigitLong(Rate));EndL;
 WriteStr('Current Delay: '+DigitLong(Delay));EndL;
 WriteStr('Set Kbd  Rate: ');
 ReadLimStr(3,S,'°',true);
 Val(S,Rate,Code);
 if not (Code = 0) then
  Begin
   WriteStr('Error.');EndL;
   Goto Rep;
  end;
Rep1:
 WriteStr('Set Kbd Delay: ');
 ReadLimStr(3,S,'°',true);
 Val(S,Delay,Code);
 if not (Code = 0) then
  Begin
   WriteStr('Error.');EndL;
   Goto Rep1;
  end;
 IvKbd.SetRate_Delay(Rate,Delay);
 Writestr('Ok.');EndL;
end.