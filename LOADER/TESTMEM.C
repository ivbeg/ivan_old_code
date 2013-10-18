#include <dos.h>

#define C1_mem  550

 union REGS regs ;
 int   rc;

void getloadersize( )      /**** Return program size in memory ****/

{
 asm  mov ah,062h
 asm  int 21h
 asm  dec bx
 asm  mov es,bx
 asm  mov bx,3
 asm  mov ax,es:[bx]
 asm  mov rc,ax
 rc = rc /64;
 printf("Program size: %d Kb \n",rc);
}

void getprefixseg ( )

{ regs.h.ah = 0x62;
 int86 ( 0x21, &regs, &regs ) ;
 printf("Program segment: %x \n",regs.x.bx);
}


int testmem ( C_mem)
int C_mem ;

{

 regs.x.bx = 0x0FFFF;
 regs.h.ah = 0x048;
 int86( 0x21, &regs, &regs );
 rc = regs.x.bx;
 rc = rc /64;
 if (  rc  > C_mem ) printf ("memory good\n") ;
				else
 printf ("No enougth Memory Free %d Kb more \n",C_mem - rc ) ;
 }

main ()
{
 getloadersize();
 getprefixseg();
 testmem(C1_mem);
}