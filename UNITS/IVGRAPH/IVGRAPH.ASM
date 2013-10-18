INCLUDE MACRO.INC


;Bios Area Imitation
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

      EXTRN SegB000:WORD,SegB800:WORD,Seg0040:WORD,SegA000:WORD
      EXTRN UseBios:BYTE,UsePorts:BYTE,CurrentVideoSeg:WORD
      EXTRN Counter:BYTE,SetCounter:BYTE,Hide:BYTE
      EXTRN PageOffset:WORD,EndL:FAR
      EXTRN TextChar:BYTE,TextAttr:BYTE
      EXTRN WindMin:WORD,WindMax:WORD
      EXTRN ActiveScreenPtr:DWORD
      EXTRN VirtualScreenActive:BYTE

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA


      PUBLIC SaveVideoState,RestoreVideoState,GetStateBufferSize
      PUBLIC TotalScanLines,GetDCC,SetDCC,CursorXY
      PUBLIC bWriteString,GetVideoMode,SetVideoMode
      PUBLIC SetVideoPage,WriteCharTTY
      PUBLIC IsCursorEm,IsWaitDisplay,IsVideoSysActive
      PUBLIC VideoMemSize,IsSaveBuffer,IsGreySumm
      PUBLIC IsDefPalLoad,GetScanLines,IsVGABoardActive
      PUBLIC IsDoubleScan,IsBlink,IsGraphMode
      PUBLIC SetScanLines,GetVideoInfo,WaitRetrace
      PUBLIC SetCgaPalette,SetCgaBorder,SetStartAddress
      PUBLIC GreySummDAC,GetDACPalette,SetDACPalette
      PUBLIC SetEgaReg,GetEgaReg,SetEgaPalette,GetEgaPalette
      PUBLIC bSetRGB,bGetRGB,pSetRGB,pGetRGB
      PUBLIC SetOverscanColor,GetOverscanColor
      PUBLIC bPutPoint,bReadPoint,mPutPoint,mReadPoint
      PUBLIC DisableDefPalLoad,DisableVideoAddr,DisableGreySumm
      PUBLIC DisableCursorEm,DisableVideoRefr,CursorForm
      PUBLIC SetDoubleScan,Scroll,SetBlink
      PUBLIC GetCurrentPage,GetPageOffset
      PUBLIC CursorOff,CursorOn,ClrScr
      PUBLIC InitIvGraph,GetX,GetY,GetXY
      PUBLIC WriteStr,WriteStrXY,WriteChar
      PUBLIC WriteCharXY,ReadChar,ReadCharXY
      PUBLIC ReadAttrXY,ReadAttr,WriteAttr
      PUBLIC FillAttr,FillAttrXY,PlaneWrite
      PUBLIC PlaneWriteXY,SetLogicPage,SetRealPage
      PUBLIC LineFeed,NoneDo,LineX,LineY

.386

TrueScroll     DB 1
LogicCursorPos DW ?


SetActivePtr PROC NEAR
              CMP        VirtualScreenActive,0
              JNE        @@DontSet
              PUSH       AX
              MOV        AX,PageOffset
              MOV        WORD PTR [ActiveScreenPtr],AX
              MOV        AX,CurrentVideoSeg
              MOV        WORD PTR [ActiveScreenPtr+2],AX
              POP        AX
    @@DontSet:
              RET
SetActivePtr ENDP

NoneDo PROC FAR
        MOV AL,1
        RET
NoneDo ENDP

SetLogicPage PROC FAR
Page         EQU  (BYTE PTR [BP+6])
              StackFrameBP
              PUSH      AX
              PUSH      DX
              PUSH      ES
              MOV       ES,Seg0040
              MOV       DX,ES:VideoBuffSize
              POP       ES
              Zero      AH
              MOV       AL,Page
              AND       AL,7
              MUL       DX
              MOV       PageOffset,AX
              CALL      SetActivePtr
              POP       DX
              POP       AX
              ExitCode  2
SetLogicPage ENDP

SetRealPage PROC FAR
              PUSH      ES
              MOV       ES,Seg0040
              MOV       AX,ES:PageAddr
              MOV       PageOffset,AX
              POP       ES
              RET
SetRealPage ENDP



GetXY      PROC FAR
            CALL GetCursorXY
            RET
GetXY      ENDP

GetCursorXY PROC NEAR
             CMP   Hide,0
             JNE   @@10
             PUSH  DS
             PUSH  SI
             MOV   DS,Seg0040
             MOV   SI,50h
             MOV   AL,DS:CurrentPage
             Zero  AH
             SHL   AL,1
             ADD   SI,AX
             MOV   AX,DS:[SI]
             POP   SI
             POP   DS
             JMP   @@11
        @@10:
             MOV   AX,LogicCursorPos
        @@11:
             RET
GetCursorXY ENDP


GetX       PROC FAR
            CALL GetCursorXY
            RET
GetX       ENDP


GetY       PROC FAR
            CALL GetCursorXY
            MOV  AL,AH
            RET
GetY       ENDP


