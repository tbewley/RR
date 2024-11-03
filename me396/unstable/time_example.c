#include <sys/time.h>
#include <stdio.h>
#include <time.h>

struct timeval GetTimeStamp() 
{
    struct timeval tv;
    gettimeofday(&tv,NULL);
    return tv;
}

int main()
{
    struct timeval tv= GetTimeStamp(); // Calculate time
    signed long time_in_micros = 1000000 * tv.tv_sec + tv.tv_usec; // Store time in microseconds
    
    getchar(); // Replace this line with the process that you need to time

    printf("Elapsed time: %ld microsecons\n", (1000000 * GetTimeStamp().tv_sec + GetTimeStamp().tv_usec) - time_in_micros);
    
}