INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC SwapB,SwapW,SwapP,Swap
      PUBLIC BitofW,BitofB,SearchPtr
      PUBLIC FillByte,FillWord,MovePtr

      
MovePtr PROC FAR
Size    EQU  (WORD  PTR [BP+14])
Dest    EQU  (DWORD PTR [BP+10])
Source  EQU  (DWORD PTR [BP+6])
         StackFrameBP
         push      ds
         mov       cx,Size
         les       di,Dest
         lds       si,Source
         cld
         shr       cx,1
         rep       movsw
         adc       cx,cx
         rep       movsb
         pop       ds
         ExitCode  10
MovePtr ENDP

SearchPtr PROC FAR
Buffer    EQU  (DWORD PTR [BP+14])
Count     EQU  (WORD  PTR [BP+12])
Buff      EQU  (DWORD PTR [BP+8])
BuffSize  EQU  (WORD  PTR [BP+6])
           StackFrameBP
           push      ds
           les       di,Buffer
           mov       bx,di
           mov       cx,Count
           mov       dx,BuffSize
           test      dx,dx
           jz        @5
           lds       si,Buff
           Lodsb
           dec       dx
           sub       cx,dx
        @1:
           repne     Scasb
           jne       @5
           test      dx,dx
           jz        @4
           push      cx
           push      di
           push      si
           mov       cx,dx
           repe      cmpsb
           pop       si
           pop       di
           pop       cx
           jne       @1
       @4:
           dec       di
           mov       ax,di
           sub       ax,bx
           mov       dx,es
           jmp       @6
       @5:
           mov       ax,0
           mov       dx,0
       @6:
           pop       ds
           ExitCode  12
SearchPtr ENDP


FillByte PROC FAR
Count    EQU  (WORD  PTR [BP+12])
B        EQU  (BYTE  PTR [BP+10])
Dest     EQU  (DWORD PTR [BP+6])
          StackFrameBP
          les       di,Dest
          mov       cx,Count
          mov       al,B
          mov       ah,al
          cld
          shr       cx,1
          rep       stosw
          adc       cx,cx
          rep       stosb
          ExitCode 8
FillByte ENDP


FillWord PROC FAR
Count    EQU  (WORD  PTR [BP+12])
W        EQU  (WORD  PTR [BP+10])
Dest     EQU  (DWORD PTR [BP+06])
          StackFrameBP
          les      di,Dest
          mov      cx,Count
          mov      ax,W
          cld
          rep      stosw
          ExitCode 4
FillWord ENDP


Swap  PROC FAR
Size   EQU  (WORD  PTR [BP+14])
Dest   EQU  (DWORD PTR [BP+10])
Source EQU  (DWORD PTR [BP+6])
        StackFrameBP
        push      ds
        les       di,Dest
        lds       si,Source
        mov       cx,Size
        cmp       cx,0
        je        Err
        shr       cx,1
        jnc       Loop1
        mov       al,BYTE PTR es:[di]
        xchg      al,BYTE PTR ds:[si]
        mov       BYTE PTR es:[di],al
        Inc       di
        Inc       si
  Loop1:
        mov       ax,WORD PTR es:[di]
        xchg      ax,WORD PTR ds:[si]
        mov       WORD PTR es:[di],ax
        add       si,2
        add       di,2
        Loop      Loop1
    Err:
        pop       ds
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
       ExitCode 0
SwapP ENDP


SwapB PROC FAR
X     EQU  (BYTE PTR [BP+8])
Y     EQU  (BYTE PTR [BP+6])
       StackFrameBP
       mov       al,X
       Xchg      al,Y
       mov       X,al
       ExitCode  0
SwapB ENDP


SwapW PROC FAR
X     EQU  (WORD PTR [BP+8])
Y     EQU  (WORD PTR [BP+6])
       StackFrameBP
       mov       ax,X
       Xchg      ax,Y
       mov       X,ax
       ExitCode  0
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


ProcessorT DB ?






CODE  ENDS

      END