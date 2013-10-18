

    /* Bios types constants */
const  unsigned char bios_Unknown        = 0;
const  unsigned char bios_Award          = 1;
const  unsigned char bios_AMI            = 2;
const  unsigned char bios_Phoenix        = 3;
const  unsigned char bios_Compaq         = 4;
const  unsigned char bios_Dell           = 5;
const  unsigned char bios_HewlettPackard = 6;
const  unsigned char bios_Toshiba        = 7;
const  unsigned char bios_Tandy1000      = 8;



    /* Processor types constants */
const  unsigned char cpu_type_8086            = 0;
const  unsigned char cpu_type_80186           = 1;
const  unsigned char cpu_type_80286           = 2;
const  unsigned char cpu_type_80386           = 3;
const  unsigned char cpu_type_80486           = 4;
const  unsigned char cpu_type_Pentium         = 5;
const  unsigned char cpu_type_PentiumPro      = 6;


extern "C"
{
 extern  WORD               GetExtendedMemorySize();
 extern  sBiosConfigTable*  GetBiosConfigTable();
 extern  BYTE               GetBiosType();
 extern  void far           Delay(DWORD Count);

 extern  void far           HardwareReboot();
 extern  void far           ColdReboot();
 extern  void far           WarmReboot();

 extern  BYTE               ReadPort(WORD Port);
 extern  void far           WritePort(WORD Port, BYTE Value);
 extern  BYTE               ReadIndexPort(WORD Port, BYTE Index);
 extern  void far           WriteIndexPort(WORD Port,BYTE Index, BYTE Value);

 extern  void far           FillByte(void* Buffer, WORD Count, BYTE Value);
 extern  void far           FillWord(void* Buffer, WORD Count, WORD Value);
 extern  void far           FillDword(void* Buffer, WORD Count, DWORD Value);
 extern  void far           Fill(void* Dest, void* Source, WORD Size, WORD Count);

 extern  WORD               GetCPU_Speed();
 extern  BYTE               GetCPU_Type();

 extern  void far           AbsWriteMemoryByte(DWORD Address, BYTE Value);
 extern  void far           AbsWriteMemoryWord(DWORD Address, WORD Value);
 extern  void far           AbsWriteMemoryDword(DWORD Address, DWORD Value);
 extern  BYTE               AbsReadMemoryByte(DWORD Address);
 extern  WORD               AbsReadMemoryWord(DWORD Address);
 extern  DWORD              AbsReadMemoryDword(DWORD Address);

 extern  void far           MovePtr(void* Source, void* Dest, WORD Size);
 extern  void*              SearchPtr(void* Buffer, WORD Count, void* SearchBuffer, WORD SBuffSize);
 extern  WORD               CompareBuffersPtr(void* Source, void* Dest, WORD Size);

 extern  void far           SwapByte(BYTE* Source, BYTE* Dest);
 extern  void far           SwapWord(WORD* Source, WORD* Dest);
 extern  void far           SwapLong(DWORD* Source, DWORD* Dest);
 extern  void far           Swap(void* Source, void* Dest, WORD Size);

 extern  BOOLEAN            RomCheck(WORD Segm);
};

