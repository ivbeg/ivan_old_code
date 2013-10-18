INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA


DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC SwapB,SwapW,SwapP,Swap
      PUBLIC BitofW,BitofB,SearchPtr
      PUBLIC FillByte,FillWord,MovePtr
      PUBLIC FillDWord,Fill,FastMove,FastFill

.386

FastMove  PROC FAR
           CLD
           PUSH      CX
           SHR       CX,1
           SHR       CX,1
           REP       MOVSD
           POP       CX
           AND       CX,3
           REP       MOVSB
           RET
FastMove  ENDP


MovePtr PROC FAR
Source  EQU  (DWORD PTR [BP+12])
Dest    EQU  (DWORD PTR [BP+8])
Size    EQU  (WORD  PTR [BP+6])
         StackFrameBP
         MOV       BX,DS
         MOV       CX,Size
         LES       DI,Dest
         LDS       SI,Source
         CALL      FastMove
         MOV       DS,BX
         ExitCode  10
MovePtr ENDP


SearchPtr PROC FAR
Buffer    EQU  (DWORD PTR [BP+14])
Count     EQU  (WORD  PTR [BP+12])
Buff      EQU  (DWORD PTR [BP+8])
BuffSize  EQU  (WORD  PTR [BP+6])
           StackFrameBP
           PUSH      DS
           LES       DI,Buffer
           MOV       BX,di
           MOV       CX,Count
           MOV       DX,BuffSize
           TEST      DX,DX
           JZ        @5
           LDS       SI,Buff
           LODSB
           DEC       DX
           SUB       CX,DX
        @1:
           REPNE     SCASB
           JNE       @5
           TEST      DX,DX
           JZ        @4
           PUSH      CX
           PUSH      DI
           PUSH      SI
           MOV       CX,DX
           REPE      CMPSB
           POP       SI
           POP       DI
           POP       CX
           JNE       @1
       @4:
           DEC       DI
           MOV       AX,DI
           SUB       AX,BX
           MOV       DX,ES
           JMP       @6
       @5:
           MOV       AX,0
           MOV       DX,0
       @6:
           POP       DS
           ExitCode  12
SearchPtr ENDP

FastFill PROC FAR
          PUSH      EAX
          MOV       AH,AL
          PUSH      AX
          SHL       EAX,16
          POP       AX
          CLD
          PUSH      CX
          SHR       CX,1
          SHR       CX,1
          REP       STOSD
          POP       CX
          AND       CX,03H
          REP       STOSB
          POP       EAX
          RET
FastFill ENDP

FillByte PROC FAR
Dest     EQU  (DWORD PTR [BP+10])
Count    EQU  (WORD  PTR [BP+8])
B        EQU  (BYTE  PTR [BP+6])
          StackFrameBP
          LES       DI,Dest
          MOV       CX,Count
          MOV       AL,B
          CALL      FastFill
          ExitCode 8
FillByte ENDP

FillWord PROC FAR
Dest     EQU  (DWORD PTR [BP+10])
Count    EQU  (WORD  PTR [BP+8])
W        EQU  (WORD  PTR [BP+6])
          StackFrameBP
          LES      DI,Dest
          MOV      CX,Count
          MOV      AX,W
          SHL      EAX,16
          MOV      AX,W
          SHR      CX,1
          CLD
          REP      STOSD
          ADC      CX,CX
          REP      STOSW
          ExitCode 8
FillWord ENDP


FillDword PROC FAR
Dest     EQU  (DWORD PTR [BP+12])
Count    EQU  (WORD  PTR [BP+10])
D        EQU  (DWORD PTR [BP+6])
          StackFrameBP
          LES      DI,Dest
          MOV      CX,Count
          CLD
          MOV      EAX,D
          REP      STOSD
          ExitCode 10
FillDword ENDP


Fill  PROC FAR
Dest     EQU  (DWORD PTR [BP+14])
Source   EQU  (DWORD PTR [BP+10])
Count    EQU  (WORD  PTR [BP+8])
Size     EQU  (WORD  PTR [BP+6])
          StackFrameBP
          PUSH      DS
          LES       DI,Dest
          LDS       SI,Source
          MOV       CX,Size
          MOV       AX,Count
          CLD
          MOV       BX,CX
      @2:
          MOV       CX,BX
          CMP       AX,0
          JE        @3
          SHR       CX,1
          SHR       CX,1
          REP       MOVSD
          MOV       CX,BX
          AND       CX,3
          REP       MOVSB
          SUB       SI,Size
          DEC       AX
          JMP       @2
       @3:
          POP       DS
          ExitCode 12
Fill  ENDP



Swap  PROC FAR
Dest   EQU  (DWORD PTR [BP+12])
Source EQU  (DWORD PTR [BP+8])
Size   EQU  (WORD  PTR [BP+6])
        StackFrameBP
        SaveDS    DX
        MOV       CX,Size
        JCXZ      Loc_3
        LES       DI,Dest
        LDS       SI,Source
        CLD
        SHR       CX,1
        JCXZ      Loc_2a
        PUSHF
 Loop1:
        MOV       AX,ES:[DI]
        XCHG      AX,DS:[SI]
        MOV       ES:[DI],AX
        ADD       SI,2
        ADD       DI,2
        LOOP      Loop1
        POPF
        JNC       Loc_3
  Loc_2a:
        MOV       AL,DS:[SI]
        XCHG      AL,ES:[DI]
        MOV       DS:[SI],AL

  Loc_3:
        RestoreDS DX
        ExitCode  10
Swap   ENDP

SwapP PROC FAR
X     EQU  (DWORD PTR [BP+10])
Y     EQU  (DWORD PTR [BP+6])
       StackFrameBP
       mov   ax,WORD PTR [X]
       mov   dx,WORD PTR [X+2]
       xchg  ax,WORD PTR [Y]
       xchg  dx,WORD PTR [Y+2]
       mov   WORD PTR [X],ax
       mov   WORD PTR [X+2],dx
       ExitCode 8
SwapP ENDP


SwapB PROC FAR
X     EQU  (DWORD PTR [BP+10])
Y     EQU  (DWORD PTR [BP+6])
       StackFrameBP
       PUSH      DS
       LES       DI,X
       LDS       SI,Y
       MOV       AL,ES:[DI]
       XCHG      AL,ES:[DI]
       MOV       ES:[DI],AL
       POP       DS
       ExitCode  8
SwapB ENDP


SwapW PROC FAR
X     EQU  (DWORD PTR [BP+10])
Y     EQU  (DWORD PTR [BP+6])
       StackFrameBP
       PUSH      DS
       LES       DI,X
       LDS       SI,Y
       MOV       AX,ES:[DI]
       XCHG      AX,DS:[SI]
       MOV       ES:[DI],AX
       POP       DS
       ExitCode  8
SwapW ENDP


BitofB PROC FAR
Dest    EQU (BYTE PTR [BP+8])
Source  EQU (BYTE PTR [BP+6])
         StackFrameBP
         mov  cl,Source
         mov  al,Dest
         shr  al,cl
         and  al,01h
         ExitCode 4
BitofB ENDP


BitofW PROC FAR
Dest    EQU (WORD PTR [BP+8])
Source  EQU (BYTE PTR [BP+6])
         StackFrameBP
         mov  cl,Source
         mov  ax,Dest
         shr  ax,cl
         and  al,01h
         ExitCode 4
BitofW ENDP


CODE  ENDS

      END