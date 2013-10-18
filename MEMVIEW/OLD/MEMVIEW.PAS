{$S-}

{$M 8192,0,655360 }
Program MemView;
{ ** Memory Viering Program ** }

Uses IvMemCtr,IvString,IvGraph,Crt,IvSystem,IvEms,Xms,IvMemory;
 { ** Uses Libraries ** }


{$I MemInc.Inc}


Const
 MaxSize = 100;
 Version = '1.01';
 Press   = 'Press Any Key';

{$I MemVars.Inc}
   { ** Procedurial Part ** }


{$I MakeList.inc}


Procedure Start;
 begin
  Writeln('Memory Viewer Version ',Version,' CopyRight by Begtin Ivan');
  Writeln('Extended Viewing of Memory in Real Time.');
 end;
Procedure Help;
 begin
  Writeln(' Options:');  GotoXY(5,WhereY);
  Writeln('S :  System Files Tables Info.');  GotoXY(5,WhereY);
  Writeln('M :  Total Memory Control Blocks.'); GotoXY(5,WhereY);
  Writeln('D :  Device Drivers List.');  GotoXY(5,WhereY);
  Writeln('X :  Extended Memory Info.');  GotoXY(5,WhereY);
  Writeln('E :  EMS Info');               GotoXY(5,WhereY);
  Writeln('G :  Global MCB List');        GotoXY(5,WhereY);
  Writeln('P:   Programs Info');          GotoXY(5,WhereY);
  Writeln('T:   Drives Parameter Tables Info'); GotoXY(5,WhereY);
  Writeln('A:   All Information');
 end;


{$I TextDos.Inc}

begin
 Start;
 if ParamStr(1)= '' then
   begin
    Writeln('Error: Option not Present');
    Halt;
   end
  else
   begin
   S:=ParamStr(1);
   if (S[1] = '/') or (S[1] = '-') then
    begin
     Case UpCase(S[2]) of
      'D' : TextDosDevList;
      'M' : TextDosMcbList;
      'E' : TextDosEmsList;
      'X' : TextDosXmsList;
      'S' : TextDosSftList;
      '?' : Help;
      'G' : TextDosGMcbList;
      'T' : TextDosDptList;
      'P' : TextDosProgramsList;
      'A' : Begin
             TextDosDevList;
              Writeln(Press);
               ReadKey;
             TextDosGMcbList;
              Writeln(Press);
               ReadKey;
             TextDosEmsList;
              Writeln(Press);
               ReadKey;
             TextDosXmsList;
              Writeln(Press);
               ReadKey;
             TextDosSftList;
              Writeln(Press);
               ReadKey;
             TextDosDptList;
            end
      else
       Help;
      end;
   end;

end;
end.

