// Every good repository of codes needs some variant of this time-honored classic.  
// Compile and run on most machines with:
//    gcc RR_hello_world.c -o RR_hello_world; ./RR_hello_world
// I am seriously not copyrighting this one.  - Tom Bewley, Nov 2024

#include <stdio.h>
#include <unistd.h>

int main() {
   int i=10;
   while (i>=0) { printf("%d... ",i); fflush(stdout); sleep(1); i--; }
   printf("\nHello, World!\n");
   return 0;
}
