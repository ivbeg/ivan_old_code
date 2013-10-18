INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN   Error   : BYTE
      EXTRN   DosIo   : NEAR

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC GetCurrentDrive,SetCurrentDrive,GetBootDrive
      PUBLIC FlushDiskBuff,DisableDrive,EnAbleDrive
      PUBLIC DosReadSector,DosWriteSector
      PUBLIC DiskFree,DiskTotal

GetCurrentDrive PROC FAR
                 mov   ah,19h
                 Call  DosIo
                 ret
GetCurrentDrive ENDP


SetCurrentDrive PROC FAR
Drive           EQU  (BYTE PTR [BP+6])
                 StackFrameBP
                 mov     al,Drive
                 mov     ah,0Eh
                 Call    DosIo
                 ExitCode 2
SetCurrentDrive ENDP


GetBootDrive PROC FAR
              mov     ax,3305h
              Call    DosIo
              ret
GetBootDrive ENDP


FlushDiskBuff PROC FAR
               mov  ah,0Dh
               Call DosIo
               ret
FlushDiskBuff ENDP

EnableDrive  PROC FAR
              mov al,07h
              jmp Activate
DisableDrive PROC FAR
Drive           EQU  (BYTE PTR [BP+6])
                 StackFrameBP
                 mov     al,08h
        Activate:
                 mov     dl,Drive
                 mov     ah,5Fh
                 Call    DosIo
                 ExitCode 2
DisableDrive ENDP
EnableDrive ENDP

DosReadSector PROC FAR
Drive         EQU (BYTE  PTR [BP+10])
ControlPacket EQU (DWORD PTR [BP+6])
              StackFrameBp
              push    ds
              lds     bx,ControlPacket
              mov     al,Drive
              int     26h
              pop     ds
              ExitCode 6
DosReadSector ENDP


DosWriteSector PROC FAR
Drive          EQU (BYTE  PTR [BP+10])
ControlPacket  EQU (DWORD PTR [BP+6])
              StackFrameBP
              push      ds
              lds       bx,ControlPacket
              mov       al,Drive
              int       25h
              pop       ds
              ExitCode  6
DosWriteSector ENDP


DiskFree  PROC NEAR
Drive     EQU  (BYTE PTR [BP+6])
           StackFrameBP
           mov       dl,Drive
           mov       ah,36h
           Call      DosIo
           mul       cx
           mul       bx
           ExitCode  2
DiskFree  ENDP


DiskTotal PROC FAR
Drive     EQU  (BYTE PTR [BP+6])
           StackFrameBP
           mov       dl,Drive
           mov       ah,36h
           Call      DosIo
           mov       bx,dx
           mul       cx
           mul       bx
           ExitCode  2
DiskTotal ENDP

CODE  ENDS

      END