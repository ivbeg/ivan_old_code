INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN   Error      : BYTE
      EXTRN   PrefixSeg  : WORD
      EXTRN   DosIo      : NEAR

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC  AllocateMemory,FreeMemory,ReSizeMemory
      PUBLIC  SetUmbLinkState,GetUmbLinkState,DosMaxMem
      PUBLIC  SetAllocStrat,GetAllocStrat

AllocateMemory PROC FAR
Size           EQU (WORD PTR [BP+6])
                StackFrameBP
                mov       bx,Size
                mov       ah,48h
                Call      DosIo
                ExitCode 2
AllocateMemory ENDP


FreeMemory PROC FAR
Segm        EQU (WORD PTR [BP+6])
             StackFrameBP
             mov       es,Segm
             mov       ah,49h
             Call      DosIo
             ExitCode 2
FreeMemory ENDP



ReSizeMemory PROC FAR
Segm        EQU (WORD PTR [BP+8])
Size        EQU (WORD PTR [BP+6])
             StackFrameBP
             mov       es,Segm
             mov       bx,Size
             mov       ah,4Ah
             Call      DosIo
             ExitCode 4
ReSizeMemory ENDP

SetUmbLinkState PROC FAR
State           EQU  (BYTE PTR [BP+6])
                 StackFrameBP
                 mov       bh,0
                 mov       bl,State
                 mov       ax,05803h
                 Call      DosIo
                 ExitCode  2
SetUmbLinkState ENDP


GetUmbLinkState PROC FAR
                 mov   ax,05802h
                 Call  DosIo
                 ret
GetUmbLinkState ENDP


DosMaxMem PROC FAR
           mov     bx,0FFFFh
           mov     ah,48h
           Call    DosIo
           mov     ax,bx
           mov     bx,16
           mul     bx
           ret
DosMaxMem ENDP

SetAllocStrat PROC FAR
Alloc         EQU  (BYTE PTR [BP+6])
               StackFrameBP
               mov       bl,Alloc
               mov       ax,5801h
               Call      DosIo
               ExitCode  2
SetAllocStrat ENDP


GetAllocStrat PROC FAR
               mov       ax,5800h
               Call      DosIo
               ret
GetAllocStrat ENDP

CODE  ENDS

      END