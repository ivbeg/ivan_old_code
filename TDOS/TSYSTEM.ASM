include   ASMMACRO.INC


DATA  SEGMENT WORD PUBLIC
      ASSUME  CS:CODE,DS:DATA


      EXTRN    CpuType            : BYTE
      EXTRN    CpuSpeed           : WORD
      EXTRN    BiosType           : BYTE
      EXTRN    ExtendedMemorySize : WORD
      EXTRN    BiosConfigTable    : DWORD
      EXTRN    CpuIDValid         : BYTE



DATA  ENDS


CODE  SEGMENT BYTE PUBLIC
      ASSUME CS:CODE,DS:DATA

                   .386

      PUBLIC  FillDword, FillWord, FillByte
      PUBLIC  Fill, MovePtr, SearchPtr
      PUBLIC  Swap, SwapByte, SwapWord, SwapLong
      PUBLIC  ReadPort, WritePort, ReadIndexPort, WriteIndexPort
      PUBLIC  ReadMemoryByte, WriteMemoryByte
      PUBLIC  ReadMemoryWord, WriteMemoryWord
      PUBLIC  ReadMemoryDword, WriteMemoryDword
      PUBLIC  CompareBuffersPtr


      PUBLIC  AbsReadMemoryByte, AbsWriteMemoryByte
      PUBLIC  AbsReadMemoryWord, AbsWriteMemoryWord
      PUBLIC  AbsReadMemoryDword, AbsWriteMemoryDword


      PUBLIC  Delay, GetExtendedMemorySize
      PUBLIC  HardwareReboot, WarmReboot, ColdReboot


      PUBLIC  GetCPU_Type
      PUBLIC  GetBiosConfigTable
      PUBLIC  GetCPU_Speed

    ; CPU Identification variables
Old_int6_Seg       DW     0000h
Old_Int6_Off       DW     0000h
Old_IntD_Seg       DW     0000h
Old_IntD_Off       DW     0000h
BadOff             DW     0000h
Int_Mask           DB     0000h

IntelSpd DW      1, 10848       ; 8088  - loop duration, factor adjust
         DW      1, 10848       ; 80186  (5Mhz =  ~8345 ticks)
         DW      2, 3234        ; 80286  (12Mhz = ~1035 ticks)
         DW     10, 16200       ; 80386  (33Mhz = ~1917 ticks)
         DW     10, 16550       ; 80486  (33Mhz = ~2006 ticks)
         DW     20, 34318       ; Pentium (60Mhz = ~2269 ticks)


    ; Fill "Buffer" by "Double Words"
FillDword  PROC   FAR
  Buffer     EQU    (DWORD PTR [BX+10])
  Count      EQU    (WORD  PTR [BX+8])
  Value      EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX                 ; Saving Base Stack Pointer in BX
   LES       DI, Buffer                ; ES  =  Segment(Dest), DI = Offset(Dest)
   MOV       CX, Count                 ; CX  =  Number of DWords
   CLD                                 ; Clearing Direction
   MOV       EAX, Value                ; EAX =  DWord Value
   REP       STOSD                     ; Filling...
   RET       10                        ; Clearing stack and return
FillDword  ENDP


    ; Fill "Buffer" by "Words"
FillWord  PROC   FAR
  Buffer     EQU    (DWORD PTR [BX+8])
  Count      EQU    (WORD  PTR [BX+6])
  Value      EQU    (WORD  PTR [BX+4])
   macro_StackFrame BX
   LES       DI, Buffer
   MOV       CX, Count
   MOV       AX, Value
   SHL       EAX, 10h
   MOV       AX, Value
   SHR       CX, 01h
   CLD
   REP       STOSD
   ADC       CX, CX
   REP       STOSW
   RET       8
FillWord  ENDP


    ; Fill "Buffer" by "Bytes"
