// RR_test_gpios.c, for USAFA ME396 lab 1 in Fall 2024, on an RPi 5
// H. Clark Briggs and Thomas Bewley, Oct 2024.   Copyright 2020 - 2024 USAFA
// This program uses 
//   gpio22 as an output (at pin 15) to control LED 1,
//   gpio27 as an output (at pin 13) to control LED 2,
//   gpio23 as an input  (at pin 16) to read BUTTON 1,
//   gpio24 as an input  (at pin 18) to read BUTTON 2,
// and is easily modified to handle more or fewer LEDs and buttons.
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
// Each RPi GPIO input pin selected has (by default) a 50K internal pulldown resistor to ground.
// So, just connect each of these input pins through a button to 3.3V (RPi pin 1).
//
// LED CONFIGURATION 1 (simple):
// Connect each GPIO output pin to an LED, through a current-limiting resister, to ground (RPi pin 6).
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

// These additional functions and structs are found below the main code in this program
int read_buttons;
int set_LEDs;
struct gpiod_chip *the_gpio_chip; // this struct is required by the gpiod library
int gpio_init;                    // this function initializes the GPIO lines
void cleanup(int signo);          // this function performs a clean shutdown if ctrl-c is pressed
int gpio_close;                   // this function closes the GPIO lines

// Now define the following as global variables, accessible in "main" as well as the other functions.
int chip=4;        // Note that the initial values defined after the = signs can be changed later.
int n_buttons=2;   // (some of these values indeed will be changed, many of them won't...)
int n_LEDs=2;
unsigned int gpio_line[] = {23, 24, 22, 27}; // the 4 GPIO lines to be used by thie program
struct gpiod_line_request *theLineRequest[] = {NULL, NULL, NULL, NULL}; // 4 pointers used by gpiod
int button_val[] = {0, 0};  // the most recently read button values
int LED_val[]    = {0, 0};  // the desired values for the LEDs (0=off, 1=on)

// This is the "main" section of the program (in C, there is always a "main").
int main(int argc, char *argv[]){
	// The following variable is "scoped" only for the "main" section.
	int i=0;
	signal(SIGINT, cleanup);  // this is the "signal catcher"; it calls cleanup on a ctrl-c interrupt
	printf("Using GPIO23 and GPIO24 to read buttons, and GPIO22 and GPIO27 to drive LEDs.\n");
	if ( gpio_init; ) { perror("Initialize GPIOs"); return -1; } // the {} parts to the right handle
	if ( gpio_set;  ) { perror("Set LEDs to off");  return -1; } // the errors, quitting on failure.
	while (i < 300) {         // loop 300 times (about 1 minute)
		read_buttons;  LED_val=button_val; // for now, just echo the button values at the LEDs
		printf("button value 0 = %d, button value 1 = %d\n", button_val[0], button_val[1]);
		// uncomment below to modify behavior to blink (on even & odd i) if both buttons pressed
		// if ( LED_val[0]*LED_val[1]==1 ) {
	    //    if (i%2==1) { LED_val[0]=1; LED_val[1]=0; }
	    //    else        { LED_val[0]=0; LED_val[1]=1; }
	    // }	
		set_LEDs; usleep(200000); i++; // set LEDs, pause 200 ms = 0.2 sec, increment i, and repeat
	}
	if ( gpio_close; ) { perror("Close GPIOs"); return -1; }
	return 0;  // indicate that we have successfully finished the main program
}

// This function reads all button values, puts the results in the global array button_val[].
int read_buttons { 
	// The following variable is "scoped" only for the "read_buttons" function.
	// Note that the i variable here is different from the i variable in the "main" section.
	int i=0;
	while (i<n_buttons) {
		int j=i+n_LEDs;  // note that, in C, variables can also be defined where they are needed
		button_val[i]=gpiod_line_request_get_value(theLineRequest[j], gpio_line[j]);
		i++;
	}
}

// This function sets all LED values, based on the global array LED_val[].
int set_LEDs {
	// The following variables are "scoped" only for the "read_buttons" function.
	int i=0;
	int ret=0;
	int VALUE;
	while (i<n_LEDs) {
		if (LED_val[i] > 0) { VALUE=GPIOD_LINE_VALUE_ACTIVE; }
        else                { VALUE=GPIOD_LINE_VALUE_INACTIVE; }
		int ret1 = gpiod_line_request_set_value(theLineRequest[i], gpio_line[i], VALUE);
		if (ret1) { perror("set LEDs"); ret=-1}   // handle errors
		i++;
	}
	return ret;
}

struct gpiod_chip *gpiod_chip_open_by_number(int chip){
	struct gpiod_chip *the_gpio_chip;
	char thePath[30];
	sprintf(thePath,"/dev/gpiochip%d",chip);
	the_gpio_chip = gpiod_chip_open(thePath);	
	return the_gpio_chip;
};

int  gpio_init {
	int i=0;
	struct gpiod_line_settings  *theLineSettings;
	struct gpiod_line_config    *theLineConfig;
	struct gpiod_request_config *theRequestConfig = NULL;
	int ret=0;
	int ret1;
	while (i < nLEDs+nButtons) {
		the_gpio_chip = gpiod_chip_open_by_number(chip);
		  if (!the_gpio_chip) { perror("Open chip"); ret=-1; } 
		theLineSettings = gpiod_line_settings_new();
		  if (!theLineSettings) { perror("Get line settings"); ret=-1; }
		if (i<nLEDs) {
			gpiod_line_settings_set_direction(theLineSettings, GPIOD_LINE_DIRECTION_OUTPUT);	
			printf("Initializing gpio%d as output\n",gpio_line[i]);
		} else {
			gpiod_line_settings_set_direction(theLineSettings, GPIOD_LINE_DIRECTION_INPUT);	
			printf("Initializing gpio%d as input\n",gpio_line[i]);
		}
		theLineConfig = gpiod_line_config_new();
		  if (!theLineConfig){ perror("Get line config"); ret=-1; }
		ret1 = gpiod_line_config_add_line_settings(theLineConfig,&gpio_line[i],1,theLineSettings);
		  if (ret1) { perror("Add line settings"); ret=-1; }       
		theRequestConfig = gpiod_request_config_new();
		  if (!theRequestConfig){ perror("Request new config"); ret=-1; }
		gpiod_request_config_set_consumer(theRequestConfig, "led lab");
		theLineRequest[i] = gpiod_chip_request_lines(the_gpio_chip,theRequestConfig,theLineConfig); 

		gpiod_request_config_free(theRequestConfig);     // clean up
		gpiod_line_config_free(theLineConfig);
		gpiod_line_settings_free(theLineSettings);
		gpiod_chip_close(the_gpio_chip);
		i++;
	}
	return ret;
}

void cleanup(int signo){
	if (signo == SIGINT){ printf("received SIGINT Ctrl-C, closing\n"); gpio_close; exit(0); }
}

int gpio_close {
	int i=0; while (i<nLEDs) { LED_val[i]=0; i++; } set_LEDs;  // turn off the LEDs first
	int j=0; while (j<nLEDs+nButtons) { gpiod_line_request_release(theLineRequest[j]); j++; }
	return 0;
}