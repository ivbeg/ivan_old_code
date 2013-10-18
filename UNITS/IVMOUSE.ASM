INCLUDE MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN   MouseType    :   WORD
      EXTRN   MousePresent :   BYTE
      EXTRN   MouseVersion :   WORD


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
      PUBLIC SetUserMouseHandler,InitMouse

mResetMouseDriver        EQU   00h
mShowMouse               EQU   01h
mHideMouse               EQU   02h
mGetMouseInfo            EQU   03h
mMouseXY                 EQU   04h
mGetButtonPressed        EQU   05h
mGetButtonRelease        EQU   06h
mSetLimitX               EQU   07h
mSetLimitY               EQU   08h
mSetGraphCursor          EQU   09h
mSetTextCursor           EQU   0Ah
mGetMotionCount          EQU   0Bh
mSetUserMaskCall         EQU   0Ch
mSetSensitivity          EQU   0Fh
mDisableCursorDisplay    EQU   10h
mSetDoubleSpeedThreshold EQU   13h
mSetUserMouseHandler     EQU   18h
mGetMouseVersion         EQU   06Dh


ShowMouse PROC  FAR
           MOV  AX,mShowMouse
           INT  33h
           RET
ShowMouse ENDP


HideMouse PROC FAR
           MOV  AX,mHideMouse
           INT  33h
           RET
HideMouse ENDP


SetLimitY PROC FAR
Max       EQU  SS:[BX+6]
Min       EQU  SS:[BX+4]
           StackFrame BX
           MOV       DX,Min
           MOV       CX,Max
           MOV       AX,mSetLimitY
           INT       33h
           RET       4
SetLimitY ENDP


SetLimitX PROC FAR
Max       EQU  SS:[BX+6]
Min       EQU  SS:[BX+4]
           StackFrame BX
           MOV       DX,Min
           MOV       CX,Max
           MOV       AX,mSetLimitX
           INT       33h
           RET       4
SetLimitX ENDP


GetMouseX PROC FAR
           MOV  AX,mGetMouseInfo
           INT  33h
           MOV  AX,CX
           RET
GetMouseX ENDP


GetMouseY PROC FAR
           MOV  AX,mGetMouseInfo
           INT  33h
           MOV  AX,DX
           RET
GetMouseY ENDP


GetMouseStatus PROC FAR
Y              EQU  (DWORD PTR [BP+14])
X              EQU  (DWORD PTR [BP+10])
Buttons        EQU  (DWORD PTR [BP+6])
                StackFrameBP
                MOV       AX,mGetMouseInfo
                INT       33h
                MOV       AX,CX
                LES       DI,Buttons
                MOV       ES:[DI],BX
                LES       DI,X
                MOV       ES:[DI],CX
                LES       DI,Y
                MOV       ES:[DI],DX
                RET       12
GetMouseStatus ENDP


MouseXY PROC FAR
Y       EQU  SS:[BX+6]
X       EQU  SS:[BX+4]
         StackFrame BX
         MOV        CX,X
         MOV        DX,Y
         MOV        AX,mMouseXY
         INT        33h
         RET        4
MouseXY ENDP


LightPenEmulation PROC FAR
B                 EQU  SS:[BX+4]
                   StackFrame BX
                   MOV        AL,B
                   AND        AL,1
                   CBW
                   ADD        AX,0Eh
                   INT        33h
                   RET        2
LightPenEmulation ENDP


CentralButton PROC FAR
               MOV       AX,mGetMouseInfo
               INT       33h
               SHR       BL,1
               SHR       BL,1
               BooleanAl BL
               RET
CentralButton ENDP


LeftButton PROC FAR
            MOV       AX,mGetMouseInfo
            INT       33h
            BooleanAl BL
            RET
LeftButton ENDP


RightButton PROC FAR
             MOV       AX,mGetMouseInfo
             INT       33h
             SHR       BL,1
             BooleanAl BL
             RET
RightButton ENDP


GetButtonPressed PROC FAR
Button            EQU  (WORD  PTR [BP+10])
Info              EQU  (DWORD PTR [BP+6])
                   StackFrameBP
                   MOV        BX,Button
                   MOV        AX,mGetButtonPressed
                   INT        33h
                   LES        DI,Info
                   MOV        ES:[DI],AX
                   MOV        ES:[DI+2],BX
                   MOV        ES:[DI+4],CX
                   MOV        ES:[DI+6],DX
                   ExitCode   2
GetButtonPressed ENDP


