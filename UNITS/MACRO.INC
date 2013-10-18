False      EQU  0
True       EQU  1

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
            Zero al
            cmp Bool,0
            je  AlOk
            mov al,1
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