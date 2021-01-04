TOPDIR = ../
include $(TOPDIR)Rules.mak
INSTALL_DIR = $(TOPDIR)/bin

EXTRA_LIBS += -lpthread

TARGET = dcm_main

all: $(TARGET)

dcm_main: dcm_main.o
	$(CC) $(CFLAGS) $^ -o $@

install:
	$(EXP_INSTALL) $(TARGET) $(INSTALL_DIR)

clean:
	rm -f *.o a.out da *.gdb dcm_main
