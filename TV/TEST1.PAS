Program Test;
Uses Some,IvString,IvSystem;

Function WordToBCDStr(W:word):Str8;
 Begin
  WordToBCDStr:=Digit(Hi(W))+'.'+Digit(Lo(W));
 end;

var
  SmartDrv: TSmartDrv;
  CacheInfo: TCacheInfo;
  S:String;
  B:Boolean;



Begin
  With SmartDrv DO
   begin
     Init;
     S:=WordToBCDStr(Version);
     Writeln(S);
     B:=Present;
     Writeln(B);
     GetSmartdrvInfo(Addr(Test.CacheInfo));
     Writeln('Hits   : ',Test.CacheInfo.Hits);
     Writeln('Misses : ',Test.CacheInfo.Misses);
     Writeln('Dirty Caches is ',Test.CacheInfo.DirtyCaches);
   end;
end.