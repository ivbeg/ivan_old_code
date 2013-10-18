include ASMMACRO.INC


 .MODEL LARGE

 .CODE



   PUBLIC C HardwareReboot
   PUBLIC C WarmReboot
   PUBLIC C ColdReboot

   PUBLIC C GetExtendedMemorySize
   PUBLIC C GetBiosConfigTable
   PUBLIC C Delay

   PUBLIC C ReadPort
   PUBLIC C WritePort
   PUBLIC C ReadIndexPort
   PUBLIC C WriteIndexPort

   PUBLIC C FillByte
   PUBLIC C FillWord
   PUBLIC C FillDword
   PUBLIC C Fill

   PUBLIC C SwapByte
   PUBLIC C SwapWord
   PUBLIC C SwapLong
   PUBLIC C Swap

   PUBLIC C MovePtr
   PUBLIC C SearchPtr
   PUBLIC C CompareBuffersPtr

   PUBLIC C GetCPU_Type
   PUBLIC C GetCPU_Speed

   PUBLIC C AbsReadMemoryByte
   PUBLIC C AbsReadMemoryWord
   PUBLIC C AbsReadMemoryDword
   PUBLIC C AbsWriteMemoryByte
   PUBLIC C AbsWriteMemoryWord
   PUBLIC C AbsWriteMemoryDword

   PUBLIC C RomCheck
   PUBLIC C GetBiosType


    ; Bios types
bios_Unknown         EQU    00h
bios_Award           EQU    01h
bios_AMI             EQU    02h
bios_Phoenix         EQU    03h
bios_Compaq          EQU    04h
bios_Dell            EQU    05h
bios_HewlettPackard  EQU    06h
bios_Toshiba         EQU    07h
bios_Tandy1000       EQU    08h


    ;Bios identificators
biosID_Dell_1        DB     'DELL'
biosID_Dell_2        DB     'Dell'
biosID_HP            DB     'HP'
biosID_Compaq        DB     'COMPAQ'
biosID_Toshiba       DB     'TOSHIBA'
biosID_Tandy1000Fl_1 DB     021h
biosID_Tandy1000Fl_2 DB     0FFh
biosID_AMI           DB     'AMI'
biosID_Phoenix       DB     'PTL', 00h
biosID_Award         DB     'Award'


    ; CPU Identification variables
old_int6_seg       DW     0000h
old_int6_off       DW     0000h
old_intD_seg       DW     0000h
old_intD_off       DW     0000h
badoff             DW     0000h
Int_Mask           DB     0000h

IntelSpd DW      1, 10848       ; 8088  - loop duration, factor adjust
         DW      1, 10848       ; 80186  (5Mhz =  ~8345 ticks)
         DW      2, 3234        ; 80286  (12Mhz = ~1035 ticks)
         DW     10, 16200       ; 80386  (33Mhz = ~1917 ticks)
         DW     10, 16550       ; 80486  (33Mhz = ~2006 ticks)
         DW     20, 34318       ; Pentium (60Mhz = ~2269 ticks)

    ; For 386+ processors only.
      .386


    ; Hardware reboot by reading/writing in port 64h
HardwareReboot  PROC   FAR
@@InitTimeOut:                 ; Restarting point
   MOV       CX, 0000h         ; CX = 0000h (Init counter)
   CLI                         ; Interrupts disabled
@@WaitOutReady:                ; Loop point
   DEC       CX                ; Decreasing CX
   JCXZ      @@InitTimeOut     ; if CX = 0 then goto @@InitTimeOut
   IN        AL, 64H           ; Read in AL from port 064h
   STI                         ; Interrupts enabled
   TEST      AL, 00000010b     ; Virtual  "AND     AL, 2"  AL not changed
   JNZ       @@WaitOutReady    ; if ZF = 1 then goto @@WaitOutReady
   CLI                         ; Interrupts disabled
   MOV       AL, 0FEh          ; AL = 0FEh
   OUT       64h, AL           ; Write AL in port 064h
@@Jump_Halt:                   ; Halt loop point
   HLT                         ; Halt command
   JMP       @@Jump_Halt       ; goto @@Jump_Halt
