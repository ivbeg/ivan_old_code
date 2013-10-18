#include <dos.h>


extern unsigned  char _pascal _far _SetRegistrate();
extern unsigned  char _pascal _far _GetRegistratingStatus();


unsigned  short x;

void main() {

_SetRegistrate();

}