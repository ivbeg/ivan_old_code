False      EQU  0
True       EQU  1


Multiplex  EQU  2Fh

Shift      Macro Dest,Source
            mov  cl,Source
            Shr  dest,Source
           endm

MouseCall  Macro MouseFunction
            mov  ax,MouseFunction
            int  33h
           endm

BooleanAl  Macro Boolean
            mov al,Boolean
            and al,01h
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