include ASMMACRO.INC



DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA

      EXTRN   Keyb_Functions   :  BYTE
      EXTRN   KeyboardType     :  BYTE

DATA  ENDS


CODE  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA

      PUBLIC  _Init_TKeyboard, Standard_GetKey, Extended_GetKey,
      PUBLIC  _122key_GetKey, KeyPresent, FlushKbdBuffer
      PUBLIC  GetShiftStates, GetExtShiftStates, Get122ShiftStates



bct_Feature2            EQU  006h   ; bct - means 'Bios Config Table'

int16h_StandardGetKey    EQU  000h
int16h_StandardCheckKey  EQU  001h
int16h_GetShiftStates    EQU  002h
int16h_GetFunctionality  EQU  009h
int16h_ExtendedGetKey    EQU  010h
int16h_ExtendedCheckKey  EQU  011h
int16h_GetExtShiftStates EQU  012h
int16h_122GetKey         EQU  020h
int16h_Get122ShiftStates EQU  022h

int_BiosInterrupt        EQU  015h
int_KbdInterrupt         EQU  016h

kbd_Standard             EQU  001h
kbd_Extended             EQU  002h
kbd_122key               EQU  003h

      .386


_Init_TKeyboard  PROC NEAR
   PUSH      ES
   PUSH      BX
   PUSH      AX
   MOV       AH, int15h_GetConfigTable
   INT       int_BiosInterrupt
   MOV       AL, BYTE PTR ES:[BX+bct_Feature2]
   AND       AL, 01000000b
   CMP       AL, 00h
   JE        @@Init_TKeyboard_ID_Unavailable
   MOV       AH, int16h_GetFunctionality
   INT       int_KbdInterrupt
   MOV       [Keyb_Functions], AL
   JMP       @@Init_TKeyboard_EndID
@@Init_TKeyboard_ID_Unavailable:
   MOV       [Keyb_Functions], 000100000b
@@Init_TKeyboard_EndID:
   MOV       AL, [Keyb_Functions]
   AND       AL, 001100000b
   JZ        @@Init_TKeyboard_Standard
   SHR       AL, 06h
   JZ        @@Init_TKeyboard_Extended
   MOV       [KeyboardType], kbd_122key
   JMP       @@Init_TKeyboard_End
@@Init_TKeyboard_Standard:
   MOV       [KeyboardType], kbd_Standard
   JMP       @@Init_TKeyboard_End
@@Init_TKeyboard_Extended:
   MOV       [KeyboardType], kbd_Extended
@@Init_TKeyboard_End:
   POP       AX
   POP       BX
   POP       ES
   RET
_Init_TKeyboard  ENDP


Standard_GetKey  PROC FAR
   MOV       AH, int16h_StandardGetKey
   INT       int_KbdInterrupt
   RET
Standard_GetKey  ENDP


Extended_GetKey  PROC FAR
   MOV       AH, int16h_ExtendedGetKey
   INT       int_KbdInterrupt
   RET
Extended_GetKey  ENDP


_122key_GetKey  PROC FAR
   MOV       AH, int16h_122GetKey
   INT       int_KbdInterrupt
   RET
_122key_GetKey  ENDP


GetShiftStates  PROC FAR
   MOV       AH, int16h_GetShiftStates
   INT       int_KbdInterrupt
   RET
GetShiftStates  ENDP


GetExtShiftStates  PROC FAR
   MOV       AH, int16h_GetExtShiftStates
   INT       int_KbdInterrupt
   MOV       AL, AH
   RET
GetExtShiftStates  ENDP


Get122ShiftStates  PROC FAR
   MOV       AH, int16h_Get122ShiftStates
   INT       int_KbdInterrupt
   MOV       AL, AH
   RET
Get122ShiftStates  ENDP


FlushKbdBuffer  PROC FAR
@@FlushKbdBuffer_Start:
   MOV       AH, int16h_StandardCheckKey
   INT       int_KbdInterrupt
   JZ        @@FlushKbdBuffer_End
   MOV       AH, int16h_StandardGetKey
   INT       int_KbdInterrupt
   JMP       @@FlushKbdBuffer_Start
@@FlushKbdBuffer_End:
   RET
FlushKbdBuffer  ENDP


KeyPresent  PROC FAR
   MOV       AH, int16h_StandardCheckKey
   INT       int_KbdInterrupt
   JZ        @@KeyPresent_False
   MOV       AH, int16h_StandardGetKey
   INT       int_KbdInterrupt
   MOV       AL, boolean_True
   JMP       @@KeyPresent_End
@@KeyPresent_False:
   MOV       AL, boolean_False
@@KeyPresent_End:
   RET
KeyPresent  ENDP


CODE  ENDS

      END