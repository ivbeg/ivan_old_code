INCLUDE   MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN   HMAResult   : BYTE
      EXTRN   FirstHMAPtr : DWORD

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC AllocateHMA,ReleaseHMA
      PUBLIC ReSizeHMA
      PUBLIC GetAllFreeHMA,GetMaxFreeHMA

.386

HMATrueSign   DB 'HMA'
SavedFreeSize DW 0FFFFh
SavedPtr      DD  ?

TCompareSign PROC NEAR
              PUSH DS
              PUSH SI
              PUSH CX
              PUSH DI
              MOV  CX,3
              MOV  SI,SEG HMATrueSign
              MOV  DS,SI
              MOV  SI,OFFSET HMATrueSign
              CLD
              REP  CMPSB
              JE   @@01
              STC
       @@01:
              POP  DI
              POP  CX
              POP  SI
              POP  DS
              RET
TCompareSign ENDP


TMoveSign PROC NEAR
           PUSH DS
           PUSH SI
           PUSH CX
           PUSH DI
           PUSH AX
           MOV  CX,3
           MOV  SI,SEG HMATrueSign
           MOV  DS,SI
           MOV  SI,OFFSET HMATrueSign
        @@02:
           CLD
           LODSB
           STOSB
           LOOP @@02
           POP  AX
           POP  DI
           POP  CX
           POP  SI
           POP  DS
           RET
TMoveSign ENDP


TFillClosed PROC NEAR
             PUSH DI
             PUSH CX
             PUSH EAX
             MOV  EAX,0
             MOV  CX,4
             REP  STOSD
             POP  EAX
             POP  CX
             POP  DI
             RET
TFillClosed ENDP

GetHMANext PROC NEAR
            ADD DI,ES:[DI+12]
            ADD DI,16
            RET
GetHMANext ENDP


GetAllFreeHMA PROC FAR
               MOV  SavedFreeSize,0
               LES  DI,FirstHMAPtr
@@ReCheckFree_5:
               CMP  BYTE PTR ES:[DI+11],0
               JE   @@I_Found_Free_5
               CMP  BYTE PTR ES:[DI+10],'Z'
               JE   @@GetAllFreeHMAEnd
               CALL GetHMANext
               JMP  @@ReCheckFree_5
@@I_Found_Free_5:
               MOV  AX,WORD PTR ES:[DI+8]
               ADD  SavedFreeSize,AX
               CMP  BYTE PTR ES:[DI+10],'Z'
               JE   @@GetAllFreeHMAEnd
@@AddToSaved_5:
               MOV  SavedFreeSize,AX
               CMP  BYTE PTR ES:[DI+10],'Z'
               JE   @@GetAllFreeHMAEnd
               CALL GetHMANext
               JMP  @@ReCheckFree_5
@@GetAllFreeHMAEnd:
               MOV  AX,SavedFreeSize
               MOV  SavedFreeSize,0FFFFh
               RET
GetAllFreeHMA ENDP


GetMaxFreeHMA PROC FAR
               MOV  SavedFreeSize,0
               LES  DI,FirstHMAPtr
@@ReCheckFree_4:
               CMP  BYTE PTR ES:[DI+11],0
               JE   @@I_Found_Free_4
               CMP  BYTE PTR ES:[DI+10],'Z'
               JE   @@GetMaxFreeHMAEnd
               CALL GetHMANext
               JMP  @@ReCheckFree_4
@@I_Found_Free_4:
               MOV  AX,WORD PTR ES:[DI+8]
               CMP  AX,SavedFreeSize
               JA   @@SetTheSaved_4
               CMP  BYTE PTR ES:[DI+10],'Z'
               JE   @@GetMaxFreeHMAEnd
@@SetTheSaved_4:
               MOV  SavedFreeSize,AX
               CMP  BYTE PTR ES:[DI+10],'Z'
               JE   @@GetMaxFreeHMAEnd
               CALL GetHMANext
               JMP  @@ReCheckFree_4
@@GetMaxFreeHMAEnd:
               MOV  AX,SavedFreeSize
               MOV  SavedFreeSize,0FFFFh
               RET