CursorForm PROC FAR
Start      EQU  (BYTE PTR [BP+8])
Stop       EQU  (BYTE PTR [BP+6])
            StackFrameBP
            PUSH       AX
            PUSH       CX
            MOV        CH,Start
            MOV        CL,Stop
            AND        CL,1Fh
            MOV        AH,01h
            INT        10H
            POP        CX
            POP        AX
            ExitCode   4
CursorForm ENDP


CursorOff PROC FAR
           PUSH AX
           PUSH CX
           PUSH DX
           PUSH ES
           CALL GetCursorXY
           MOV  CX,AX
           MOV  DL,AL
           MOV  ES,Seg0040
           MOV  DH,ES:CrtRows
           INC  DH
           POP  ES
           MOV  Hide,0
           CALL SetCursorPos
           MOV  Hide,1
           MOV  DX,CX
           CALL SetCursorPos
           POP  DX
           POP  CX
           POP  AX
           RET
CursorOff ENDP


CursorOn  PROC FAR
            PUSH DX
            PUSH AX
            CALL GetCursorXY
            MOV  Hide,0
            MOV  DX,AX
            CALL SetCursorPos
            POP  AX
            POP  DX
            RET
CursorOn  ENDP


GetCurrentPage PROC FAR
               PUSH DS
               MOV  DS,Seg0040
               MOV  AL,DS:CurrentPage
               POP  DS
               RET
GetCurrentPage ENDP


GetPageOffset PROC FAR
               PUSH ES
               MOV  ES,Seg0040
               MOV  AX,ES:PageAddr
               POP  ES
               RET
GetPageOffset ENDP


WritePort_3d5h PROC NEAR
                PUSH DS
                PUSH DX
                MOV  DS,Seg0040
                MOV  DX,DS:Addr6845
                POP  DS
                OUT  DX,AX
                POP  DS
                RETN
WritePort_3d5h ENDP


SetDoubleScan PROC FAR
Scan          EQU  (BYTE PTR [BP+6])
               StackFrameBP
               MOV       AL,9
               CALL      ReadPort_3d5h
               MOV       AH,Scan
               MOV       CL,7
               SHL       AH,CL
               OR        AL,AH
               MOV       AH,AL
               MOV       AL,9
               CALL      WritePort_3d5h
               ExitCode  2
SetDoubleScan ENDP


IsCursorEm PROC FAR
            PUSH    DS
            MOV     DS,Seg0040
            MOV     AL,DS:EgaFlags
            POP     DS
            BitinAL AX,0
            CMP     AL,0
            JE      @89
            Zero    AL
            JMP     @90
        @89:
            INC     AL
        @90:
            RET
IsCursorEm ENDP


IsWaitDisplay PROC FAR
              PUSH    DS
              MOV     DS,Seg0040
              MOV     AL,DS:EgaFlags
              POP     DS
              BitinAL AX,2
              RET
IsWaitDisplay ENDP


IsVideoSysActive PROC FAR
                  PUSH    DS
                  MOV     DS,Seg0040
                  MOV     AL,DS:EgaFlags
                  POP     DS
                  BitinAL AX,3
                  RET
IsVideoSysActive ENDP


IsSaveBuffer PROC FAR
              PUSH    DS
              MOV     DS,Seg0040
              MOV     AL,DS:EgaFlags
              POP     DS
              BitinAL AX,7
              RET
IsSaveBuffer ENDP


IsVGABoardActive PROC FAR
              PUSH    DS
              MOV     DS,Seg0040
              MOV     AL,DS:VgaFlags
              POP     DS
              BitinAL AX,0
              RET
IsVGABoardActive ENDP


VideoMemSize PROC FAR
              PUSH    DS
              MOV     DS,Seg0040
              MOV     AL,DS:EgaFlags
              MOV     CL,5
              SHR     AL,CL
              AND     AL,3
              INC     AL
              Zero    AH
              INC     CL
              SHL     AX,CL
              RET
VideoMemSize ENDP


IsGreySumm PROC FAR
            PUSH    DS
            MOV     DS,Seg0040
            MOV     AL,DS:VgaFlags
            POP     DS
            BitinAL AX,1
            RET
IsGreySumm ENDP


IsDefPalLoad PROC FAR
              PUSH    DS
              MOV     DS,Seg0040
              MOV     AL,DS:VgaFlags
              POP     DS
              BitinAL AX,3
              RET
IsDefPalLoad ENDP


GetScanLines PROC FAR
              PUSH    DS
              MOV     DS,Seg0040
              MOV     AL,DS:VgaFlags
              BitinAL AX,7
              SHR     AL,1
              MOV     BL,AL
              MOV     AL,DS:VgaFlags
              BitinAL AX,4
              ADD     AL,BL
              POP     DS
              RET
GetScanLines ENDP


SaveVideoState PROC FAR
StateType      EQU  (WORD  PTR [BP+10])
Buffer         EQU  (DWORD PTR [BP+6])
                StackFrameBP
                MOV       CX,StateType
                LES       BX,Buffer
                MOV       AX,1C01h
                INT       10h
                ExitCode  6
SaveVideoState ENDP


