
Multiplex  EQU  2Fh

EmsCall Macro EmsFunction
         mov  ah,EmsFunction
         int  67h
         mov  EmsError,ah
        endm

KbdCall Macro KbdFunction
         mov   ah,KbdFunction
         int   16h
        endm
        
DosCall Macro DosFunction
         mov   ah,DosFunction
         int   21h
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