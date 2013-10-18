INCLUDE	Macro.INC


DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA

      EXTRN   DiskResult: TFunctionResult

intDiskInterrupt     EQU    13h


dcomResetDisk		EQU    00h
dcomGetDiskStatus	EQU    01h
dcomReadSectors		EQU    02h
dcomWriteSectors	EQU    03h
dcomVerifySectors	EQU    04h
dcomFormatTrack		EQU    05h
dcomInitHardDiskTables	EQU    09h
dcomReadLongSectors	EQU    0Ah
dcomWriteLongSectors	EQU    0Bh
dcomSeekToCyllinder	EQU    0Ch
dcomResetHardDisk	EQU    0Dh
dcomRecalibrateDrive	EQU    11h
dcomControllerIntDiag	EQU    14h
dcomGetDiskType		EQU    15h
dcomSetFloppyFormatType	EQU    17h
dcomSetMediaType	EQU    18h

derrNoError		EQU    00h


DATA  ENDS


CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

      PUBLIC  ResetDisk, GetDiskStatus
      PUBLIC  ResetHardDisk, GetDiskType
      PUBLIC  SetFloppyFormatType, RecalibrateDrive
      PUBLIC  ControllerIntDiag, SetMediaType
      PUBLIC  ReadFromDisk, WriteToDisk, VerifyDisk
      PUBLIC  InitHardDiskTables


.386

Disk_IO		   PROC	  NEAR
	    PUSH     GS
	    mcSetDATA_GS
	    MOV	     BYTE PTR GS:[DiskResult].Interrupt, intDiskInterrupt
	    MOV	     WORD PTR GS:[DiskResult].Result, derrNoError
	    INT	     13h
	    POP	     GS
	    mcSetDATA_GS
	    JNC	     @@Disk_3_NoError
	    XCHG     AL, AH
	    MOV	     WORD PTR GS:[DiskResult].Result,AX
	    CALL     DWORD PTR GS:[DiskResult].ErrorProc
@@Disk_3_NoError:
	    RET
Disk_IO		   ENDP


ResetDisk	   PROC	   FAR
 Disk	      EQU  SS:[BX+4]
	       mcStackFrame BX
	       MOV	    AH,	dcomResetDisk
	       MOV	    DL,	Disk
	       CALL	    Disk_IO
	       RET	    2
ResetDisk	   ENDP


ResetHardDisk	   PROC	   FAR
 Disk	      EQU  SS:[BX+4]
	       mcStackFrame BX
	       MOV	    AH,	dcomResetHardDisk
	       MOV	    DL,	Disk
	       CALL	    Disk_IO
	       RET	    2
ResetHardDisk	   ENDP


GetDiskStatus	   PROC	   FAR
 Disk	      EQU  SS:[BX+4]
	       mcStackFrame BX
	       MOV	    AH,	dcomGetDiskStatus
	       MOV	    DL,	Disk
	       CALL	    Disk_IO
	       RET	    2
GetDiskStatus	   ENDP


GetDiskType	   PROC	   FAR
 Disk	      EQU  SS:[BX+4]
	       mcStackFrame BX
	       MOV	    AH,	dcomGetDiskType
	       MOV	    DL,	Disk
	       CALL	    Disk_IO
	       RET	    2
GetDiskType	   ENDP


SetFloppyFormatType PROC   FAR
 Disk	      EQU  SS:[BX+6]
 FormatType   EQU  SS:[BX+4]
	       mcStackFrame BX
	       MOV	    AH,	dcomSetFloppyFormatType
	       MOV	    DL,	Disk
	       MOV	    AL,	FormatType
	       CALL	    Disk_IO
	       RET	    4
SetFloppyFormatType ENDP


SetMediaType	   PROC	  FAR
 Disk	      EQU  SS:[BX+8]
 Cyllinders   EQU  SS:[BX+6]
 Sectors      EQU  SS:[BX+4]
	       mcStackFrame BX
	       MOV	    AH,	dcomSetMediaType
	       MOV	    CH,	BYTE PTR [Cyllinders]
	       MOV	    AL,	BYTE PTR [Cyllinders+1]
	       MOV	    CL,	Sectors
	       AND	    CL,	00111111b
	       SHL	    AL,	6
	       OR	    CL,	AL
	       MOV	    DL,	Disk
	       CALL	    Disk_IO
	       RET	    6
SetMediaType	   ENDP


ControllerIntDiag  PROC	  FAR
	       MOV	    AH,	dcomControllerIntDiag
	       CALL	    Disk_IO
	       RET
ControllerIntDiag  ENDP


RecalibrateDrive   PROC	  FAR
 Disk	      EQU  SS:[BX+4]
	       mcStackFrame BX
	       MOV	    AH,	dcomRecalibrateDrive
	       MOV	    DL,	Disk
	       CALL	    Disk_IO
	       RET	    2
RecalibrateDrive   ENDP


ReadFromDisk	   PROC	  FAR
 SecNum	      EQU  SS:[SI+16]
 Cyllinder    EQU  SS:[SI+14]
 StartSec     EQU  SS:[SI+12]
 Head	      EQU  SS:[SI+10]
 Drive	      EQU  SS:[SI+8]
 Buffer	      EQU  SS:[SI+4]
	       MOV	    AH,	dcomReadSectors
@@R_W_V_Jump:
	       mcStackFrame SI
	       MOV	    CH,	BYTE PTR Cyllinder
	       MOV	    AL,	BYTE PTR [Cyllinder+1]
	       MOV	    CL,	StartSec
	       AND	    CL,	00111111b
	       SHL	    AL,	6
	       OR	    CL,	AL
	       MOV	    DH,	Head
	       MOV	    DL,	Drive
	       LES	    BX,	Buffer
	       MOV	    AL,	SecNum
	       CALL	    Disk_IO
	       RET 14
ReadFromDisk	   ENDP


WriteToDisk	   PROC	  FAR
	       MOV	    AH,	dcomWriteSectors
	       JMP	    @@R_W_V_Jump
WriteToDisk	   ENDP


VerifyDisk	   PROC	  FAR
	       MOV	    AH,	dcomVerifySectors
	       JMP	    @@R_W_V_Jump
VerifyDisk	   ENDP


InitHardDiskTables PROC	  FAR
 Disk	      EQU  SS:[BX+4]
	       mcStackFrame BX
	       MOV	    AH,	dcomInitHardDiskTables
	       MOV	    DL,	Disk
	       CALL	    Disk_IO
	       RET	    2
InitHardDiskTables ENDP



CODE  ENDS

      END
