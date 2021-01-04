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

#define TUBE_IOCTROL  0x11
#define DOT_IOCTROL   0x12
#define ADC_DEV		"/dev/s3c2410_adc"
//#define SAMPLE_CODE 2.5
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

int encode(int n){
	n+=26;
	n*=13;
	return h;
}

int decode(int n){
	n/=13;
	n-=26;
	return n;
}

int main(void)
{
    int fd;
    int i,j,k;
	int i0,j0,k0;
    //int a;
    //int tmp;
    float d[3];
    //int rand_num;
	//int rand_sleep;
    //int state;
    unsigned int LEDWORD;
    unsigned int MLEDA[8];
    unsigned char LEDCODE[10]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};//led 0~9
    unsigned char dd_data[10]={0,0,0,0x8,0,0,0,0,0,0};//dot orginal 8x8
    pthread_t th_com;
    void * retval;


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

	//set s3c44b0 AD register and start AD
    if(init_ADdevice()<0)
	return -1;
                                                                                
	/* Create the threads */
    pthread_create(&th_com, NULL, comMonitor, 0);

	//set random value设置随机数
	rand0 = rand()%100+1;

	rand_num = rand()%10+1; //1-10
	rand_sleep = rand()%20+5; //5-25
	
    printf("\nPress Enter key exit!\n");
    write(fd,dd_data,10);//init
    jmdelay(1000);

	
	//step 1-1: dotmat->led,state+1
	while( stop==0 ){
		rand0 = rand()%100+1;
		state = rand0;//state init
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
		jmdelay(rand0);//insert short sleep, defend attack
		//state+=1;j+=3;k+=4;//encode j,k,state change
		state = encode(state);
		j0 = encode(j);
		k0 = encode(k);
		//back up
		//k_last=k;j_last=j;
		
	//step1-2: show on led according to j,k
		if (decode(state)!=rand0) continue; //judge_1
		LEDWORD=(LEDCODE[decode(j0)]<<8)|LEDCODE[decode(k0)];
		ioctl(fd,0x12,LEDWORD);
		jmdelay(rand0);
		usleep(1);
		
		
	//step2-1: sample
		for(i=0;i<3;i++){
		    d[i]=0.0;
		}
		jmdelay(rand0);
		//for(a=0;a<10;a++){
		for(i=0; i<=2; i++){//����0~2·A/Dֵ
			d[i]+=((float)GetADresult(i)*3.3)/1024.0;//value0-3
			//printf("a%d=%8.4f\t",i,d);//output the value
		}
		//}
		jmdelay(rand0);
		for(i=0;i<=2;i++){
		//	d[i] /= 10.0;
			d[i]+=SAMPLE_CODE;//encode
		}
		//state+=2;
		
		//d[0] used for left-right d[1] for up-down
	//step2-2: movement 
		if (decode(state)!=rand0) continue;//judge_2
		tmp = (int)(d[0]-SAMPLE_CODE);//decode
		if (1.9<tmp<2.1) tmp+=0.3;//avoid swaping
		if (tmp>=2){ 
			if(decode(j0)<8) j+=1;
		//	else j=4;
			}
		tmp = (int)(d[1]-SAMPLE_CODE);
		if (1.9<tmp<2.1) tmp+=0.3;//avoid swaping
		jmdelay(rand0);
		if (tmp>=2){
			if(decode(k0)<8) k+=1;
		//	else k=5;
			}
		//if ((j-j_last)>1||(k-k_last)>1){
		//	k=k_last;
		//	j=j_last;//the dot can only move step by step. if the movement>1, set the value back
		//}
		
	//modify dd_data
		for(i=0;i<10;i++)
			dd_data[i]=0;
		//state+=3;
	//step3-1: change dd_data and show in dot-mat
		if (decode(state)!=rand0) continue;//judge_3
		//j-=3;k-=4;//decode j,k
		j = decode(j0);
		k = decode(k0);
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
		jmdelay(rand0);
		write(fd,dd_data,10);
		
	}
	/* Wait until producer and consumer finish. */
	pthread_join(th_com, &retval);
		
	printf("\n");
	return 0;
}
