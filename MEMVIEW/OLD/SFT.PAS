Unit Sft;

InterFace
Uses Module,IvString;
Type
 SftDescBlock = record
  FileName:String;
  Handles:word;
  FileSize:LongInt;
  OwnerName:string;
 end;
 SftBlock = record
  Number:word;
  TotDesc:word;
  Segm,Offs:word;
  Arr:array[1..40] of SftDescBlock;
 end;
 Arra = Array[1..3] of SftBlock;
Function BuildSftList(var SftArr:Arra):word;
Implementation

Function BuildSftList(var SftArr:Arra):word;
Var Se,Ofe:word;
    I:byte;
    Ses,Ofes,Segs,Ofegs:word;
    Count:word;
 begin
  DtSftAdr(Se,Ofe);
  I:=0;
  repeat
   Inc(I);
   SftArr[I].Number:=I;
   SftArr[I].TotDesc:=MemW[Se:Ofe+4];
   Segs:=Se;
   Ofegs:=Ofe+6;
   for Count:=1 to SftArr[I].TotDesc do
    begin
      SftArr[I].Arr[Count].FileName:=GetString(Segs,Ofegs+$20,8)+':'+GetString(Segs,Ofegs+$28,3);
      SftArr[I].Arr[Count].Handles:=MemW[Segs:Ofegs];
    end;

   Ses:=Se;
   Ofes:=Ofe;
   Se:=Mem[Ses:Ofes+2];
   Ofe:=Mem[Ses:Ofes];

  Until Ofe = $FFFF;
 end;
end.