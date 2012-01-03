#
# update this variable to wherever you installed the OpenXDK libraries
#
PREFIX = /usr/local/openxdk

CC   = i386-pc-xbox-gcc
CPP  = i386-pc-xbox-g++
CXBE = cxbe

SDLFLAGS  = -DENABLE_XBOX -DDISABLE_CDROM 
CC_FLAGS  = -c -g -std=gnu99 -ffreestanding -nostdlib -fno-builtin -fno-exceptions -mno-cygwin -march=i386 $(SDLFLAGS)
CPP_FLAGS = -c -g                           -nostdlib -fno-builtin -fno-exceptions -mno-cygwin -march=i386 $(SDLFLAGS)
INCLUDE   = -I$(PREFIX)/i386-pc-xbox/include -I$(PREFIX)/include -I$(PREFIX)/include/SDL

CLINK = -nostdlib
ALIGN = -Wl,--file-alignment,0x20 -Wl,--section-alignment,0x20 
SHARED = -shared
ENTRYPOINT = -Wl,--entry,_WinMainCRTStartup 
STRIP = -Wl,--strip-all
LD_FLAGS = $(CLINK) $(ALIGN) $(SHARED) $(ENTRYPOINT) $(STRIP)
LD_DIRS = -L$(PREFIX)/i386-pc-xbox/lib -L$(PREFIX)/lib 
LD_LIBS  = $(LD_DIRS) -lSDL_image -ljpeg -lpng -lc -lg -lz -lm -lSDL -lopenxdk -lhal -lc -lhal -lc -lusb -lxboxkrnl -lc

OBJ_FILES = main.o players.o game.o

all: \
	xset.exe

objfiles: $(OBJ_FILES)

.o:
	$(CC) -c $< $(CC_FLAGS) $(INCLUDE)

xset.exe: $(OBJ_FILES)
	$(CC) -o $@ $< $(LD_LIBS) $(LD_FLAGS)
	$(CXBE) -TITLE:"$@" -DUMPINFO:"xset.cxbe" -OUT:"xset.xbe" $@

clean: 
	rm -f *.o *.exe *.dll *.xbe *.cxbe


