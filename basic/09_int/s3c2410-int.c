


//#include <linux/config.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

#include <linux/miscdevice.h>
#include <linux/sched.h>
#include <linux/delay.h>
#include <linux/poll.h>
#include <linux/spinlock.h>
#include <linux/delay.h>
#include <linux/interrupt.h>
#include <linux/irq.h>
#include <asm/io.h>
#include <asm/hardware.h>
#include <asm-arm/arch-s3c2410/regs-gpio.h>
#include <asm/arch/irqs.h>

#define SA_INTERRUPT          IRQF_DISABLED
#define DEVICE_NAME  "s3c2410-int"
#define S3C2410_IRQ5		IRQ_EINT5	//IRQ_EINT3


//#define GPIO_key_int01  (GPIO_MODE_IN | GPIO_PULLUP_DIS | GPIO_F3)

#define led01_enable() \
	 ({ 	writel ((readl(S3C2410_GPCCON) & (~0xc00)),S3C2410_GPCCON); \
		writel ((readl(S3C2410_GPCCON) | 0x400),S3C2410_GPCCON);              \
		writel ((readl(S3C2410_GPCDAT) & (~ 0x20)),S3C2410_GPCDAT);          \
		writel ((readl(S3C2410_GPCDAT) | 0x0),S3C2410_GPCDAT);   } )

#define led01_disable() \
	 ({ 	writel ((readl(S3C2410_GPCDAT) & (~ 0x20)),S3C2410_GPCDAT);          \
	 	writel ((readl(S3C2410_GPCDAT) | 0x20),S3C2410_GPCDAT);     })

#define led02_enable() \
   	 ({  	writel ((readl(S3C2410_GPCCON) & (~ 0x3000)),S3C2410_GPCCON);          \
        	writel ((readl(S3C2410_GPCCON) | 0x1000),S3C2410_GPCCON);   \
		writel ((readl(S3C2410_GPCDAT) & (~ 0x40)),S3C2410_GPCDAT);          \
       		writel ((readl(S3C2410_GPCDAT) | 0x0),S3C2410_GPCDAT); 	})

#define led02_disable() \
   	 ({  	writel ((readl(S3C2410_GPCDAT) & (~ 0x40)),S3C2410_GPCDAT);          \
                writel ((readl(S3C2410_GPCDAT) | 0x40),S3C2410_GPCDAT);   \
         	})

#define led03_enable() \
    	({	writel ((readl(S3C2410_GPCCON) & (~ 0xC000)),S3C2410_GPCCON);          \
                writel ((readl(S3C2410_GPCCON) | 0x4000),S3C2410_GPCCON);   \
		writel ((readl(S3C2410_GPCDAT) & (~ 0x80)),S3C2410_GPCDAT);          \
                writel ((readl(S3C2410_GPCDAT) | 0x0),S3C2410_GPCDAT);   \ 
        	})

#define led03_disable() \
        ({ 	writel ((readl(S3C2410_GPCDAT) & (~ 0x80)),S3C2410_GPCDAT);          \
                writel ((readl(S3C2410_GPCDAT) | 0x80),S3C2410_GPCDAT); \
          	})



 irqreturn_t  s3c2410_IRQ3_fun (int irq, void *dev_id, struct pt_regs *reg)
{
    	printk("enter interrupt 5 !\n");
           
         led01_enable();
	 mdelay(200);
 	 led01_disable();
	 mdelay(200);
         led02_enable();
         mdelay(200);
         led02_disable();
         mdelay(200);
         led03_enable();
         mdelay(200);
         led03_disable();
	
}

static int __init s3c2410_interrupt_init(void)
{
    	int ret;
	int flags;
	s3c2410_gpio_cfgpin(S3C2410_GPC5,S3C2410_GPC5_INP);  

	led01_disable();
	led02_disable();
    	led03_disable();
	mdelay(200);
 
        led01_enable();
        led02_enable();
        led03_enable();
        
        mdelay(200);
        led01_disable();
        led02_disable();
        led03_disable();  
       
        local_irq_save(flags);
// by sprife
	
        s3c2410_gpio_cfgpin( S3C2410_GPF5, S3C2410_GPF5_EINT5);
        s3c2410_gpio_pullup(S3C2410_GPF5,1);
// end
	set_irq_type(S3C2410_IRQ5,/*IRQT_FALLING*/IRQT_LOW);
	s3c2410_gpio_pullup(S3C2410_GPC5, 0);   
      
	local_irq_restore(flags);
	ret = request_irq(S3C2410_IRQ5, s3c2410_IRQ3_fun, SA_INTERRUPT, "S3C2410_IRQ5", NULL);
	if (ret)
    {
        printk("S3C2410_IRQ5 request_irq  failure");
        return ret;
    }
	printk(DEVICE_NAME " int05   initialized\n");
	return 0;
}


static void __exit s3c2410_interrupt_exit(void)
{
	free_irq(S3C2410_IRQ5,NULL);
	printk(DEVICE_NAME " unloaded\n");
}
MODULE_LICENSE("GPL");
module_init(s3c2410_interrupt_init);
module_exit(s3c2410_interrupt_exit);
