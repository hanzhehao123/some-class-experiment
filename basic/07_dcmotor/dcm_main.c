/*
 * dcm_main.c
 *
 * S3C2410-S DCM MOTOR
 *
 * Author: wang bin <wbinbuaa@163.com>	
 * Date  : $Date: 2005/07/27 $ 
 *
 * $Revision: 1.0.0.1 $
 *						
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file COPYING in the main directory of this archive
 * for more details.
 */

#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <sys/ioctl.h>

#define DCM_IOCTRL_SETPWM 			(0x10)
#define DCM_TCNTB0				(16384)

static int dcm_fd = -1;
char *DCM_DEV="/dev/s3c2410-dc-motor0";

void Delay(int t)
{
	int i;
	for(;t>0;t--)
		for(i=0;i<400;i++);
}

/****************************************************************/
int main(int argc, char **argv)
{
	int i = 0;
	int status = 1;
	int setpwm = 0;
	int factor = DCM_TCNTB0/1024;
	if((dcm_fd=open(DCM_DEV, O_WRONLY))<0){
		printf("Error opening %s device\n", DCM_DEV);
		return 1;
	}
	
	
	for (;;) {
		for (i=-512; i<=512; i++) {
			if(status == 1)
				setpwm = i;
			else
				setpwm = -i;
			ioctl(dcm_fd, DCM_IOCTRL_SETPWM, (setpwm * factor));			
			Delay(500);
			printf("setpwm = %d \n", setpwm);
		}
		status = -status;
	}
	
	close(dcm_fd);	
	return 0;
}
