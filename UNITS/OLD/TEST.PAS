Uses IvMemory,Crt,IvString;
Var
    CountSft:word;
    Count:word;
Procedure TextDosSftList;
Var SftArr:PSftArrT;
    ECount:word;
 begin
   New(SftArr);
  CountSft:=BuildSftList(SftArr);
   For Count:=1 to CountSft do
    begin
    GotoXY(20,WhereY);
     Writeln('System File Table Num:',Count,  ' Total Descriptors :',SftArr^[Count].TotDesc);
    GotoXY(20,WhereY);
     Writeln('Address ',HexW(SftArr^[Count].Segm),':',HexW(SftArr^[Count].Offs));
     Writeln(' Name         Handles   Size    Owner Name');
     Writeln(' ----         -------   ----    ----------');
     ECount:=0;
     Repeat
      Inc(ECount);
      Begin
       Case SftArr^[Count].Arr[ECount].Free of
        False: Begin
                Write(' ',SftArr^[Count].Arr[ECount].FileName);       GotoXY(15,WhereY);
                Write(SftArr^[Count].Arr[ECount].Handles);            GotoXY(25,WhereY);
                Write(SftArr^[Count].Arr[ECount].Size);               GotoXY(33,WhereY);
                Writeln(SftArr^[Count].Arr[ECount].OwnerName);
               End;
        True:  Begin
                Writeln('Free Descriptors = ',SftArr^[Count].TotDesc-ECount);
                ECount:=SftArr^[Count].TotDesc;
               End;
       end;
      end;
     Until ECount = SftArr^[Count].TotDesc;
      end;
      DisPose(SftArr);
    end;
Begin

 TextDosSftList;
end.
