/*
	fpga-test.c, need insmod s3c2410-fpga.o first.
	author: wb <wbinbuaa@163.com>
	date:   2005-6-13 21:05
*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <pthread.h>
//#include <sys/mman.h>
#include <termios.h>

#define _485_IOCTRL_RE2DE	(0x10)			//send or receive
#define _485_RE			0					//receive
#define _485_DE			1					//send

//#define BAUDRATE B115200
#define COM2 "/dev/ttySAC2"
#define DEV485 "/dev/s3c2410_4850"

static int get_baudrate(int argc,char** argv);

static void help_menu()
{
	printf("\n");
	printf("	DESCRIPTION\n");
	printf("      	S3c2410 485 uart test program. \n");	
	printf("      	arg0: 485-test \n");	
	printf("      	arg1: baudrate, default for input 115200 \n");	
	printf("      	arg2: select 485 mode: \n");	
	printf("      	rev: receive data. \n");	
	printf("      	send: send data, access data from console. \n");	
	printf("	OPTIONS\n");
	printf("      	-h or --help:    this menu\n");
	printf("\n");
}

int main(int argc, char **argv)
{
	int fd485, fdcom2;
	struct termios oldtio,newtio,oldstdtio,newstdtio;
	char buf[1024]={0}, c='\n', *d;
	int baud;
	
	if((argc > 3 ) ||(argc == 1)){
		help_menu();
		exit(0);
	}
	
	fd485 = open(DEV485,O_RDWR);
	if(fd485 < 0){
		printf("####s3c2410_485 device open %s fail####\n",DEV485);
		return (-1);
	}

	fdcom2 = open(COM2, O_RDWR);
	if (fdcom2 <0) {
	    	perror(COM2);
	    	exit(-1);
  	}
	
	if((baud=get_baudrate(argc, argv)) == -1) {
		printf("####s3c2410 485 device baudrate set failed####\n");
	}
	
  	tcgetattr(0,&oldstdtio);
  	tcgetattr(fdcom2,&oldtio); /* save current modem settings */
  	tcgetattr(fdcom2,&newstdtio); /* get working stdtio */
	newtio.c_cflag = baud | CRTSCTS | CS8 | CLOCAL | CREAD;/*ctrol flag*/
	newtio.c_iflag = IGNPAR; /*input flag*/
	newtio.c_oflag &= ~(ICANON | ECHO | ECHOE | ISIG);		/*output flag*/
 	newtio.c_lflag &= ~OPOST;
 	newtio.c_cc[VMIN]=1;
	newtio.c_cc[VTIME]=0;
 	/* now clean the modem line and activate the settings for modem */
 	tcflush(fdcom2, TCIFLUSH);
	tcsetattr(fdcom2,TCSANOW,&newtio);/*set attrib	  */
	
	if(strncmp(argv[2],"send",4)==0) {
		
		ioctl(fd485, _485_IOCTRL_RE2DE, _485_DE );		//set 485 mode: send
		printf("####s3c2410 485 device ready to send####\n");
		#if 1
		{
			int i;
			for(i='0'; i<='z'; i++) {
				printf("%c", i);
				fflush(stdout);
				write(fdcom2,&i,1);
				usleep(10000);
				if (i == 'z')
					i = '0'-1;
			}
		}
		#endif
		
		#if 0
		while(1) {
			gets(buf);
			d = buf;
			while(*d != '\0') {
				write(fdcom2, d, 1);
				usleep(100);
				d++;
			}
			write(fdcom2, &c, 1);
		}
		#endif
		
	} else if (strncmp(argv[2],"rev",3)==0) {
	
		ioctl(fd485, _485_IOCTRL_RE2DE, _485_RE );		//set 485 mode: rev		
		printf("####s3c2410 485 device receiving ####\n");
		
		do {
    			read(fdcom2,&c,1); /* com port */
			printf("%c", c);
			fflush(stdout);
		}while (c != '\0');
	}
	
	close(fdcom2);
	close(fd485);
	return 0;
}

static int get_baudrate(int argc,char** argv)
{
	int v=atoi(argv[1]);
	 switch(v){
		case 4800:
			return B4800;
			
		case 9600:
			return B9600;
			
		case 19200:
			return B19200;
			
		case 38400:
			return B38400;
			
		case 57600:
			return B57600;
			
		case 115200:
			return B115200;
		default:
			return -1;
	 } 	 
}


