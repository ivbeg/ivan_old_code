Uses IvSystem,IvString,IvDos;
Type
 ProgBlockRec = record
                 Name    : array[1..13] of Char;
                 Address : pointer;
                end;
Var P:pchar;
    Block:ProgBlockRec;
    Okk:boolean;
Procedure FindRomPrg(Name:Pchar;Var ProgBlock:ProgBlockRec);
Var S:String[127];
    Ok:boolean;
 Begin
  asm
   mov Ok,0
   mov ah,6Dh
   lds dx,Name
   int 21h
   jc  @1
   mov Ok,1
@1:
  end;
  Okk:=Ok;
  if Ok then Move(PspAddr^.CommandLine[0],ProgBlock,Sizeof(ProgBlock));
  end;

 Begin
  New(P);
  P:='800';
  FindRomPrg(P,Block);
  ArrChtoPchar(Block.Name,P);
  if Okk then Begin
  Writeln(P);
  Writeln(HexPtr(Block.Address)); end else Halt;
  DisPose(P) ;
 end.