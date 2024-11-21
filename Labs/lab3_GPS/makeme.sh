gcc -o UTMconverter.o -c UTM.c -std=c11 -lm
gcc -o my_gps_example gpsExample.c UTMconverter.o -lm -lgps
