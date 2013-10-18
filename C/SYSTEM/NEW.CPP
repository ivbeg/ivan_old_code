#include <stdio.h>
#include <dos.h>
#include "clib.h"
#include "system.h"

/* Declaration Part */

void main()
{
  BYTE  PortValue;
  WORD  MemSize;
  BYTE  Buffer[100];
  BYTE  BiosType;
  BYTE  CpuType;
  WORD  CpuSpeed;

  Delay(200);
  sBiosConfigTable*    BiosConfigTable;
  BiosConfigTable = GetBiosConfigTable();
  printf("Bios config table: %p\n", BiosConfigTable);
  printf("Size of table: %d\n", (*BiosConfigTable).Size);
  printf("Model: 0%Xh\n", (*BiosConfigTable).Model);
  printf("Revision: %d\n", (*BiosConfigTable).Revision);

  MemSize = GetExtendedMemorySize();
  printf("Extended Memory: %u Kb\n", MemSize);

  PortValue = ReadPort(0x3DA);
  printf("Read port 03DAh: 0%Xh\n", PortValue);

  FillByte(Buffer, sizeof(Buffer), 0x00);

  BiosType = GetBiosType();
  printf("Bios type : 0%Xh\n", BiosType);

  CpuType = GetCPU_Type();
  printf("Cpu type : %d\n", CpuType);
  CpuSpeed = GetCPU_Speed();
  printf("Cpu speed : %d\n", CpuSpeed);

};