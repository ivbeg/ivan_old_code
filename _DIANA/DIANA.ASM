

DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA

   EXTRN     DOS_DiskResult    : TFunctionResult
   EXTRN     BIOS_DiskResult   : TFunctionResult


DATA  ENDS





CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

                   .386

;------------------------------- CONSTANTS PART -----------------------------
;
; Include all interrupts functions used in this program



int__DOS_ReadSectors               EQU   025h
int__DOS_WriteSectors              EQU   026h


int__BIOS_DiskAccess               EQU   013h



;---------------------------- PROCEDURES PART -------------------------------
;       Interrupt 25h,26h (MS-DOS Read/Write logical sectors)
;       used to direct access to MS-DOS logical drives
;       First sector is 0000h





DOS_OldDisk_IO  PROC NEAR

DOS_OldDisk_IO  ENDP


DOS_Disk_IO  PROC NEAR

DOS_Disk_IO  ENDP


DOS_OldReadSectors  PROC FAR
  DOS_DriveNumber    EQU (BYTE PTR  SS:[BP+14])
  StartingSector     EQU (WORD PTR  SS:[BP+12])
  NumberOfSectors    EQU (WORD PTR  SS:[BP+10])
  DataBuffer         EQU (DWORD PTR SS:[BP+6])
    macro_StackFrameBP
    macro_SetDATA_GS    
    PUSH       DS
    MOV        AL, DOS_DriveNumber
    MOV        DX, StartingSector
    MOV        CX, NumberOfSectors
    LDS        BX, DataBuffer
    INT        int__DOS_ReadSectors
    POP        DS    
    JNC        @@DOS_OldReadSectors__Ok

  @@DOS_OldReadSectors__Ok:
    macro_ExitCode  10
DOS_OldReadSectors  ENDP


DOS_OldWriteSectors  PROC FAR
  DOS_DriveNumber    EQU (BYTE PTR  SS:[BP+14])
  StartingSector     EQU (WORD PTR  SS:[BP+12])
  NumberOfSectors    EQU (WORD PTR  SS:[BP+10])
  DataBuffer         EQU (DWORD PTR SS:[BP+6])
    macro_StackFrameBP
    macro_SetDATA_GS    
    PUSH       DS
    MOV        AL, DOS_DriveNumber
    MOV        DX, StartingSector
    MOV        CX, NumberOfSectors
    LDS        BX, DataBuffer
    INT        int__DOS_WriteSectors
    POP        DS
    JNC        @@DOS_OldWriteSectors__Ok
    
  @@DOS_OldWriteSectors__Ok:
    macro_ExitCode  10    
DOS_OldWriteSectors  ENDP



DOS_ReadSectors  PROC FAR
  DOS_DriveNumber    EQU (BYTE PTR  SS:[BP+10])
  DOS_DiskPacket     EQU (DWORD PTR SS:[BP+6])
    macro_StackFrameBP
    macro_SetDATA_GS    
    PUSH       DS
    MOV        AL, DOS_DriveNumber
    LDS        BX, DOS_DiskPacket
    INT        int__DOS_ReadSectors
    POP        DS
    JNC        @@DOS_ReadSectors__Ok

@@DOS_ReadSectors__Ok:
    macro_ExitCode  6
DOS_ReadSectors  ENDP


DOS_WriteSectors  PROC FAR
  DOS_DriveNumber    EQU (BYTE PTR  SS:[BP+10])
  DOS_DiskPacket     EQU (DWORD PTR SS:[BP+6])
    macro_StackFrameBP
    macro_SetDATA_GS    
    PUSH       DS
    MOV        AL, DOS_DriveNumber
    LDS        BX, DOS_DiskPacket
    INT        int__DOS_WriteSectors
    POP        DS
    JNC        @@DOS_WriteSectors__Ok

@@DOS_WriteSectors__Ok:
    macro_ExitCode  6
DOS_WriteSectors  ENDP
