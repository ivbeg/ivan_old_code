#include <stdio.h>


extern unsigned  char _pascal _far SetRegistrate();
extern unsigned  char _pascal _far _GetRegistratingStatus();

 void* far pascal Module1;

unsigned  short x;

void main() {

//*_SetRegistrate();

x = _GetRegistratingStatus();
printf("Status: %d \n ",x); 

}