GetMaxFreeHMA ENDP


ReSizeHMA PROC FAR
Pointer    EQU  (DWORD PTR [BP+8])
Size       EQU  (WORD  PTR [BP+6])
             StackFrameBP
             LES       DI,Pointer
             CALL      TCompareSign
             JC        @@InvalidSegment_3
             MOV       BX,Size
             CMP       BX,WORD PTR ES:[DI+8]
             JE        @@ReSizeHMAEnd
             MOV       DX,WORD PTR ES:[DI+12]
             SUB       DX,BX
             CMP       BX,WORD PTR ES:[DI+12]
             JA        @@ReSizeMaxer
             CMP       DX,17
             JBE       @@AddToRealSize_3
             MOV       CX,DI
             CALL      GetHMANext
             CMP       BYTE PTR ES:[DI+11],0
             JNE       @@CreateNewBlock_3
             SUB       DX,16
             ADD       WORD PTR ES:[DI+12],DX
             ADD       WORD PTR ES:[DI+8],DX
             PUSH      DS
             MOV       SI,ES
             MOV       DS,SI
             MOV       SI,CX
             ADD       SI,DS:[SI+12]
             ADD       SI,16
             MOV       CX,4
             REP       MOVSD
             POP       DS
             JMP       @@ReSizeHMAEnd
@@CreateNewBlock_3:
             MOV       DI,CX
             MOV       CL,BYTE PTR ES:[DI+10]
             MOV       BYTE PTR ES:[DI+10],'M'
             MOV       WORD PTR ES:[DI+8],BX
             MOV       WORD PTR ES:[DI+12],BX
             CALL      GetHMANext
             CALL      TMoveSign
             SUB       DX,16
             MOV       BYTE PTR ES:[DI+10],CL
             MOV       WORD PTR ES:[DI+12],DX
             MOV       WORD PTR ES:[DI+8],DX
             MOV       BYTE PTR ES:[DI+11],0
             JMP       @@ReSizeHMAEnd
@@AddToRealSize_3:
             ADD       WORD PTR ES:[DI+12],DX
             MOV       WORD PTR ES:[DI+8],BX
             JMP       @@ReSizeHMAEnd
@@ReSizeMaxer:
             SUB       DX,16
             MOV       CX,DI
             CALL      GetHMANext
             CMP       BYTE PTR ES:[DI+11],0
             JNE       @@InsuffMemory_3
             CMP       WORD PTR ES:[DI+12],DX
             JE        @@SetEqualBlock_3
             CMP       WORD PTR ES:[DI+12],DX
             JB        @@InsuffMemory_3
             MOV       AX,WORD PTR ES:[DI+12]
             SUB       DX,AX
             CMP       DX,17
             JA        @@CreateNewBlock_3
             MOV       DI,CX
             JMP       @@AddToRealSize_3
@@SetEqualBlock_3:
             MOV       CL,BYTE PTR ES:[DI+10]
             MOV       DI,CX
             MOV       WORD PTR ES:[DI+12],BX
             MOV       WORD PTR ES:[DI+8],BX
             MOV       BYTE PTR ES:[DI+10],CL
             JMP       @@ReSizeHMAEnd
@@InsuffMemory_3:
             MOV       HMAResult,8
             JMP       @@ReSizeHMAEnd
@@InvalidSegment_3:
             MOV       HMAResult,9
@@ReSizeHMAEnd:
             ExitCode  6
ReSizeHMA ENDP


AllocateHMA PROC FAR
Size        EQU  (WORD PTR [BP+6])
             StackFrameBP
             LES       DI,FirstHMAPtr
             MOV       BX,Size
             ADD       BX,16
@@BlockCheck:
             CALL      TCompareSign
             JC        @@ChainError_2
             CMP       BYTE PTR ES:[DI+11],0
             JE        @@ProceedCheck
             CMP       BYTE PTR ES:[DI+10],'Z'
             JE        @@InsuffMemory_2
             CALL      GetHMANext
             JMP       @@BlockCheck