FillByte  PROC   FAR
  Buffer     EQU    (DWORD PTR [BX+8])
  Count      EQU    (WORD  PTR [BX+6])
  Value      EQU    (BYTE  PTR [BX+4])
   macro_StackFrame BX
   LES       DI, Buffer
   MOV       CX, Count
   MOV       AL, Value
   MOV       AH, AL
   PUSH      AX
   SHL       EAX, 10h
   POP       AX
   CLD
   PUSH      CX
   SHR       CX, 02h
   REP       STOSD
   POP       CX
   AND       CX, 03h
   REP       STOSB
   POP       EAX
   RET       08h
FillByte  ENDP


    ; Fill "Dest" by "Source" with size "Size" "Count" times
Fill  PROC   FAR
  Dest       EQU    (DWORD PTR [BX+12])
  Source     EQU    (DWORD PTR [BX+8])
  Size       EQU    (WORD  PTR [BX+6])
  Count      EQU    (WORD  PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   LES       DI, Dest
   LDS       SI, Source
   MOV       CX, Size
   MOV       AX, Count
   CLD
   MOV       BX, CX
@@Fill_Loop:
   MOV       CX, BX
   CMP       AX, 00h
   JE        @@Fill_EndOfLoop
   SHR       CX, 02h
   REP       MOVSD
   MOV       CX, BX
   AND       CX, 03h
   REP       MOVSB
   SUB       SI, Size
   DEC       AX
   JMP       @@Fill_Loop
@@Fill_EndOfLoop:
   POP       DS
   RET       12
Fill  ENDP



    ; Move "Size" bytes from "Source" to "Dest"
MovePtr  PROC   FAR
  Source     EQU    (DWORD PTR [BX+10])
  Dest       EQU    (DWORD PTR [BX+6])
  Size       EQU    (WORD  PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       CX, Size
   LES       DI, Dest
   LDS       SI, Source
   CLD
   PUSH      CX
   SHR       CX, 02h
   REP       MOVSD
   POP       CX
   AND       CX, 03h
   REP       MOVSB
   POP       DS
   RET       6
MovePtr  ENDP


    ; Swap two byte variables
SwapByte  PROC   FAR
  Source     EQU    (DWORD PTR [BX+8])
  Dest       EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   PUSH         DS
   LES          DI, Source
   LDS          SI, Dest
   MOV          AL, BYTE PTR ES:[DI]
   XCHG         AL, BYTE PTR DS:[SI]
   STOSB
   POP          DS
   RET          8
SwapByte  ENDP


    ; Swap two word variables
SwapWord  PROC   FAR
  Source     EQU    (DWORD PTR [BX+8])
  Dest       EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   LES       DI, Source
   LDS       SI, Dest
   MOV       AX, WORD PTR ES:[DI]
   XCHG      AX, WORD PTR DS:[SI]
   STOSW
   POP          DS
   RET          8
SwapWord  ENDP


    ; Swap two double word variables
SwapLong                 PROC   FAR
  Source     EQU    (DWORD PTR [BX+8])
  Dest       EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   LES       DI, Source
   LDS       SI, Dest
   MOV       EAX, DWORD PTR ES:[DI]
   XCHG      EAX, DWORD PTR DS:[SI]
   STOSD
   POP       DS
   RET       8
SwapLong                 ENDP


    ; Swap "Source" and "Dest" on "Size" bytes
Swap  PROC   FAR
  Source     EQU    (DWORD PTR [BX+10])
  Dest       EQU    (DWORD PTR [BX+6])
  Size       EQU    (WORD  PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       CX, Size
   JCXZ      @@Swap_EndLoop
   LES       DI, Dest
   LES       SI, Source
   CLD
   SHR       CX, 01h
   JCXZ      @@Swap_LocLoop
   PUSHF
@@Swap_Loop:
   MOV       AX, WORD PTR ES:[DI]
   XCHG      AX, WORD PTR DS:[SI]
   MOV       WORD PTR ES:[DI], AX
   ADD       SI, 02h
   ADD       DI, 02h
   LOOP      @@Swap_Loop
   POPF
   JNC       @@Swap_EndLoop
@@Swap_LocLoop:
   MOV       AL, BYTE PTR DS:[SI]
   XCHG      AL, BYTE PTR ES:[DI]
   MOV       BYTE PTR DS:[SI], AL
@@Swap_EndLoop:
   POP       DS
   RET       10
Swap  ENDP


   ; Searce in "Buffer" with size "Count" "Buff" with size "BuffSize"
SearchPtr                PROC   FAR
  Buffer     EQU    (DWORD PTR [BX+12])
  Count      EQU    (WORD  PTR [BX+10])
  Buff       EQU    (DWORD PTR [BX+6])
  BuffSize   EQU    (WORD  PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   LES       DI, Buffer
   MOV       BX, DI
   MOV       CX, Count
   MOV       DX, BuffSize
   TEST      DX, DX
   JZ        @@SearchPtr_NotFound
   LDS       SI, Buff
   LODSB
   DEC       DX
   SUB       CX, DX
@@Search_LocLoop:
   REP       SCASB
   JNE       @@SearchPtr_NotFound
   TEST      DX, DX
   JZ        @@SearchPtr_Loop
   PUSH      CX
   PUSH      DI
   PUSH      SI
   MOV       CX, DX
   REPE      CMPSB
   POP       SI
   POP       DI
   POP       CX
   JNE       @@Search_LocLoop
@@SearchPtr_Loop:
   DEC       DI
   MOV       AX, DI
   SUB       AX, BX
   MOV       DX, ES
   JMP       @@SearchPtr_End
@@SearchPtr_NotFound:
   MOV       AX, 0000h
   MOV       DX, 0000h
@@SearchPtr_End:
   POP       DS
   RET       12
SearchPtr                ENDP


    ; Read byte from "Source"
ReadMemoryByte  PROC   FAR
  Source     EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   LES       DI, Source
   MOV       AL, BYTE PTR ES:[DI]
   RET       4
ReadMemoryByte  ENDP


    ; Read word from "Source"
ReadMemoryWord  PROC   FAR
  Source     EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   LES          DI, Source
   MOV          AX, WORD PTR ES:[DI]
   RET          4
ReadMemoryWord  ENDP


    ; Read double word from "Source"
ReadMemoryDWord          PROC   FAR
  Source     EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   LES          DI, Source
   MOV          AX, WORD PTR ES:[DI]
   MOV          DX, WORD PTR ES:[DI+2]
   RET          4
ReadMemoryDWord          ENDP


    ; Write byte in "Source"
WriteMemoryByte          PROC   FAR
  Source     EQU    (DWORD PTR [BX+6])
  Value      EQU    (BYTE  PTR [BX+4])
   macro_StackFrame BX
   MOV          AL, Value
   LES          DI, Source
   STOSB
   RET          6
WriteMemoryByte          ENDP


    ; Write word in "Source"
WriteMemoryWord          PROC   FAR
  Source     EQU    (DWORD PTR [BX+6])
  Value      EQU    (WORD  PTR [BX+4])
   macro_StackFrame BX
   MOV          AX, Value
   LES          DI, Source
   STOSW
   RET          6
WriteMemoryWord          ENDP


    ; Write double word in "Source"
WriteMemoryDWord          PROC  FAR
  Source     EQU    (DWORD PTR [BX+8])
  Value      EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   MOV          EAX, Value
   LES          DI, Source
   STOSD
   RET          8
WriteMemoryDWord          ENDP


    ; Read byte from port "Port"
ReadPort                  PROC  FAR
  Port         EQU    (WORD  PTR [BX+4])
   macro_StackFrame BX
   MOV          DX, Port
   IN           AL, DX
   RET          2
ReadPort                  ENDP


    ; Write byte in port "Port"
WritePort  PROC   FAR
  Port         EQU    (WORD  PTR [BX+6])
  Value        EQU    (BYTE  PTR [BX+4])
   macro_StackFrame BX
   MOV          DX, Port
              MOV          AL, Value
              OUT          DX, AL
              RET          4
WritePort  ENDP


    ; Write index byte in port "Port" and read byte from "Port"+1
ReadIndexPort  PROC   FAR
  Port         EQU    (WORD  PTR [BX+6])
  Index        EQU    (BYTE  PTR [BX+4])
   macro_StackFrame BX
   MOV          DX, Port
   OUT          DX, AL
   INC          DX
   IN           AL, DX
   RET          4
ReadIndexPort  ENDP


    ; Write index byte in port "Port" and write "Value" in "Port"+1
WriteIndexPort  PROC   FAR
  Port         EQU    (WORD  PTR [BX+8])
  Index        EQU    (BYTE  PTR [BX+6])
  Value        EQU    (BYTE  PTR [BX+4])
   macro_StackFrame BX
   MOV          DX, Port
   MOV          AH, Index
   MOV          AL, Value
   OUT          DX, AX
   RET          6
WriteIndexPort  ENDP


    ; Move size of extended memory in "ExtendedMemorySize"
GetExtendedMemorySize  PROC   NEAR
   CLI                        ; Interrupts disabled
   MOV       AL, 18h          ; AL = 18h (CMOS Reg.)
   OUT       70h, AL          ; AL now in CMOS
   IN        AL, 71h          ; Reading CMOS Reg. AL
   MOV       AH, AL           ; Saving it in AH
   MOV       AL, 17h          ; AL = 17h (CMOS Reg.)
   OUT       70h, AL          ; AL now in CMOS
   IN        AL, 71h          ; Reading CMOS Reg. AL
   STI                        ; Interrupts enabled
   MOV       [ExtendedMemorySize], AX
   RET
GetExtendedMemorySize  ENDP


    ; Move address of BIOS Config table in "BiosConfigTable"
GetBiosConfigTable  PROC   NEAR
   MOV       AH, int15h_GetConfigTable
   INT       15h
   MOV       WORD PTR [BiosConfigTable], BX
   MOV       WORD PTR [BiosConfigTable+2], ES
   RET
GetBiosConfigTable  ENDP


    ; Read byte "Value" from "AbsAddr"
AbsReadMemoryByte  PROC   FAR
  AbsAddr    EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, WORD PTR [AbsAddr]
   MOV       SI, WORD PTR [AbsAddr+2]
   PUSH      SI
   PUSH      AX
   POP       ESI
   XOR       AX, AX
   MOV       DS, AX
   MOV       AL, BYTE PTR DS:[ESI]
   POP       DS
   RET       4
AbsReadMemoryByte  ENDP


    ; Read word "Value" from "AbsAddr"
AbsReadMemoryWord  PROC   FAR
  AbsAddr    EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, WORD PTR [AbsAddr]
   MOV       SI, WORD PTR [AbsAddr+2]
   PUSH      SI
   PUSH      AX
   POP       ESI
   XOR       AX, AX
   MOV       DS, AX
   MOV       AX, WORD PTR DS:[ESI]
   POP       DS
   RET       4
AbsReadMemoryWord  ENDP


    ; Read double word "Value" from "AbsAddr"
AbsReadMemoryDWord  PROC   FAR
  AbsAddr    EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, WORD PTR [AbsAddr]
   MOV       SI, WORD PTR [AbsAddr+2]
   PUSH      SI
   PUSH      AX
   POP       ESI
   XOR       AX, AX
   MOV       DS, AX
   MOV       AX, WORD PTR DS:[ESI]
   MOV       DX, WORD PTR DS:[ESI+2]
   POP       DS
   RET       4
AbsReadMemoryDWord  ENDP


    ; Write byte "Value" in "AbsAddr"
AbsWriteMemoryByte  PROC   FAR
  AbsAddr    EQU    (DWORD PTR [BX+6])
  Value      EQU    (BYTE  PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, WORD PTR [AbsAddr]
   MOV       SI, WORD PTR [AbsAddr+2]
   PUSH      SI
   PUSH      AX
   POP       ESI
   XOR       AX, AX
   MOV       DS, AX
   MOV       AL, Value
   MOV       BYTE PTR DS:[SI], AL
   POP       DS
   RET       6
AbsWriteMemoryByte  ENDP


    ; Write word "Value" in "AbsAddr"
AbsWriteMemoryWord  PROC   FAR
  AbsAddr    EQU    (DWORD PTR [BX+6])
  Value      EQU    (WORD  PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, WORD PTR [AbsAddr]
   MOV       SI, WORD PTR [AbsAddr+2]
   PUSH      SI
   PUSH      AX
   POP       ESI
   XOR       AX, AX
   MOV       DS, AX
   MOV       AX, Value
   MOV       WORD PTR DS:[SI], AX
   POP       DS
   RET       6
AbsWriteMemoryWord  ENDP


    ; Write double word "Value" in "AbsAddr"
AbsWriteMemoryDWord  PROC   FAR
  AbsAddr    EQU    (DWORD PTR [BX+8])
  Value      EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   PUSH      DS
   MOV       AX, WORD PTR [AbsAddr]
   MOV       SI, WORD PTR [AbsAddr+2]
   PUSH      SI
   PUSH      AX
   POP       ESI
   XOR       AX, AX
   MOV       DS, AX
   MOV       EAX, Value
   MOV       DWORD PTR DS:[SI], EAX
   POP       DS
   RET       8
AbsWriteMemoryDWord  ENDP

    ; Compare "Source" and "Dest" on "Size" bytes
CompareBuffersPtr  PROC   FAR
  Source     EQU    (DWORD PTR [BX+10])
  Dest       EQU    (DWORD PTR [BX+6])
  Size       EQU    (WORD  PTR [BX+4])
   macro_StackFrame BX               ; Set up stack frame
   MOV       DX, DS              ; Save DS
   MOV       CX, Size            ; Bytes counter
   JCXZ      @@CompBuff_End      ; If zero,done
   LDS       SI, Source          ; Load pointers
   LES       DI, Dest
   CLD                           ; Go forward
   MOV       BX, SI              ; Save a start offset
   MOV       AX, 0FFFFh          ; Assume that fails
   REPE      CMPSB               ; Repeat while equal
   JE        @@CompBuff_End      ; AX = result
   DEC       SI                  ; Adjust back
   SUB       SI, BX              ; Find the offset
   MOV       AX, SI              ; AX = result
@@CompBuff_End:
   MOV       DS, DX              ; Restore DS
   RET       10                  ; Clearing stack and return.
CompareBuffersPtr  ENDP


    ; CPU independence delay
Delay  PROC   FAR
  Count      EQU    (DWORD PTR [BX+4])
   macro_StackFrame BX
   MOV       DX, WORD PTR [Count]
   MOV       CX, WORD PTR [Count+2]
   MOV       AH, int15h_Wait
   INT       15h
   RET          4
Delay  ENDP


    ; Hardware reboot by reading port 64h
    ; Reset method is done by using of the keyboard controller interface
    ; Keyboard controller does it by CPU reset pin pulsing
    ; This procedure returns never
    ; Use this procedure for any OS on own risky
HardwareReboot  PROC   FAR
@@InitTimeOut:
   MOV       CX, 0000h
   CLI
@@WaitOutReady:
   DEC       CX
   JCXZ      @@InitTimeOut
   IN        AL, 64H
   STI
   TEST      AL, 00000010b
   JNZ       @@WaitOutReady
   CLI
   MOV       AL, 0FEh
   OUT       64h, AL
@@Jump_Halt:
   HLT
   JMP       @@Jump_Halt
HardwareReboot  ENDP


    ; Standard warm reboot
WarmReboot  PROC   FAR
   MOV       AX, 0040h
   MOV       DS, AX
   MOV       WORD PTR DS:[0072h], 1234h
   PUSH      0FFFFh
   PUSH      00000h
   RETF
WarmReboot  ENDP


    ; Standard cold reboot
ColdReboot  PROC   FAR
   MOV       AX, 0040h
   MOV       DS, AX
   MOV       WORD PTR DS:[0072h], 0000h
   PUSH      0FFFFh
   PUSH      00000h
   RETF
ColdReboot  ENDP


   ; Move in "CpuType" type of CPU
GetCPU_Type               PROC   NEAR
              CLI
              PUSHF
              PUSHF
              POP          AX
              AND          AX, 0FFFh
              OR           AX, 5000h
              PUSH         AX
              POPF
              PUSHF
              POP          AX
              POPF
              STI
              AND          AX, 0F000h
              CMP          AX, 0F000h
              JNE          @@Check_286
              MOV          AL, 1
              JMP          @@GetCPU_Type_End
@@Check_286:
              OR           AX, AX
              JNE          @@Check_386
              MOV          AL, 2
              JMP          @@GetCPU_Type_End
@@Check_386:
              PUSHFD
              PUSHFD
              POP          EAX
              MOV          EBX, EAX
              CLI
              XOR          EAX, 40000h
              PUSH         EAX
              POPFD
              PUSHFD
              POP          EAX
              POPFD
              STI
              AND          EAX, 40000h
              AND          EBX, 40000h
              CMP          EAX, EBX
              JNE          @@Check_486
              MOV          AL, cpu_type_80386
              JMP          @@GetCPU_Type_End
@@Check_486:
              CLI
              PUSHFD
              PUSHFD
              POP          EAX
              XOR          EAX, 200000h
              PUSH         EAX
              POPFD
              PUSHFD
              POP          EAX
              POPFD
              STI
              AND          EAX, 200000h
              AND          EBX, 200000h
              CMP          EAX, EBX
              JNE          @@Check_Pentium
              MOV          AL, cpu_type_80486
              JMP          @@GetCPU_Type_End
@@Check_Pentium:
              MOV          [CpuIDValid], 1
              MOV          EAX, 1
              macro_CPUID
              AND          EAX, 0F00h
              SHR          EAX, 8
              CMP          EAX, cpu_type_Pentium
              JE           @@GetCPU_Type_End
              MOV          AL, cpu_type_PentiumHigh
@@GetCPU_Type_End:
              MOV          [CpuType], AL
              RET
GetCPU_Type               ENDP


Hook_Int6                 PROC   NEAR
              PUSH         AX
              PUSH         CX
              PUSH         ES
              XOR          AX, AX
              MOV          ES, AX
              CLI
              MOV          AX, ES:[6*4]
              MOV          CX, ES:[6*4+2]
              MOV          WORD PTR ES:[6*4], OFFSET bad_op_handler
              MOV          WORD PTR ES:[6*4+2],SEG bad_op_handler
              STI
              MOV          [old_int6_seg], CX
              MOV          [old_int6_off], AX
              POP          ES
              POP          CX
              POP          AX
              RET
Hook_Int6                 ENDP

Restore_Int6              PROC   NEAR
              PUSH         AX
              PUSH         CX
              PUSH         DX
              MOV          CX, [old_int6_seg]
              MOV          DX, [old_int6_off]
              PUSH         ES
              XOR          AX, AX
              MOV          ES, AX
              CLI
              MOV          WORD PTR ES:[6*4], DX
              MOV          WORD PTR ES:[6*4+2], CX
              STI
              POP          ES
              POP          DX
              POP          CX
              POP          AX
              RET
Restore_Int6              ENDP

bad_op_handler            PROC   FAR
              PUSH         AX
              PUSH         BP
              MOV          AX, CS:[badoff]
              MOV          BP, SP
              MOV          SS:[BP+4], AX
              POP          BP
              POP          AX
              IRET
bad_op_handler            ENDP


Hook_IntD                 PROC   NEAR
              PUSH         AX
              PUSH         CX
              PUSH         ES
              XOR          AX, AX
              MOV          ES, AX
              CLI
              IN           AL, 21h
              MOV          [Int_Mask], AL
              macro_IODELAY
              OR           AL, 20h
              OUT          21h, AL
              MOV          AX, WORD PTR ES:[0Dh*4]
              MOV          CX, WORD PTR ES:[0Dh*4+2]
              MOV          WORD PTR ES:[0Dh*4], OFFSET  bad_op_handler
              MOV          WORD PTR ES:[0Dh*4], SEG bad_op_handler
              STI
              MOV          [old_intD_seg], CX
              MOV          [old_intD_off], AX
              POP          ES
              POP          CX
              POP          AX
              RET
Hook_IntD                 ENDP

Restore_IntD              PROC   NEAR
              PUSH         AX
              PUSH         CX
              PUSH         DX
              MOV          CX, [old_intD_seg]
              MOV          DX, [old_intD_off]
              PUSH         ES
              XOR          AX, AX
              MOV          ES, AX
              CLI
              MOV          ES:[0Dh*4], DX
              MOV          ES:[0Dh*4+2], CX
              IN           AL, 21h
              MOV          AH, [Int_Mask]
              macro_IODELAY
              OR           AH, 0DFh
              AND          AL, AH
              OUT          21h, AL
              STI
              POP          ES
              POP          DX
              POP          CX
              POP          AX
              RET
Restore_IntD              ENDP




    ; Get CPU speed
GetCPU_Speed              PROC   NEAR
              PUSH         DX
              PUSH         SI
              MOV          AL, [CpuType]
              XOR          AH, AH
              SHL          AX, 1
              SHL          AX, 1
              MOV          SI, OFFSET IntelSpd
              ADD          SI, AX
              MOV          AL, 0B0h
              OUT          43h, AL
              macro_IoDelay
              MOV          AL, 0FFh
              OUT          42h, AL
              macro_IoDelay
              OUT          42h, AL
              macro_IoDelay
              CLI
              MOV          AL, 80h
              OUT          70h, AL
              macro_IoDelay
              IN           AL, 61h
              macro_IoDelay
              OR           AL, 1
              OUT          61h, AL
              XOR          DX, DX
              MOV          BX, 1
              MOV          AX, CS:[SI]
@@Cpus_Loop_1:
              MOV          CX, 10h
@@Cpus_Loop_2:
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              DIV          BX
              LOOP         @@Cpus_Loop_2
              DEC          AX
              JNZ          @@Cpus_Loop_1

              IN           AL, 61h
              macro_IoDelay
              AND          AL, 0FEh
              OUT          61h, AL
              XOR          AL, AL
              OUT          70h, AL
              STI

              MOV          AL, 80h
              OUT          43h, AL
              macro_IoDelay
              IN           AL, 42h
              macro_IoDelay
              MOV          DL, AL
              IN           AL, 42h
              MOV          DH, AL
              MOV          AX, 0FFFFh
              SUB          AX, DX
              MOV          CX, AX
              MOV          BX, AX
              MOV          AX, CX
              CMP          WORD PTR CS:[SI+2], 0
              JE           @@Cpus_skp2

              MOV          AX, CS:[SI+2]
              XOR          DX, DX
              SHL          AX, 1
              RCL          DX, 1
              SHL          AX, 1
              RCL          DX, 1
              DIV          CX
@@Cpus_skp2:
              POP          SI
              POP          DX
              MOV          [CpuSpeed], AX
              RET
GetCPU_Speed              ENDP



CODE  ENDS

      END

