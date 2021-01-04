TOPDIR = ../
include $(TOPDIR)Rules.mak

EXTRA_LIBS += -lpthread

EXEC= $(INSTALL_DIR)/pthread  ./pthread
OBJS= pthread.o

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS)  $(EXTRA_LIBS)

install:
	$(EXP_INSTALL) $(EXEC) $(INSTALL_DIR)


clean:
	-rm -f $(EXEC) *.elf *.gdb *.o
