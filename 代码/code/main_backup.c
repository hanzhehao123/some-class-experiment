/************************************************\
*	by threewater<threewater@up-tech.com>	*
*		2004.06.18			*
*						*
\***********************************************/

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/ioctl.h>
#include <pthread.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/mman.h>
#include "s3c2410-adc.h"
///#include <linux/delay.h>

#define TUBE_IOCTROL  0x11
#define DOT_IOCTROL   0x12
#define ADC_DEV		"/dev/s3c2410_adc"
static int adc_fd = -1;

static int init_ADdevice(void)
{
	if((adc_fd=open(ADC_DEV, O_RDWR))<0){
		printf("Error opening %s adc device\n", ADC_DEV);
		return -1;
	}
}

static int GetADresult(int channel)
{
	int PRESCALE=0XFF;
	int data=ADC_WRITE(channel, PRESCALE);
	write(adc_fd, &data, sizeof(data));
	read(adc_fd, &data, sizeof(data));
	return data;
}
static int stop=0;

static void* comMonitor(void* data)
{
	getchar();
	stop=1;
	return NULL;
}

void jmdelay(int n) {
    int i,j,k;
    for (i=0;i<n;i++)
        for (j=0;j<100;j++)
            for (k=0;k<100;k++);
}

int main(void)
{
	int fd;
    int i,j,k;//todo
    unsigned int LEDWORD;
    unsigned int MLEDA[8];
    unsigned char LEDCODE[10]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};//led 0~9
    unsigned char dd_data[10]={0,0,0,0x8,0,0,0,0,0,0};//dot orginal 8x8
    
	fd=open("/dev/s3c2410_led0",O_RDWR);
    if (fd < 0) {
        printf("####Led device open fail####\n");
        return (-1);
    }
	LEDWORD=0xff00;
    printf("will enter TUBE LED  ,please waiting .............. \n");
    LEDWORD=0xff00;
    ioctl(fd,0x12,LEDWORD);
    sleep(1);
	//led get ready
	
	float d[3];
	pthread_t th_com;
	void * retval;

	//set s3c44b0 AD register and start AD
	if(init_ADdevice()<0)
		return -1;
                                                                                
	/* Create the threads */
	pthread_create(&th_com, NULL, comMonitor, 0);

	printf("\nPress Enter key exit!\n");
	
	write(fd,dd_data,10);//init
	jmdelay(1000);
	
	while( stop==0 ){
		for(i=0; i<=7; i++){
			if(dd_data[i]!=0){
				j=i+1;//column
				switch(dd_data[i]){
					case 0x1:
						k=8;break;//row
					case 0x2:
						k=7;break;
					case 0x4:
						k=6;break;
					case 0x8:
						k=5;break;
					case 0x10:
						k=4;break;
					case 0x20:
						k=3;break;
					case 0x40:
						k=2;break;
					case 0x80:
						k=1;break;
					default:  k=1;break;
				}
				break;
			} 
		}
		//led show position ,calculate {0,0,0,0x8,0,0,0,0,0,0}
		LEDWORD=(LEDCODE[j]<<8)|LEDCODE[k];
		ioctl(fd,0x12,LEDWORD);
		jmdelay(1500);
		usleep(1);
		
		
		//sample
		for(i=0; i<=2; i++){//采样0~2路A/D值
			d[i]=((float)GetADresult(i)*3.3)/1024.0;//value0-3
			printf("a%d=%8.4f\t",i,d);//output the value

		}
		printf("\r");
		//d[0] used for left-right d[1] for up-down
		//move
		int tmp; 
		tmp = (int)d[0];
		if (tmp>=2): 
			if (j<8): j=j+1;
			else: j=1;
		tmp = (int)d[1];
		if (tmp>=2):
			if (k<8): k=k+1;
			else: k=1;
		//modify dd_data
		for(i=0;i<10;i++)
			dd_data[i]=0;
		switch(k){
			case 1:
				dd_data[j-1]=0x80;break;//row
			case 2:
				dd_data[j-1]=0x40;break;
			case 3:
				dd_data[j-1]=0x20;break;
			case 4:
				dd_data[j-1]=0x10;break;
			case 5:
				dd_data[j-1]=0x8;break;
			case 6:
				dd_data[j-1]=0x4;break;
			case 7:
				dd_data[j-1]=0x2;break;
			case 8:
				dd_data[j-1]=0x1;break;
			default:  dd_data[j-1]=1;break;
		}
		write(fd,dd_data,10)
		
	}
	/* Wait until producer and consumer finish. */
	pthread_join(th_com, &retval);

	printf("\n");
	return 0;
}