HardwareReboot  ENDP

    ; Warm reboot by BIOS call
WarmReboot  PROC   FAR
   MOV       AX, 0040h        ; AX = 0040h ( Bios Area address)
   MOV       DS, AX           ; DS = AX = 0040h
   MOV       WORD PTR DS:[0072h], 1234h     ; 0040h:[0072h] = 1234h (Warm boot ID)
   PUSH      0FFFFh           ; Put stack address 0FFFFh
   PUSH      00000h           ; Put stack address 00000h
   RETF                       ; Like "CALL  0FFFFh:00000h"
WarmReboot  ENDP


    ; Cold reboot by BIOS call
ColdReboot  PROC   FAR
   MOV       AX, 0040h        ; AX = 0040h ( Bios Area address)
   MOV       DS, AX           ; DS = AX = 0040h
   MOV       WORD PTR DS:[0072h], 0000h     ; 0040h:[0072h] = 0000h (Cold boot ID)
   PUSH      0FFFFh           ; Put stack address 0FFFFh
   PUSH      00000h           ; Put stack address 00000h
   RETF                       ; Like "CALL  0FFFFh:00000h"
ColdReboot  ENDP


    ; CPU independence delay
Delay  PROC   FAR
  Count      EQU    (DWORD PTR SS:[BX+4])
   macro_StackFrame BX
   MOV       DX, WORD PTR [Count]
   MOV       CX, WORD PTR [Count+2]
   MOV       AH, int15h_Wait
   INT       15h
   RET
Delay  ENDP


    ; Return extended memory size in kilobytes
GetExtendedMemorySize  PROC   FAR
   macro_Zero EAX
   CLI                        ; Interrupts disabled
   MOV       AL, 18h          ; AL = 18h (CMOS Reg.)
   OUT       70h, AL          ; AL now in CMOS
   IN        AL, 71h          ; Reading CMOS Reg. AL
   MOV       AH, AL           ; Saving it in AH
   MOV       AL, 17h          ; AL = 17h (CMOS Reg.)
   OUT       70h, AL          ; AL now in CMOS
   IN        AL, 71h          ; Reading CMOS Reg. AL
   STI                        ; Interrupts enabled
   RETF
GetExtendedMemorySize  ENDP


    ; Return address of Bios configuration table
GetBiosConfigTable  PROC FAR
   PUSH      ES                         ; Saving ES
   MOV       AH, int15h_GetConfigTable  ; AH = "int15h_GetConfigTable"
   INT       15h                        ; Interrupt 15h (AT Services)
   MOV       AX, BX                     ; AX = BX
   MOV       DX, ES                     ; DX = ES
   POP       ES                         ; Restoring ES
   RETF
GetBiosConfigTable  ENDP


  ; Read byte from port "Port"
ReadPort  PROC  FAR
  Port         EQU    (WORD  PTR SS:[BX+4])
   macro_StackFrame BX        ; BX = SP  (SS:[SP] = SS:[BX])
   MOV          DX, Port      ; DX = Port number
   IN           AL, DX        ; Read from port DX in AL
   RETF                       ; Return far
ReadPort  ENDP


    ; Write byte in port "Port"
WritePort  PROC   FAR
  Port         EQU    (WORD  PTR SS:[BX+4])
  Value        EQU    (BYTE  PTR SS:[BX+6])
   macro_StackFrame BX        ; BX = SP  (SS:[SP] = SS:[BX])
   MOV          DX, Port      ; DX = Port number
   MOV          AL, Value     ; AL = Byte for writing in port DX
   OUT          DX, AL        ; Write AL in port DX
   RETF                       ; Return far
WritePort  ENDP


    ; Write index byte in port "Port" and read byte from "Port"+1
ReadIndexPort  PROC   FAR
  Port         EQU    (WORD  PTR SS:[BX+4])
  Index        EQU    (BYTE  PTR SS:[BX+6])
   macro_StackFrame BX        ; BX = SP
   MOV          DX, Port      ; DX = Port number
   MOV          AL, Index     ; AL = Index
   OUT          DX, AL        ; Write AL (index) in port DX
   INC          DX            ; Increasing DX (DX = DX + 1)
   IN           AL, DX        ; Read in AL from port DX+1
   RETF                       ; Return far
