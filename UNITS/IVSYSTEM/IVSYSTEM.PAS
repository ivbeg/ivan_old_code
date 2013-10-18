unit IvSystem;

interface


{$I IvTypes.INC}


  Var
       PspAddr:PspRecP;
       IntTable: array[0..255] of pointer
                 absolute $0000:$0000;
     BiosArea:BiosAreaRec absolute$0040:$0000;
      Err:record
           Error:byte;
           Etype:byte;
          end;
      Error:byte;
      EType:byte;
        sgbErrorDecode:boolean;

Function  SearchPtr(Buffer:pointer;Count:word;Buff:pointer;BuffSize:word):pointer;
Procedure FillByte(Count:word;B:byte;P:pointer);
Procedure Reboot;
InLine(
$CD/
$19);
Procedure FullReboot;
Function  BitofB(Bite,Stat:byte):boolean;
Function  BitofW(Wrd:word;Count:byte):boolean;
Function  SayNo(BooL:boolean):str3;
Procedure SwapB(Var X,Y:byte);
Procedure SwapW(Var X,Y:word);
Procedure SwapP(Var X,Y:Pointer);
Function  GetIntVector(Int:byte):pointer;
Procedure SetIntVector(Int:byte;P:pointer);
Procedure FillWord(Cnt : Word; W : Word;P:pointer);
Procedure IsError;
Function  AddPtr(P:pointer;W:word):pointer;
               inline($5B       {  pop bx     ; BX = Num       }
               /$58       {  pop ax     ; AX = Ofs(P)    }
               /$5A       {  pop dx     ; DX = Seg(P)    }
               /01/$D8);  {  add ax,bx  ; DX:AX = result }

Function  SubPtr(P : pointer; Num : word) : pointer;
               inline($5B        {  pop bx     ; BX = Num       }
               /$58        {  pop ax     ; AX = Ofs(P)    }
               /$5A        {  pop dx     ; DX = Seg(P)    }
               /29/$D8);   {  sub ax,bx  ; DX:AX = result }

Procedure MovePtr(S,D:pointer;Cnt:word);
Function CheckPtr(Ptr1:Pointer):Pointer;
         inline($58           {  pop  ax      ;  AX = Offset  }
               /$5A           {  pop  dx      ;  DX = Segment }
               /$89/$C3       {  mov  bx,ax   ;  BX = Ofs(P^) }
               /$B1/$04       {  mov  cl,4    ;  CL = shift count }
               /$D3/$EB       {  shr  bx,cl   ;  BX = Ofs(P^) div 16 }
               /$01/$DA       {  add  dx,bx   ;  add to Segment }
               /$25/$0F/$00); {  and  ax,15   ;  mask out unwanted }
                                           {  ;  bits in offset }

Procedure Swap(Size:word;P1,P2:pointer);
Procedure Cli;
 Inline($FA);

Procedure Sti;
 Inline($FB);

implementation
{$L IVSYSTEM.OBJ}

Function  SearchPtr(Buffer:pointer;Count:word;Buff:pointer;BuffSize:word):pointer;External;
Procedure MovePtr(S,D:pointer;Cnt:word);External;
Procedure FillByte(Count:word;B:byte;P:pointer);External;
Function  BitofB(Bite,Stat:byte):boolean;External;
Function  BitofW(Wrd:word;Count:byte):boolean;External;
Procedure FillWord(Cnt : Word; W : Word;P:pointer);External;

Procedure SwapB(Var X,Y:byte);External;
Procedure SwapW(Var X,Y:word);External;
Procedure SwapP(Var X,Y:Pointer);External;
Procedure Swap(Size:word;P1,P2:pointer);External;
Procedure SwapVar(Size:word;Var S,D);
 Begin
  Swap(Size,Addr(S),Addr(D));
 end;

Procedure FullReboot;
begin
MemW[0:$472]:=$1234;
Inline(
$EA/
$00/
$00/
$FF/
$FF );
end;

Function  SayNo(BooL:boolean):str3;
 begin
  if Bool then SayNo:='Yes' else SayNo:='No';
 end;

Function GetIntVector(Int:byte):pointer;
 Begin
  GetIntVector:=IntTable[Int];
 end;

Procedure SetIntVector(Int:byte;P:pointer);
 Begin
  IntTable[Int]:=P;
 end;

Procedure IsError;
 Begin
  if Error > 0 then RunError(Error);
 end;

Begin
  Error:=0;
  EType:=0;
  PspAddr:=Ptr(PrefixSeg,0);
end.
