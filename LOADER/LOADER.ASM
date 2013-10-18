DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA


eOtherComputer EQU 0FEh
eSizeChanged   EQU 0FFh

eModulesNumber EQU 0Ah

eSftRecordSize EQU 3Bh


        Module1     DD 0000h
        Module2     DD 0000h
        Module3     DD 0000h
        Module4     DD 0000h
        Module5     DD 0000h
        Module6     DD 0000h
        Module7     DD 0000h
        Module8     DD 0000h
        Module9     DD 0000h
        Module10    DD 0000h

DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME  CS:CODE,DS:DATA

      PUBLIC  _GetRegistratingStatus,_SetRegistrate

.386

_ModulesNames     DD eModulesNumber DUP (0)

_CodeError        DB 00h

_CodeFileHandle   DW 0FFFFh
_CodeOffsetsTable DW 0010h
                  DW 0232h
                  DW 0421h

_CodeBytesTable   DB 0
                  DB 0
                  DB 0

_ModulesOffsets   DW 100h
                  DW 147h
                  DW 495h
                  DW 033h
                  DW 543h
                  DW 2D4h
                  DW 345h
                  DW 509h
                  DW 089h
                  DW 3F1h

_ModulesClusters  DW eModulesNumber DUP (0)
_ModuleHandle     DW 0FFFFh



_InitModulesNames PROC NEAR
                   MOV  EAX,Module1
                   MOV  _ModulesNames,EAX
                   MOV  EAX,Module2
                   MOV  _ModulesNames[4],EAX
                   MOV  EAX,Module3
                   MOV  _ModulesNames[8],EAX
                   MOV  EAX,Module4
                   MOV  _ModulesNames[12],EAX
                   MOV  EAX,Module5
                   MOV  _ModulesNames[16],EAX
                   MOV  EAX,Module6
                   MOV  _ModulesNames[20],EAX
                   MOV  EAX,Module7
                   MOV  _ModulesNames[24],EAX
                   MOV  EAX,Module8
                   MOV  _ModulesNames[28],EAX
                   MOV  EAX,Module9
                   MOV  _ModulesNames[32],EAX
                   MOV  EAX,Module10
                   MOV  _ModulesNames[36],EAX
                   RET
_InitModulesNames ENDP


CodeFileName      DB 'DATA.BIN',0

_CharWordToByte PROC NEAR
                 SUB AH,30h
                 MOV BL,AH
                 SUB AL,30h
                 MOV BH,10
                 MUL BH
                 ADD AL,BL
                 RET
_CharWordToByte ENDP


_ByteToCharWord PROC NEAR
                 CMP  AL,10
                 JB   @@Lower_Ten
                 MOV  BL,AL
                 MOV  BH,10
                 MOV  AH,0
                 DIV  BH
                 ADD  AH,30h
                 ADD  AL,30h
                 XCHG AL,AH
                 RET
@@Lower_Ten:
                 MOV  AH,30h
                 ADD  AL,AH
                 RET
_ByteToCharWord ENDP


_OpenCodeFile PROC NEAR
              MOV  _CodeError,0
              PUSH DS
              MOV  AX,CS
              MOV  DS,AX
              LEA  DX,CodeFileName
              MOV  AX,3D02h
              INT  21h
              POP  DS
              JNC  @@Proceed_Open
              MOV  _CodeError,AL
@@Proceed_Open:
              MOV _CodeFileHandle,AX
              RET
_OpenCodeFile ENDP


_CloseCodeFile PROC NEAR
                MOV AH,3Eh
                MOV BX,_CodeFileHandle
                INT 21h
                RET
_CloseCodeFile ENDP


_SeekCodeFile PROC NEAR
               MOV  _CodeError,0
               MOV  AX,4200h
               MOV  BX,_CodeFileHandle
               MOV  CX,0
               INT  21h
               JNC  @@Proceed_Seek
               MOV  _CodeError,AL
@@Proceed_Seek:
               RET
_SeekCodeFile ENDP


_GetCodeFileSize PROC NEAR
                  MOV  _CodeError,0
                  MOV  AX,4202h
                  MOV  BX,_CodeFileHandle
                  MOV  DX,0
                  MOV  CX,DX
                  INT  21h
                  JNC  @@Proceed_GetSize
                  MOV  _CodeError,AL
@@Proceed_GetSize:
                  RET
_GetCodeFileSize ENDP


_ReadCodeFile PROC NEAR
               PUSH DS
               MOV  AH,3Fh
               MOV  BX,_CodeFileHandle
               PUSH AX
               MOV  AX,CS
               MOV  DS,AX
               POP  AX
               LEA  DX,_CodeBytesTable
               ADD  DX,3
               SUB  DX,CX
               MOV  CX,1
               INT  21h
               JNC  @@Proceed_ReadFile
               MOV  _CodeError,AL