ReadIndexPort  ENDP


    ; Write index byte in port "Port" and write "Value" in "Port"+1
WriteIndexPort  PROC   FAR
  Port         EQU    (WORD  PTR SS:[BX+4])
  Index        EQU    (BYTE  PTR SS:[BX+6])
  Value        EQU    (BYTE  PTR SS:[BX+8])
   macro_StackFrame BX        ; BX = SP
   MOV          DX, Port      ; DX = Port number
   MOV          AH, Index     ; AH = Index
   MOV          AL, Value     ; AL = Value
   OUT          DX, AX        ; Write Index and Value in port DX and port DX+1
   RETF         6             ; Return far
WriteIndexPort  ENDP


    ; Fill "Buffer" by "Double Words"
FillDword  PROC   FAR
  Buffer     EQU    (DWORD PTR SS:[BX+4])
  Count      EQU    (WORD  PTR SS:[BX+8])
  Value      EQU    (DWORD PTR SS:[BX+10])
   macro_StackFrame BX        ; Saving Base Stack Pointer in BX
   LES       DI, Buffer       ; ES  =  Segment(Dest), DI = Offset(Dest)
   MOV       CX, Count        ; CX  =  Number of DWords
   CLD                        ; Clearing Direction
   MOV       EAX, Value       ; EAX =  DWord Value
   REP       STOSD            ; Filling...
   RETF                       ; Clearing stack and return
FillDword  ENDP


    ; Fill "Buffer" by "Words"
FillWord  PROC   FAR
  Buffer     EQU    (DWORD PTR SS:[BX+4])
  Count      EQU    (WORD  PTR SS:[BX+8])
  Value      EQU    (WORD  PTR SS:[BX+10])
   macro_StackFrame BX        ; BX = SP
   LES       DI, Buffer       ; ES = Seg(Buffer), DI = Offs(Buffer)
   MOV       CX, Count        ; CX = Number of words
   MOV       AX, Value        ; AX = Word value
   SHL       EAX, 10h         ; EAX = double copy of AX
   MOV       AX, Value        ;
   SHR       CX, 01h          ; CX = CX/2
   CLD                        ; Clear DF
   REP       STOSD            ; Filling buffer by Dwords
   ADC       CX, CX           ; Add CF to CX
   REP       STOSW            ; Filling buffer by Words
   RETF                       ; Return far
FillWord  ENDP


    ; Fill "Buffer" by "Bytes"
FillByte  PROC   FAR
  Buffer     EQU    (DWORD PTR SS:[BX+4])
  Count      EQU    (WORD  PTR SS:[BX+8])
  Value      EQU    (BYTE  PTR SS:[BX+10])
   macro_StackFrame BX        ; BX = SP
   LES       DI, Buffer       ; ES = Seg(Buffer), DI = Offs(Buffer)
   MOV       CX, Count        ; CX = Number of words
   MOV       AL, Value        ; AL = Byte value
   MOV       AH, AL           ; AH = AL
   PUSH      AX               ; Saving AX
   SHL       EAX, 10h         ; EAX = AX * 10000h
   POP       AX               ; Restoring EAX
   CLD                        ; Clear DF
   PUSH      CX               ; Saving CX
   SHR       CX, 02h          ; CX = CX/4
   REP       STOSD            ; Filling by Dwords
   POP       CX               ; Restore CX
   AND       CX, 03h          ; CX <= 3
   REP       STOSB            ; Filling by Bytes
   RET                        ; Return far
FillByte  ENDP


    ; Fill "Dest" by "Source" with size "Size" "Count" times
Fill  PROC   FAR
  Dest       EQU    (DWORD PTR SS:[BX+4])
  Source     EQU    (DWORD PTR SS:[BX+8])
  aSize      EQU    (WORD  PTR SS:[BX+12])
  Count      EQU    (WORD  PTR SS:[BX+14])
   macro_StackFrame BX        ; BX = SP
   PUSH      DS               ; Saving DS
   LES       DI, Dest         ; ES = Seg (Dest), DI = Offs (Source)
   LDS       SI, Source       ; DS = Seg (Source), SI = Offs (Source)
   MOV       CX, aSize        ; CX = Size of Source
   MOV       AX, Count        ; AX = Repeating counter
   CLD                        ; Clear DF
   MOV       BX, CX           ; BX = CX
