// RR_test_gpios.c, for USAFA ME396 lab 1 in Fall 2024, on an RPi 5
// H. Clark Briggs and Thomas Bewley, Oct 2024.   Copyright 2020 - 2024 USAFA
// This program uses 
//   gpio22 as an output (at pin 15) to control LED 1,
//   gpio27 as an output (at pin 13) to control LED 2,
//   gpio23 as an input  (at pin 16) to read BUTTON 1,
//   gpio24 as an input  (at pin 18) to read BUTTON 2,
//
// Note that "Embedded C", as opposed to "Standard C" (as used by hello_world), leverages rich
// library functions, like gpiod.h, to "touch hardware" (e.g., read buttons, light LEDs, ...)
//
// See RPi pin graphic here:
//   https://www.raspberrypi.com/documentation/computers/images/GPIO-Pinout-Diagram-2.png
// The RPi commands "gpioinfo" and "cat /boot/firmware/config.txt" help to see what pins are
// taken.  See also helpful information about gpiod_line_request get and set values here:
//    https://libgpiod.readthedocs.io/en/latest/group__line__request.html
//
// BUTTON CONFIGURATION: 
// Each RPi GPIO input pin selected has internally (by default) a 50K internal pulldown resistor
// to ground.  So, just connect each of these input pins through a button to 3.3V (RPi pin 1).
//
// LED CONFIGURATION 1 (simple):
// Connect each GPIO output pin to an LED via a current-limiting resister to ground (RPi pin 6).
//
// LED CONFIGURATION 2 (suggested in class, leveraging 2N2222 npn transistors):
//   a. Provide a prototypng board with 3.3V (RPi pin 1) and ground (RPi pin 6)
//   b. For each GPIO output pin, connect through a 1.5 kohm resistor to the Base of a transistor.
//   c. Connect the Emitter of each transistor to ground.
//   d. Connect 3.3v to an LED, through a 220 kohm resistor, to the Collector of each transistor.
// 
// The "main" program drives the LEDs, based on the presses of the buttons, in a simple manner.
//
// Compile and execute on an RPi5 as follows:
//   gcc RR_test_gpios.c -Wall -g -lgpiod -o RR_test_gpios; ./RR_test_gpios
// Note: -Wall gives warnings, -g keeps symbols for use by a debugger

#include <stdio.h>  // the first two standard libraries define a whole bunch of useful stuff 
#include <stdlib.h> //     (google them...)
#include <string.h> // this library defines some string handling commands
#include <errno.h>  // this library defines the convenient perror message
#include <unistd.h> // this library defines the sleep, usleep, nanosleep commands
#include <signal.h>	// this library defines a mechanism to capture ctrl-c signals
#include <gpiod.h>  // this is the modern linux library of functions to handle GPIOs.

// these additional functions and structs are below the main code in this program
int  set_LEDs();
int  read_buttons();
int  gpio_init();
void cleanup(int signo);
int  gpio_close();
struct gpiod_chip *theChip;
struct gpiod_line_request *theLineA = NULL;
struct gpiod_line_request *theLineB = NULL;
struct gpiod_line_request *theLineC = NULL;
struct gpiod_line_request *theLineD = NULL;

// Define the following as global so we don't have to pass them around everywhere
int chip=4;        // Note that the initial values defined after the = signs can be changed later.
int n_buttons=2;   // (some of these values indeed will be changed, many of them won't...)
int n_LEDs=2;
int button_val[] = {0, 0};  // the most recently-read button values
int LED_val[]    = {0, 0};  // the desired values for the LEDs (0=off, 1=on)
unsigned int gpio_line[] = {22, 27, 23, 24}; // the 4 GPIO lines to be used by thie program

// This is the "main" section of the program (in C, there is always a "main").
int main(int argc, char *argv[]){
	int i=0;
	signal(SIGINT, cleanup);  // this is the "signal catcher"; it calls cleanup on a ctrl-c interrupt
	printf("Using gpio%d and gpio%d to drive LEDs,",  gpio_line[0],gpio_line[1]);
	printf("and gpio%d and gpio%d to read buttons.\n",gpio_line[2],gpio_line[3]);
	if ( gpio_init() ) { perror("Initialize GPIOs"); return -1; } // the {} parts to the right handle
	if ( set_LEDs()  ) { perror("Set LEDs to off");  return -1; } // the errors, quitting on failure.
	while (i < 300) {         // loop 300 times (about 1 minute)
		if ( read_buttons() ) { perror("Reading buttons"); return -1; } 
		LED_val[0]=button_val[0]; LED_val[1]=button_val[1];  // echo the button values at the LEDs
	    if ( button_val[0]*button_val[1]==1 ) {    		     // blink (on even & odd i) 
	        if (i%2==1) { LED_val[0]=1; LED_val[1]=0; }      // if both buttons pressed
	        else        { LED_val[0]=0; LED_val[1]=1; }
	     }
	    if ( set_LEDs() ) { perror("Set LEDs");  return -1; }
		usleep(200000); i++; // set LEDs, pause 200 ms = 0.2 sec, increment i, and repeat
	}
	if ( gpio_close() ) { perror("Close GPIOs"); return -1; }
	return 0;  // indicate that we have successfully finished the main program
}

