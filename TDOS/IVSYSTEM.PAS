unit IvSystem;

interface


{$I IvTypes.INC}


  Var
       PspAddr:PspRecP;
       IntTable: array[0..255] of pointer
                 absolute $0000:$0000;
     BiosArea:BiosAreaRec absolute $0040:$0000;
      Err:record
           Error:byte;
           Etype:byte;
          end;
      Error:byte;
      EType:byte;
        sgbErrorDecode:boolean;


Procedure DoNone;

Procedure FastFill;
Procedure FastMove;

Function  ExtMem:word;
Function  LowMem:word;
Function  SearchPtr(Buffer:pointer;Count:word;Buff:pointer;BuffSize:word):pointer;
Procedure FillByte(P:pointer;Count:word;B:byte);
Procedure FillWord(P:pointer;Count:word;W:Word);
Procedure FillDWord(P:pointer;Count:word;D:Longint);

Procedure FillByteVar(Var D;Count:word;B:Byte);
Procedure FillWordVar(Var D;Count:word;W:Word);
Procedure FillDWordVar(Var Dest;Count:word;D:Longint);
Procedure FillVar(Var D,S;Size,Count:word);

Procedure Fill(Dest:Pointer;Source:pointer;Size:word;Count:word);
Procedure FullReboot;
Function  BitofB(Bite,Stat:byte):boolean;
Function  BitofW(Wrd:word;Count:byte):boolean;
Procedure SwapB(Var X,Y:byte);
Procedure SwapW(Var X,Y:word);
Procedure SwapP(Var X,Y:Pointer);
Function  GetIntVector(Int:byte):pointer;
Procedure SetIntVector(Int:byte;P:pointer);
Procedure IsError;

Procedure Reboot;
InLine(
$CD/$19);
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
Procedure MoveVar(Var S,D;Count:word);
Function  CheckPtr(Ptr1:Pointer):Pointer;
         inline($58           {  pop  ax      ;  AX = Offset  }
               /$5A           {  pop  dx      ;  DX = Segment }
               /$89/$C3       {  mov  bx,ax   ;  BX = Ofs(P^) }
               /$B1/$04       {  mov  cl,4    ;  CL = shift count }
               /$D3/$EB       {  shr  bx,cl   ;  BX = Ofs(P^) div 16 }
               /$01/$DA       {  add  dx,bx   ;  add to Segment }
               /$25/$0F/$00); {  and  ax,15   ;  mask out unwanted }
                                           {  ;  bits in offset }

Procedure Swap(P1,P2:pointer;Size:word);
Procedure SwapVar(Var S,D;Size:word);
Procedure Cli;
 Inline($FA);

Procedure Sti;
 Inline($FB);

implementation
{$L IVSYSTEM.OBJ}

Function  SearchPtr(Buffer:pointer;Count:word;Buff:pointer;BuffSize:word):pointer;External;
Procedure MovePtr(S,D:pointer;Cnt:word);External;
Procedure MoveVar(Var S,D;Count:word);
 Begin
  MovePtr(Addr(S),Addr(D),Count);
 end;

Function  BitofB(Bite,Stat:byte):boolean;External;
Function  BitofW(Wrd:word;Count:byte):boolean;External;
Procedure FillByte(P:pointer;Count:word;B:byte);External;
Procedure FillByteVar(Var D;Count:word;B:Byte);
 Begin
  FillByte(Addr(D),Count,B);
 end;

Procedure FillWord(P:pointer;Count:word;W:Word);External;
Procedure FillWordVar(Var D;Count:word;W:Word);
 Begin
  FillWord(Addr(D),Count,W);
 end;

Procedure FillDWord(P:pointer;Count:word;D:Longint);External;
Procedure FillDWordVar(Var Dest;Count:word;D:Longint);
 Begin
  FillDWord(Addr(Dest),Count,D);
 end;

Procedure Fill(Dest:Pointer;Source:pointer;Size:word;Count:word);External;
Procedure FillVar(Var D,S;Size,Count:word);
 Begin
  Fill(Addr(D),Addr(S),Size,Count);
 end;

Procedure SwapB(Var X,Y:byte);External;
Procedure SwapW(Var X,Y:word);External;
Procedure SwapP(Var X,Y:Pointer);External;
Procedure Swap(P1,P2:pointer;Size:word);External;
Procedure SwapVar(Var S,D;Size:word);
 Begin
  Swap(Addr(S),Addr(D),Size);
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

Function LowMem:word;assembler;
  asm
   int   12h
  end;

Function ExtMem:word;assembler;
  asm
   mov  ah,88h
   int  15h
  end;

Procedure DoNone;Assembler;
 asm
 end;

Procedure FastFill;External;
Procedure FastMove;External;

Begin
  Error:=0;
  EType:=0;
  PspAddr:=Ptr(PrefixSeg,0);
end.