@@Fill_Loop:                  ; Loop point
   MOV       CX, BX           ; CX = BX
   CMP       AX, 00h          ; if AX = 00h
   JE        @@Fill_EndOfLoop ; then goto @@Fill_EndOfLoop
   SHR       CX, 02h          ; CX = CX/4
   REP       MOVSD            ; Filling by Dwords
   MOV       CX, BX           ; CX = BX
   AND       CX, 03h          ; CX <= 03h
   REP       MOVSB            ; Filling by Bytes
   SUB       SI, aSize        ; SI = SI - Size
   DEC       AX               ; Decreasing AX
   JMP       @@Fill_Loop      ; goto @@Fill_Loop
@@Fill_EndOfLoop:             ; Loop end point
   POP       DS               ; Restoring DS
   RETF                       ; Return far
Fill  ENDP


    ; Move "Size" bytes from "Source" to "Dest"
MovePtr  PROC   FAR
  Source     EQU    (DWORD PTR SS:[BX+4])
  Dest       EQU    (DWORD PTR SS:[BX+8])
  aSize      EQU    (WORD  PTR SS:[BX+12])
   macro_StackFrame BX
   PUSH      DS
   MOV       CX, aSize
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
   RETF
MovePtr  ENDP


    ; Swap two byte variables
SwapByte  PROC   FAR
  Source     EQU    (DWORD PTR SS:[BX+4])
  Dest       EQU    (DWORD PTR SS:[BX+8])
   macro_StackFrame BX
   PUSH      DS
   LES       DI, Source
   LDS       SI, Dest
   MOV       AL, BYTE PTR ES:[DI]
   XCHG      AL, BYTE PTR DS:[SI]
   STOSB
   POP       DS
   RET
SwapByte  ENDP


    ; Swap two word variables
SwapWord  PROC   FAR
  Source     EQU    (DWORD PTR SS:[BX+4])
  Dest       EQU    (DWORD PTR SS:[BX+8])
   macro_StackFrame BX
   PUSH      DS
   LES       DI, Source
   LDS       SI, Dest
   MOV       AX, WORD PTR ES:[DI]
   XCHG      AX, WORD PTR DS:[SI]
   STOSW
   POP       DS
   RETF
SwapWord  ENDP


    ; Swap two double word variables
SwapLong                 PROC   FAR
  Source     EQU    (DWORD PTR SS:[BX+4])
  Dest       EQU    (DWORD PTR SS:[BX+8])
   macro_StackFrame BX
   PUSH      DS
   LES       DI, Source
   LDS       SI, Dest
   MOV       EAX, DWORD PTR ES:[DI]
   XCHG      EAX, DWORD PTR DS:[SI]
   STOSD
   POP       DS
   RETF
SwapLong                 ENDP


    ; Swap "Source" and "Dest" on "Size" bytes
Swap  PROC   FAR
  Source     EQU    (DWORD PTR SS:[BX+4])
  Dest       EQU    (DWORD PTR SS:[BX+8])
  aSize      EQU    (WORD  PTR SS:[BX+12])
   macro_StackFrame BX
   PUSH      DS
   MOV       CX, aSize
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
   RETF
Swap  ENDP


   ; Searce in "Buffer" with size "Count" "Buff" with size "BuffSize"
SearchPtr                PROC   FAR
  Buffer     EQU    (DWORD PTR SS:[BX+4])
  Count      EQU    (WORD  PTR SS:[BX+8])
  Buff       EQU    (DWORD PTR SS:[BX+10])
  BuffSize   EQU    (WORD  PTR SS:[BX+14])
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
   RETF
SearchPtr                ENDP


    ; Compare "Source" and "Dest" on "Size" bytes
