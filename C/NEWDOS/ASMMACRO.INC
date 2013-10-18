; ASMMACRO.INC List of macroses
; Started  at  5.05.96
; Macroses for assembler oriented on TASM 3.2 and compatible
; <name> - Upcase started string
; <type> - Lowcase string
;
; Macros record format:
;     "macro_"<name>" Macro"<reg8/reg16/reg32/mem8/mem16/mem32>
;         <command>     <operand>,...,<operand>
;                    "EndM"
;
; Constants records format:
;     <type>_..._<type>_<name>


    ; Set DATA segment in GS
macro_SetDATA_GS Macro
   PUSH      @DATA
   POP       GS
                 EndM

    ; Move Stack Pointer (SP) in reg16
macro_StackFrame Macro reg16
   MOV       reg16, SP
                 EndM

    ; Saving DS in reg16
macro_SaveDS Macro reg16
   MOV       reg16, DS
             EndM

    ; Restoring from reg16
macro_RestoreDS Macro reg16
   MOV        DS, reg16
                EndM

    ; Saving BP and move BP in SP
macro_StackFrameBP Macro
   PUSH       BP
   MOV        BP, SP
                   EndM

    ; Return after "StackFrameBP"
macro_ExitCode Macro Count
   MOV        SP, BP
   POP        BP
   RET        Count
               EndM

    ; Zero reg
macro_Zero Macro reg
   XOR        reg, reg
           EndM

    ; 486+ Cpu Identification code
macro_CPUID Macro
   DB         0Fh, 0A2h
            EndM

    ; Input/Outlput delay macros
macro_IODELAY Macro
   JMP        short $+2
   JMP        short $+2
              EndM

    ; Boolean values
boolean_False           EQU  00h
boolean_True            EQU  01h

    ; CPU types
cpu_type_80386          EQU  03h
cpu_type_80486          EQU  04h
cpu_type_Pentium        EQU  05h
cpu_type_PentiumHigh    EQU  06h

    ; Interrupt 15h - Functions
int15h_Wait             EQU  086h
int15h_CopyExtMemory    EQU  087h
int15h_GetExtMemorySize EQU  088h
int15h_GetConfigTable   EQU  0C0h


    ; Functions result code
TFunctionResult Struc
   Function       DW     0000h
   Interrupt      DB     00h
   CalledAddr     DD     00000000h
   Result         DW     0000h
   ErrorProc      DD     00000000h
                EndS


    ; Format of Bios date record
TBiosDateFormat Struc
   Day            DW     ?
   Filler_1       DB     ?
   Month          DW     ?
   Filler_2       DB     ?
   Year           DW     ?
                EndS



