INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN   Error   : BYTE
      EXTRN   DosIO   : NEAR

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC DosWriteStr,DosWriteChar,DosReadChar
      PUBLIC DosWritePrnChar,DosWriteAuxChar,DosReadAuxChar
      PUBLIC DosBuffInput

DosWriteStr PROC FAR
DosString   EQU  (DWORD PTR [BP+6])
             StackFrameBP
             push      ds
             lds       dx,DosString
             Inc       dx
             mov       ah,09h
             Call      DosIo
             pop       ds
             ExitCode 4
DosWriteStr ENDP


WriteChar PROC NEAR
CharCode        EQU  (BYTE PTR [BP+8])
                 StackFrameBP
                 mov       dl,CharCode
                 Call      DosIo
                 ExitCode  0
WriteChar ENDP


DosWriteChar PROC FAR
                 mov       ah,2
                 Call      WriteChar
                 ret       2
DosWriteChar ENDP


DosReadChar PROC FAR
EchoChar    EQU  (BYTE PTR [BP+6])
             StackFrameBP
             mov  ah,0
             cmp  EchoChar,0
             je   AL0
             mov  ah,7
         AL0:
             Call DosIo
             ExitCode 2
DosReadChar ENDP


DosWritePrnChar PROC FAR
                 mov       ah,5h
                 Call      WriteChar
                 ret       2
DosWritePrnChar ENDP


DosWriteAuxChar PROC FAR
                 mov       ah,4h
                 Call      WriteChar
                 ret       2
DosWriteAuxChar ENDP


DosReadAuxChar PROC FAR
                mov   ah,03h
                Call  DosIO
                ret
DosReadAuxChar ENDP

DosBuffInput PROC FAR
Buffer       EQU  (DWORD PTR [BP+6])
              StackFrameBP
              push      ds
              lds       dx,Buffer
              mov       ah,0Ah
              Call      DosIO
              pop       ds
              ExitCode 0
DosBuffInput ENDP

CODE  ENDS

      END