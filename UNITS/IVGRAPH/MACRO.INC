False      EQU  0
True       EQU  1


LoadData   Macro
             PUSH  AX
             MOV   AX,SEG DATA
             MOV   DS,AX
             POP   AX
           endm
BitinAL    Macro reg16,Immed
            BT   reg16,Immed
            SETC AL
           endm

StackFrame Macro reg16
           MOV   reg16,SP
           endm


SaveDS     Macro reg16
            MOV   reg16,DS
           endm

RestoreDS  Macro reg16
            MOV   DS,reg16
           endm

Multiplex  EQU  2Fh

BooleanAl  Macro Bool
           LOCAL AlOk
           LOCAL Zerook
            cmp Bool,0
            je  Zerook
            mov al,1
            jmp Alok
     Zerook:
            Zero al
       ALok:
           endm

EmsCall Macro EmsFunction
         mov  ah,EmsFunction
         int  67h
         mov  EmsError,ah
        endm

KbdCall Macro KbdFunction
         mov   ah,KbdFunction
         int   16h
        endm

StackFrameBP Macro
              push bp
              mov  bp,sp
             endm

ExitCode Macro Count
          mov  sp,bp
          pop  bp
          ret  Count
         endm

Zero     Macro reg
          xor  Reg,Reg
         endm