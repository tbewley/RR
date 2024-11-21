# This is a simple Makefile, to see how they work
CC=gcc     # use the ubiquitous gcc compiler
CFLAGS=-I. # look in the present directory, ., for files
LFLAGS=-lm # link with the standard c math library libm
DEPS = levmarq.h  # the .h file describing stuff needed by levmarq
OBJ = main.o levmarq.o # a list of all object files needed

%.o: %.c $(DEPS)  # this compiles all of the OBJ files
	$(CC) -c -o $@ $< $(CFLAGS) 
# the above line (and the two similar lines below) starts with a tab!

main: $(OBJ) # once all of the OBJ files are compiled, this links them
	$(CC) -o $@ $^ $(CFLAGS) $(LFLAGS)

clean:     # gets rid of all created object files, and the main file
	rm -f *.o main    
