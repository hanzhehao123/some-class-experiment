CROSS = arm-linux-
CC= $(CROSS)gcc
EXP_INSTALL = install -m 755 

EXTRA_LIBS += -lpthread

EXEC= getkey
OBJS= keyboard.o get_key.o main.o

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC)  -o $@ $(OBJS)  $(EXTRA_LIBS)

install:
	$(EXP_INSTALL) $(EXEC) $(INSTALL_DIR)


clean:
	-rm -f $(EXEC) *.elf *.gdb *.o
