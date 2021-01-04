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

#define DA_IOCTRL_WRITE 	0x10
#define DA_IOCTRL_CLR 		0x12

#define Max504_FULL			4.096f
static int da_fd = -1;
char *DA_DEV="/dev/da";

void Delay(int t)
{
	int i;
	for(;t>0;t--)
		for(i=0;i<400;i++);
}

/****************************************************************/
int main(int argc, char **argv)
{
	float v;
	unsigned int value;
// 	char *da_dev;
//	unsigned int da_num=0;
	
	if(argc <2){
		printf("\n");
		printf("Error parameter\n");		
		printf("Input as:\n");
		printf("[~]./da_main  num\n");		
		printf("    num: range 0.0 ~ 4.096\n");
		printf("\n");
		return 1;
	}
	
	sscanf(argv[1], "%f",&v);	
	if(v<0 || v>Max504_FULL){
		printf("DA out must between: 0 to %f\n", Max504_FULL);
		return 1;
	}
	
	value=(unsigned int)((v*1024.0f)/Max504_FULL);
	
	if((da_fd=open(DA_DEV, O_WRONLY))<0){
		printf("Error opening /dev/exio/0raw device\n");
		return 1;
	}
		ioctl(da_fd, DA_IOCTRL_CLR);		//clear da.
		ioctl(da_fd, DA_IOCTRL_WRITE, &value);		
	close(da_fd);                                                         
	printf("Current Voltage is %f v\n", v);
	return 0;
}
