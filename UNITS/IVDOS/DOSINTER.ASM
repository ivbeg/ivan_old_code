INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN   Error   : BYTE

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC DosError,DosIo

DosIo    PROC NEAR
          int  21h
          Call DosError
          ret
DosIo    ENDP

DosError PROC NEAR
          jnc ErrLoc
          mov Error,al
  Errloc:
          ret
DosError ENDP


CODE  ENDS

      END