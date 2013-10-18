Uses IvDos,IvSystem;
Var P:PChar;

Procedure ExecOvr(FileName:Pchar; CommLine:CommStr);
Var OldSS,OldSP:word;
    Error:byte absolute Err;
 Begin
  ExecBlock.CommTail:=@CommLine;
  asm
   mov  bx,Seg  ExecBlock
   mov  es,bx
   mov  bx,Offset  ExecBlock
   lds  dx,FileName
   cli
   mov  OldSS,ss
   mov  OldSP,sp
   sti
   mov  ax,4b00h
   int  21h
   mov  ax,Seg @Data
   mov  ds,ax
   cli
   mov  ss,OldSS
   mov  sp,OldSP
   sti
   jc   @1
   mov  Error,0
   JMP  @2
@1:
   mov  Error,al
@2:
  end;
 end;

Begin
 New(P);
 P:='D:\UTIL\RAMVIEW.COM';
 ExecOvr(P,'');
 P:='D:\UTIL\MEMVIEW.EXE';
 Exec(P,' /m /u /p');
 SetUMBLinkState(false);
end.
