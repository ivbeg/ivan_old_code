INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN   Error   : BYTE
      EXTRN   DosIo   : NEAR

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC MakeDir,RemDir,ChangeDir

Directory  EQU  (DWORD PTR [BP+6])

DirControl PROC NEAR
            push      ds
            lds       dx,Directory
            Call      DosIo
            Pop       ds
            retn
DirControl ENDP

MakeDir    PROC FAR
            StackFrameBP
            mov       ah,39h
            Call      DirControl
            ExitCode   4
MakeDir    ENDP


ChangeDir  PROC FAR
            StackFrameBP
            mov       ah,3Bh
            Call      DirControl
            ExitCode   4
ChangeDir  ENDP


RemDir     PROC FAR
            StackFrameBP
            mov       ah,3Ah
            Call      DirControl
            ExitCode   4
RemDir     ENDP


CODE  ENDS

      END