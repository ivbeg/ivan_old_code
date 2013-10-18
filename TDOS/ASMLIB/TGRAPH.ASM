include   ASMMACRO.INC


CrtMode         EQU     (BYTE  PTR 049h)
CrtWidth        EQU     (BYTE  PTR 04Ah)
VideoBuffSize   EQU     (WORD  PTR 04Ch)
PageAddr        EQU     (WORD  PTR 04Eh)
CursorPos       EQU     (WORD  PTR 050h)
CursorSize      EQU     (WORD  PTR 060h)
CurrentPage     EQU     (BYTE  PTR 062h)
Addr6845        EQU     (WORD  PTR 063h)
CrtModeSet      EQU     (BYTE  PTR 065h)
CrtPalette      EQU     (BYTE  PTR 066h)
Timer           EQU     (DWORD PTR 06Ch)
CrtRows         EQU     (BYTE  PTR 084h)
LetterHigh      EQU     (WORD  PTR 085h)
EgaFlags        EQU     (BYTE  PTR 087h)
EgaSwitches     EQU     (BYTE  PTR 088h)
VgaFlags        EQU     (BYTE  PTR 089h)
MainDCC         EQU     (BYTE  PTR 08Ah)
VideoTabPtr     EQU     (BYTE  PTR 0A8h)



DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

      EXTRN SegB000             : WORD
      EXTRN SegB800             : WORD
      EXTRN SegA000             : WORD
      EXTRN Seg0040             : WORD
      EXTRN UseBios             : BYTE
      EXTRN CurrentVideoSeg     : WORD
      EXTRN PageOffset          : WORD
      EXTRN StringCounter       : BYTE
      EXTRN ActiveCounter       : BYTE
      EXTRN WindMin             : WORD
      EXTRN WindMax             : WORD
      EXTRN TextChar            : BYTE
      EXTRN TextAttr            : BYTE
      EXTRN ActiveScreenPtr     : DWORD
      EXTRN VirtualScreenActive : DWORD
      EXTRN HideCursor          : BYTE
      EXTRN VideoBiosType       : BYTE
      EXTRN Pause               : FAR

SegC000                    EQU  0C000h

int10h_SetVideoMode        EQU  00h
int10h_SetCursorShape      EQU  01h
int10h_SetCursorPos        EQU  02h
int10h_SetVideoPage        EQU  05h
int10h_SetCGABorder        EQU  0Bh
int10h_SetCGAPalette       EQU  0Bh

int10h_SetEgaReg           EQU  1000h
int10h_SetOverscanColor    EQU  1001h
int10h_SetEgaPalette       EQU  1002h
int10h_SetBlink            EQU  1003h
int10h_GetEgaReg           EQU  1007h
int10h_GetOverscanColor    EQU  1008h
int10h_GetEgaPalette       EQU  1009h
int10h_SetRGB              EQU  1010h
int10h_SetDACPalette       EQU  1012h
int10h_GetRGB              EQU  1015h
int10h_GetDACPalette       EQU  1017h
int10h_GreySummDAC         EQU  101Bh
int10h_WriteString         EQU  13h

int10h_GetDCC              EQU  1A00h
int10h_SetDCC              EQU  1A01h

int10h_GetVideoInfo        EQU  1B1Bh

int10h_GetStateBufferSize  EQU  1C00h
int10h_SaveVideoState      EQU  1C01h
int10h_RestoreVideoState   EQU  1C02h


vbt_Unknown                EQU  00h
vbt_Paradise               EQU  01h
vbt_Oak                    EQU  02h
vbt_ATI                    EQU  03h
vbt_EgaWonder              EQU  04h
vbt_VgaWonder              EQU  05h
vbt_EgaWonder800           EQU  06h
vbt_Genoa                  EQU  07h
vbt_SuperEGA               EQU  08h
vbt_Ahead                  EQU  09h

DATA  ENDS


CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE, DS:DATA


      PUBLIC  GetVideoMode, GetCurrentVideoPage
      PUBLIC  SetLogicPage, GetRealPageOffset
      PUBLIC  GetXY, GetX, GetY, CursorXY
      PUBLIC  CursorOff, CursorOn, SetCursorShape
      PUBLIC  BiosWriteString,
      PUBLIC  SetDoubleScan, GetDCC, SetDCC
      PUBLIC  SaveVideoState, RestoreVideoState, GetStateBufferSize
      PUBLIC  GetTotalScanLines, SetBlink, SetStartOffset
      PUBLIC  is_DoubleScan, is_Blink, is_GraphMode
      PUBLIC  GetVideoInfo, SetCGABorder, SetCGAPalette
      PUBLIC  SetOverscanColor, GetOverscanColor
      PUBLIC  SetDACPalette, GetDACPalette, GreySummDAC
      PUBLIC  SetEgaPalette, GetEgaPalette, SetEgaReg, GetEgaReg
      PUBLIC  SetRGB, GetRGB
      PUBLIC  SetVideoMode, SetVideoPage
      PUBLIC  LineFeed, WriteCharXY, WriteChar
      PUBLIC  WriteStr, WriteStrXY, ReadChar, ReadAttr
      PUBLIC  ReadCharXY, ReadAttrXY, FillAttr, FillAttrXY
      PUBLIC  WriteAttr, PlaneWrite, PlaneWriteXY
      PUBLIC  ClrScr, InitTGraph

.386

LogicCursorPos  DW ?
TrueScroll      DB 1


GetVideoMode  PROC  FAR
   MOV       AL, GS: CrtMode
   RET
GetVideoMode  ENDP


GetCurrentVideoPage  PROC FAR
   MOV       AL, GS: CurrentPage
   RET
GetCurrentVideoPage  ENDP


SetActivePtr  PROC NEAR
   CMP       VirtualScreenActive, 0
   JNE       @@SetActivePtr_DontSet
   PUSH      AX
   MOV       AX, PageOffset
   MOV       WORD PTR [ActiveScreenPtr], AX
   MOV       AX, CurrentVideoSeg
   MOV       WORD PTR [ActiveScreenPtr+2], AX
   POP       AX
@@SetActivePtr_DontSet:
   RET
SetActivePtr  ENDP


SetLogicPage  PROC FAR
 Page            EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      AX
   PUSH      DX
   MOV       DX, GS:VideoBuffSize
   XOR       AH, AH
   MOV       AL, Page
   AND       AL, 7
   MUL       DX
   MOV       PageOffset, AX
   CALL      SetActivePtr
   POP       DX
   POP       AX
   RET       2
SetLogicPage  ENDP


SetRealPage  PROC NEAR
   MOV       AX, GS:PageAddr
   MOV       PageOffset, AX
   RET
SetRealPage  ENDP


GetRealPageOffset  PROC FAR
   MOV       AX, GS:PageAddr
   RET
GetRealPageOffset  ENDP


GetCursorXY  PROC NEAR
   CMP       HideCursor, 0
   JNE       @@GetCursorXY_Logic
   PUSH      DS
   PUSH      SI
   MOV       DS, Seg0040
   MOV       SI, 50h
   MOV       AL, GS:CurrentPage
   XOR       AH, AH
   SHL       AL, 1
   ADD       SI, AX
   MOV       AX, WORD PTR DS: [SI]
   POP       SI
   POP       DS
   JMP       @@GetCursorXY_End
@@GetCursorXY_Logic:
   MOV       AX, LogicCursorPos
@@GetCursorXY_End:
   RET
GetCursorXY  ENDP


GetXY  PROC FAR
   CALL      GetCursorXY
   RET
GetXY  ENDP


GetX  PROC FAR
   CALL      GetCursorXY
   RET
GetX  ENDP


GetY  PROC FAR
   CALL      GetCursorXY
   MOV       AL, AH
   RET
GetY  ENDP


LogicCursor  PROC NEAR
   MOV       LogicCursorPos, DX
   RET
LogicCursor  ENDP


BiosCursor  PROC NEAR
   MOV       AH, int10h_SetCursorPos
   CALL      GetCurrentVideoPage
   MOV       BH, AL
   INT       10h
   RET
BiosCursor  ENDP


SetCursorPos  PROC NEAR
   PUSH      AX
   CMP       HideCursor, 0
   JE        @@SetCursorPos_BiosCursor
   CALL      LogicCursor
   JMP       @@SetCursorPos_End
@@SetCursorPos_BiosCursor:
   CALL      BiosCursor
@@SetCursorPos_End:
   POP       AX
   RET
SetCursorPos  ENDP