RestoreVideoState PROC FAR
StateType         EQU  (WORD  PTR [BP+10])
Buffer            EQU  (DWORD PTR [BP+6])
                   StackFrameBP
                   MOV       CX,StateType
                   LES       BX,Buffer
                   MOV       AX,1C02h
                   INT       10h
                   ExitCode  6
RestoreVideoState ENDP


GetStateBufferSize PROC FAR
StateType          EQU  (WORD  PTR [BP+6])
                   StackFrameBP
                   MOV       CX,StateType
                   MOV       AX,1C00h
                   INT       10h
                   MOV       AX,BX
                   ExitCode  2
GetStateBufferSize ENDP

GetDCC PROC FAR
            MOV  AX,1A00h
            INT  10h
            MOV  AX,BX
            XCHG AH,AL
            RET
GetDCC ENDP


SetDCC PROC FAR
Main   EQU  (BYTE PTR [BP+8])
Second EQU  (BYTE PTR [BP+6])
        StackFrameBP
        MOV       AX,1A01h
        MOV       BL,Main
        MOV       BH,Second
        INT       10h
        ExitCode  4
SetDCC ENDP


SetCurrentVideoSeg PROC NEAR
                    PUSH AX
                    PUSH DX
                    MOV  DX,3CEh
                    MOV  AL,6
                    OUT  DX,AL
                    INC  DX
                    IN   AL,DX
                    SHR  AL,1
                    SHR  AL,1
                    AND  AL,3
                    CMP  AL,2
                    JE   @SetMono
                    CMP  AL,3
                    JE   @SetColor
                    MOV  AX,SegA000
                    JMP  @SetSeg
           @SetMono:
                    MOV  AX,SegB000
                    JMP  @SetSeg
          @SetColor:
                    MOV  AX,SegB800
           @SetSeg:
                    MOV  CurrentVideoSeg,AX
                    POP  DX
                    POP  AX
                    RET
SetCurrentVideoSeg ENDP

SetVideoPage PROC FAR
Page           EQU  (BYTE PTR SS:[BX+4])
                StackFrame BX
                MOV        AL,Page
                MOV        AH,5h
                INT        10h
                CALL       SetRealPage
                CALL       SetCurrentVideoSeg
                CALL       SetActivePtr
                CMP        Hide,1
                JNE        @DontSet
                CALL       CursorOff
       @DontSet:
                RET        2
SetVideoPage ENDP



SetVideoMode  PROC FAR
Mode          EQU  (BYTE PTR SS:[BX+4])
              StackFrame BX
              MOV        AH,0
              MOV        AL,Mode
              INT        10h
              CALL       LocalWinSet
              CALL       SetRealPage
              CALL       SetCurrentVideoSeg
              CALL       SetActivePtr
              RET        2
SetVideoMode  ENDP


GetVideoMode  PROC  FAR
               PUSH DS
               MOV  DS,Seg0040
               MOV  AL,BYTE PTR DS:CrtMode
               POP  DS
               RET
GetVideoMode  ENDP


LogicCursor PROC NEAR
             MOV   LogicCursorPos,DX
             RET
LogicCursor ENDP


BiosCursor PROC NEAR
            MOV        AH,02H
            CALL       GetCurrentPage
            MOV        BH,AL
            INT        10h
            RET
BiosCursor ENDP


SetCursorPos PROC NEAR
              PUSH       AX
              CMP        Hide,0
              JE         @SetBiosCursor
              CALL       LogicCursor
              JMP        @SetCursorPosEnd
@SetBiosCursor:
              CALL       BiosCursor
@SetCursorPosEnd:
              POP        AX
              RET
SetCursorPos ENDP

CursorXY  PROC FAR
X         EQU  (BYTE PTR SS:[BX+6])
Y         EQU  (BYTE PTR SS:[BX+4])
           StackFrame BX
           MOV        DH,Y
           MOV        DL,X
           CALL       SetCursorPos
           RET        4
CursorXY  ENDP


WriteCharTTY PROC FAR
CharCode     EQU  (BYTE PTR [BP+10])
Attr         EQU  (BYTE PTR [BP+8])
Page         EQU  (BYTE PTR [BP+6])
              StackFrameBP
              MOV        AH,0Eh
              MOV        BH,Page
              MOV        AL,CharCode
              MOV        BL,Attr
              INT        10h
              ExitCode   6
WriteCharTTY ENDP


BiosWriteChar  PROC NEAR
                PUSH       AX
                MOV        BL,AH
                CALL       GetCurrentPage
                MOV        BH,AL
                POP        AX
                MOV        CX,1
                MOV        AH,09h
                INT        10h
                RET
BiosWriteChar  ENDP


BiosReadCharAttr   PROC NEAR
                    PUSH       DS
                    MOV        DS,Seg0040
                    MOV        BH,DS:CurrentPage
                    POP        DS
                    MOV        AH,8h
                    INT        10H
                    RET
BiosReadCharAttr   ENDP


