INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

PCharSize PROC FAR
PCharStr  EQU  (DWORD PTR [BP+6])
           StackFrameBP
           LES       DI,PCharStr
           MOV       BX,DI
           MOV       CX,0FFFFh
           SUB       AL,AL
           CLS
           REPNE     SCASB
           SUB       DI,BX
           MOV       AX,DI
           DEC       AX
           ExitCode  4
PCharSize ENDP


AsciizString PROC FAR
StringPtr    EQU  (DWORD PTR [BP+6])
              StackFrameBP
              CLD
              SaveDS    DX
              LDS       SI,StringPtr
              LES       DI,StringPtr
              Zero      CH
              MOV       CL,BYTE PTR [SI]
              JCXZ      CxZero1
              INC       SI
              REP       MOVSB
              MOV       BYTE PTR ES:[DI],0
      CxZero1:
              RestoreDS DX
              ExitCode  4
AsciizString ENDP


AscString PROC FAR
StringPtr EQU  (DWORD PTR [BP+6])
           StackFrameBP
           CLD
           LES       DI,StringPtr
           MOV       CX,255
           Zero      al
           REPNE     SCASB
           NOT       CL
           DEC       CL
           JCXZ      CxZero2
           SaveDS    DX
           LDS       SI,StringPtr
           STD
           DEC       DI
           MOV       SI,DI
           DEC       SI
           PUSH      CX
           REP       MOVSB
           POP       CX
           MOV       BYTE PTR [DI],CL
           RestoreDS DX
           ExitCode  4
AscString ENDP


LoCase   PROC FAR
CharCode EQU  (BYTE PTR [BP+6])
          StackFrameBP
          MOV       AX,CharCode
          CMP       AL,'z'
          JA        Quit4
          CMP       AL,'A'
          JB        Quit4
          ADD       AL,'A'-'A'
    Quit4:
          ExitCode  2
LoCase   ENDP


StrLow    PROC FAR
StringPtr EQU  (DWORD PTR [BP+6])
           StackFrameBP
           CLD
           SaveDS    DX
           LDS       SI,StringPtr
           SUB       CX,CX
           MOV       CL,BYTE PTR [SI]
           JCXZ      Quit5
           LES       DI,StringPtr
           INC       SI
           INC       DI
SetLowCase:
           LODSB
           CMP       AL,'A'
           JB        LowCase1
           CMP       AL,'Z'
           JA        LowCase1
           ADD       AL,'a'-'A'
  LowCase1:
           STOSB
           LOOP      SetLowCase
     Quit5:
           RestoreDS DX
           ExitCode  4
StrLow    ENDP

StrUpp    PROC FAR
StringPtr EQU  (DWORD PTR [BP+6])
           StackFrameBP
           CLD
           SaveDS    DX
           LDS       SI,StringPtr
           SUB       CX,CX
           MOV       CL,BYTE PTR [SI]
           JCXZ      Quit5
           LES       DI,StringPtr
           INC       SI
           INC       DI
SetUpCase:
           LODSB
           CMP       AL,'a'
           JB        UpCase1
           CMP       AL,'z'
           JA        UpCase1
           SUB       AL,'a'-'A'
  UpCase1:
           STOSB
           LOOP      SetUpCase
     Quit5:
           RestoreDS DX
           ExitCode  4
StrUpp    ENDP


CheckChar PROC FAR
CharCode  EQU  (BYTE PTR [BP+10])
Start     EQU  (BYTE PTR [BP+8])
Ende      EQU  (BYTE PTR [BP+6])
           StackFrameBP
           MOV       BH,Start
           MOV       BL,Ende
           CMP       BH,BL
           JB        SwapThem
           JMP       DontSwap
  SwapThem:
           XCHG      BH,BL
  DontSwap:
           MOV       AL,CharCode
           CMP       AL,BH
           JB        Quit7
           CMP       AL,BL
           JA        Quit7
           MOV       AL,1
           JMP       Quit8
     Quit7:
           MOV       AL,0
     Quit8:
           ExitCode  6
CheckChar ENDP

CODE ENDS
     END