CursorXY  PROC FAR
 X           EQU  (BYTE  PTR SS:[BX+6])
 Y           EQU  (BYTE  PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       DL, X
   MOV       DH, Y
   CALL      SetCursorPos
   RET              4
CursorXY  ENDP


CursorOff  PROC FAR
   CMP       HideCursor, 0
   JNE       @@CursorOff_End
   PUSH      AX
   PUSH      CX
   PUSH      DX
   CALL      GetCursorXY
   MOV       CX, AX
   MOV       DL, AL
   MOV       DH, GS: CrtRows
   INC       DH
   MOV       HideCursor, 0
   CALL      SetCursorPos
   MOV       HideCursor, 1
   MOV       DX, CX
   CALL      SetCursorPos
   POP       DX
   POP       CX
   POP       AX
@@CursorOff_End:
   RET
CursorOff  ENDP


CursorOn  PROC FAR
   CMP       HideCursor, 0
   JE        @@CursorOn_End
   PUSH      DX
   PUSH      AX
   CALL      GetCursorXY
   MOV       HideCursor, 0
   MOV       DX, AX
   CALL      CursorXY
   POP       AX
   POP       DX
@@CursorOn_End:
   RET
CursorOn  ENDP


BiosWriteString PROC FAR
 Point           EQU  (WORD  PTR SS:[DI+16])
 Page            EQU  (BYTE  PTR SS:[DI+14])
 Str             EQU  (DWORD PTR SS:[DI+10])
 Size            EQU  (WORD  PTR SS:[DI+8])
 Attr            EQU  (BYTE  PTR SS:[DI+6])
 WriteMode       EQU  (BYTE  PTR SS:[DI+4])
   macro_StackFrame DI
   MOV              AH, int10h_WriteString
   MOV              AL, WriteMode
   MOV              DX, Point
   MOV              CX, Size
   MOV              BH, Page
   MOV              BL, Attr
   LES              BP, Str
   INT              10h
   RET              14
BiosWriteString ENDP


GetVideoBiosType  PROC NEAR
   PUSH      DS
   PUSH      SegC000
   POP       DS
@@Check_Ahead:
   MOV       SI, 0025h
   LODSD
   CMP       EAX, 'AEHA'
   JNE       @@Check_Paradise
   LODSB
   CMP       AL, 'D'
   JNE       @@Check_Paradise
   MOV       VideoBiosType, vbt_AHEAD
   JMP       @@GetVideoBiosType_End
@@Check_Paradise:
   MOV       SI, 007Dh
   LODSD
   CMP       EAX, '=AGV'
   JNE       @@Check_Oak
   MOV       VideoBiosType, vbt_Paradise
   JMP       @@GetVideoBiosType_End
@@Check_Oak:
   MOV       SI, 0008h
   LODSD
   CMP       EAX, ' KAO'
   JNE       @@Check_ATI
   LODSW
   CMP       AX, 'AG'
   JNE       @@Check_ATI
   LODSB
   CMP       AL, 'V'
   JNE       @@Check_ATI
   MOV       VideoBiosType, vbt_Oak
   JMP       @@GetVideoBiosType_End
@@Check_ATI:
   MOV       SI, 0043h
   LODSD
   CMP       EAX, '2167'
   JNE       @@Check_EgaWonder
   LODSD
   CMP       EAX, '2559'
   JNE       @@Check_EgaWonder
   LODSB
   CMP       AL, '0'
   JNE       @@Check_EgaWonder
   MOV       VideoBiosType, vbt_ATI
   JMP       @@GetVideoBiosType_End
@@Check_EgaWonder:
   MOV       SI, 0040h
   CMP       WORD PTR [SI], '22'
   JNE       @@Check_VgaWonder
   MOV       VideoBiosType, vbt_EgaWonder
   JMP       @@GetVideoBiosType_End
@@Check_VgaWonder:
   CMP       WORD PTR [SI], '31'
   JNE       @@Check_EgaWonder800
   MOV       VideoBiosType, vbt_VgaWonder
   JMP       @@GetVideoBiosType_End
@@Check_EgaWonder800:
   CMP       WORD PTR [SI], '32'
   JNE       @@Check_Genoa
   MOV       VideoBiosType, vbt_EgaWonder800
   JMP       @@GetVideoBiosType_End
@@Check_Genoa:
   MOV       SI, 0037h
   LODSW
   MOV       SI, AX
   LODSW
   CMP       AL, 77h
   JNE       @@Check_SuperEGA
   LODSW
   CMP       AX, 6699h
   JNE       @@Check_SuperEGA
   MOV       VideoBiosType, vbt_Genoa
   JMP       @@GetVideoBiosType_End
@@Check_SuperEGA:
   MOV       SI, 0070h
   LODSD
   CMP       EAX, 'MTXE'
   JNE       @@Check_Cirrus
   LODSW
   CMP       AX, 'ED'
   JNE       @@Check_Cirrus
   LODSB
   CMP       AL, 'O'
   JNE       @@Check_Cirrus
   MOV       VideoBiosType, vbt_SuperEGA
   JMP       @@GetVideoBiosType_End

@@Check_Cirrus:
   MOV       VideoBiosType, vbt_Unknown
   JMP       @@GetVideoBiosType_End
@@Check_Trident:
@@GetVideoBiosType_End:
   POP       DS
   RET
GetVideoBiosType  ENDP


SetCursorShape  PROC FAR
 Start           EQU  (BYTE PTR SS:[BX+6])
 Stop            EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   PUSH      AX
   PUSH      CX
   MOV       CH, Start
   MOV       CL, Stop
   MOV       AH, int10h_SetCursorShape
   INT       10h
   POP       CX
   POP       AX
   RET              4
SetCursorShape  ENDP


SetCurrentVideoSeg  PROC NEAR
   PUSH      AX
   PUSH      DX
   MOV       DX, 03CEh
   MOV       AL, 06h
   OUT       DX, AL
   INC       DX
   IN        AL, DX
   SHR       AL, 2
   AND       AL, 3
   CMP       AL, 2
   JE        @@SetCurrentVideoSeg_SetMono
   JA        @@SetCurrentVideoSeg_SetColor
   MOV       AX, SegA000
   JMP       SHORT @@SetCurrentVideoSeg_SetSeg
@@SetCurrentVideoSeg_SetMono:
   MOV       AX, SegB000
   JMP       SHORT @@SetCurrentVideoSeg_SetSeg
@@SetCurrentVideoSeg_SetColor:
   MOV       AX, SegB800
@@SetCurrentVideoSeg_SetSeg:
   MOV       CurrentVideoSeg, AX
   POP       DX
   POP       AX
   RETN
SetCurrentVideoSeg  ENDP


WritePort_3D5h  PROC FAR
   PUSH      DX
   MOV       DX, GS: Addr6845
   OUT       DX, AX
   POP       DX
   RETN
WritePort_3D5h  ENDP


ReadPort_3D5h  PROC FAR
   PUSH      DX
   MOV       DX, GS: Addr6845
   OUT       DX, AL
   INC       DL
   IN        AL, DX
   POP       DX
   RET
ReadPort_3D5h  ENDP


SetDoubleScan  PROC FAR
 Value           EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AL, 9
   CALL      ReadPort_3D5h
   MOV       AH, Value
   SHR       AH, 7
   OR        AL, AH
   MOV       AH, AL
   MOV       AL, 9
   CALL      WritePort_3D5h
   RET       2
SetDoubleScan  ENDP


SaveVideoState  PROC FAR
 StateType       EQU  (WORD PTR  SS:[DI+8])
 Buffer          EQU  (DWORD PTR SS:[DI+4])
   macro_StackFrame DI
   MOV       CX, StateType
   LES       BX, Buffer
   MOV       AX, int10h_SaveVideoState
   INT       10h
   RET       6
SaveVideoState  ENDP



RestoreVideoState  PROC FAR
 StateType       EQU  (WORD  PTR SS:[DI+8])
 Buffer          EQU  (DWORD PTR SS:[DI+4])
   macro_StackFrame DI
   MOV       CX, StateType
   LES       BX, Buffer
   MOV       AX, int10h_RestoreVideoState
   INT       10h
   RET       6
RestoreVideoState  ENDP


GetStateBufferSize  PROC FAR
 StateType       EQU  (WORD PTR SS:[DI+4])
   macro_StackFrame DI
   MOV       CX, StateType
   MOV       AX, int10h_GetStateBufferSize
   INT       10h
   MOV       AX, BX
   RET       2
GetStateBufferSize  ENDP


GetDCC  PROC FAR
   MOV       AX, int10h_GetDCC
   INT       10h
   MOV       AX, BX
   XCHG      AL, AH
   RET
GetDCC  ENDP


SetDCC  PROC FAR
 Main            EQU  (BYTE PTR SS:[DI+6])
 Second          EQU  (BYTE PTR SS:[DI+4])
   macro_StackFrame DI
   MOV       AX, int10h_SetDCC
   MOV       BL, Main
   MOV       BH, Second
   INT       10h
   RET       4
SetDCC  ENDP


GetTotalScanLines  PROC FAR
   MOV       DX, GS: Addr6845
   MOV       AL, 12h
   OUT       DX, AL
   INC       DL
   IN        AL, DX
   MOV       BL, AL
   macro_Zero AH
   DEC       DL
   MOV       AL, 07h
   OUT       DX, AL
   INC       DL
   IN        AL, DX
   MOV       BH, AL
   AND       AL, 2
   SHR       AL, 1
   OR        AH, AL
   AND       BH, 01000000b
   SHR       BH, 4
   OR        AH, BH
   MOV       AL, BL
   INC       AX
   RET
GetTotalScanLines  ENDP


SetBlink  PROC FAR
Value     EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int10h_SetBlink
   MOV       BL, Value
   INT       10h
   RET       2
SetBlink  ENDP


SetStartOffset  PROC FAR
 Hi       EQU  (BYTE PTR SS:[BX+5])
 Lo       EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       DX, GS: Addr6845
   MOV       AL, 0Ch
   MOV       AH, Lo
   OUT       DX, AX
   MOV       AH, Hi
   INC       AL
   OUT       DX, AX
   RET       2
SetStartOffset  ENDP


is_DoubleScan  PROC FAR
   MOV       AL, 09h
   CALL      ReadPort_3D5h
   SHR       AL, 7
is_DoubleScan  ENDP


ReadPort_3C0h  PROC FAR
   PUSHF
   CLI
   MOV       AH, AL
   MOV       DX, GS:Addr6845
   ADD       DX, 05h
   IN        AL, DX
   MOV       DL, 0C0h
   MOV       AL, AH
   OR        AL, 20h
   OUT       DX, AL
   INC       DL
   IN        AL, DX
   POPF
   RET
ReadPort_3C0h  ENDP


WritePort_3C0h  PROC FAR
   PUSHF
   MOV       BX, AX
   CLI
   MOV       DX, GS:Addr6845
   ADD       DX, 05h
   IN        AL, DX
   MOV       DL, 0C0h
   MOV       BX, AX
   XCHG      AL, AH
   OR        AL, 20h
   OUT       DX, AL
   INC       DL
   MOV       AL, AH
   OUT       DX, AL
   POPF
   RET
WritePort_3C0h  ENDP


is_Blink  PROC FAR
   MOV       AL, 010h
   CALL      ReadPort_3C0h
   AND       AL, 08h
   OR        AL, AL
   JZ        @@is_Blink_End
   MOV       AL, 01h
@@is_Blink_End:
   RET
is_Blink  ENDP


is_GraphMode  PROC FAR
   MOV       AL, 010h
   CALL      ReadPort_3C0h
   AND       AL, 01h
   RET
is_GraphMode  ENDP


GetVideoInfo  PROC FAR
 Table    EQU  (DWORD  PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int10h_GetVideoInfo
   LES       DI, Table
   macro_Zero BX
   INT       10h
   RET       4
GetVideoInfo  ENDP


SetCGABorder  PROC FAR
 Color    EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AL, int10h_SetCGABorder
   MOV       BL, Color
   macro_Zero BH
   INT       10h
   RET       2
SetCGABorder  ENDP


SetCGAPalette  PROC FAR
 PalID    EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AL, int10h_SetCGAPalette
   MOV       BL, Color
   MOV       BH, 01h
   INT       10h
   RET       2
SetCGAPalette  ENDP


GetOverscanColor  PROC FAR
   MOV       AX, int10h_GetOverscanColor
   INT       10h
   MOV       AL, BH
   RET
GetOverscanColor  ENDP


SetOverscanColor  PROC FAR
 Color    EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int10h_SetOverscanColor
   MOV       BH, Color
   INT       10h
   RET       2
SetOverscanColor  ENDP


SetDACPalette  PROC FAR
 Palette  EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int10h_SetDACPalette
   LES       DX, Palette
   MOV       BX, 0
   MOV       CX, 100h
   INT       10h
   RET       4
SetDACPalette  ENDP


GetDACPalette  PROC FAR
 Palette  EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int10h_GetDACPalette
   LES       DX, Palette
   MOV       BX, 0
   MOV       CX, 100h
   INT       10h
   RET       4
GetDACPalette  ENDP


GreySummDAC  PROC FAR
 StartReg EQU  (WORD PTR SS:[BX+6])
 Count    EQU  (WORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int10h_GreySummDAC
   MOV       CX, Count
   MOV       BX, StartReg
   INT       10h
   RET       4
GreySummDAC  ENDP


SetEgaPalette  PROC FAR
 Palette  EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int10h_SetEgaPalette
   LES       DX, Palette
   INT       10h
   RET       4
SetEgaPalette  ENDP


GetEgaPalette  PROC FAR
 Palette  EQU  (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int10h_GetEgaPalette
   LES       DX, Palette
   INT       10h
   RET       4
GetEgaPalette  ENDP


GetEgaReg  PROC FAR
 EgaReg   EQU  (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, int10h_GetEgaReg
   MOV       BL, EgaReg
   INT       10h
   MOV       AL, BH
   RET       2
GetEgaReg  ENDP


SetEgaReg  PROC FAR
 EgaReg   EQU  (BYTE PTR SS:[DI+6])
 Value    EQU  (BYTE PTR SS:[DI+4])
   macro_StackFrame DI
   MOV       AX, int10h_GetEgaPalette
   MOV       BL, EgaReg
   MOV       BH, Value
   INT       10h
   RET       4
SetEgaReg  ENDP


GetRGB  PROC FAR
 Reg      EQU  (WORD  PTR SS:[DI+8])
 RGB      EQU  (DWORD PTR SS:[DI+4])
   macro_StackFrame DI
   MOV       AX, int10h_GetRGB
   MOV       BX, Reg
   INT       10h
   LES       DI, RGB
   MOV       BYTE PTR [DI], DH
   MOV       WORD PTR [DI+1], CX
   RET       4
GetRGB  ENDP


SetRGB  PROC FAR
 Reg      EQU  (WORD  PTR SS:[DI+8])
 RGB      EQU  (DWORD PTR SS:[DI+4])
   macro_StackFrame DI
   MOV       AX, int10h_SetRGB
   MOV       BX, Reg
   MOV       DH, BYTE PTR [DI]
   MOV       CX, WORD PTR [DI+1]
   LES       DI, RGB
   INT       10h
   RET       4
SetRGB  ENDP


LocalWinSet  PROC FAR
   MOV       AH, GS:CrtWidth
   MOV       AL, GS:CrtRows
   DEC       AH
   MOV       WindMax, AX
   MOV       WindMin, 0
   RET
LocalWinSet  ENDP


SetVideoMode  PROC FAR
 Mode     EQU  (BYTE  PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int10h_SetVideoMode
   MOV       AL, Mode
   INT       10h
   CALL      LocalWinSet
   CALL      SetRealPage
   CALL      SetCurrentVideoSeg
   CALL      SetActivePtr
   RET       2
SetVideoMode  ENDP


SetVideoPage  PROC FAR
 Page     EQU  (BYTE  PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int10h_SetVideoPage
   MOV       AL, Page
   INT       10h
   CALL      LocalWinSet
   CALL      SetRealPage
   CALL      SetCurrentVideoSeg
   CALL      SetActivePtr
   RET       2
SetVideoPage  ENDP


GetXYPos  PROC NEAR
   PUSH      AX
   MOV       AX, WindMax
   MOV       AL, AH
   INC       AL
   MUL       DH
   SHL       AX, 1
   MOV       DI, AX
   MOV       AL, DL
   XOR       AH, AH
   SHL       AX, 1
   ADD       AX, DI
   LES       DI, ActiveScreenPtr
   ADD       DI, AX
   POP       AX
   RET
GetXYPos  ENDP


MemWriteChar  PROC NEAR
   PUSH      ES
   PUSH      DI
   CALL      GetXYPos
   MOV       WORD PTR ES:[DI], AX
   POP       DI
   POP       ES
   RET
MemWriteChar  ENDP


MemReadCharAttr  PROC NEAR
   PUSH      ES
   PUSH      DI
   CALL      GetXYPos
   MOV       AX, WORD PTR ES:[DI]
   POP       DI
   POP       ES
   RET
MemReadCharAttr  ENDP


ScrollOne  PROC NEAR
   PUSH      AX
   XCHG      CH, CL
   XCHG      DH, DL
   MOV       BH, TextAttr
   MOV       AX, 0601h
   INT       10h
   POP       AX
   RET
ScrollOne  ENDP


LineFeed  PROC FAR
   PUSH      CX
   MOV       CX, WindMin
   MOV       DX, WindMax
   CALL      GetCursorXY
   CMP       AH, DL
   JNB       @@LineFeed_LineScroll
   INC       AH
   JMP       @@LineFeed_CheckCounter
@@LineFeed_LineScroll:
   CMP       TrueScroll, 0
   JNE       @@LineFeed_Scrolling
   JMP       @@LineFeed_CheckCounter
@@LineFeed_Scrolling:
   CALL      ScrollOne
@@LineFeed_CheckCounter:
   MOV       AL, CH
   MOV       DX, AX
   CALL      SetCursorPos
   CMP       ActiveCounter, 0
   JE        @@LineFeed_End
   MOV       AX, WindMax
   MOV       DX, WindMin
   SUB       AL, 3
   CMP       AL, DL
   JNE       @@LineFeed_End
   CALL      Pause
@@LineFeed_End:
   POP       CX
   RET
LineFeed  ENDP


AddOne   PROC NEAR
   PUSH      CX
   CALL      GetCursorXY
   MOV       DX, WindMax
   CMP       AL, DH
   JAE       @@AddOne_LineFeed
   INC       AL
   MOV       DX, AX
   CALL      SetCursorPos
   JMP       @@AddOne_End
@@AddOne_LineFeed:
   CALL      LineFeed
@@AddOne_End:
   POP       CX
   RET
AddOne   ENDP


WriteCharXY  PROC FAR
 X          EQU  (BYTE PTR SS:[BP+12])
 Y          EQU  (BYTE PTR SS:[BP+10])
 CharCode   EQU  (BYTE PTR SS:[BP+8])
 Attr       EQU  (BYTE PTR SS:[BP+6])
   macro_StackFrameBP
   MOV       DL, X
   MOV       DH, Y
   MOV       AL, CharCode
   MOV       AH, Attr
   CALL      MemWriteChar
   macro_ExitCode  8
WriteCharXY  ENDP


wMemWriteChar  PROC FAR
   PUSH      AX
   CALL      GetCursorXY
   MOV       DX, AX
   POP       AX
   CALL      MemWriteChar
   CALL      AddOne
   RET
wMemWriteChar  ENDP


WriteChar  PROC FAR
 CharCode   EQU  (BYTE PTR SS:[BP+8])
 Attr       EQU  (BYTE PTR SS:[BP+6])
   macro_StackFrameBP
   MOV       AH, Attr
   MOV       AL, CharCode
   CALL      wMemWriteChar
   macro_ExitCode  4
WriteChar  ENDP


WriteStr  PROC FAR
 S          EQU  (DWORD PTR [BP+8])
 Attr       EQU  (BYTE  PTR [BP+6])
   macro_StackFrameBP
   PUSH      FS
   LFS       SI, S
   XOR       CH, CH
   MOV       CL, BYTE PTR FS:[SI]
   INC       SI
   JCXZ      @@WriteStr_End
   MOV       AH, Attr
@@WriteStr_Loop:
   MOV       AL, BYTE PTR FS:[SI]
   INC       SI
   MOV       AH, Attr
   CALL      wMemWriteChar
   LOOP      @@WriteStr_Loop
@@WriteStr_End:
   POP       FS
   macro_ExitCode  6
WriteStr  ENDP


WriteStrXY  PROC FAR
 X          EQU  (BYTE  PTR SS:[BP+14])
 Y          EQU  (BYTE  PTR SS:[BP+12])
 S          EQU  (DWORD PTR SS:[BP+8])
 Attr       EQU  (BYTE  PTR SS:[BP+6])
   macro_StackFrameBP
   MOV       DL, X
   MOV       DH, Y
   CALL      GetCursorXY
   PUSH      AX
   CALL      SetCursorPos
   MOV       AL, Attr
   PUSH      S
   PUSH      AX
   CALL      WriteStr
   POP       DX
   CALL      SetCursorPos
   macro_ExitCode  10
WriteStrXY  ENDP


ReadChar  PROC FAR
   CALL      GetCursorXY
   MOV       DX, AX
   CALL      MemReadCharAttr
   RET
ReadChar  ENDP


ReadAttr  PROC FAR
   CALL      GetCursorXY
   MOV       DX, AX
   CALL      MemReadCharAttr
   MOV       AL, AH
   RET
ReadAttr  ENDP


ReadCharXY  PROC FAR
 X          EQU  (BYTE  PTR SS:[BP+6])
 Y          EQU  (BYTE  PTR SS:[BP+4])
   macro_StackFrameBP
   MOV       DH, X
   MOV       DL, Y
   CALL      MemReadCharAttr
   macro_ExitCode  4
ReadCharXY  ENDP


ReadAttrXY  PROC FAR
 X          EQU  (BYTE  PTR SS:[BP+8])
 Y          EQU  (BYTE  PTR SS:[BP+6])
   macro_StackFrameBP
   MOV       DH, X
   MOV       DL, Y
   CALL      MemReadCharAttr
   MOV       AL, AH
   macro_ExitCode  4
ReadAttrXY  ENDP


FillAttr  PROC FAR
 Attr       EQU  (BYTE  PTR SS:[BP+8])
 Count      EQU  (BYTE  PTR SS:[BP+6])
   macro_StackFrameBP
   MOV       CL, Count
   XOR       CH, CH
   JCXZ      @@FillAttr_End
@@FillAttr_Loop:
   PUSH      BX
   PUSH      CX
   CALL      ReadChar
   PUSH      AX
   MOV       AL, Attr
   PUSH      AX
   CALL      WriteChar
   POP       CX
   POP       BX
   LOOP      @@FillAttr_Loop
@@FillAttr_End:
   macro_ExitCode  4
FillAttr  ENDP


FillAttrXY  PROC FAR
 X          EQU  (BYTE  PTR SS:[BP+12])
 Y          EQU  (BYTE  PTR SS:[BP+10])
 Attr       EQU  (BYTE  PTR SS:[BP+8])
 Count      EQU  (BYTE  PTR SS:[BP+6])
   macro_StackFrameBP
   MOV       CL, Count
   XOR       CH, CH
   JCXZ      @@FillAttrXY_End
   MOV       TrueScroll, 0
   MOV       DH, Y
   MOV       DL, X
   CALL      GetCursorXY
   PUSH      AX
   CALL      SetCursorPos
   MOV       AL, Attr
   PUSH      AX
   MOV       AL, CL
   PUSH      AX
   CALL      FillAttr
   POP       DX
   CALL      SetCursorPos
@@FillAttrXY_End:
   MOV       TrueScroll, 1
   macro_ExitCode  8
FillAttrXY  ENDP


WriteAttr  PROC FAR
 Attr       EQU  (BYTE  PTR SS:[BP+6])
   macro_StackFrameBP
   CALL      ReadChar
   PUSH      AX
   MOV       AL, Attr
   PUSH      AX
   CALL      WriteChar
   macro_ExitCode  2
WriteAttr  ENDP


PlaneWrite  PROC FAR
 S          EQU  (DWORD PTR SS:[BP+6])
   macro_StackFrameBP
   PUSH      DS
   LDS       SI, S
   LODSB
   MOV       CL, AL
   XOR       CH, CH
   JCXZ      @@PlaneWrite_End
@@PlaneWrite_Loop:
   PUSH      CX
   LODSB
   PUSH      AX
   CALL      ReadAttr
   PUSH      AX
   CALL      WriteChar
   POP       CX
   LOOP      @@PlaneWrite_Loop
@@PlaneWrite_End:
   POP       DS
   macro_ExitCode  4
PlaneWrite  ENDP


PlaneWriteXY  PROC FAR
 X          EQU  (BYTE  PTR SS:[BP+12])
 Y          EQU  (BYTE  PTR SS:[BP+10])
 S          EQU  (DWORD PTR SS:[BP+6])
   macro_StackFrameBP
   MOV       DH, Y
   MOV       DL, X
   CALL      GetCursorXY
   PUSH      AX
   CALL      SetCursorPos
   PUSH      S
   MOV       TrueScroll, 0
   CALL      PlaneWrite
   POP       DX
   CALL      SetCursorPos
   MOV       TrueScroll, 1
   macro_ExitCode  8
PlaneWriteXY  ENDP


ClrScr  PROC  FAR
   CALL      is_GraphMode
   CMP       AL, 0
   JNE       @@ClrScr_GraphClear
   MOV       CX, GS: VideoBuffSize
   SHR       CX, 2
   LES       DI, ActiveScreenPtr
   MOV       BL, TextChar
   MOV       BH, TextAttr
   MOV       AX, BX
   SHL       EAX, 16
   MOV       AX, BX
   JMP       @@ClrScr_EGA_VGA
@@ClrScr_GraphClear:
   MOV       CX, 100h
   MOV       DX, SegA000
   CMP       CurrentVideoSeg, DX
   JE        @@ClrScr_EGA_VGA
   MOV       CX, 80h
@@ClrScr_EGA_VGA:
   REP       STOSD
   RET
ClrScr  ENDP


InitTGraph  PROC FAR
   MOV       GS, Seg0040
   MOV       StringCounter, 0
   MOV       ActiveCounter, 0
   MOV       HideCursor, 0
   MOV       UseBios, 0
   MOV       TextChar, 20h
   MOV       TextAttr, 07h
   CALL      LocalWinSet
   CALL      SetCurrentVideoSeg
   CALL      SetRealPage
   CALL      SetActivePtr
   CALL      GetVideoBiosType
   RET
InitTGraph  ENDP


CODE  ENDS

      END