TotalScanLines PROC     FAR
                PUSH    DS
                MOV     DS,Seg0040
                MOV     DX,DS:Addr6845
                MOV     AL,12H
                OUT     DX,AL
                INC     DL
                IN      AL,DX
                MOV     BL,AL
                Zero    AH
                DEC     DL
                MOV     AL,7
                OUT     DX,AL
                INC     DL
                IN      AL,DX
                MOV     BH,AL
                AND     AL,2
                SHR     AL,1
                OR      AH,AL
                AND     BH,01000000b
                MOV     CL,4
                SHR     BH,CL
                OR      AH,BH
                MOV     AL,BL
                INC     AX
                POP     DS
                RET
TotalScanLines ENDP


SetBlink  PROC FAR
B         EQU  (BYTE PTR [BP+6])
           StackFrameBP
           MOV  AX,1003h
           MOV  BL,B
           INT  10h
           ExitCode 2
SetBlink  ENDP


ReadPort_3D5h PROC NEAR
               PUSH DS
               MOV  DS,Seg0040
               MOV  DX,DS:Addr6845
               POP  DS
               OUT  DX,AL
               INC  DL
               IN   AL,DX
               RET
ReadPort_3D5h ENDP


SetStartAddress PROC  FAR
Hi               EQU  (BYTE PTR [BP+7])
Lo               EQU  (BYTE PTR [BP+6])
                 StackFrameBP
                 MOV       DX,Addr6845
                 MOV       AL,0Ch
                 MOV       AH,Lo
                 OUT       DX,AX
                 MOV       AH,Hi
                 INC       AL
                 OUT       DX,AX
                 ExitCode  2
SetStartAddress ENDP


IsDoubleScan PROC FAR
              MOV   AL,09h
              CALL  ReadPort_3D5h
              MOV   CL,7
              SHR   AL,CL
              RET
IsDoubleScan ENDP


ReadPort_3C0h PROC NEAR
               PUSHF
               CLI               ; Closing Interrupts
               MOV AH,AL         ; Saving Index in AH
               MOV DX,3DAh       ; DX = 3DAh (Video Port)
               IN  AL,DX         ; Reading in Port at DX (3DAh)
               MOV DL,192        ; DX = 3C0h
               MOV AL,AH         ; AL = AH = Index
               OR  AL,32         ; If Bit 5 is zero then isDefPalLoad = false
               OUT DX,AL         ; Writing in Port at DX (Index in DX)
               INC DL            ; DX = 3C1h
               IN  AL,DX         ; Reading our byte
               POPF
               RET
ReadPort_3C0h ENDP


WritePort_3C0h PROC    NEAR
               PUSHF
               MOV     BX,AX
               CLI                   ; Closing Interrupts
               MOV     DX,3DAh       ; Reading Port 3DAh
               IN      AL,DX
               MOV     DL,192        ; Now DX = 3C0h
               MOV     BX,AX
               XCHG    AL,AH
               OR      AL,32
               OUT     DX,AL
               INC     DL
               MOV     AL,AH
               OUT     DX,AL
               POPF
               RET
WritePort_3C0h         ENDP


IsBlink PROC      FAR
         MOV       AL,010h
         CALL      ReadPort_3C0h
         AND       AL,8
         BooleanAL AL
         RET
IsBlink ENDP


IsGraphMode PROC      FAR
         MOV       AL,010h
         CALL      ReadPort_3C0h
         AND       AL,1
         BooleanAL AL
         RET
IsGraphMode ENDP


SetScanLines PROC   FAR
Scan         EQU   (BYTE PTR [BP+6])
              StackFrameBP
              MOV        AH,12h
              MOV        BL,30h
              MOV        AL,Scan
              INT        10h
              ExitCode   2
SetScanLines ENDP


GetVideoInfo PROC FAR
Table        EQU  (DWORD PTR [BP+6])
              StackFrameBP
              MOV       AX,1B1Bh
              MOV       BX,0
              LES       DI,Table
              INT       10h
              ExitCode  4
GetVideoInfo ENDP


WaitRetrace PROC FAR
             MOV       DX,03DAh
      @Vert1:
             IN         AL,DX
             TEST       AL,8
             JNZ        @Vert1
      @Vert2:
             IN         AL,DX
             TEST       AL,8
             JZ         @Vert2
             RET
WaitRetrace ENDP


bReadPoint PROC FAR
X          EQU  (WORD PTR [BP+8])
Y          EQU  (WORD PTR [BP+6])
            StackFrameBP
            MOV       DX,Y
            MOV       CX,Y
            MOV       AH,0Dh
            INT       10h
            ExitCode  4
bReadPoint ENDP


bPutPoint PROC       FAR
X          EQU  (WORD PTR [BP+10])
Y          EQU  (WORD PTR [BP+8])
Color      EQU  (BYTE PTR [BP+6])
           StackFrameBP
           PUSH      DS
           MOV       DS,Seg0040
           MOV       BH,DS:CurrentPage
           POP       DS
           MOV       DX,Y
           MOV       CX,X
           MOV       AL,Color
           MOV       AH,0Ch
           INT       10h
           ExitCode  6
bPutPoint ENDP


