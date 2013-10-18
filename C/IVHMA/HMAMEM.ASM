 include ASMMACRO.INC


 .MODEL LARGE

 .DATA

   HMAResult    DB     00h
   FirstHMAPtr  DD     000000h


 .CODE

    .386

HMATrueSign   DB 'HMA'
SavedFreeSize DW 0FFFFh
SavedPtr      DD  ?


TCompareSign  PROC NEAR
   PUSH      DS
   PUSH      SI
   PUSH      CX
   PUSH      DI
   MOV       CX, 3
   MOV       SI, SEG HMATrueSign
   MOV       DS, SI
   MOV       SI, OFFSET HMATrueSign
   CLD
   REP       CMPSB
   JE        @@TCompareSign_End
   STC
@@TCompareSign_End:
   POP       DI
   POP       CX
   POP       SI
   POP       DS
   RET
TCompareSign  ENDP


TMoveSign  PROC NEAR
   PUSH      DS
   PUSH      SI
   PUSH      CX
   PUSH      DI
   PUSH      AX
   MOV       CX, 3
   MOV       SI, SEG HMATrueSign
   MOV       DS, SI
   MOV       SI, OFFSET HMATrueSign
@@TMoveSign_Loop:
   CLD
   LODSB
   STOSB
   LOOP      @@TMoveSign_Loop
   POP       AX
   POP       DI
   POP       CX
   POP       SI
   POP       DS
   RET
TMoveSign  ENDP


TFillClosed  PROC NEAR
   PUSH      DI
   PUSH      CX
   PUSH      EAX
   macro_Zero EAX
   MOV       CX, 4
   REP       STOSD
   POP       EAX
   POP       CX
   POP       DI
   RET
TFillClosed  ENDP


GetHMANext  PROC NEAR
   ADD       DI, WORD PTR ES:[DI+12]
   ADD       DI, 16
   RET
GetHMANext  ENDP


GetAllFreeHMA  PROC NEAR
   MOV       SavedFreeSize, 00h
   LES       DI, FirstHMAPtr
@@GetAllFreeHMA_ReCheckFree:
   CMP       BYTE PTR ES:[DI+11], 0
   JE        @@GetAllFreeHMA_FoundFree
   CMP       BYTE PTR ES:[DI+10], 'Z'
   JE        @@GetAllFreeHMA_End
   CALL      GetHMANext
   JMP       @@GetAllFreeHMA_ReCheckFree
@@GetAllFreeHMA_FoundFree:
   MOV       AX, WORD PTR ES:[DI+8]
   ADD       SavedFreeSize, AX
   CMP       BYTE PTR ES:[DI+10], 'Z'   
   JE        @@GetAllFreeHMA_End
   JMP       @@GetAllFreeHMA_ReCheckFree
@@GetAllFreeHMA_End:
   MOV       AX, SavedFreeSize
   MOV       SavedFreeSize, 0FFFFh
   RET
GetAllFreeHMA  ENDP


GetMaxFreeHMA  PROC FAR
   MOV       SavedFreeSize, 00h
   LES       DI, FirstHMAPtr
@@GetMaxFreeHMA_ReCheckFree:
   CMP       BYTE PTR ES:[DI+11], 0
   JE        @@GetMaxFreeHMA_FoundFree
   CMP       BYTE PTR ES:[DI+10], 'Z'
   JE        @@GetMaxFreeHMA_End
   CALL      GetHMANext
   JMP       @@GetMaxFreeHMA_ReCheckFree
@@GetMaxFreeHMA_FoundFree:
   MOV       AX, WORD PTR ES:[DI+8]
   CMP       AX, SavedFreeSize
   JB        @@GetMaxFreeHMA_SetFree
   MOV       SavedFreeSize, AX
@@GetMaxFreeHMA_Next:
   CMP       BYTE PTR ES:[DI+10], 'Z'
   JE        @@GetMaxFreeHMA_End
   JMP       @@GetMaxFreeHMA_ReCheckFree
@@GetMaxFreeHMA_End:
   MOV       AX, SavedFreeSize
   MOV       SavedFreeSize, 0FFFFh
   RET
GetMaxFreeHMA  ENDP


AllocateHMA  PROC FAR
 BlockSize     EQU    (WORD PTR SS:[BP+6])
   macro_StackFrameBP
   LES       DI, FirstHMAPtr
   MOV       BX, Size
   ADD       BX, 16
@@AllocateHMA_BlockCheck:
@@AllocateHMA_ProceedCheck:
@@AllocateHMA_SetEqualBlock:

   
   macro_ExitCode  0
AllocateHMA  ENDP


ReleaseHMA  PROC FAR
 Pointer       EQU    (WORD PTR SS:[BP+6])
   macro_StackFrameBP
   LES       DI, Pointer
   CALL      TCompareSign
   JC        @@ReleaseHMA_InvalidSegment
   MOV       AL, BYTE PTR ES:[DI+10]
   CMP       AL, 'Z'
   JE        @@ReleaseHMA_EndBlock
   MOV       AX, WORD PTR ES:[DI+12]
   ADD       DI, 16
   ADD       DI, AX
   CALL      TCompareSign
   JC        @@ReleaseHMA_ChainError
   CMP       BYTE PTR ES:[DI+11], 0
   JE        @@ReleaseHMA_AddBlocks
   SUB       DI, AX
   SUB       DI, 16
   JMP       @@ReleaseHMA_EndBlock
@@ReleaseHMA_AddBlocks:
   MOV       DX, WORD PTR ES:[DI+12]
   MOV       BL, BYTE PTR ES:[DI+10]
   CALL      TFillClosed
   SUB       DI, AX
   SUB       DI, 16
   ADD       DX, 16
   ADD       WORD PTR ES:[DI+12], DX
   MOV       AX, WORD PTR ES:[DI+12]
   MOV       WORD PTR ES:[DI+8], AX
   MOV       BYTE PTR ES:[DI+10], BL
   MOV       BYTE PTR ES:[DI+110], 0
   JMP       @@ReleaseHMA_End
@@ReleaseHMA_InvalidSegment:
   MOV       HMAResult, 9
   JMP       @@ReleaseHMA_End
@@ReleaseHMA_ChainError:
   MOV       HMAResult, 7
   JMP       @@ReleaseHMA_End
@@ReleaseHMA_EndBlock:
   MOV       BYTE PTR ES:[DI+11], 00h
@@ReleaseHMA_End:
   macro_ExitCode  0
ReleaseHMA  ENDP

