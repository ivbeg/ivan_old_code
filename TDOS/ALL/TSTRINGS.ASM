include   ASMMACRO.INC


DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA





DATA  ENDS


CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

                   .386

      PUBLIC  StrLen, StrEnd, StrCopy, StrMove
      PUBLIC  StrPas, StrPCopy, StrLower, StrUpper



StrLen  PROC FAR
  _String    EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   LES       DI, _String
   MOV       CX, 0FFFFh
   macro_Zero  AL
   CLD
   REPNE     SCASB
   MOV       AX, 0FFFEh
   SUB       AX, CX
   RET       4
StrLen  ENDP


StrEnd  PROC FAR
  _String    EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrameBP
   LES       DI, _String
   MOV       CX, 0FFFFh
   macro_Zero  AL
   CLD
   REPNE     SCASB
   MOV       AX, DI
   MOV       DX, ES
   DEC       AX
   RET       4
StrEnd  ENDP


StrCopy  PROC FAR
  Source     EQU    (DWORD PTR SS:[BX+8])
  Dest       EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   LES       DI, Source
   MOV       CX, 0FFFFh
   macro_Zero  AL
   CLD
   REPNE     SCASB
   NOT       CX
   LES       DI, Source
   LDS       SI, Dest
   MOV       AX, DI
   MOV       DX, ES
   REP       MOVSB
   POP       DS
   RET       8
StrCopy  ENDP


StrMove  PROC FAR
  Source     EQU    (DWORD PTR SS:[BX+10])
  Dest       EQU    (DWORD PTR SS:[BX+6])
  Count      EQU    (WORD  PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   LES       DI, Source
   LDS       SI, Dest
   MOV       AX, DI
   MOV       DX, ES
   MOV       CX, Count
   CLD
   CMP       SI, DI
   JAE       @@StrMove_Repeat
   STD
   ADD       SI, CX
   ADD       DI, CX
   DEC       SI
   DEC       DI
@@StrMove_Repeat:
   REPNE     MOVSB
   CLD
   POP       DS
   RET       10
StrMove  ENDP


StrPCopy  PROC FAR
  Source     EQU    (DWORD PTR SS:[BP+10])
  Dest       EQU    (DWORD PTR SS:[BP+6])
   macro_StackFrameBP
   PUSH      DS
   LDS       SI, Source
   LES       DI, Dest
   MOV       BX, DI
   MOV       DX, ES
   LODSB
   XOR       AH, AH
   XCHG      AX, CX
   REP       MOVSB
   macro_Zero  AL
   STOSB
   XCHG      AX, BX
   POP       DS
   macro_ExitCode  8
StrPCopy  ENDP


StrUpper PROC FAR
  _String    EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrameBP
   PUSH      DS
   CLD
   LDS       SI, _String
   MOV       BX, SI
   MOV       DX, DS
   MOV       CX, 0FFFFh
@@StrUpper_Loop:
   LODSB
   OR        AL, AL
   JE        @@StrUpper_End
   CMP       AL, 'a'
   JB        @@StrUpper_Loop
   CMP       AL, 'z'
   JA        @@StrUpper_Loop
   SUB       AL, 20h
   MOV       [SI-1], AL
   LOOP      @@StrUpper_Loop
   XCHG      AX, BX
@@StrUpper_End:
   POP       DS
   macro_ExitCode  4
StrUpper ENDP


StrLower  PROC FAR
  _String    EQU    (DWORD PTR SS:[BP+6])
   macro_StackFrameBP
   PUSH      DS
   CLD
   LDS       SI, _String
   MOV       BX, SI
   MOV       DX, DS
   MOV       CX, 0FFFFh
@@StrLower_Loop:
   LODSB
   OR        AL, AL
   JE        @@StrLower_End
   CMP       AL, 'A'
   JB        @@StrLower_Loop
   CMP       AL, 'Z'
   JA        @@StrLower_Loop
   ADD       AL, 20h
   MOV       [SI-1], AL
   LOOP      @@StrLower_Loop
   XCHG      AX, BX
@@StrLower_End:
   POP       DS
   macro_ExitCode  4
StrLower  ENDP


StrPas  PROC FAR
  Source     EQU    (DWORD PTR SS:[BX+8])
  Dest       EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      DS
   CLD
   LES       DI, Source
   MOV       CX, 0FFFFh
   macro_Zero AL
   NOT       CX
   DEC       CX
   LDS       SI, Source
   LES       DI, Dest
   OR        CH, CH
   JZ        @@StrPas_Check
   MOV       CX, 0FFh
@@StrPas_Check:
   macro_Zero CH
   STOSB
   REP       MOVSB
   POP       DS
   RET       4
StrPas  ENDP




CODE  ENDS

      END
