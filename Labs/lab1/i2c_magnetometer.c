/* ME396 Fall 2024
* I2C HMC5883L magnetometer lab for the RPi
* 10/30/2024 By Briggs
* Copyright USAFA 2024
*/
/* Original code from 
* James Sleeman, http://sparks.gogo.co.nz/
* for Arduino
* Copyright (C) 2014 James Sleeman
*/
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h> //uint8_t
#include <unistd.h>	//sleep
#include <signal.h>	//capture ctrl-c

#include "magnetometer.h"

void cleanup(int signo);	//Ctrl-C signal catcher function on exit

int main(int argc, char *argv[]){
	int ret;
	float heading;
	
	signal(SIGINT, cleanup);	//signal catcher calls cleanup function on exit
	
	//initialize
	fprintf(stdout, "main: intializing I2C Magnetometer\n");
	ret = magnetometer_init();
	if (ret == -1){
		fprintf(stderr,"ERROR: in main, magnetometer_init failed\n");
		return -1;
	}

	fprintf(stdout, "main: will loop collecting a magnetometer reading 1 per second. Terminate with Ctrl-C on the console\n");
	while (1==1){
		heading = GetHeadingDegrees( );
		fprintf(stdout,"main: heading = %2.2f degrees\n", heading);
		sleep(1);
	}
	//not reached
	magnetometer_close();
	fprintf(stdout, "main: that's all folks!\n");
	return (0);
}

void cleanup(int signo){
	if (signo == SIGINT){
		magnetometer_close();
		fprintf(stdout, "\nreceived SIGINT Ctrl-C. Bye bye.\n");
		exit(0);
 	}
};


