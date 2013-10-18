INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA


DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC  GetKey,FlushKbdBuff,KeyPresent
      PUBLIC  WriteKey,SetRate_Delay,WaitForKey


GetKey        PROC FAR
               KbdCall 10h
               ret
GetKey        ENDP


FlushKbdBuff   PROC FAR
           @1:
                KbdCall 11h
                jz      @2
                KbdCall 10h
                jmp     @1
           @2:
                ret
FlushKbdBuff   ENDP


KeyPresent   PROC FAR
              KbdCall 11h
              jz      @3
              cmp     ax,0
              je      @5
              KbdCall 10h
           @5:
              mov     al,1
              jmp     @4
           @3:
              Zero    al
           @4:
              ret
KeyPresent   ENDP


SetRate_Delay PROC FAR
Rate          EQU  (BYTE PTR [BP+8])
Delay         EQU  (BYTE PTR [BP+6])
               StackFrameBP
               mov       bl,Rate
               mov       bh,Delay
               mov       al,05h
               KbdCall   03h
               ExitCode  4
SetRate_Delay ENDP


WaitForKey PROC FAR
Key        EQU  (WORD PTR [BP+6])
            StackFrameBP
            mov      bx,Key
     RepLoc:
            KbdCall  10h
            cmp      ax,bx
            jne      RepLoc
            ExitCode 2
WaitForKey ENDP


WriteKey   PROC FAR
Key        EQU  (WORD PTR [BP+10])
Ok         EQU  (DWORD PTR [BP+6])
            StackFrameBP
            mov cx,Key
            KbdCall 5h
            cmp     al,0
            jne     @7
            inc     al
            jmp     @8
        @7:
            xor     al,al
        @8:
            ExitCode 2
WriteKey   ENDP


CODE  ENDS

      END