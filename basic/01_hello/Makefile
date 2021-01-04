TOPDIR = ../
include $(TOPDIR)Rules.mak

EXEC = $(INSTALL_DIR)/hello  ./hello
OBJS = hello.o 

all: $(EXEC)
$(EXEC): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) 
install:
	$(EXP_INSTALL) $(EXEC) $(INSTALL_DIR)


clean:
	-rm -f $(EXEC) *.elf *.gdb *.o