GetPos  PROC NEAR
         XCHG      AH,AL
         ADD       BX,AX
         SHR       AX,1
         SHR       AX,1
         ADD       BX,AX
         MOV       AX,SegA000
         MOV       ES,AX
         RET
GetPos  ENDP


mPutPoint PROC FAR
X          EQU  (WORD PTR [BP+10])
Y          EQU  (WORD PTR [BP+8])
Color      EQU  (BYTE PTR [BP+6])
            StackFrameBP
            MOV       BX,X
            MOV       AX,Y
            CALL      GetPos
            MOV       AL,Color
            MOV       BYTE PTR ES:[BX],AL
            ExitCode  6
mPutPoint ENDP


mReadPoint PROC FAR
X          EQU  (WORD PTR [BP+8])
Y          EQU  (WORD PTR [BP+6])
            StackFrameBP
            MOV       AX,X
            MOV       BX,Y
            CALL      GetPos
            MOV       AL,ES:[BX]
            ExitCode  4
mReadPoint ENDP


Disable12h PROC NEAR
B          EQU  (BYTE PTR [BP+8])
            StackFrameBP
            MOV       AH,12h
            MOV       AL,B
            INT       10h
            ExitCode  0
Disable12h ENDP


DisableDefPalLoad PROC FAR
                   MOV   BL,31h
                   CALL  Disable12h
                   RET   2
DisableDefPalLoad ENDP


DisableVideoAddr PROC FAR
                   MOV   BL,32h
                   CALL  Disable12h
                   RET   2
DisableVideoAddr ENDP


DisableGreySumm  PROC FAR
                   MOV      BL,33h
                   CALL     Disable12h
                   RET 2
DisableGreySumm  ENDP


DisableCursorEm PROC FAR
                   MOV   BL,34h
                   CALL  Disable12h
                   RET   2
DisableCursorEm ENDP


DisableVideoRefr PROC FAR
                  MOV   BL,36h
                  CALL  Disable12h
                  RET   2
DisableVideoRefr ENDP


SetCGABorder PROC FAR
Color        EQU  (BYTE PTR SS:[BP+6])
              StackFrameBP
              MOV        AL,0Bh
              MOV        BH,00h
              MOV        BL,Color
              INT        10h
              ExitCode   2
SetCGABorder ENDP


SetCGAPalette PROC FAR
PalID         EQU  (BYTE PTR SS:[BP+6])
               StackFrameBP
               MOV        AL,0Bh
               MOV        BH,01h
               MOV        BL,PalID
               INT        10h
               ExitCode   2
SetCGAPalette ENDP


GetOverscanColor PROC   FAR
                  MOV   AX,1008h
                  INT   10h
                  MOV   AL,BH
                  RET
GetOverscanColor ENDP


SetOverscanColor PROC   FAR
Color            EQU  (BYTE PTR [BP+6])
                  StackFrameBP
                  MOV   AX,1008h
                  INT   10h
                  MOV   AL,BH
                  ExitCode 2
SetOverscanColor ENDP


SetDACPalette PROC FAR
Palette       EQU  (DWORD PTR [BP+6])
               StackFrameBP
               MOV        AX,1012h
               MOV        BX,0
               MOV        CX,256
               LES        DX,Palette
               INT        10h
               ExitCode   8
SetDACPalette ENDP


GetDACPalette PROC FAR
Palette       EQU  (DWORD PTR [BP+6])
               StackFrameBP
               MOV        AX,1017h
               MOV        BX,0
               MOV        CX,256
               LES        DX,Palette
               INT        10h
               ExitCode   8
GetDACPalette ENDP


GreySummDAC PROC FAR
StartReg    EQU  (WORD PTR [BP+8])
Count       EQU  (WORD PTR [BP+6])
             StackFrameBP
             MOV        AX,101Bh
             MOV        BX,StartReg
             MOV        CX,Count
             INT        10h
             ExitCode   4
GreySummDAC ENDP


bWriteString PROC FAR
StrOut       EQU  (DWORD PTR [BP+14])
X            EQU  (BYTE PTR  [BP+12])
Y            EQU  (BYTE PTR  [BP+10])
Attr         EQU  (BYTE PTR  [BP+8])
Page         EQU  (BYTE PTR  [BP+6])
              StackFrameBP
              MOV   AH,13h
              MOV   AL,01h
              MOV   BH,Page
              MOV   BL,Attr
              MOV   DH,Y
              MOV   DL,X
              LES   DI,StrOut
              MOV   CL,BYTE PTR ES:[DI]
              Zero  CH
              INC   DI
              PUSH  BP
              MOV   BP,DI
              INT   10h
              POP   BP
              ExitCode 12
bWriteString ENDP


SetEgaPalette PROC FAR
Palette       EQU  (DWORD PTR [BP+6])
               StackFrameBP
               MOV        AX,1002h
               LES        DX,Palette
               ExitCode   2
SetEgaPalette ENDP


GetEgaPalette PROC FAR
Palette       EQU  (DWORD PTR [BP+6])
               StackFrameBP
               MOV        AX,1009h
               LES        DX,Palette
               ExitCode   2
