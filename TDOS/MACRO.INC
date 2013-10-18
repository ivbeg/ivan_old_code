caNoCalls                EQU  00h

mcSetDATA_GS MACRO
  PUSH  SEG DATA
  POP   GS
ENDM


TFunctionResult STRUC
   Interrupt        DB 00h
   CalledAddr       DD 00000000h
   Result           DW 0000h
   ErrorProc        DD 00000000h
ENDS


FALSE      EQU  0
TRUE       EQU  1

mcStackFrame MACRO reg16
           MOV   reg16,SP
             ENDM


SaveDS     MACRO reg16
            MOV   reg16,DS
           ENDM

RestoreDS  MACRO reg16
            MOV   DS,reg16
           ENDM

Multiplex  EQU  2Fh

BooleanAl  MACRO Bool
           LOCAL AlOk
            Zero al
            cmp Bool,0
            je  AlOk
            mov al,1
      ALok:
           ENDM

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