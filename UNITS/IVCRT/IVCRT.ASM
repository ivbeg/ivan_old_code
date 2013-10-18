INCLUDE MACRO.INC


; Coordinate record
X               EQU     (BYTE PTR 0)
Y               EQU     (BYTE PTR 1)

;Bios Area Imitation
CrtMode         EQU     (BYTE  PTR 49h)
CrtWidth        EQU     (BYTE  PTR 4Ah)
VideoBuffSize   EQU     (WORD  PTR 4Ch)
PageOffset      EQU     (WORD  PTR 4Eh)
CursorPos       EQU     (WORD  PTR 50h)
CursorSize      EQU     (WORD  PTR 60h)
ActivePage      EQU     (BYTE  PTR 62h)
Addr6845        EQU     (WORD  PTR 63h)
CrtModeSet      EQU     (BYTE  PTR 65h)
CrtPalette      EQU     (BYTE  PTR 66h)
Timer           EQU     (DWORD PTR 6Ch)
CrtRows         EQU     (BYTE  PTR 84h)
CrtInfo         EQU     (BYTE  PTR 87h)

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA

              ;External Variables
      EXTRN SegB000:WORD,SegB800:WORD,Seg0040:WORD  ;External System.TPU Variables
      EXTRN WindMin:WORD,WindMax:WORD               ;IVCRT.TPU Variables
      EXTRN Hide:BYTE,Counter:BYTE,SetCounter:BYTE
      EXTRN CurrVideoSeg:WORD,TextAttr:BYTE,TextChar:BYTE
      EXTRN DosOutPut:BYTE,OutputHandle:WORD
      EXTRN CurrentVideoSeg:BYTE,UseBios:BYTE       ;IVGRAPH.TPU Variables

              ;External Procedures
      EXTRN CursorXY:FAR,GetX:FAR,GetY:FAR

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC


XYPosToWord PROC NEAR

XYPosToWord ENDP


AsmWriteString PROC FAR
ScreenStart    EQU  (DWORD PTR [BP+20])
X              EQU  (BYTE  PTR [BP+18])
Y              EQU  (BYTE  PTR [BP+16])
Cols           EQU  (BYTE  PTR [BP+14])
Rows           EQU  (BYTE  PTR [BP+12])
Attr           EQU  (BYTE  PTR [BP+10])
St             EQU  (DWORD PTR [BP+6])
                StackFrameBP
                LES DI,ScreenStart
                MOV CL,Cols

                ExitCode 18
AsmWriteString ENDP

AsmWritePchar PROC FAR
ScreenStart    EQU  (DWORD PTR [BP+20])
X              EQU  (BYTE  PTR [BP+18])
Y              EQU  (BYTE  PTR [BP+16])
Width          EQU  (BYTE  PTR [BP+14])
Cols           EQU  (BYTE  PTR [BP+12])
Attr           EQU  (BYTE  PTR [BP+10])
St             EQU  (DWORD PTR [BP+6])
                StackFrameBP
                LES

                ExitCode 18
AsmWritePchar ENDP





ClrScr PROC FAR
        PUSH DS
        MOV  CX,DS:VideoBuffSize
        POP  DS
        MOV  ES,CurrentVideoSeg
        MOV  DI,DS:PageOffset
        POP  DS
        Zero AX
        REP  STOSW
        RET
ClrScr ENDP

EndL PROC FAR

EndL ENDP


CODE  ENDS

      END
