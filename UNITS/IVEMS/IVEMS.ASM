
INCLUDE   MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA;

       EXTRN    EmsError      : BYTE ; Ems Functions Error
       EXTRN    IsEmm         : BYTE ; Ems Present status byte

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

         PUBLIC EmsResult,EmsVersion,PageFrame
         PUBLIC TotalEmsPages,AvailEmsPages,ActiveHandles
         PUBLIC TotalHandles,SetHandleAttr,SetHandleName
         PUBLIC GetHandleName,GetHandlePages,EmsHandleTable
         PUBLIC FreeRawPages,TotalRawPages,GetHandleAttr
         PUBLIC GetEmsHardwareInfo,MapEmsPages
         PUBLIC SaveEmsContext,RestoreEmsContext
         PUBLIC AllocateEmsPages,DeAllocateEmsPages,ReAllocateEmsPages
         PUBLIC QemmPresent,QemmHiRamSeg

EmsResult  PROC FAR
            EmsCall 40h
            mov     al,ah
EmsResult  ENDP


EmsVersion PROC FAR
            EmsCall 46h
            ret
EmsVersion ENDP


PageFrame  PROC FAR
            EmsCall 41h
            mov  ax,bx
            ret
PageFrame  ENDP

TotalEmsPages PROC FAR
               EmsCall 42h
               mov     ax,dx
               ret
TotalEmsPages ENDP

AvailEmsPages PROC FAR
               EmsCall 42h
               mov     ax,bx
               ret
AvailEmsPages ENDP


ActiveHandles PROC FAR
              EmsCall 4Bh
              mov     ax,bx
              Ret
ActiveHandles ENDP


TotalHandles  PROC FAR
              mov  al,2
              EmsCall 54h
              mov  ax,bx
              Ret
TotalHandles  ENDP


SetHandleAttr PROC FAR
Handle        EQU (WORD PTR [BP+8]) ;Parameters
Attr          EQU (BYTE PTR [BP+6])
               StackFrameBP
               mov       al,01h
               mov       bl,Attr
               mov       dx,Handle
               EmsCall   52h
               ExitCode 4
SetHandleAttr ENDP


SetHandleName PROC FAR
Handle        EQU (WORD  PTR [BP+10]) ;Parameters
EmsName       EQU (DWORD PTR [BP+6])
               StackFrameBP           ;Set up stack
               push  ds               ;Save ds
               lds   si,EmsName       ;Load name of handle
               mov   dx,Handle        ;Load handle
               mov   al,01h           ;al = 'SetHandleName' Function
               EmsCall 53h            ;Call Int 67h
               pop   ds               ;Restore ds
               ExitCode 6             ;Return
SetHandleName ENDP


GetHandleName PROC FAR
EmsName       EQU (DWORD PTR [BP+8]) ;Parameters
Handle        EQU (WORD PTR  [BP+6])
               StackFrameBP
               les  di,EmsName
               mov  byte ptr es:[di],8
               inc  di
               mov  al,0
               mov  dx,Handle
               EmsCall 53h
               ExitCode 2
GetHandleName ENDP


GetHandlePages PROC FAR
Handle         EQU (WORD PTR [BP+6]) ;Parameters
                StackFrameBP
                mov  dx,Handle
                EmsCall 4Ch
                mov  ax,bx
                ExitCode 2
GetHandlePages ENDP


EmsHandleTable PROC FAR
Table          EQU  (DWORD PTR [BP+6]) ;Parameters
                StackFrameBP
                les       di,Table
                EmsCall   4Dh
                mov       ax,dx
                ExitCode  0
EmsHandleTable ENDP

FreeRawPages  PROC FAR
               mov     al,01h
               EmsCall 59h
               mov     ax,bx
               ret
FreeRawPages  ENDP

TotalRawPages PROC FAR
               mov     al,01h
               EmsCall 59h
               mov     ax,dx
               ret
TotalRawPages ENDP

GetEmsHardwareInfo PROC FAR
Table              EQU  (DWORD PTR [BP+6]) ;Parameters
                    StackFrameBP
                    les       di,Table
                    mov       al,0
                    EmsCall   59h
                    ExitCode  0
GetEmsHardwareInfo ENDP


MapEmsPages PROC FAR
Handle       EQU (WORD PTR [BP+10])
LogicalPage  EQU (WORD PTR [BP+8])
PhisicalPage EQU (BYTE PTR [BP+6])
                    StackFrameBP
                    mov       al,PhisicalPage
                    and       al,3
                    mov       bx,LogicalPage
                    mov       dx,Handle
                    EmsCall   44h
                    ExitCode  6
MapEmsPages ENDP


SaveEmsContext PROC FAR
Handle       EQU (WORD PTR [BP+6])
              StackFrameBP
              mov dx,Handle
              EmsCall 47h
              ExitCode 2
SaveEmsContext ENDP


RestoreEmsContext PROC FAR
Handle       EQU (WORD PTR [BP+6])
              StackFrameBP
              mov       dx,Handle
              EmsCall   48h
              ExitCode  2
RestoreEmsContext ENDP


GetHandleAttr PROC FAR
Handle        EQU  (WORD PTR [BP+6])
              StackFrameBP
              mov       dx,Handle
              mov       al,00h
              EmsCall   52h
              ExitCode  2
GetHandleAttr     ENDP

AllocateEmsPages   PROC FAR
Pages               EQU (WORD PTR [BP+10])
Handle              EQU (DWORD PTR [BP+6])
                     StackFrameBP
                     mov       bx,Pages
                     EmsCall   43h
                     les       di,Handle
                     mov       es:[di],dx
                     ExitCode  2
AllocateEmsPages   ENDP

DeAllocateEmsPages PROC FAR
Handle              EQU (WORD PTR [BP+6])
                     StackFrameBP
                     mov       dx,Handle
                     EmsCall   45h
                     ExitCode  2
DeAllocateEmsPages ENDP

ReAllocateEmsPages PROC FAR
Handle              EQU (WORD PTR [BP+12])
Pages               EQU (WORD PTR [BP+10])
Result              EQU (DWORD PTR [BP+6])
                     StackFrameBP
                     mov      dx,Handle
                     mov      bx,Pages
                     EmsCall  43h
                     les      di,Result
                     mov      es:[di],bx
                     ExitCode  4
ReAllocateEmsPages ENDP


QemmPresent PROC FAR
             mov   ax,0d201h
             mov   bx,5145h
             mov   cx,4D4Dh
             mov   dx,3432h
             Int   2Fh
             Zero  al
             Cmp   bx,4F4Bh
             jne   QemmDone
             Inc   al
    QemmDone:
             ret
QemmPresent ENDP


QemmHiRamSeg PROC FAR
             mov   ax,0d201h
             mov   bx,4849h
             mov   cx,5241h
             mov   dx,4d30h
             Int   2Fh
             mov   ax,cx
             ret
QemmHiRamSeg  ENDP


CODE ENDS

     END

