INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN   Error    : BYTE
      EXTRN   OpenMode : BYTE
      EXTRN   DosIO    : NEAR
      EXTRN   ReWriteF : BYTE

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC OpenFile,CreateFile,DeleteFile
      PUBLIC FflushFile,SetHandlesCount,DupHandle
      PUBLIC ForceDupHandle,RenameFile,CloseFile
      PUBLIC GetFileAttr,SetFileAttr,SetFileTimeDate
      PUBLIC GetFileTime,GetFileDate,SeekFile
      PUBLIC WriteFile,WriteFilePtr,ReadFile,ReadFilePtr
      PUBLIC InputStatus,OutputStatus,HandleRemote,GetHandleAttr,SetHandleAttr
      PUBLIC IoWriteBuff,IoWriteBuffPtr,IoReadBuff,IoReadBuffPtr

OpenFile PROC FAR
FileName EQU  (DWORD PTR [BP+10])
Handle   EQU  (DWORD PTR [BP+6])
          StackFrameBP
          push      ds
          lds       dx,FileName
          mov       al,OpenMode
          mov       ah,3Dh
          Call      DosIO
          les       di,Handle
          mov       WORD PTR es:[di],ax
          pop       ds
          ExitCode  4
OpenFile ENDP

CreateFile PROC FAR
FileName   EQU  (DWORD PTR [BP+12])
Attr       EQU  (WORD  PTR [BP+10])
Handle     EQU  (DWORD PTR [BP+6])
            StackFrameBP
            Push      ds
            mov       ah,05Bh
            cmp       ReWriteF,0
            je        @9
            sub       ah,01Fh
       @9:
            lds       dx,FileName
            mov       cx,Attr
            Call      DosIo
            les       di,Handle
            mov       WORD PTR es:[di],ax
            Pop       ds
            ExitCode  10
CreateFile ENDP


FFlushFile PROC FAR
Handle     EQU  (WORD PTR [BP+6])
            StackFrameBP
            mov       bx,Handle
            mov       ah,68h
            Call      DosIo
            ExitCode  2
FFlushFile ENDP

SetHandlesCount PROC FAR
Num             EQU  (WORD PTR [BP+6])
                 StackFrameBP
                 mov       bx,Num
                 mov       ah,67h
                 Call      DosIo
                 ExitCode  2
SetHandlesCount ENDP

DupHandle PROC FAR
           mov    ah,45h
           jmp    MainBlock
ForceDupHandle PROC FAR
Handle1        EQU  (WORD PTR [BP+8])
Handle2        EQU  (WORD PTR [BP+6])
                 mov       ah,46h
            MainBlock:
                 StackFrameBP
                 mov       bx,Handle1
                 mov       cx,Handle2
                 Call      DosIo
                 ExitCode  4
ForceDupHandle ENDP
DupHandle ENDP


DeleteFile PROC FAR
FileName   EQU  (DWORD PTR [BP+6])
            StackFrameBP
            push      ds
            mov       ah,41h
            Call      DosIo
            ExitCode  4
DeleteFile ENDP


CloseFile PROC FAR
Handle    EQU  (WORD PTR [BP+6])
           StackFrameBP
           mov       bx,Handle
           mov       ah,3Eh
           Call      DosIo
           ExitCode  2
CloseFile ENDP


RenameFile PROC FAR
Name1      EQU  (DWORD PTR [BP+10])
Name2      EQU  (DWORD PTR [BP+6])
            StackFrameBP
            push      ds
            lds       dx,Name1
            les       si,Name2
            mov       ah,56h
            Call      DosIo
            pop       ds
            ExitCode  8
RenameFile ENDP


GetFileAttr PROC FAR
FileName    EQU  (DWORD PTR [BP+6])
             StackFrameBP
             push      ds
             lds       dx,FileName
             mov       ax,4300h
             Call      DosIo
             pop       ds
             ExitCode  4
GetFileAttr ENDP


SetFileAttr PROC FAR
FileName    EQU  (DWORD PTR [BP+8])
Attr        EQU  (WORD  PTR [BP+6])
             StackFrameBP
             push      ds
             lds       dx,FileName
             mov       cx,Attr
             mov       ax,4301h
             Call      DosIo
             pop       ds
             ExitCode  6
SetFileAttr ENDP