@@ProceedCheck:
             MOV       AX,WORD PTR ES:[DI+8]
             CMP       AX,BX
             JE        @@SetEqualBlock
             CMP       AX,BX
             JA        @@SetHigherSize
             CMP       BYTE PTR ES:[DI+10],'Z'
             JE        @@InsuffMemory_2
             CALL      GetHMANext
             JMP       @@BlockCheck
@@AddToSaved_2:
             CMP       AX,SavedFreeSize
             JNB       @@BlockCheck
             MOV       SavedFreeSize,AX
             JMP       @@BlockCheck
@@SetEqualBlock:
             MOV       BYTE PTR ES:[DI+11],1
             MOV       AX,DI
             MOV       DX,ES
             JMP       @@AllocateHMAEnd
@@SetHigherSize:
             MOV       AX,WORD PTR ES:[DI+12]
             MOV       BX,Size
             SUB       AX,BX
             CMP       AX,17
             JB        @@RealNotSize
             MOV       BYTE PTR ES:[DI+11],1
             MOV       WORD PTR ES:[DI+8],BX
             MOV       WORD PTR ES:[DI+12],BX
             MOV       DL,BYTE PTR ES:[DI+10]
             MOV       BYTE PTR ES:[DI+10],'M'
             ADD       BX,16
             ADD       DI,BX
             CALL      TMoveSign
             SUB       AX,16
             MOV       WORD PTR ES:[DI+8],AX
             MOV       WORD PTR ES:[DI+12],AX
             MOV       BYTE PTR ES:[DI+10],DL
             MOV       BYTE PTR ES:[DI+11],0
             SUB       DI,BX
             MOV       AX,DI
             MOV       DX,ES
             JMP       @@AllocateHMAEnd
@@RealNotSize:
             SUB       BX,16
             MOV       WORD PTR ES:[DI+8],BX
             ADD       BX,AX
             MOV       WORD PTR ES:[DI+12],BX
             ADD       BX,16
             JMP       @@SetEqualBlock
@@InsuffMemory_2:
             MOV       HMAResult,8
             CMP       SavedFreeSize,0FFFFh
             JE        @@ZeroPointer
             MOV       HMAResult,0
             LES       DI,SavedPtr
             JMP       @@SetHigherSize
@@ChainError_2:
             MOV       HMAResult,7
@@ZeroPointer:
             XOR       AX,AX
             MOV       DX,AX
@@AllocateHMAEnd:
             MOV       SavedFreeSize,0FFFFh
             ExitCode  2
AllocateHMA ENDP


ReleaseHMA PROC FAR
Pointer    EQU  (DWORD PTR [BP+6])
            StackFrameBP
            LES       DI,Pointer
            CALL      TCompareSign
            JC        @@InvalidSegment_1
            MOV       AL,BYTE PTR ES:[DI+10]
            CMP       AL,'Z'
            JE        @@EndBlock_1
            MOV       AX,WORD PTR ES:[DI+12]
            ADD       DI,16
            ADD       DI,AX
            CALL      TCompareSign
            JC        @@ChainError_1
            CMP       BYTE PTR ES:[DI+11],0
            JE        @@AddBlocks_1
            SUB       DI,AX
            SUB       DI,16
            JMP       @@EndBlock_1
@@AddBlocks_1:
            MOV       DX,WORD PTR ES:[DI+12]
            MOV       BL,BYTE PTR ES:[DI+10]
            CALL      TFillClosed
            SUB       DI,AX
            SUB       DI,16
            ADD       DX,16
            ADD       WORD PTR ES:[DI+12],DX
            MOV       AX,WORD PTR ES:[DI+12]
            MOV       WORD PTR ES:[DI+8],AX
            MOV       BYTE PTR ES:[DI+10],BL
            MOV       BYTE PTR ES:[DI+11],0
            JMP       @@ReleaseHMAEnd
@@InvalidSegment_1:
            MOV       HMAResult,9
            JMP       @@ReleaseHMAEnd
@@ChainError_1:
            MOV       HMAResult,7
            JMP       @@ReleaseHMAEnd
@@EndBlock_1:
            MOV       BYTE PTR ES:[DI+11],0
@@ReleaseHMAEnd:
            ExitCode  4
ReleaseHMA ENDP


CODE ENDS

     END