@@Proceed_ReadFile:
               POP  DS
               RET
_ReadCodeFile ENDP


_WriteCodeFile PROC NEAR
                PUSH DS
                MOV  AH,40h
                MOV  BX,_CodeFileHandle
                PUSH AX
                MOV  AX,CS
                MOV  DS,AX
                POP  AX
                LEA  DX,_CodeBytesTable
                ADD  DX,3
                SUB  DX,CX
                MOV  CX,1
                INT  21h
                JNC  @@Proceed_WriteFile
                MOV  _CodeError,AL
@@Proceed_WriteFile:
                POP  DS
                RET
_WriteCodeFile ENDP


_ReadCodeFromFile PROC NEAR
                   MOV  CX,3
                   PUSH AX
                   MOV  AX,CS
                   MOV  ES,AX
                   POP  AX
                   LEA  DI,_CodeOffsetsTable
@@ReadFileCodeLoop:
                   PUSH CX
                   MOV  DX,WORD PTR ES:[DI]
                   CALL _SeekCodeFile
                   JC   @@ReadFileCodeError
                   POP  CX
                   PUSH CX
                   CALL _ReadCodeFile
                   JC   @@ReadFileCodeError
                   ADD  DI,2
                   POP  CX
                   LOOP @@ReadFileCodeLoop
                   RET
@@ReadFileCodeError:
                   STC
                   RET
_ReadCodeFromFile ENDP


_WriteCodeInFile PROC NEAR
                  MOV  CX,3
                  PUSH AX
                  MOV  AX,CS
                  MOV  ES,AX
                  POP  AX
                  LEA  DI,_CodeOffsetsTable
@@WriteFileCodeLoop:
                  PUSH CX
                  MOV  DX,WORD PTR ES:[DI]
                  ADD  DI,2
                  CALL _SeekCodeFile
                  JC   @@WriteFileCodeError
                  POP  CX
                  PUSH CX
                  CALL _WriteCodeFile
                  JC   @@WriteFileCodeError
                  POP  CX
                  LOOP @@WriteFileCodeLoop
                  RET
@@WriteFileCodeError:
                  STC
                  RET
_WriteCodeInFile ENDP


_ReadComputerCode PROC NEAR
                   MOV  DI,0FFFFh
                   MOV  ES,DI            ;ES = BiosDate Segment
                   MOV  DI,00005h        ;DI = BiosDate Offset
                   MOV  CX,3
                   PUSH DS
                   PUSH AX
                   MOV  AX,CS
                   MOV  DS,AX
                   POP  AX
                   LEA  SI,_CodeBytesTable
@@ReadCodeLoop:
                   MOV  AX,WORD PTR ES:[DI]
                   CALL _CharWordToByte
                   MOV  BYTE PTR DS:[SI],AL
                   ADD  DI,3
                   INC  SI
                   LOOP @@ReadCodeLoop
                   POP  DS
                   RET
_ReadComputerCode ENDP


_CheckComputerCode PROC NEAR
                    MOV  DI,0FFFFh
                    MOV  ES,DI            ;ES = BiosDate Segment
                    MOV  DI,00005h        ;DI = BiosDate Offset
                    MOV  CX,3
                    PUSH DS
                    PUSH AX
                    MOV  AX,CS
                    MOV  DS,AX
                    POP  AX
                    LEA  SI,_CodeBytesTable
@@CheckCodeLoop:
                    MOV  AX,WORD PTR ES:[DI]
                    CALL _CharWordToByte
                    CMP  AL,BYTE PTR DS:[SI]
                    JNE  @@Code_Error
                    ADD  DI,3
                    INC  SI
                    LOOP @@CheckCodeLoop
                    POP  DS
                    RET
@@Code_Error:
                    MOV  _CodeError,eOtherComputer
                    STC
                    POP  DS
                    RET
_CheckComputerCode ENDP


_GetRegistratingStatus PROC FAR
                        CALL _OpenCodeFile
                        JC   @@FileError
                        CALL _ReadCodeFromFile
                        JC   @@FileError_Close
                        CALL _CheckComputerCode
                        JC   @@FileError_Close
                        CALL _CheckClusterNumInFile
@@FileError_Close:
                        CALL _CloseCodeFile
@@FileError:
                        MOV AL,_CodeError
                        RET
_GetRegistratingStatus ENDP


_SetRegistrate         PROC FAR
                        CALL _OpenCodeFile
                        JC   @@FileError_1
                        CALL _ReadComputerCode
                        JC   @@FileError_Close_1
                        CALL _WriteCodeInFile
                        JC   @@FileError_Close_1
                        CALL _WriteClusterNumInFile
@@FileError_Close_1:
                        CALL _CloseCodeFile
@@FileError_1:
                        MOV AL,_CodeError
                        RET
_SetRegistrate         ENDP


