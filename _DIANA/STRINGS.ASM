include   ASMMACRO.INC


DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA





DATA  ENDS


CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

                   .386

      PUBLIC  LowCase, HexChar
      PUBLIC  StrLen, StrEnd, StrCopy, StrMove
      PUBLIC  StrPas, StrPCopy, StrLower, StrUpper


LowCase  PROC FAR
  CharCode EQU  (BYTE PTR [BP+6])
   macro_StackFrameBP
   MOV       AL, CharCode
   CMP       AL, 'Z'
   JA        @@Lowcase_End
   CMP       AL, 'A'
   JB        @@Lowcase_End
   ADD       AL, 'a'-'A'
@@Lowcase_End:
   macro_ExitCode  2
LowCase  ENDP


HexChar  PROC FAR
  Character EQU  (BYTE  PTR [BP+6])
   macro_StackFrameBP
   MOV       AL, Character
   SUB       AL, '0'
   CMP       AL, 9
   JBE       @@HexChar_End
   AND       AL, 11011111b
   SUB       AL, 'A'-'9'-1
@@HexChar_End:
   macro_ExitCode  2
HexChar  ENDP


StrLen  PROC FAR
  Str      EQU  (DWORD PTR [BP+6])
   macro_StackFrameBP
   LES       DI, Str
   MOV       CX, 0FFFFh
   macro_Zero  AL
   CLD
   REPNE     SCASB
   MOV       AX, 0FFFEh
   SUB       AX, CX
   macro_ExitCode  4
StrLen  ENDP


StrEnd  PROC FAR
  Str      EQU  (DWORD PTR [BP+6])
   macro_StackFrameBP
   LES       DI, Str
   MOV       CX, 0FFFFh
   macro_Zero  AL
   CLD
   REPNE     SCASB
   MOV       AX, DI
   MOV       DX, ES
   DEC       AX
   macro_ExitCode  4
StrEnd  ENDP


StrCopy  PROC FAR
  Source   EQU  (DWORD PTR [BP+10])
  Dest     EQU  (DWORD PTR [BP+6])
   macro_StackFrameBP
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
   macro_ExitCode  8
StrCopy  ENDP


StrMove  PROC FAR
  Source   EQU  (DWORD PTR [BP+12])
  Dest     EQU  (DWORD PTR [BP+8])
  Count    EQU  (WORD  PTR [BP+6])
   macro_StackFrameBP
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
   macro_ExitCode  10
StrMove  ENDP


StrPCopy  PROC FAR
  Source   EQU  (DWORD PTR [BP+10])
  Dest     EQU  (DWORD PTR [BP+6])
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
  Str      EQU  (DWORD PTR [BP+6])
   macro_StackFrameBP
   PUSH      DS
   CLD
   LDS       SI, Str
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
  Str      EQU  (DWORD PTR [BP+6])
   macro_StackFrameBP
   PUSH      DS
   CLD
   LDS       SI, Str
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
  Source   EQU  (DWORD PTR [BP+8])
  Dest     EQU  (DWORD PTR [BP+6])
   macro_StackFrameBP
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
   macro_ExitCode  4
StrPas  ENDP




CODE  ENDS

      END
