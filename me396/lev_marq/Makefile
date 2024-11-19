# This is a simple Makefile, to see how the work
CC=gcc     # use the ubiquitous gcc compiler
CFLAGS=-I. # look in the present directory, ., for files
LFLAGS=-lm # link with the standard c math library libm
DEPS = levmarq.h  # the .h file describing stuff needed by levmarq
OBJ = main.o levmarq.o # a list of all object files needed

%.o: %.c $(DEPS)  # this compiles all of the OBJ files
	$(CC) -c -o $@ $< $(CFLAGS)          # this line starts with a tab!

main: $(OBJ) # once all of the OBJ files are complied, this links them
	$(CC) -o $@ $^ $(CFLAGS) $(LFLAGS)   # this line starts with a tab!

clean:     # get rid of created object files, and main file
	rm -f *.o main                       # this line starts with a tab!
