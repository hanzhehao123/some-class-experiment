/***********************************************\
*	      by zhln<chlzh@mail.china.com>	        *
*		            2005.07.07	        	    *
*						                        *
\***********************************************/

#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/ioctl.h>
#include <pthread.h>
#include <fcntl.h>
#include <time.h>


/* -----------------------AD----------------------- */
#define ADC_WRITE(ch, prescale)	((ch)<<16|(prescale))

#define ADC_WRITE_GETCH(data)	(((data)>>16)&0x7)
#define ADC_WRITE_GETPRE(data)	((data)&0xff)


#define ADC_DEV		"/dev/s3c2410_adc"
static int adc_fd = -1;

static int init_ADdevice(void)
{
	if((adc_fd=open(ADC_DEV, O_RDWR))<0){
		printf("Error opening %s adc device\n", ADC_DEV);
		return -1;
	}
	return 0;
}

static int GetADresult(int channel)
{
	int PRESCALE=0XFF;
	int data=ADC_WRITE(channel, PRESCALE);
	write(adc_fd, &data, sizeof(data));
	read(adc_fd, &data, sizeof(data));
	return data;
}


/* ------------------------CAN----------------------- */
#define UPCAN_IOCTRL_SETBAND			0x1	//set can bus band rate
#define UPCAN_IOCTRL_SETID				0x2	//set can frame id data
#define UPCAN_IOCTRL_SETLPBK			0x3	//set can device in loop back mode or normal mode
#define UPCAN_IOCTRL_SETFILTER			0x4	//set a filter for can device
#define UPCAN_IOCTRL_PRINTRIGISTER	0x5	// print register information of spi and portE

#define UPCAN_EXCAN					(1<<31)	//extern can flag

typedef enum{
	BandRate_125kbps=1,
	BandRate_250kbps=2,
	BandRate_500kbps=3,
	BandRate_1Mbps=4
}CanBandRate;

typedef struct {
	unsigned int id;	
	unsigned char data[8];
	unsigned char dlc;		
	int IsExt; 
	int rxRTR;	
}CanData, *PCanData;

typedef struct{
	unsigned int Mask;
	unsigned int Filter;
	int IsExt;
}CanFilter,*PCanFilter;


#define CAN_DEV "/dev/can0"

static int can_fd=-1;

//#define DEBUG
#ifdef DEBUG
#define DPRINTF(x...) printf("Debug:"##x)
#else
#define DPRINTF(x...)
#endif

static void* canRev(void* t)
{
  CanData data;
  int i;

  DPRINTF("can receive thread begin.\n");
  for(;;){
	read(can_fd,&data,sizeof(CanData));
	for(i=0;i<data.dlc;i++)
	  putchar(data.data[i]);
	fflush(stdout);
  }
  return NULL;
}

#define MAX_CANDATALEN 8
static void CanSendString(char *pstr)
{
  CanData data;
  int len=strlen(pstr);
  memset(&data,0,sizeof(CanData));
  data.id=0x123;
  data.dlc=8;
  for(;len>MAX_CANDATALEN;len-=MAX_CANDATALEN){
    memcpy(data.data,pstr,8);
    write(can_fd,&data,sizeof(CanData));
  }

  data.dlc=len;
  memcpy(data.data,pstr,len);
  write(can_fd,&data,sizeof(CanData));
}

int main(void)
{
	static int i;
	int flag;

	char datasend[8];
	pthread_t th_can;
    int d,d0,d1,d2;
	//    int j=0;


	int id=0x123;
    if(init_ADdevice()<0){
	  printf("Error initing ADdevice\n");
	  return -1;
	}
	if((can_fd=open(CAN_DEV,O_RDWR))<0){
	  printf("\nOops,could not open %s can device !\n",CAN_DEV);
	  return 1;
	}

	ioctl(can_fd,UPCAN_IOCTRL_SETID,id);
	
#ifdef DEBUG
  ioctl(can_fd,UPCAN_IOCTRL_SETLPBK,1);
#endif

	pthread_create(&th_can,NULL,canRev,0);


	while(1){
	  printf("    +---------------------------------------------------------+\n");
	  printf("    |   Please input 1,2,3,4,5,or 6 to respectively operate   |\n");
	  printf("    |  led1,led2,led3,buzzer,numeral transitor or step motor  |\n");
	  printf("    +---------------------------------------------------------+\n");
	  scanf("%d",&flag);
	  switch(flag){
      case 1:
		datasend[0]=0x81;
		datasend[2]=0;
		while(1){
		  printf("Input '0' or '1' to set led1,'2' to exit this cycle \n");
		  scanf("%d",&i);
		  if(i==0)
			datasend[1]=0;
		  else if(i==1)
			datasend[1]=1;
		  else
			break;
		  printf("\n0x%x,%d\n",datasend[0],datasend[1]);
		  write(can_fd,datasend,8);
		}
		  break;
	  case 2:
		datasend[0]=0x82;
		while(1){
		  printf("Input '0' or '1' to set led2,'2' to exit this cycle \n");
		  scanf("%d",&i);
		  if(i==0)
			  datasend[1]=0;
		  else if(i==1)
			  datasend[1]=1;
		  else if(i==2)
			  break;
		  write(can_fd,datasend,8);		  
		}
	    break;
	  case 3:
		datasend[0]=0x83;
		while(1){
		  printf("Input '0' or '1' to set led3,'2' to exit this cycle \n");
		  scanf("%d",&i);
		  if(i==0)
			datasend[1]=0;
		  else if(i==1)
			datasend[1]=1;
		  else if(i==2)
			break;
		  write(can_fd,datasend,8);
		}
		break;
	  case 4:
		datasend[0]=0x84;
		while(1){
		  printf("Input 1 to start buzzer 0 to stop buzzer,or 2 to exit this cycle\n");
		  scanf("%d",&i);
		  if(i==0)
			datasend[1]=0;
		  else if(i==1)
			datasend[1]=1;
		  else if(i==2)
			break;
		  CanSendString(datasend);
		}
		break;
	  case 5:
		datasend[0]=0x85;
		while(1){
	  	  printf("Input a number to light numeral transistor\n");
		  printf("Input '0xaa' to put out numeral transistor\n");
		  // scanf("%x",&i);
		  for(i=0;i<100;i++){
			datasend[1]=((i/10)<<4)+i%10;
		    CanSendString(datasend);
			sleep(1);
		  }
		}
		break;
	  case 6:
		datasend[0]=0x86;
        while( 1 ){		  
		  d0=GetADresult(1);
		  usleep(500000);
		  d1=GetADresult(1);
		  usleep(500000);
		  d2=GetADresult(1);
		  if((abs(d1-d2))>5){
			d1=d2;
		  }
		  else
			continue;
		  d=(d1-d0);
		  if(abs(d)<5){
			printf("The sample value -- %d is too small\n",d);
			continue;
		  }
		  printf("The sample value is: %6d\n",d);
		  datasend[1]=d*3/32;
		  write(can_fd,datasend,8);
		  
		}		  
		break;
	  default:
		break;
	  }
	}

	pthread_join(th_can,NULL);


	printf("\n");
	if(close(can_fd)<0){
	  printf("Oops,could not close the %s can device",CAN_DEV);
	  exit(1);
	}
	return 0;
}
