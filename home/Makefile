CC = gcc
RM = rm

CFLAGS = -Wall -Wextra -ansi -pedantic
LIBS = 
OBJECTS = 
PROG = 
SOURCES = 
D_FLAGS = -g -DDEBUG
debug_prefix = d_

D_OBJECTS := $(OBJECTS:%=$(debug_prefix)%)



$(PROG) : $(OBJECTS) $(LIBS) $(SOURCES)
	$(CC) $(CFLAGS) -o $@ $^

$(PROG)-debug : $(D_OBJECTS) $(LIBS) $(SOURCES)
	$(CC) $(CFLAGS) -o $@ $^

$(PROG)-debug : CFLAGS += $(D_FLAGS)

# Enter recipes for debug objects below
#d_example.o : example.c example.h
#	$(CC) $(CFLAGS) -c -o $@ $<



debug : $(PROG)-debug

all : $(PROG)-debug $(PROG)

#test :

clean :
	-@$(RM) $(PROG) $(PROG)-debug 2> /dev/null || true

cleanobj :
	-@$(RM) *.o 2> /dev/null || true

cleanall : clean cleanobj

.POSIX:
.PHONY: debug all test clean cleanobj cleanall
