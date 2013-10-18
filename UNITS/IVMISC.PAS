Unit IvMisc;


interface

Procedure Delay(Count:word);
Procedure Sound(Value:word);
Procedure NoSound;

implementation

Procedure Delay(Count:word);assembler;
  asm
   cmp  Count,0
   je   @1
   mov  ah,86h
   mov  cx,Count
   mov  dx,0
   int  15h
@1:
 end;

Procedure Sound(Value:word);assembler;
  asm
   MOV  BX,Value
   MOV  AX,34DDh
   MOV  DX,0012h
   CMP  DX,BX
   JNC  @@2
   DIV  BX
   MOV  BX,AX
   IN   AL,61h
   TEST AL,3
   JNZ  @@1
   OR   AL,3
   OUT  61h,AL
   MOV  AL,182
   OUT  43h,AL
@@1:
   MOV  AL,BL
   OUT  42h,AL
   MOV  AL,BH
   OUT  42h,AL
@@2:
  end;

Procedure NoSound;assembler;
 asm
  IN   AL,61h
  AND  AL,11111100b
  OUT  61h,AL
 end;

end.