CompareBuffersPtr  PROC   FAR
  Source     EQU    (DWORD PTR SS:[BX+4])
  Dest       EQU    (DWORD PTR SS:[BX+8])
  aSize      EQU    (WORD  PTR SS:[BX+12])
   macro_StackFrame BX               ; Set up stack frame
   MOV       DX, DS              ; Save DS
   MOV       CX, aSize           ; Bytes counter
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
   RETF                          ; Clearing stack and return.
CompareBuffersPtr  ENDP



   ; Move in "CpuType" type of CPU
GetCPU_Type               PROC   FAR
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
              MOV          EAX, 1
              macro_CPUID
              AND          EAX, 0F00h
              SHR          EAX, 8
              CMP          EAX, cpu_type_Pentium
              JE           @@GetCPU_Type_End
              MOV          AL, cpu_type_PentiumHigh
@@GetCPU_Type_End:
              RETF
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
GetCPU_Speed              PROC   FAR
              CALL         GetCPU_Type
              PUSH         DX
              PUSH         SI
              XOR          AH, AH
              SHL          AX, 1
              SHL          AX, 1
              MOV          SI, OFFSET IntelSpd
              ADD          SI, AX
              MOV          AL, 0B0h
              OUT          43h, AL
              macro_IODELAY
              MOV          AL, 0FFh
              OUT          42h, AL
              macro_IODELAY
              OUT          42h, AL
              macro_IODELAY
              CLI
              MOV          AL, 80h
              OUT          70h, AL
              macro_IODELAY
              IN           AL, 61h
              macro_IODELAY
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
              macro_IODELAY
              AND          AL, 0FEh
              OUT          61h, AL
              XOR          AL, AL
              OUT          70h, AL
              STI

              MOV          AL, 80h
              OUT          43h, AL
              macro_IODELAY
              IN           AL, 42h
              macro_IODELAY
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
              RET
GetCPU_Speed              ENDP


    ; Read byte "Value" from "AbsAddr"
AbsReadMemoryByte  PROC   FAR
  AbsAddr    EQU    (DWORD PTR SS:[BX+4])
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
   RETF
AbsReadMemoryByte  ENDP


    ; Read word "Value" from "AbsAddr"
AbsReadMemoryWord  PROC   FAR
  AbsAddr    EQU    (DWORD PTR SS:[BX+4])
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
   RETF
AbsReadMemoryWord  ENDP


    ; Read double word "Value" from "AbsAddr"
AbsReadMemoryDword  PROC   FAR
  AbsAddr    EQU    (DWORD PTR SS:[BX+4])
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
   RETF
AbsReadMemoryDword  ENDP


    ; Write byte "Value" in "AbsAddr"
AbsWriteMemoryByte  PROC   FAR
  AbsAddr    EQU    (DWORD PTR SS:[BX+4])
  Value      EQU    (BYTE  PTR SS:[BX+8])
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
   RETF
AbsWriteMemoryByte  ENDP


    ; Write word "Value" in "AbsAddr"
AbsWriteMemoryWord  PROC   FAR
  AbsAddr    EQU    (DWORD PTR SS:[BX+4])
  Value      EQU    (WORD  PTR SS:[BX+8])
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
   RETF
AbsWriteMemoryWord  ENDP


    ; Write double word "Value" in "AbsAddr"
AbsWriteMemoryDword  PROC   FAR
  AbsAddr    EQU    (DWORD PTR SS:[BX+4])
  Value      EQU    (DWORD PTR SS:[BX+8])
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
   RETF
AbsWriteMemoryDword  ENDP


    ; Check memory segment on ROM memory
RomCheck  PROC FAR
  Segm       EQU    (WORD PTR SS:[BX+4])
   macro_StackFrame BX                         ; BX = SP
   PUSH             DS                         ; Saving DS
   MOV              DS, [Segm]                 ; DS = Segm (Segment for check)
   MOV              AL, boolean_False          ; AL = 0
   macro_Zero       BX                         ; BX = 0
   CMP              WORD PTR DS:[BX], 0AA55h   ; if Segm:[0000h] = RomID
   JNE              @@RomCheck_End             ; then goto @@RomCheck_End
   MOV              AL, boolean_True           ; AL = 1
@@RomCheck_End:                                ; End point
   POP              DS                         ; Restoring DS
   RETF                                        ; Return far
