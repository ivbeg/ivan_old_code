include ASMMACRO.INC



DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA


      EXTRN   DiskResult       : TFunctionResult

DATA  ENDS


int13h_ResetDisk                   EQU  00h
int13h_GetStatus                   EQU  01h
int13h_ReadSectors                 EQU  02h
int13h_WriteSectors                EQU  03h
int13h_VerifySectors               EQU  04h
int13h_GetDriveParms               EQU  08h
int13h_InitializeController        EQU  09h
int13h_ReadLongSectors             EQU  0Ah
int13h_WriteLongSectors            EQU  0Bh
int13h_SeekToCyllinder             EQU  0Ch
int13h_ResetHardDisk               EQU  0Dh
int13h_CheckDriveReady             EQU  10h
int13h_RecalibrateDisk             EQU  11h
int13h_GetDiskType                 EQU  15h
int13h_DetectDiskChange            EQU  16h


disk_error_NoError                 EQU  00h
disk_error_DriveNotReady           EQU  0AAh

int_DiskInterrupt                  EQU  13h


CODE  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA

      PUBLIC  ResetDisk,InitializeController
      PUBLIC  ResetHardDisk,RecalibrateDisk,CheckDriveReady
      PUBLIC  ReadSectors, ReadLongSectors, VerifySectors
      PUBLIC  WriteSectors, WriteLongSectors, SeekToCyllinder


      .386


Disk_Int_Call  PROC FAR
   PUSH      GS
   macro_SetDATA_GS
   MOV       BYTE PTR GS:[DiskResult].Interrupt, int_DiskInterrupt
   PUSH      AX
   SHR       AX, 8
   MOV       WORD PTR GS:[DiskResult].Function, AX
   POP       AX
   MOV       WORD PTR GS:[DiskResult].Result, disk_error_NoError
   MOV       DWORD PTR GS:[DiskResult].CalledAddr, 00000h
   INT       int_DiskInterrupt
   POP       GS
   macro_SetDATA_GS
   JNC       @@Disk_Call_No_Errors
   MOV       AL, AH
   macro_Zero  AH
   MOV       WORD PTR GS:[DiskResult].Result, AX
   CALL      DWORD PTR GS:[DiskResult].ErrorProc
@@Disk_Call_No_Errors:
   RET
Disk_Int_Call  ENDP


ResetDisk  PROC FAR
  Disk        EQU   (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int13h_ResetDisk
   MOV       DL, Disk
   CALL      Disk_Int_Call
   RET       2
ResetDisk  ENDP



InitializeController  PROC FAR
  Disk        EQU   (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int13h_InitializeController
   MOV       DL, Disk
   CALL      Disk_Int_Call
   RET       2
InitializeController  ENDP


ResetHardDisk     PROC FAR
  Disk        EQU   (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int13h_ResetHardDisk
   MOV       DL, Disk
   CALL      Disk_Int_Call
   RET       2
ResetHardDisk     ENDP


RecalibrateDisk  PROC FAR
  Disk        EQU   (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int13h_RecalibrateDisk
   MOV       DL, Disk
   CALL      Disk_Int_Call
   RET       2
RecalibrateDisk  ENDP


CheckDriveReady  PROC FAR
  Disk        EQU   (BYTE PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AH, int13h_CheckDriveReady
   MOV       DL, Disk
   PUSH      GS
   macro_SetDATA_GS
   MOV       BYTE PTR GS:[DiskResult].Interrupt, int_DiskInterrupt
   MOV       WORD PTR GS:[DiskResult].Function, AX
   MOV       WORD PTR GS:[DiskResult].Result, disk_error_NoError
   MOV       DWORD PTR GS:[DiskResult].CalledAddr, 00000h
   INT       13h
   POP       GS
   macro_SetDATA_GS
   JC        @@CheckDrive_Check
   MOV       AL, boolean_False
   JMP       @@CheckDrive_No_Errors
@@CheckDrive_Check:
   CMP       AH, disk_error_DriveNotReady
   JNE       @@CheckDrive_Error
   MOV       AL, boolean_True
@@CheckDrive_Error:
   OR        AL, AL
   MOV       AH, AL
   MOV       WORD PTR GS:[DiskResult].Result, AX
   CALL      DWORD PTR GS:[DiskResult].ErrorProc
@@CheckDrive_No_Errors:
   RET       2
CheckDriveReady  ENDP


Disk_Services  PROC NEAR
  Disk        EQU   (BYTE  PTR SS:[BX+18])
  Cyllinder   EQU   (WORD  PTR SS:[BX+16])
  Head        EQU   (BYTE  PTR SS:[BX+14])
  StartSector EQU   (BYTE  PTR SS:[BX+12])
  SectorsNum  EQU   (BYTE  PTR SS:[BX+10])
  Buffer      EQU   (DWORD PTR SS:[BX+6])
   macro_StackFrame BX
   MOV       AL, SectorsNum
   PUSH      AX
   MOV       AX, Cyllinder
   MOV       DL, Disk
   MOV       DH, Head
   MOV       CL, StartSector
   AND       CL, 03Fh
   ROR       AH, 2
   AND       AH, 0C0h
   MOV       CH, AL
   OR        CL, AH
   LES       BX, Buffer
   POP       AX
   CALL      Disk_Int_Call
   RET
Disk_Services  ENDP


ReadSectors  PROC FAR
   MOV       AH, int13h_ReadSectors
   CALL      Disk_Services
   RET       14
ReadSectors  ENDP


ReadLongSectors  PROC FAR
   MOV       AH, int13h_ReadLongSectors
   CALL      Disk_Services
   RET       14
ReadLongSectors  ENDP


VerifySectors  PROC FAR
   MOV       AH, int13h_VerifySectors
   CALL      Disk_Services
   RET       14
VerifySectors  ENDP


WriteSectors  PROC FAR
   MOV       AH, int13h_WriteSectors
   CALL      Disk_Services
   RET       14
WriteSectors  ENDP


WriteLongSectors  PROC FAR
   MOV       AH, int13h_WriteSectors
   CALL      Disk_Services
   RET       14
WriteLongSectors  ENDP


SeekToCyllinder  PROC FAR
  Disk        EQU   (BYTE  PTR SS:[BX+10])
  Cyllinder   EQU   (WORD  PTR SS:[BX+8])
  Head        EQU   (BYTE  PTR SS:[BX+6])
  StartSector EQU   (BYTE  PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       AX, Cyllinder
   MOV       DL, Disk
   MOV       DH, Head
   MOV       CL, StartSector
   AND       CL, 03Fh
   ROR       AH, 2
   AND       AH, 0C0h
   MOV       CH, AL
   OR        CL, AH
   MOV       AH, int13h_SeekToCyllinder
   CALL      Disk_Int_Call
   RET
SeekToCyllinder  ENDP

CODE  ENDS


      END