SetFileTimeDate PROC FAR
Handle          EQU  (WORD PTR [BP+10])
Time            EQU  (WORD PTR [BP+8])
Date            EQU  (WORD PTR [BP+6])
                 StackFrameBP
                 mov       bx,Handle
                 mov       cx,Time
                 mov       dx,Date
                 mov       ax,5701h
                 Call      DosIo
                 ExitCode  6
SetFileTimeDate ENDP


GetFileDate PROC FAR
Handle      EQU  (WORD PTR [BP+6])
             StackFrameBP
             mov       bx,Handle
             mov       ax,5700h
             Call      DosIO
             mov       ax,dx
             ExitCode  2
GetFileDate ENDP


GetFileTime PROC FAR
Handle      EQU  (WORD PTR [BP+6])
             StackFrameBP
             mov       bx,Handle
             mov       ax,5700h
             Call      DosIo
             mov       ax,dx
             ExitCode  2
GetFileTime ENDP

WriteFilePtr PROC NEAR
WriteFile    PROC NEAR
              mov ah,40h
              jmp Main
ReadFilePtr  PROC NEAR
ReadFile     PROC NEAR
Handle       EQU  (WORD  PTR [BP+16])
Buffer       EQU  (DWORD PTR [BP+12])
Count        EQU  (WORD  PTR [BP+10])
Result       EQU  (DWORD PTR [BP+6])
              mov ah,3Fh
         Main:
              StackFrameBP
              push      ds
              mov       bx,Handle
              mov       cx,Count
              lds       dx,Buffer
              Call      DosIO
              les       di,Result
              mov       WORD PTR es:[di],ax
              pop       ds
              ExitCode  12
ReadFile     ENDP
ReadFilePtr  ENDP

WriteFile    ENDP
WriteFilePtr ENDP


SeekFile PROC FAR
Handle   EQU  (WORD  PTR [BP+10])
SeekPos  EQU  (DWORD PTR [BP+6])
          StackFrameBP
          mov       bx,Handle
          les       dx,SeekPos
          mov       cx,es
          mov       ah,42h
          Call      DosIo
          ExitCode  6
SeekFile ENDP


HandleIO PROC NEAR
Handle   EQU  (WORD PTR [BP+8])
          StackFrameBP
          mov       bx,Handle
          mov       ah,44h
          Call      DosIO
          ExitCode  0
HandleIO ENDP


InputStatus PROC FAR
              mov       al,06h
              Call      HandleIo
              BooleanAl al
              ret       2
InputStatus ENDP


OutputStatus PROC FAR
              mov       al,07h
              Call      HandleIo
              BooleanAl al
              ret       2
OutputStatus ENDP


HandleRemote PROC FAR
              mov       al,0Ah
              Call      HandleIo
              and       dx,01000000b
              BooleanAL dx
              ret       2
HandleRemote ENDP


GetHandleAttr PROC FAR
               xchg      al,al
               Call      HandleIo
               mov       ax,dx
GetHandleAttr ENDP

IoReadBuffPtr  PROC FAR
IoReadBuff     PROC FAR
                mov       al,02h
                jmp       Loc1
IoWriteBuffPtr PROC FAR
IoWriteBuff    PROC FAR
Handle         EQU  (WORD  PTR [BP+16])
Buffer         EQU  (DWORD PTR [BP+12])
Count          EQU  (WORD  PTR [BP+10])
Result         EQU  (DWORD PTR [BP+6])
                mov       al,03h
            Loc1:
                StackFrameBP
                push      ds
                mov       ah,44h
                mov       bx,Handle
                lds       dx,Buffer
                mov       cx,Count
                Call      DosIO
                les       di,Result
                mov       WORD PTR es:[di],ax
                pop       ds
                ExitCode  12
IoWriteBuff    ENDP
IoWriteBuffPtr ENDP

IoReadBuff     ENDP
IoReadBuffPtr  ENDP


SetHandleAttr PROC FAR
Handle        EQU  (WORD PTR [BP+8])
Attr          EQU  (WORD PTR [BP+6])
               StackFrameBP
               mov       ax,4401h
               mov       bx,Handle
               mov       dx,Attr
               Call      DosIO
               ExitCode  4
SetHandleAttr ENDP

CODE  ENDS

      END