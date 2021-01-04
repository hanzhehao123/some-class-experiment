#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
///#include <linux/delay.h>

#define TUBE_IOCTROL  0x11
#define DOT_IOCTROL   0x12

void jmdelay(int n) {
    int i,j,k;
    for (i=0;i<n;i++)
        for (j=0;j<100;j++)
            for (k=0;k<100;k++);
}

int main() {
    int fd;
    int i,j,k;
    unsigned int LEDWORD;
    unsigned int MLEDA[8];
    unsigned char LEDCODE[10]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};
    unsigned char dd_data[16][10]={{0xff,0,0,0,0,0,0,0,0,0},
	{0,0xff,0,0,0,0,0,0,0,0},
	{0,0,0xff,0,0,0,0,0,0,0},
	{0,0,0,0xff,0,0,0,0,0,0},
	{0,0,0,0,0xff,0,0,0,0,0},
	{0,0,0,0,0,0xff,0,0,0,0},
	{0,0,0,0,0,0,0xff,0,0,0},
	{0,0,0,0,0,0,0,0xff,0,0},
	{0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1,0,0},
	{0x2,0x2,0x2,0x2,0x2,0x2,0x2,0x2,0,0},
	{0x4,0x4,0x4,0x4,0x4,0x4,0x4,0x4,0,0},
	{0x8,0x8,0x8,0x8,0x8,0x8,0x8,0x8,0,0},
	{0x10,0x10,0x10,0x10,0x10,0x10,0x10,0x10,0,0},
	{0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0,0},
	{0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x40,0,0},
	{0x80,0x80,0x80,0x80,0x80,0x80,0x80,0x80,0,0},
    };
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

    for (j=0;j<2;j++)
        for (i=0;i<10;i++)

        {
            LEDWORD=(LEDCODE[i]<<8)|LEDCODE[9-i];
            ioctl(fd,0x12,LEDWORD);
            jmdelay(1500);
        }

    printf("will enter DIG LED  ,please waiting .............. \n");

    sleep(1);

    for (i=0;i<16;i++) {
	write(fd,dd_data[i],10);
	jmdelay(1000);
    }
    while(1){
	unsigned char a[10];
        for (i=0;i<10;i++)
		a[i] = rand() % 255;
	write(fd,a,10);
	jmdelay(500);
            
    }
    close(fd);
    return 0;

}