// This function reads all button values, puts the results in the global array button_val[].
int read_buttons() { 
	button_val[0]=gpiod_line_request_get_value(theLineC, gpio_line[2]);
	button_val[1]=gpiod_line_request_get_value(theLineD, gpio_line[3]);
	// printf("LED values = %d and %d\n",LED_val[0],LED_val[1]); // uncomment to debug.
	return 0;
}

// This function sets all LED values, based on the global array LED_val[].
int set_LEDs() {
	int ret;
	if (LED_val[0] > 0) {
		ret = gpiod_line_request_set_value(theLineA, gpio_line[0], GPIOD_LINE_VALUE_ACTIVE);
	} else {
		ret = gpiod_line_request_set_value(theLineA, gpio_line[0], GPIOD_LINE_VALUE_INACTIVE);
	}
	if (ret) { perror("set LED 0"); }
	if (LED_val[1] > 0) {
		ret = gpiod_line_request_set_value(theLineB, gpio_line[1], GPIOD_LINE_VALUE_ACTIVE);
	} else {
		ret = gpiod_line_request_set_value(theLineB, gpio_line[1], GPIOD_LINE_VALUE_INACTIVE);
	}
	if (ret) { perror("set LED 1"); }
	return 0;
}

struct gpiod_chip *gpiod_chip_open_by_number(int chip){
	struct gpiod_chip *theChip;
	char thePath[30];
	sprintf(thePath,"/dev/gpiochip%d",chip);
	theChip = gpiod_chip_open(thePath);	
	return theChip;
};

int  gpio_init() {
	int i=0;
	struct gpiod_line_settings  *theSettings;
	struct gpiod_line_config    *theConfig;
	struct gpiod_request_config *theRequest = NULL;
	int ret=0;
	unsigned int line;
	theChip = gpiod_chip_open_by_number(chip);  	                  // open the chip
	if (!theChip) { printf("Open chip %d failed\n",chip); ret=-1; } // handle errors
	theSettings = gpiod_line_settings_new();
	if (!theSettings) { perror("Get line settings"); ret=-1; }
	while (i < 4) {
		line=gpio_line[i];
		if (i<2) {
			gpiod_line_settings_set_direction(theSettings,GPIOD_LINE_DIRECTION_OUTPUT);	
			printf("Initializing gpio%d as output\n",line);
		} else {
			gpiod_line_settings_set_direction(theSettings,GPIOD_LINE_DIRECTION_INPUT);	
			printf("Initializing gpio%d as input\n",line);
		} 
		theConfig = gpiod_line_config_new();
		if (!theConfig){ perror("Initializing gpio line config"); ret=-1; }	
		if ( gpiod_line_config_add_line_settings(theConfig, &line, 1, theSettings) )
			{ perror("Add line settings"); ret=-1; }	
		theRequest = gpiod_request_config_new();
		if (!theRequest){ perror("Request new config"); ret=-1; }
		gpiod_request_config_set_consumer(theRequest, "gpio demo");
		switch (i) {
		  case 0: theLineA=gpiod_chip_request_lines(theChip,theRequest,theConfig); break;
		  case 1: theLineB=gpiod_chip_request_lines(theChip,theRequest,theConfig); break;
		  case 2: theLineC=gpiod_chip_request_lines(theChip,theRequest,theConfig); break;
		  case 3: theLineD=gpiod_chip_request_lines(theChip,theRequest,theConfig); break;	
		}
		gpiod_request_config_free(theRequest);
		gpiod_line_config_free(theConfig);
		i++;
	}
	gpiod_line_settings_free(theSettings);
	gpiod_chip_close(theChip);
	return ret;
}

void cleanup(int signo){
	if (signo == SIGINT){
		printf("received SIGINT Ctrl-C; closing.  Go Air Force!\n");
		if ( gpio_close() ) { perror("cleanup"); } // handle errors
		exit(0);
 	}
}

// close out gpios
int gpio_close() {
	int ret=0;
	LED_val[0]=0; LED_val[1]=0;  if ( set_LEDs() ) { perror("Set LEDs");  ret=-1; }
	gpiod_line_request_release(theLineA);  // release the line request
	gpiod_line_request_release(theLineB);  // release the line request
	gpiod_line_request_release(theLineC);  // release the line request
	gpiod_line_request_release(theLineD);  // release the line request
	return ret;
}