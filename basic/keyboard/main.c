/************************************************
*	by zou jian guo<zounix@126.com>	
*		2004.9.27 14:30			
*						
*   the driver is s3c2410_da_max504.c in drivers/char
*************************************************/

#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <sys/ioctl.h>
#include "keyboard.h"


/****************************************************************/
int main()

{
	char mykey;

	kbd_init();
	while(mykey!=48)
	{   mykey=get_key();
            printf("which key you press is %c  \n", mykey,mykey,mykey);
	}
	kbd_close();
	return 0;
}
