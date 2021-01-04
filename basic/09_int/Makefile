
# To build modules outside of the kernel tree, we run "make"
# in the kernel source tree; the Makefile these then includes this
# Makefile once again.
# This conditional selects whether we are being included from the
# kernel Makefile or not.

TARGET = s3c2410-int
CROSS_COMPILE =arm-linux-
#CROSS_COMPILE =armv4l-unknown-linux-
CC              = $(CROSS_COMPILE)gcc
STRIP           = $(CROSS_COMPILE)strip
#CFLAGS          = -O2


ifeq ($(KERNELRELEASE),)

    # Assume the source tree is where the running kernel was built
    # You should set KERNELDIR in the environment if it's elsewhere
#    KERNELDIR ?= /home/qianzg/up-techpxa270/kernel/kernelspi
#KERNELDIR ?=/home/zhoujq/up_cup_s2410/kernel/2.6.24/linux-2.6.24.4
KERNELDIR ?=/home/oyx/classic/linux-2.6.24_released/linux-2.6.24.4
   # The current directory is passed to sub-makes as argument
    PWD := $(shell pwd)

all:	modules

modules:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules
modules_install:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install
install:
	cp -arf  s3c2410-int.ko /tftpboot/.

clean:
	rm -rf   *.o *~ core .depend .*.cmd *.ko *.mod.c .tmp_versions $(TARGET)

.PHONY: modules modules_install clean

else
    # called from kernel build system: just declare what our modules are
    obj-m := s3c2410-int.o

endif
