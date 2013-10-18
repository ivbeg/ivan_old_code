INCLUDE    MACRO.INC

DATA  SEGMENT WORD PUBLIC
      ASSUME  DS:DATA


DATA  ENDS

CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA


      .386  ;Use 386+ processor

      PUBLIC  Get_NDOS_Version, Get_4DOS_Version
      PUBLIC  Get_DosNavigator_Present

e4DOS_Check  EQU  0D44Dh
e4DOS_Sign   EQU  044DDh
eNDOS_Check  EQU  0E44Dh
eDN_Sign     EQU  0444Eh ; 'DN'
eDN_Check    EQU  09900h


Get_NDOS_Version PROC FAR
CommInfo         EQU  SS:[DI+4]
                  MOV        AX, eNDOS_Check
                  JMP        @@Check_For
Get_4DOS_Version PROC FAR
                  MOV        AX, e4DOS_Check
@@Check_For:
                  MOV        BH, 0
                  INT        2Fh
                  CMP        AX, e4DOS_Sign
                  JNE        @@Dont_4DOS
@@Dont_4DOS:
                  StackFrame DI
                  LES        DI, CommInfo
                  XOR        EAX, EAX
                  STOSD
                  STOSB
                  MOV        AL, false
                  JMP        SHORT @@4DOS_End
@@Is_4DOS:
                  LES        DI, CommInfo
                  MOV        WORD PTR ES:[DI], BX
                  MOV        WORD PTR ES:[DI+2], CX
                  MOV        BYTE PTR ES:[DI+3], DL
                  MOV        AL, true
@@4DOS_End:
                  RET        4
Get_4DOS_Version ENDP
Get_NDOS_Version ENDP


Get_DosNavigator_Present PROC FAR
                          MOV  AX, eDN_Check
                          INT  2Fh
                          CMP  AX, eDN_Sign
                          JE   @@Is_DN
                          MOV  AL,false
                          JMP  SHORT @@DN_End
@@Is_DN:
                          MOV  AL, true
@@DN_End:
                          RET
Get_DosNavigator_Present ENDP



CODE  ENDS

      END

