INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN   DosResult : BYTE

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC DosError,DosIo

DosIo    PROC NEAR
          INT  21h
          CALL DosError
          RET
DosIo    ENDP

DosError PROC NEAR
          MOV DosResult,0
          JNC ErrLoc
          MOV DosResult,AL
  Errloc:
          RET
DosError ENDP


CODE  ENDS

      END