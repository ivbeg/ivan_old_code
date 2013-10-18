INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA


DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC ShowMouse,HideMouse,MouseXY
      PUBLIC SetLimitX,SetLimitY,GetMouseStatus
      PUBLIC GetMouseX,GetMouseY,LightPenEmulation
      PUBLIC CentralButton,LeftButton,RightButton
      PUBLIC GetButtonPressed,DisableCursorDisplay,
      PUBLIC SetDoubleSpeedThreshold,SetUserMaskCall
      PUBLIC GetMotionCount,SetSensitivity,SetGraphCursor
      PUBLIC SetTextHardCursor,SetTextSoftCursor,GetButtonRelease

ShowMouse PROC FAR
           MouseCall 01h
           ret
ShowMouse ENDP


HideMouse PROC FAR
           MouseCall 02h
           ret
HideMouse ENDP


SetLimitY PROC FAR
Max       EQU  (WORD PTR [BP+8])
Min       EQU  (WORD PTR [BP+6])
           StackFrameBP
           mov       dx,Min
           mov       cx,Max
           MouseCall 08h
           ExitCode  4
SetLimitY ENDP


SetLimitX PROC FAR
Max       EQU  (WORD PTR [BP+8])
Min       EQU  (WORD PTR [BP+6])
           StackFrameBP
           mov       dx,Min
           mov       cx,Max
           MouseCall 07h
           ExitCode  4
SetLimitX ENDP


GetMouseX PROC FAR
           MouseCall 03h
           mov       ax,cx
           ret
GetMouseX ENDP


GetMouseY PROC FAR
           MouseCall 03h
           mov       ax,dx
           ret
GetMouseY ENDP


GetMouseStatus PROC FAR
Y              EQU  (DWORD PTR [BP+14])
X              EQU  (DWORD PTR [BP+10])
Buttons        EQU  (DWORD PTR [BP+6])
                StackFrameBP
                MouseCall 03h
                les       di,Buttons
                mov       es:[di],bx
                les       di,X
                mov       es:[di],cx
                les       di,Y
                mov       es:[di],dx
                ExitCode  0
GetMouseStatus ENDP


MouseXY PROC FAR
Y       EQU  (WORD PTR [BP+6])
X       EQU  (WORD PTR [BP+8])
         StackFrameBP
         mov   cx,X
         mov   dx,Y
         MouseCall 04h
         ExitCode 4
MouseXY ENDP


LightPenEmulation PROC FAR
B                 EQU  (BYTE PTR [BP+6])
                   StackFrameBP
                   mov  ax,0Eh
                   add  al,B
                   MouseCall ax
                   ExitCode 2
LightPenEmulation ENDP


CentralButton PROC FAR
               MouseCall 03h
               shr       bl,1
               shr       bl,1
               BooleanAl bl
               ret
CentralButton ENDP


LeftButton PROC FAR
            MouseCall 03h
            BooleanAl bl
            ret
LeftButton ENDP


RightButton PROC FAR
             MouseCall 03h
             shr       bl,1
             BooleanAl bl
             ret
RightButton ENDP


GetButtonPressed PROC FAR
Button            EQU  (WORD  PTR [BP+10])
Info              EQU  (DWORD PTR [BP+6])
                   StackFrameBP
                   mov        bx,Button
                   MouseCall  05h
                   les        di,Info
                   mov        es:[di],ax
                   mov        es:[di+2],bx
                   mov        es:[di+4],cx
                   mov        es:[di+6],dx
                   ExitCode   2
GetButtonPressed ENDP

GetButtonRelease PROC FAR
Button           EQU  (WORD  PTR [BP+10])
Info             EQU  (DWORD PTR [BP+6])
                  StackFrameBP
                  mov        bx,Button
                  MouseCall  06h
                  les        di,Info
                  mov        es:[di],ax
                  mov        es:[di+2],bx
                  mov        es:[di+4],cx
                  mov        es:[di+6],dx
                  ExitCode   2
GetButtonRelease ENDP

DisableCursorDisplay PROC FAR
UpperX               EQU  (BYTE PTR [BP+12])
UpperY               EQU  (BYTE PTR [BP+10])
LowerX               EQU  (BYTE PTR [BP+8])
LowerY               EQU  (BYTE PTR [BP+6])
                      StackFrameBP
                      mov       bh,UpperX
                      mov       ch,UpperY
                      mov       bl,LowerX
                      mov       cl,LowerY
                      MouseCall 12h
                      ExitCode 8
DisableCursorDisplay ENDP


SetDoubleSpeedThreshold PROC FAR
DoubleSpeed             EQU  (WORD PTR [BP+6])
                         StackFrameBP
                         mov       dx,DoubleSpeed
                         MouseCall 13h
                         ExitCode 2
SetDoubleSpeedThreshold ENDP


SetTextHardCursor PROC FAR
StartScanLine     EQU  (WORD PTR [BP+8])
EndScanLine       EQU  (WORD PTR [BP+6])
                   StackFrameBP
                   mov  bx,1
                   mov  cx,StartScanLine
                   mov  dx,EndScanLine
                   MouseCall 0Ah
                   ExitCode 4
SetTextHardCursor ENDP


SetTextSoftCursor PROC FAR
ScreenMask        EQU  (WORD PTR [BP+8])
CursorMask        EQU  (WORD PTR [BP+6])
                   StackFrameBP
                   mov  bx,1
                   mov  cx,ScreenMask
                   mov  dx,CursorMask
                   MouseCall 0Ah
                   ExitCode 4
SetTextSoftCursor ENDP


SetGraphCursor PROC FAR
HotSpotX       EQU  (WORD  PTR [BP+12])
HotSpotY       EQU  (WORD  PTR [BP+10])
GraphBlock     EQU  (DWORD PTR [BP+6])
                StackFrameBP
                mov       bx,HotSpotX
                mov       cx,HotSpotY
                les       dx,GraphBlock
                MouseCall 09h
                ExitCode  4
SetGraphCursor ENDP


SetSensitivity PROC FAR
MiskeyX        EQU  (WORD PTR [BP+8])
MiskeyY        EQU  (WORD PTR [BP+6])
                StackFrameBP
                mov       cx,MiskeyX
                mov       dx,MiskeyY
                MouseCall 0Fh
                ExitCode  4
SetSensitivity ENDP


GetMotionCount PROC FAR
CountX         EQU  (DWORD PTR [BP+10])
CountY         EQU  (DWORD PTR [BP+6])
                StackFrameBP
                MouseCall 0Bh
                les       di,CountX
                mov       es:[di],cx
                les       di,CountY
                mov       es:[di],dx
                ExitCode  4
GetMotionCount ENDP

SetUserMaskCall PROC FAR
aMask           EQU  (WORD  PTR [BP+10])
UserCall        EQU  (DWORD PTR [BP+6])
                 StackFrameBP
                 mov       cx,aMask
                 Les       dx,UserCall
                 MouseCall 0Ch
                 ExitCode  6
SetUserMaskCall ENDP


CODE  ENDS

      END