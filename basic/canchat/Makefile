TOPDIR = ../
#include $(TOPDIR)/Rules.mak

CC=arm-linux-gcc

EXTRA_LIBS += -lpthread

EXEC= ./canchat 

OBJS= main.o

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS)  $(EXTRA_LIBS)  

install:
	$(EXP_INSTALL) $(EXEC) $(INSTALL_DIR)

clean:
	rm -f *.o a.out canchat *.gdb
