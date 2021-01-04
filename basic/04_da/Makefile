TOPDIR = ../
include $(TOPDIR)Rules.mak

EXTRA_LIBS += -lpthread

TARGET = da_main

da_main: da_main.o
	$(CC) $(CFLAGS) $^ -o $@

install:
	$(EXP_INSTALL) $(TARGET) $(INSTALL_DIR)

clean:
	rm -f *.o a.out da *.gdb da_main
