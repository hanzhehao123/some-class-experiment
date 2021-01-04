
include ./Rules.mak
dirs = 01_hello 02_pthread 03_tty 04_ad  05_da 06_can 07_httpd 08_485 09_dcmotor 10_led keyboard 

all: 
	for i in $(dirs) ; do  make -C $$i || exit $? ; done
clean:
	-for i in $(dirs) ; do \
		[ ! -d $$i ] || make -C $$i clean; \
	done

install:
	-for i in $(dirs) ; do \
		[ ! -d $$i ] || make -C $$i install; \
	done