GetEgaPalette ENDP


GetEgaReg PROC FAR
EgaReg    EQU  (BYTE PTR [BP+6])
           StackFrameBP
           MOV       AX,1007H
           MOV       BL,EgaReg
           INT       10h
           MOV       AL,BH
           ExitCode  2
GetEgaReg ENDP


SetEgaReg PROC FAR
EgaReg    EQU  (BYTE PTR [BP+8])
Color     EQU  (BYTE PTR [BP+6])
           StackFrameBP
           MOV       AX,1000H
           MOV       BL,Reg
           MOV       BH,Color
           INT       10h
           ExitCode  4
SetEgaReg ENDP


pGetRGB   PROC FAR
Reg       EQU  (BYTE  PTR [BX+8])
RGB       EQU  (DWORD PTR [BX+4])
           StackFrame BX
           CLD
           LES        DI,RGB
           MOV        DX,3C7H
           MOV        AL,Reg
           OUT        DX,AL
           ADD        DL,2
           CLD
           MOV        CX,3
     Loop2:
           IN         AL,DX
           STOSB
           LOOP       Loop2
           RET        6
pGetRGB   ENDP


pSetRGB   PROC FAR
Reg       EQU  (BYTE  PTR [BX+8])
RGB       EQU  (DWORD PTR [BX+4])
           StackFrame BX
           PUSH       DS
           CLD
           LDS        SI,RGB
           MOV        DX,3C8H
           MOV        AL,Reg
           OUT        DX,AL
           INC        DL
           CLD
           MOV        CX,3
     Loop3:
           LODSB
           OUT        DX,AL
           LOOP       Loop3
           POP        DS
           RET        6
pSetRGB   ENDP


bGetRGB   PROC FAR
Reg       EQU  (BYTE  PTR [BX+8])
RGB       EQU  (DWORD PTR [BX+4])
           StackFrame BX
           MOV        AX,1015h
           INT        10h
           LES        DI,RGB
           MOV        BYTE PTR [DI],DH
           MOV        WORD PTR [DI+1],CX
           RET        6
bGetRGB   ENDP


bSetRGB   PROC FAR
Reg       EQU  (BYTE  PTR [BX+8])
RGB       EQU  (DWORD PTR [BX+4])
           StackFrame BX
           LES        DI,RGB
           MOV        DH,BYTE PTR [DI]
           MOV        CX,WORD PTR [DI+1]
           MOV        AX,1010h
           INT        10h
           RET        6
bSetRGB   ENDP


GetXYPos PROC NEAR
          PUSH AX
          MOV  AX,WindMax
          MOV  AL,AH
          INC  AL
          MUL  DH
          SHL  AX,1
          MOV  BX,AX
          MOV  AL,DL
          Zero AH
          SHL  AX,1
          ADD  AX,BX
          LES  BX,ActiveScreenPtr
          ADD  BX,AX
          POP  AX
          RET
GetXYPos ENDP

MemWriteChar PROC NEAR
              PUSH      ES
              PUSH      BX
              CALL      GetXYPos
              MOV       ES:[BX],AX
              POP       BX
              POP       ES
              RET
MemWriteChar ENDP


MemReadCharAttr PROC NEAR
                 PUSH      ES
                 PUSH      BX
                 CALL      GetXYPos
                 MOV       AX,ES:[BX]
                 POP       BX
                 POP       ES
                 RET
MemReadCharAttr ENDP





LocalWinSet PROC NEAR
             PUSH  DS
             MOV   DS,Seg0040
             MOV   AH,DS:CrtWidth
             MOV   AL,DS:CrtRows
             POP   DS
             DEC   AH
             MOV   WindMax,AX
             MOV   WindMin,0
             RET
LocalWinSet ENDP

InitIvGraph PROC FAR
             CALL  LocalWinSet
             CALL  SetCurrentVideoSeg
             MOV   Counter,0
             MOV   SetCounter,0
             MOV   Hide,0
             MOV   UseBios,0
             MOV   UsePorts,1
             MOV   TextChar,20h
             MOV   TextAttr,07h
             RET
InitIvGraph ENDP


Scroll PROC FAR
X1     EQU  (BYTE  PTR [BP+18])
Y1     EQU  (BYTE  PTR [BP+16])
X2     EQU  (BYTE  PTR [BP+14])
Y2     EQU  (BYTE  PTR [BP+12])
Num    EQU  (BYTE  PTR [BP+10])
Attr   EQU  (BYTE  PTR [BP+8])
Stype  EQU  (BYTE  PTR [BP+6])
        StackFrameBP
        MOV       CL,X1
        MOV       CH,Y1
        MOV       DL,X2
        MOV       DH,Y2
        MOV       BH,Attr
        MOV       AL,Num
        MOV       AH,Stype
        AND       AH,01h
        ADD       AH,06h
        INT       10h
        ExitCode  14h
Scroll ENDP


ScrollOne PROC FAR
           PUSH AX
           XCHG CH,CL
           XCHG DH,DL
           MOV  BH,TextAttr
           MOV  AL,1
           MOV  AH,6h
           INT  10h
           POP  AX
           RET