RomCheck  ENDP




GetBiosType  PROC FAR
@@CheckBiosType_Award:
   PUSH      DS
   CALL      GetBiosConfigTable
   ADD       AX, 0Ah
   MOV       SI, AX
   MOV       AX, DS
   MOV       ES, AX
   MOV       DS, DX
   MOV       DI, offset biosID_Award
   MOV       CX, 05h
   MOV       AL, bios_Award
   CLD
   REP       CMPSB
   POP       DS
   JE        @@CheckBiosType_End

@@CheckBiosType_AMI:
   MOV       AX, DS
   MOV       ES, AX
   MOV       DI, offset biosID_AMI
   PUSH      DS
   MOV       AX, 0F000h
   MOV       DS, AX
   MOV       SI, 0FF60h
   MOV       CX, 03h
   MOV       AL, bios_AMI
   CLD
   REP       CMPSB
   POP       DS
   JE        @@CheckBiosType_End

@@CheckBiosType_Compaq:
   MOV       AX, DS
   MOV       ES, AX
   MOV       DI, offset biosID_Compaq
   PUSH      DS
   MOV       AX, 0F000h
   MOV       DS, AX
   MOV       SI, 0FFEAh
   MOV       CX, 06h
   MOV       AL, bios_Compaq
   CLD
   REP       CMPSB
   POP       DS
   JE        @@CheckBiosType_End

@@CheckBiosType_Hewlett:
   MOV       AX, DS
   MOV       ES, AX
   MOV       DI, offset biosID_HP
   PUSH      DS
   MOV       AX, 0F000h
   MOV       DS, AX
   MOV       SI, 000F8h
   MOV       CX, 02h
   MOV       AL, bios_HewlettPackard
   CLD
   REP       CMPSB
   POP       DS
   JE        @@CheckBiosType_End

@@CheckBiosType_Dell:
   MOV       AX, DS
   MOV       ES, AX
   MOV       DI, offset biosID_Dell_1
   PUSH      DS
   MOV       AX, 0F000h
   MOV       DS, AX
   MOV       SI, 000F8h
   MOV       CX, 04h
   MOV       AL, bios_HewlettPackard
   CLD
   REP       CMPSB
   POP       DS
   JE        @@CheckBiosType_End
   PUSH      DS
   MOV       SI, 000F8h
   MOV       DI, offset biosID_Dell_2
   MOV       CX, 04h
   CLD
   REP       CMPSB
   POP       DS
   JE        @@CheckBiosType_End

@@CheckBiosType_Toshiba:
   MOV       AX, DS
   MOV       ES, AX
   MOV       DI, offset biosID_Toshiba
   PUSH      DS
   MOV       AX, 0F000h
   MOV       DS, AX
   MOV       SI, 0E010h
   MOV       CX, 07h
   MOV       AL, bios_Toshiba
   CLD
   REP       CMPSB
   POP       DS
   JE        @@CheckBiosType_End

@@CheckBiosType_Tandy1000:
   PUSH      DS
   MOV       AX, 0F000h
   MOV       DS, AX
   MOV       SI, 0C000h
   LODSB
   POP       DS
   CMP       AL, biosID_Tandy1000Fl_1
   JNE       @@CheckBiosType_Phoenix
   PUSH      DS
   MOV       AX, 0FFFFh
   MOV       DS, AX
   MOV       SI, 0000Eh
   LODSB
   MOV       AH, AL
   MOV       AL, bios_Tandy1000
   POP       DS
   CMP       AH, biosID_Tandy1000Fl_2
   JE        @@CheckBiosType_End

@@CheckBiosType_Phoenix:
   PUSH      DS
   CALL      GetBiosConfigTable
   ADD       AX, 013h
   MOV       AX, SI
   MOV       AX, DS
   MOV       DS, DX
   MOV       ES, AX
   MOV       DI, offset biosID_Phoenix
   MOV       CX, 04h
   MOV       AL, bios_Phoenix
   CLD
   REP       CMPSB
   POP       DS
   JE        @@CheckBiosType_End

   MOV       AL, bios_Unknown
@@CheckBiosType_End:
   RETF
GetBiosType  ENDP

      END