GetButtonRelease PROC FAR
Button           EQU  (WORD  PTR [BP+10])
Info             EQU  (DWORD PTR [BP+6])
                  StackFrameBP
                  MOV        BX,Button
                  MOV        AX,mGetButtonRelease
                  INT        33h
                  LES        DI,Info
                  MOV        ES:[DI],AX
                  MOV        ES:[DI+2],BX
                  MOV        ES:[DI+4],CX
                  MOV        ES:[DI+6],DX
                  ExitCode   6
GetButtonRelease ENDP

DisableCursorDisplay PROC FAR
UpperX               EQU  (BYTE PTR [BP+12])
UpperY               EQU  (BYTE PTR [BP+10])
LowerX               EQU  (BYTE PTR [BP+8])
LowerY               EQU  (BYTE PTR [BP+6])
                      StackFrameBP
                      MOV       BH,UpperX
                      MOV       CH,UpperY
                      MOV       BL,LowerX
                      MOV       CL,LowerY
                      MOV       AX,mDisableCursorDisplay
                      INT       33h
                      ExitCode 8
DisableCursorDisplay ENDP


SetDoubleSpeedThreshold PROC FAR
DoubleSpeed             EQU  SS:[BX+4]
                         StackFrame BX
                         MOV        DX,DoubleSpeed
                         MOV        AX,mSetDoubleSpeedThreshold
                         INT        33h
                         RET        2
SetDoubleSpeedThreshold ENDP


SetTextHardCursor PROC FAR
StartScanLine     EQU  (WORD PTR [BP+8])
EndScanLine       EQU  (WORD PTR [BP+6])
                   StackFrameBP
                   MOV  BX,1
                   MOV  CX,StartScanLine
                   MOV  DX,EndScanLine
                   MOV  AX,mSetTextCursor
                   INT  33h
                   ExitCode 4
SetTextHardCursor ENDP


SetTextSoftCursor PROC FAR
ScreenMask        EQU  (WORD PTR [BP+8])
CursorMask        EQU  (WORD PTR [BP+6])
                   StackFrameBP
                   MOV  BX,1
                   MOV  CX,ScreenMask
                   MOV  DX,CursorMask
                   MOV  AX,mSetTextCursor
                   INT  33h
                   ExitCode 4
SetTextSoftCursor ENDP


SetGraphCursor PROC FAR
HotSpotX       EQU  (WORD  PTR [BP+12])
HotSpotY       EQU  (WORD  PTR [BP+10])
GraphBlock     EQU  (DWORD PTR [BP+6])
                StackFrameBP
                MOV       BX,HotSpotX
                MOV       CX,HotSpotY
                LES       DX,GraphBlock
                MOV       AX,mSetGraphCursor
                INT       33h
                ExitCode  8
SetGraphCursor ENDP


SetSensitivity PROC FAR
MiskeyX        EQU  (WORD PTR [BP+8])
MiskeyY        EQU  (WORD PTR [BP+6])
                StackFrameBP
                MOV       CX,MiskeyX
                MOV       DX,MiskeyY
                MOV       AX,mSetSensitivity
                INT       33h
                ExitCode  4
SetSensitivity ENDP


GetMotionCount PROC FAR
CountX         EQU  (DWORD PTR [BP+10])
CountY         EQU  (DWORD PTR [BP+6])
                StackFrameBP
                MOV       AX,mGetMotionCount
                INT       33h
                LES       DI,CountX
                MOV       ES:[DI],CX
                LES       DI,CountY
                MOV       ES:[DI],DX
                ExitCode  8
GetMotionCount ENDP


SetUserMaskCall PROC FAR
aMask           EQU  (WORD  PTR [BP+10])
UserCall        EQU  (DWORD PTR [BP+6])
                 StackFrameBP
                 MOV       CX,aMask
                 LES       DX,UserCall
                 MOV       AX,mSetUserMaskCall
                 INT       33h
                 ExitCode  6
SetUserMaskCall ENDP


SetUserMouseHandler PROC FAR
aMask               EQU  (WORD  PTR [BP+10])
UserCall            EQU  (DWORD PTR [BP+6])
                     StackFrameBP
                     MOV       CX,aMask
                     LES       DX,UserCall
                     MOV       AX,mSetUserMouseHandler
                     INT       33h
                     ExitCode  6
SetUserMouseHandler ENDP


GetMouseVersion PROC NEAR
                 MOV   AX,mGetMouseVersion
                 INT   33h
                 MOV   AX,ES:[DI]
                 MOV   MouseVersion,AX
                 RET
GetMouseVersion ENDP


InitMouse PROC FAR
           MOV  AX,mResetMouseDriver
           INT  33h
           CMP  AL,00h
           JE   @@SetNo
           MOV  AL,1
@@SetNo:
           MOV  MousePresent,AL
           MOV  MouseType,BX
           CALL GetMouseVersion
           RET
InitMouse ENDP


CODE  ENDS

      END