ScrollOne ENDP


LineFeed PROC NEAR
         PUSH CX
         MOV  CX,WindMin
         MOV  DX,WindMax
         CALL GetCursorXY
         CMP  AH,DL
         JNB  @LineScroll
         INC  AH
         JMP  @LineFeedEnd
@LineScroll:
         CMP  TrueScroll,1
         JE   @Scrolling
         JMP  @LineFeedEnd
@Scrolling:
         CALL ScrollOne
@LineFeedEnd:
         MOV  AL,CH
         MOV  DX,AX
         CALL SetCursorPos
         CMP  Counter,1
         JNE  @DontPause

@DontPause:
         POP  CX
         RET
LineFeed ENDP

AddOne PROC NEAR
        PUSH CX
        CALL GetCursorXY         ;AX = Cursor Position
        MOV  DX,WindMax
        CMP  AL,DH               ;If AL => THEN ?
        JAE  @NextStep1
        INC  AL
        MOV  DX,AX
        CALL SetCursorPos
        JMP  @AddOneExit
@NextStep1:
        CALL EndL
@AddOneExit:
        POP  CX
        RET
AddOne ENDP


WriteCharXY PROC FAR
X           EQU  (BYTE PTR [BP+12])
Y           EQU  (BYTE PTR [BP+10])
CharCode    EQU  (BYTE PTR [BP+8])
Attr        EQU  (BYTE PTR [BP+6])
             StackFrameBP
             MOV       DL,X
             MOV       DH,Y
             MOV       AL,CharCode
             MOV       AH,Attr
             CALL      MemWriteChar
@WriteCharXYExit:
             ExitCode  8
WriteCharXY ENDP


wBiosWriteChar PROC NEAR
                CALL      BiosWriteChar
                CALL      AddOne
                RET
wBiosWriteChar ENDP

wMemWriteChar PROC NEAR
               PUSH      AX
               CALL      GetCursorXY
               MOV       DX,AX
               POP       AX
               CALL      MemWriteChar
               CALL      AddOne
               RET
wMemWriteChar ENDP


WriteChar PROC FAR
CharCode  EQU  (BYTE PTR [BP+8])
Attr      EQU  (BYTE PTR [BP+6])
           StackFrameBP
           MOV       AH,Attr
           MOV       AL,CharCode
           CALL      wMemWriteChar
@WriteCharExit:
           ExitCode 4
WriteChar ENDP


WriteStr PROC FAR
St       EQU  (DWORD PTR [BP+8])
Attr     EQU  (BYTE  PTR [BP+6])
          StackFrameBP
          LES       DI,St
          Zero      CH
          MOV       CL,ES:[DI]
          INC       DI
          JCXZ      @WriteStrExit
          MOV       AH,Attr
@WriteMemStrLoop:
          MOV       AL,ES:[DI]
          MOV       AH,Attr
          INC       DI
          CALL      wMemWriteChar
          LOOP      @WriteMemStrLoop
@WriteStrExit:
          ExitCode  6
WriteStr ENDP


WriteStrXY PROC FAR
X          EQU  (BYTE  PTR [BP+14])
Y          EQU  (BYTE  PTR [BP+12])
Attr       EQU  (BYTE  PTR [BP+10])
St         EQU  (DWORD PTR [BP+6])
            StackFrameBP
            MOV       DL,X
            MOV       DH,Y
            CALL      GetCursorXY
            PUSH      AX
            CALL      SetCursorPos
            MOV       AL,Attr
            PUSH      St
            PUSH      AX
            CALL      WriteStr
            POP       DX
            CALL      SetCursorPos
            ExitCode  10
WriteStrXY ENDP

ReadChar   PROC FAR
            CALL GetCursorXY
            MOV  DX,AX
            CALL MemReadCharAttr
@ReadCharExit:
            RETF
ReadChar   ENDP


ReadAttr PROC FAR
          CALL GetCursorXY
          MOV  DX,AX
          CALL MemReadCharAttr
@ReadAttrExit:
          MOV  AL,AH
          RETF
ReadAttr ENDP


ReadCharXY PROC FAR
X          EQU  (BYTE PTR [BP+8])
Y          EQU  (BYTE PTR [BP+6])
            StackFrameBP
            MOV       DH,X
            MOV       DL,Y
            CALL      MemReadCharAttr
            ExitCode  4
ReadCharXY ENDP


ReadAttrXY PROC FAR
X          EQU  (BYTE PTR [BP+8])
Y          EQU  (BYTE PTR [BP+6])
            StackFrameBP
            MOV       DH,X
            MOV       DL,Y
            CALL      MemReadCharAttr
            MOV       AL,AH
            ExitCode  4
ReadAttrXY ENDP


FillAttr  PROC FAR
Attr      EQU  (BYTE PTR [BP+8])
Count     EQU  (BYTE PTR [BP+6])
           StackFrameBP
           MOV       CL,Count
           Zero      CH
           JCXZ      @FillAttrEnd
