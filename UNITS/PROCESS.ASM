INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN   Error     : BYTE
      EXTRN   OldSS     : WORD
      EXTRN   OldSP     : WORD
      EXTRN   PrefixSeg : WORD
      EXTRN   ExecBlock : DWORD
      EXTRN   DosIO     : NEAR

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC Keep,GetExitCode

Keep  PROC FAR
ECode EQU (BYTE PTR [BP+6])
       StackFrameBP
       mov  ax,PrefixSeg
       mov  es,ax
       mov  dx,Word Ptr es:2
       sub  dx,ax
       mov  al,Ecode
       mov  ah,31h
       Call DosIo
       ExitCode 2
Keep  ENDP

GetExitCode PROC FAR
             mov  ah,4Dh
             Call DosIo
             ret
GetExitCode ENDP

CODE  ENDS

      END
