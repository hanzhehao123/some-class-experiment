TOPDIR = ../
include $(TOPDIR)/Rules.mak

INSTALL_DIR = $(TOPDIR)/bin
EXTRA_LIBS += -lpthread

TARGET = 485-test

485-test: 485-test.o
	$(CC) $(CFLAGS) $^ -o $@


install:
	$(EXP_INSTALL) $(TARGET) $(INSTALL_DIR)


clean:
	rm -f *.o a.out da *.gdb 485-test
