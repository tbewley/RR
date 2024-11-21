// example  gpsd client
// hacked by Briggs
// 9/11/2024
// original from https://gpsd.io/gpsd-client-example-code.html
// compile this way:
//    gcc example1.c -o example1 -lgps -lm
#include <gps.h>         // for gps_*()
#include <math.h>        // for isfinite()
#include "UTM.h"	  //for the UTM converter

#define MODE_STR_NUM 4
static char *mode_str[MODE_STR_NUM] = {
    "n/a",
    "None",
    "2D",
    "3D"
};

int main(int argc, char *argv[])
{
    struct gps_data_t gps_data;
    double xEasting, yNorthing;
    
    printf("Looking for gpsd on localhost:2947\n");

    if (0 != gps_open("localhost", "2947", &gps_data)) {
        printf("Open error. Is gpsd running? Bye, bye\n");
        return 1;
    } else {
    	printf("Made contact with gpsd on localhost:2947\n");
    }

    (void)gps_stream(&gps_data, WATCH_ENABLE | WATCH_JSON, NULL);

    while (gps_waiting(&gps_data, 5000000)) {
        if (-1 == gps_read(&gps_data, NULL, 0)) {
            printf("Read error.  Bye, bye\n");
            break;
        }
        if (MODE_SET != (MODE_SET & gps_data.set)) {
            // did not even get mode, nothing to see here
            continue;
        }
        if (0 > gps_data.fix.mode ||
            MODE_STR_NUM <= gps_data.fix.mode) {
            gps_data.fix.mode = 0;
        }
        printf("Fix mode: %s (%d) Time: ",
               mode_str[gps_data.fix.mode],
               gps_data.fix.mode);
        if (TIME_SET == (TIME_SET & gps_data.set)) {
            // not 32 bit safe
            printf("%ld.%09ld ", gps_data.fix.time.tv_sec,
                   gps_data.fix.time.tv_nsec);
        } else {
            puts("n/a ");
        }
        if (isfinite(gps_data.fix.latitude) &&
            isfinite(gps_data.fix.longitude) &&
            isfinite(gps_data.fix.altitude)) {
            // Display data from the GPS receiver if valid.
            printf("Lat %.6f Lon %.6f Alt %.6f\n",
                   gps_data.fix.latitude, gps_data.fix.longitude, gps_data.fix.altitude);
           LatLonToUTMXY (gps_data.fix.latitude, gps_data.fix.longitude, 0 /*zone*/,  &xEasting,  &yNorthing);
           printf("x(Easting) %.6f y(Northing) %.6f\n",xEasting,yNorthing);
        } else {
            printf("Lat n/a Lon n/a Alt n/a\n");
        }
    }

    // When you are done...
    (void)gps_stream(&gps_data, WATCH_DISABLE, NULL);
    (void)gps_close(&gps_data);
    return 0;
}