@FillAttrLoop:
           PUSH      CX
           CALL      ReadChar
           PUSH      AX
           MOV       AL,Attr
           PUSH      AX
           CALL      WriteChar
           POP       CX
           LOOP      @FillAttrLoop
@FillAttrEnd:
           ExitCode  4
FillAttr  ENDP


FillAttrXY PROC FAR
X         EQU  (BYTE PTR [BP+12])
Y         EQU  (BYTE PTR [BP+10])
Attr      EQU  (BYTE PTR [BP+8])
Count     EQU  (BYTE PTR [BP+6])
           StackFrameBP
           MOV       CL,Count
           Zero      CH
           JCXZ      @FillAttrXYEnd
           MOV       TrueScroll,0
           MOV       DH,Y
           MOV       DL,X
           CALL      GetCursorXY
           PUSH      AX
           CALL      SetCursorPos
           MOV       AL,Attr
           PUSH      AX
           MOV       AL,CL
           PUSH      AX
           CALL      FillAttr
           POP       DX
           CALL      SetCursorPos
@FillAttrXYEnd:
           MOV       TrueScroll,1
           ExitCode  8
FillAttrXY ENDP


WriteAttr PROC FAR
Attr      EQU  (BYTE PTR [BP+6])
           StackFrameBP
           CALL      ReadChar
           PUSH      AX
           MOV       AL,Attr
           PUSH      AX
           CALL      WriteChar
           ExitCode  2
WriteAttr ENDP


PlaneWrite PROC FAR
St         EQU  (DWORD PTR [BP+6])
            StackFrameBP
            LES       DI,St
            MOV       CL,ES:[DI]
            INC       DI
            Zero      CH
            JCXZ      @PlaneWriteEnd
@PlaneWriteLoop:
            PUSH      CX
            MOV       AL,ES:[DI]
            INC       DI
            PUSH      AX
            CALL      ReadAttr
            PUSH      AX
            CALL      WriteChar
            POP       CX
            LOOP      @PlaneWriteLoop
@PlaneWriteEnd:
            ExitCode  4
PlaneWrite ENDP


PlaneWriteXY PROC FAR
X            EQU  (BYTE PTR [BP+12])
Y            EQU  (BYTE PTR [BP+10])
St           EQU  (DWORD PTR [BP+6])
              StackFrameBP
              MOV       DH,Y
              MOV       DL,X
              CALL      GetCursorXY
              PUSH      AX
              CALL      SetCursorPos
              PUSH      St
              MOV       TrueScroll,0
              CALL      PlaneWrite
              POP       DX
              CALL      SetCursorPos
              MOV       TrueScroll,1
              ExitCode  8
PlaneWriteXY ENDP


ClrScr  PROC FAR
         PUSH DS
         MOV  DS,Seg0040
         MOV  CX,DS:VideoBuffSize
         POP  DS
         SHR  CX,2
         LES  DI,ActiveScreenPtr
         MOV  BL,TextChar
         MOV  BH,TextAttr
         CALL IsGraphMode
         CMP  AL,1
         JE   @GraphClear
         MOV  AX,BX
         SHL  EAX,16
         MOV  AX,BX
         JMP  @ClearExit
@GraphClear:
         Zero EAX
@ClearExit:
         REP  STOSD
         RET
ClrScr  ENDP


LineX   PROC FAR
X1      EQU  (WORD PTR [BP+12])
X2      EQU  (WORD PTR [BP+10])
Y       EQU  (WORD PTR [BP+8])
Color   EQU  (BYTE PTR [BP+6])
         StackFrameBP
         MOV      CX,X2
         CMP      CX,X1
         JNB      @@ResetArgs
         XCHG     CX,X1
@@ResetArgs:
         SUB      CX,X1
         JCXZ     @@LoopEnd_1
         MOV      BX,X1
         MOV      AX,Y
         CALL     GetPos
         MOV      AL,Color
         MOV      DI,BX
         CALL     FastFill
@@LoopEnd_1:
         ExitCode 8
LineX   ENDP

LineY   PROC FAR
X       EQU  (WORD PTR [BP+12])
Y1      EQU  (WORD PTR [BP+10])
Y2      EQU  (WORD PTR [BP+8])
Color   EQU  (BYTE PTR [BP+6])
         StackFrameBP
         MOV      CX,Y2
         MOV      DI,Y1
         SUB      CX,DI
         JCXZ     @@Ende
         JG       @@Make_VLine
         NEG      CX
         MOV      DI,Y2
@@Make_VLine:
         MOV      ES,SegA000
         MOV      AX,320
         MUL      DI
         ADD      AX,X
         MOV      DI,AX
         CLD
         MOV      AL,Color
         MOV      DX,320
     @l1:
         MOV      ES:[DI],AL
         ADD      DI,DX
         LOOP     @l1
@@Ende:
         ExitCode 8
LineY   ENDP


FastFill PROC NEAR
          MOV  AH,AL
          PUSH AX
          SHL  EAX,16
          POP  AX
          PUSH CX
          SHR  CX,2
          REP  STOSD
          POP  CX
          AND  CX,3
          REP  STOSB
          RET
FastFill ENDP

CODE  ENDS

      END
