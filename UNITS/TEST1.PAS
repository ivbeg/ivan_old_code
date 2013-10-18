Uses IvSystem,IvGraph,IvCrt,IvKbd,IvString,IvMouse,IvDos;
Var C      :byte;
    Handle :word;

 Function GetVideoAddress:word;assembler;
  asm
   mov dx,3d4h
   mov al,0Ch
   out dx,al
   Inc dl
   in  al,dx
   mov ah,al
   dec dl
   mov al,0Dh
   out dx,al
   Inc dl
   in  al,dx
  end;
  Procedure Scan(W:word);assembler;
   asm
    mov dx,3d4h
    mov bx,W
    mov ah,bl
    mov al,12h
    out dx,ax
    mov ah,bh
    and bh,2
    and ah,1
    shl ah,1
    mov cl,5
    shl bh,cl
    or  ah,bh
    mov al,7h
    out dx,al
    inc dl
    in  al,dx
    or  ah,al
    dec dl
    mov al,7
    out dx,ax
   end;


Procedure SetDouble;assembler;
 asm
  mov dx,3d4h
  mov al,9
  out dx,al
  inc dl
  in  al,dx
  or  al,128
  mov ah,al
  dec dl
  mov al,9
  out dx,ax
 end;

Begin
 SetPage(3);
 repeat until keypresent;
 CreateFile('Ivan.Lst',StdAttr,Handle);
 IsError;
 WriteStrInFile(Handle,'ScanLines: '+Digit(GetVideoAddress));
 CloseFile(Handle);
 IsError;
 SetPage(0);

end.
