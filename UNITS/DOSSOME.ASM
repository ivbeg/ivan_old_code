INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA

      EXTRN   Error     : BYTE
      EXTRN   DosVer    : WORD
      EXTRN   DosIO     : NEAR
DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC GetTime,SetTime,GetDate,SetDate
      PUBLIC GetSwitchChar,SetSwitchChar,GetDosVersion
      PUBLIC GetBreakFlag,SetBreakFlag,GetVerifyFlag
      PUBLIC SetVerifyFlag,GetDtaAddr,SetDtaAddr
      PUBLIC GetIntVector,SetIntVector,CheckKbd

GetTime PROC FAR
Time    EQU  (DWORD PTR [BP+6])
         StackFrameBP
         Push      ds
         mov       ah,2Ch
         Call      DosIo
         lds       di,Time
         mov       WORD PTR es:[di],dx
         mov       WORD PTR es:[di+2],dx
         Pop       ds
         ExitCode  0
GetTime ENDP


SetTime PROC FAR
Time    EQU  (DWORD PTR [BP+6])
         StackFrameBP
         Push      ds
         lds       di,Time
         mov       cx,WORD PTR es:[di]
         mov       dx,WORD PTR es:[di+2]
         mov       ah,2Dh
         Call      DosIo
         Pop       ds
         ExitCode  4
SetTime ENDP


GetDate PROC FAR
Date    EQU  (DWORD PTR [BP+6])
         StackFrameBP
         Push      ds
         mov       ah,2Ah
         Call      DosIO
         lds       di,Date
         mov       WORD PTR es:[di],dx
         mov       WORD PTR es:[di+2],dx
         Pop       ds
         ExitCode  0
GetDate ENDP


SetDate PROC FAR
Date    EQU  (DWORD PTR [BP+6])
         StackFrameBP
         Push      ds
         lds       di,Date
         mov       cx,WORD PTR es:[di]
         mov       dx,WORD PTR es:[di+2]
         mov       ah,2Bh
         Call      DosIo
         Pop       ds
         ExitCode  4
SetDate ENDP


SetSwitchChar PROC FAR
CharCode      EQU  (BYTE PTR [BP+6])
               StackFrameBP
               mov       ax,3701h
               mov       dl,CharCode
               Call      DosIo
               ExitCode 2
SetSwitchChar ENDP


GetSwitchChar PROC FAR
               mov     ax,3700h
               Call    DosIo
               mov     al,dl
               ret
GetSwitchChar ENDP


GetDosVersion PROC FAR
               mov     ah,30h
               Call    DosIo
               xchg    al,ah
               mov     DosVer,ax
               ret
GetDosVersion ENDP


GetVerifyFlag PROC FAR
               mov     ah,54h
               Call    DosIo
               ret
GetVerifyFlag ENDP


SetVerifyFlag PROC FAR
Flag           EQU (BYTE PTR [BP+6])
               StackFrameBP
               mov     al,Flag
               mov     ah,5Eh
               Call    DosIo
               ExitCode 2
SetVerifyFlag ENDP


SetDTAAddr PROC FAR
Flag       EQU  (DWORD PTR [BP+6])
            StackFrameBP
            push    ds
            lds     dx,Flag
            mov     ah,1Ah
            Call    DosIo
            Pop     ds
            ExitCode 4
SetDTAAddr ENDP


GetDTAAddr PROC FAR
            mov     ah,2Fh
            Call    DosIo
            mov     dx,es
            mov     ax,bx
            ret
GetDTAAddr ENDP


SetBreakFlag PROC FAR
Flag           EQU (BYTE PTR [BP+6])
               StackFrameBP
               mov       dl,Flag
               mov       ax,3301h
               Call      DosIo
               ExitCode  2
SetBreakFlag ENDP


GetBreakFlag PROC FAR
               mov       ax,3300h
               Call      DosIo
               mov       al,dl
               ret
GetBreakFlag ENDP


GetIntVector PROC FAR
Inter        EQU  (BYTE PTR [BP+6])
              StackFrameBP
              mov      al,Inter
              mov      ah,35h
              Call     DosIo
              mov      dx,es
              mov      ax,bx
              ExitCode 2
GetIntVector ENDP


SetIntVector PROC FAR
Inter        EQU  (BYTE  PTR [BP+10])
Pointer      EQU  (DWORD PTR [BP+6])
              StackFrameBP
              push     ds
              mov      al,Inter
              lds      dx,Pointer
              mov      ah,25h
              Call     DosIo
              pop      ds
              ExitCode 6
SetIntVector ENDP


CheckKbd PROC FAR
          mov    ah,0Bh
          Call   DosIo
          BooleanAl al
          ret
CheckKbd ENDP


CODE  ENDS

      END