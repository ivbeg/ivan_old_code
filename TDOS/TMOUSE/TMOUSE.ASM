include ASMMACRO.INC



DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA

      EXTRN   MouseType          :  WORD
      EXTRN   MouseVersion       :  WORD
      EXTRN   MousePresent       :  BYTE

DATA  ENDS


CODE  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA

      PUBLIC  GetCopirightString, ShowMouseCursor, HideMouseCursor
      PUBLIC  LeftButtonPressed, RightButtonPressed, MiddleButtonPressed
      PUBLIC  AnyButtonPressed, Init_TMouse

      .386

int33h_ResetDriver             EQU  00h
int33h_ShowCursor              EQU  01h
int33h_HideCursor              EQU  02h
int33h_GetMousePosition        EQU  03h
int33h_SetMousePosition        EQU  04h
int33h_DefineHorRange          EQU  07h
int33h_DefineVerRange          EQU  08h
int33h_DefineDoubleSpeed       EQU  013h
int33h_SetMouseSentensivity    EQU  01Ah
int33h_GetMouseSentensivity    EQU  01Bh
int33h_SetInterruptRate        EQU  01Ch
int33h_DefineDisplayPage       EQU  01Dh
int33h_ReturnDisplayPage       EQU  01Eh
int33h_DisableMouseDriver      EQU  01Fh
int33h_EnableMouseDriver       EQU  020h


int33h_GetMouseInformation     EQU  024h
int33h_GetGeneralInformation   EQU  025h
int33h_MouseHardwareReset      EQU  02Fh
int33h_GetCopirightString      EQU  04Dh


int33h_GetMouseVersion         EQU  06Dh



int_MouseInterrupt      EQU  033h

mousetype_NotInstalled  EQU  0FFF0h


Init_TMouse  PROC NEAR
   MOV       AX, int33h_ResetDriver
   INT       int_MouseInterrupt
   TEST      AX, AX
   JZ        @@Init_TMouse_MouseNotInstalled
   MOV       [MousePresent], boolean_True
   MOV       [MouseType], 0000h
   PUSH      ES
   PUSH      BX
   MOV       AX, int33h_GetMouseVersion
   INT       int_MouseInterrupt
   MOV       AX, WORD PTR ES:[BX]
   MOV       [MouseVersion], AX
   POP       BX
   POP       ES
   JMP       @@Init_TMouse_End
@@Init_TMouse_MouseNotInstalled:
   MOV       [MousePresent], boolean_False
   MOV       [MouseType], mousetype_NotInstalled
   MOV       [MouseVersion], 00000h
@@Init_TMouse_End:
   RET
Init_TMouse  ENDP


ShowMouseCursor  PROC FAR
   MOV       AX, int33h_ShowCursor
   INT       int_MouseInterrupt
   RET
ShowMouseCursor  ENDP


HideMouseCursor  PROC FAR
   MOV       AX, int33h_HideCursor
   INT       int_MouseInterrupt
   RET
HideMouseCursor  ENDP


Mouse_GetX  PROC FAR
   MOV       AX, int33h_GetMousePosition
   INT       int_MouseInterrupt
   MOV       AX, CX
   RET
Mouse_GetX  ENDP


Mouse_GetY  PROC FAR
   MOV       AX, int33h_GetMousePosition
   INT       int_MouseInterrupt
   MOV       AX, DX
   RET
Mouse_GetY  ENDP


LeftButtonPressed  PROC FAR
   MOV       AX, int33h_GetMousePosition
   INT       int_MouseInterrupt
   MOV       AX, BX
   AND       AL, 1
   RET
LeftButtonPressed  ENDP


RightButtonPressed  PROC FAR
   MOV       AX, int33h_GetMousePosition
   INT       int_MouseInterrupt
   MOV       AX, BX
   SHR       AX, 1
   AND       AX, 1
   RET
RightButtonPressed  ENDP


MiddleButtonPressed  PROC FAR
   MOV       AX, int33h_GetMousePosition
   INT       int_MouseInterrupt
   MOV       AX, BX
   SHR       AX, 2
   AND       AX, 1
   RET
MiddleButtonPressed  ENDP


AnyButtonPressed  PROC FAR
   MOV       AX, int33h_GetMousePosition
   INT       int_MouseInterrupt
   MOV       AX, BX
   AND       AX, 07h
   TEST      AX, AX
   JZ        @@AnyButtonPressed_NotPressed
   MOV       AX, 01h
   RET
@@AnyButtonPressed_NotPressed:

   RET
AnyButtonPressed  ENDP


SetMousePosition  PROC FAR
  X_Pos      EQU    (WORD PTR SS:[BX+6])
  Y_Pos      EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int33h_SetMousePosition
   MOV       CX, X_pos
   MOV       DX, Y_pos
   INT       int_MouseInterrupt
   RET       4
SetMousePosition  ENDP


DefineHorisontalRange  PROC FAR
  MinX       EQU    (WORD PTR SS:[BX+6])
  MaxX       EQU    (WORD PTR SS:[BX+6])
   macro_StackFrame BX
   MOV       AX, int33h_DefineHorRange
   MOV       CX, MinX
   MOV       DX, MaxX
   INT       int_MouseInterrupt
   RET       4
DefineHorisontalRange  ENDP


DefineVerticalRange  PROC FAR
  MinY       EQU    (WORD PTR SS:[BX+6])
  MaxY       EQU    (WORD PTR SS:[BX+6])
   macro_StackFrame BX
   MOV       AX, int33h_DefineVerRange
   MOV       CX, MinY
   MOV       DX, MaxY
   INT       int_MouseInterrupt
   RET       4
DefineVerticalRange  ENDP


DefineDoubleSpeedThreshold  PROC FAR
  Threshold  EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int33h_DefineDoubleSpeed
   MOV       DX, Threshold
   INT       int_MouseInterrupt
   RET       2
DefineDoubleSpeedThreshold  ENDP


SetMouseSentensivity  PROC FAR
  Horisontal EQU    (WORD PTR SS:[BX+8])
  Vertical   EQU    (WORD PTR SS:[BX+6])
  Threshold  EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int33h_SetMouseSentensivity
   MOV       DX, Threshold
   MOV       CX, Vertical
   MOV       BX, Horisontal
   INT       int_MouseInterrupt
   RET       6
SetMouseSentensivity  ENDP


ReturnMouseHorisontalSpeed  PROC FAR
   MOV       AX, int33h_GetMouseSentensivity
   INT       int_MouseInterrupt
   MOV       AX, BX
   RET
ReturnMouseHorisontalSpeed  ENDP


ReturnMouseVerticalSpeed  PROC FAR
   MOV       AX, int33h_GetMouseSentensivity
   INT       int_MouseInterrupt
   MOV       AX, CX
   RET
ReturnMouseVerticalSpeed  ENDP


ReturnMouseDoubleSpeed  PROC FAR
   MOV       AX, int33h_GetMouseSentensivity
   INT       int_MouseInterrupt
   MOV       AX, DX
   RET
ReturnMouseDoubleSpeed  ENDP


SetInterruptRate  PROC FAR
  Rate       EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int33h_SetInterruptRate
   MOV       BX, Rate
   INT       int_MouseInterrupt
   RET       2
SetInterruptRate  ENDP


GetCopirightString  PROC FAR
   MOV       AX, int33h_GetCopirightString
   INT       int_MouseInterrupt
   MOV       DX, ES
   MOV       AX, DI
   RET
GetCopirightString  ENDP



CODE  ENDS

      END