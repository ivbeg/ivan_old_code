#include <stdio.h>
#include <alloc.h>
#include "clib.h"
#include "dos_lib.h"


void main()
{
  Init_Newdos();
  printf("Dos version: %d.%d \n", (*psDosVersion(pointer(&DosVersion))).High,(*psDosVersion(pointer(&DosVersion))).Low);
  printf("SysVars ptr: %p\n", SysVars);
  printf("Indos flag address: %p\n", IndosFlag);
  printf("Indos flag value  : %d\n", *IndosFlag);
};