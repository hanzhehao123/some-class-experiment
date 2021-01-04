TOPDIR = ../
include $(TOPDIR)Rules.mak 
EXTRA_LIBS += -lpthread

EXEC = $(INSTALL_DIR)/httpd  ./httpd
OBJS = httpd.o copy.o

#HTTPD_DOCUMENT_ROOT = /mnt/yaffs
HTTPD_DOCUMENT_ROOT = /root
CFLAGS += -DHTTPD_DOCUMENT_ROOT=\"$(HTTPD_DOCUMENT_ROOT)\"

all: $(EXEC)

$(EXEC): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(EXTRA_LIBS)


install:
	$(EXP_INSTALL) $(EXEC) $(INSTALL_DIR)

clean:
	-rm -f $(EXEC) *.elf *.gdb *.o