_GetFirstSftPtr PROC NEAR
                 MOV   AH,52h
                 INT   21h
                 MOV   DI,ES:[BX+4]
                 MOV   AX,ES:[BX+6]
                 MOV   ES,AX
                 RET
_GetFirstSftPtr ENDP


_GetHandlePtr PROC NEAR
               CALL  _GetFirstSftPtr
               MOV   CX,_ModuleHandle
@@Retry_Check:
               MOV   AX,ES:[DI+4]
               CMP   CX,AX
               JB    @@Found_Table
               SUB   CX,AX
               MOV   AX,ES:[DI+2]
               MOV   DI,ES:[DI]
               MOV   ES,AX
               JMP   @@Retry_Check
@@Found_Table:
               RET
_GetHandlePtr ENDP


_GetHandle_FirstCluster PROC FAR
                         CALL _GetHandlePtr
                         ADD  DI,6
                         MOV  AL,CL
                         MOV  AH,eSftRecordSize
                         MUL  AH
                         ADD  DI,AX
                         MOV  AX,ES:[DI+0Bh]
                         RET
_GetHandle_FirstCluster ENDP


_OpenModule PROC NEAR
             MOV  _CodeError,0
             PUSH DS
             MOV  AX,CS
             MOV  DS,AX
             LEA  DX,_ModulesNames
             MOV  AX,CX
             SHL  AX,2
             ADD  DX,AX
             MOV  AX,3D02h
             INT  21h
             POP  DS
             JNC  @@Proceed_FOpen
             MOV  _CodeError,AL
@@Proceed_FOpen:
             MOV _ModuleHandle,AX
             RET
_OpenModule ENDP


_CloseModule PROC NEAR
              MOV AH,3Eh
              MOV BX,_ModuleHandle
              INT 21h
              RET
_CloseModule ENDP


_WriteClusterNum PROC NEAR
                  PUSH  CS
                  POP   ES
                  LEA   DI,_ModulesOffsets
                  MOV   AX,_ModuleHandle
                  SHL   AX,1
                  ADD   DI,AX
                  MOV   DX,WORD PTR ES:[DI]
                  CALL  _SeekCodeFile
                  PUSH  DS
                  MOV   BX,_CodeFileHandle
                  PUSH  DS
                  PUSH  CS
                  POP   DS
                  LEA   DX,_CodeBytesTable
                  MOV   AH,40h
                  MOV   CX,2
                  INT   21h
                  JNC   @@Proceed_FWriteFile
                  MOV   _CodeError,AL
@@Proceed_FWriteFile:
                  POP   DS
                  RET
_WriteClusterNum ENDP


_WriteClusterNumInFile PROC NEAR
                        MOV  CX,eModulesNumber
@@Write_Rep:
                        PUSH CX
                        CALL _OpenModule
                        JC   @@FileOpen_Error
                        CALL _GetHandle_FirstCluster
                        CALL _WriteClusterNum
                        JC   @@FileWrite_Error
                        CALL _CloseModule
                        POP  CX
                        LOOP @@Write_Rep
@@FileWrite_Error:
                        CALL _CloseModule
@@FileOpen_Error:
                        RET
_WriteClusterNumInFile ENDP


_CheckClusterNum PROC NEAR
                  PUSH  CS
                  POP   ES
                  LEA   DI,_ModulesOffsets
                  MOV   AX,_ModuleHandle
                  SHL   AX,1
                  ADD   DI,AX
                  MOV   DX,WORD PTR ES:[DI]
                  CALL  _SeekCodeFile
                  PUSH  DS
                  MOV   BX,_CodeFileHandle
                  PUSH  DS
                  PUSH  CS
                  POP   DS
                  LEA   DX,_CodeBytesTable
                  MOV   AH,3Fh
                  MOV   CX,2
                  INT   21h
                  JNC   @@Proceed_FReadFile
                  MOV   _CodeError,AL
@@Proceed_FReadFile:
                  POP   DS
                  RET
_CheckClusterNum ENDP


_CheckClusterNumInFile PROC NEAR
                        MOV  CX,eModulesNumber
@@Writer_Rep:
                        PUSH CX
                        CALL _OpenModule
                        JC   @@FileOpen_Error
                        CALL _GetHandle_FirstCluster
                        PUSH AX
                        CALL _CheckClusterNum
                        POP  CX
                        JC   @@FileRead_Error
                        CMP  CX,AX
                        JE  @@DontSet_Error
                        MOV  _CodeError,eOtherComputer
                        STC
                        JMP  @@FileOpenr_Error
@@DontSet_Error:
                        CALL _CloseModule
                        POP  CX
                        LOOP @@Writer_Rep
@@FileRead_Error:
                        CALL _CloseModule
@@FileOpenr_Error:
                        RET
_CheckClusterNumInFile ENDP



CODE ENDS

     END

