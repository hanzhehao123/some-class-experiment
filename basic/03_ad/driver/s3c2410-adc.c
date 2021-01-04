/*
 * s3c2410-adc.c
 *
 * S3C2410 ADC 
 *  exclusive with s3c2410-ts.c
 *
 * Author: SeonKon Choi <bushi@mizi.com>
 * Date  : $Date: 2003/01/20 14:24:49 $ 
 *
 * $Revision: 1.1.2.6 $
 *
	2008-6-14 add a device by lyj_uptech<lyj_uptech@126.com>

   Fri Dec 03 2002 SeonKon Choi <bushi@mizi.com>
   - initial

 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file COPYING in the main directory of this archive
 * for more details.
 */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <linux/ioport.h>
#include <linux/device.h>
#include <linux/serio.h>
#include <linux/delay.h>
#include <linux/err.h>
#include <linux/fs.h>
#include <linux/bcd.h>
#include <linux/errno.h>
#include <linux/slab.h>
#include <linux/input.h>
#include <linux/types.h>
#include <linux/cdev.h>
#include <linux/miscdevice.h>
#include <linux/poll.h>
#include <linux/spinlock.h>
#include <asm/plat-s3c/regs-adc.h>
#include <linux/clk.h>

#include <asm/io.h>
#include <asm/hardware.h>
#include <linux/sched.h>
#include <asm/irq.h>
#include <asm/semaphore.h>
#include <asm/arch/regs-gpio.h>
#include <asm/uaccess.h>

#include "s3c2410-adc.h"
MODULE_LICENSE("Dual BSD/GPL");

#define DEVICE_MAJOR  250
#define DEVICE_MINOR  0
struct cdev *mycdev;
   struct class_simple *myclass;
dev_t devno;

int adc_major;
int adc_minor;

struct cdev adc_cdev;
static void __iomem *base_addr;
struct clk *clk;
static int ch;

int adc_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
{
	 printk(KERN_ERR "cmd %d\n",cmd);
	ch=cmd; //set up channel
	return 0;
}


ssize_t s3c2410_adc_read(struct file *filp,char __user *buf,size_t count,loff_t *f_pos)
{
	int i,LOOP=10000;


	clk_enable(clk); //enable clk

	writel((1<<14)|S3C2410_ADCCON_PRSCVL(254)|(ch<<3)|(0<<1)|(0<<0),base_addr+S3C2410_ADCCON); //setup channel

	for(i=0;i<LOOP;i++); //delay to set up the next channel


	writel((readl(base_addr+S3C2410_ADCCON)|0x1),base_addr+S3C2410_ADCCON); //start ADC
	while((readl(base_addr+S3C2410_ADCCON) & 0x1)); //check if enable start flag is low
	while(!(readl(base_addr+S3C2410_ADCCON) & 0x8000)); //check if EC(End of Conversion) flag is high

	writel(0,base_addr+S3C2410_ADCCON); //stop ADC
	i=readl(base_addr+S3C2410_ADCDAT0);
	i= i & 0x3ff;
	copy_to_user(buf, &i, sizeof i);
	return sizeof i;
}
 
static ssize_t s3c2410_adc_write(struct file *file, const char *buffer, size_t count, loff_t * ppos)
{
        int data;
 
        if(count!=sizeof(data)){
                printk("the size of  input data must be %d\n", sizeof(data));
                return 0;
        }
 
        copy_from_user(&data, buffer, count);
        ch=ADC_WRITE_GETCH(data);
 
 
        return count;
}
 

struct file_operations adc_fops = {
	.owner = THIS_MODULE,
	.ioctl = adc_ioctl,
	.read = s3c2410_adc_read,
	.write = s3c2410_adc_write,
};

int S3C2410adc_init(void)
{
	int err;
        devno = MKDEV(DEVICE_MAJOR, DEVICE_MINOR);     
        mycdev = cdev_alloc();

	cdev_init(mycdev,&adc_fops);
//	adc_cdev.owner=THIS_MODULE;
//	adc_cdev.ops=&adc_fops;
	err=cdev_add(mycdev,devno,1);
	if (err < 0)
		printk(KERN_ERR "can't add s3c2410_adc");
        myclass = class_create(THIS_MODULE, "s3c2410_adc");
        if(IS_ERR(myclass)) {
          printk("Err: failed in creating class.\n");
          return -1;
	}
 
	class_device_create(myclass,NULL, MKDEV(DEVICE_MAJOR,DEVICE_MINOR), NULL, "s3c2410_adc",DEVICE_MINOR);


	base_addr = ioremap(0x58000000, 0x20);
	if (base_addr == NULL) {
		printk(KERN_ERR "Failed to remap register block\n");
		return -ENOMEM;
	}

	/* get our clock */
	clk = clk_get(NULL, "adc");

	if (IS_ERR(clk) || clk == NULL) {
		printk(KERN_ERR "ADC clk_get err!!!!!!!!!!!!!\n");
	}

	/* only enable the clock when we are actually using the adc */

	printk(KERN_ERR "add s3c2410_adc ok!!!!!!!!!!!!\n");

	return 0;
}
void S3C2410adc_exit(void)
{
	dev_t dev=MKDEV(adc_major,adc_minor);
	cdev_del(&adc_cdev);
	class_device_destroy(myclass,devno);
        class_destroy(myclass);
	iounmap(base_addr);
//	unregister_chrdev_region(dev,1);
	
}
module_init(S3C2410adc_init);
module_exit(S3C2410adc_exit);

