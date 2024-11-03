// RR_test_led.c, for ME396 lab 1, on an RPi 5
// H. Clark Briggs 10/26/2024, with some tweaks by Thomas Bewley 10/30/24
// Copyright 2020 - 2024 USAFA
// This lab uses 
//   gpio22 output (at pin 15) to control LEDa
//   gpio27 output (at pin 13) to control LEDb
//   gpio23 input  (at pin 16) to read BUTTONa (internal pulldown, button pulls to high)
//   gpio24 input  (at pin 18) to read BUTTONb (internal pulldown, button pulls to high)
// See pin graphic here:
//   https://www.raspberrypi.com/documentation/computers/images/GPIO-Pinout-Diagram-2.png
// The RPi commands "gpioinfo" and "cat /boot/firmware/config.txt" help to see what pins are taken...
// See also helpful information about gpiod here:
//    https://libgpiod.readthedocs.io/en/latest/group__line__request.html#:~:text=gpiod_line_request_get_value
//
// CONFIGURATION 1 (simple):
// Connect each RPI output pin to an LED, through a current-limiting resister, to ground (RPi pin 6).
//
// CONFIGURATION 2 (suggested in class):
//   a. Provide a prototypng board with 3.3V (RPi pin 1) and ground (RPi pin 6)
//   b. For each RPi GPIO output pin, connect through a 1.5 kohm resistor to the Base of a 2N2222 npn transistor.
//   c. Connect the Emitters of the transistors to ground.
//   d. Connect 3.3v to an LED, through a 220 kohm resistor, to the Collector of each transistor.
// This program will {turn the LEDs on, wait 2 sec, turn the LEDs off, wait 2 sec}, repeat 5x, exit.
//
// Compile and execute on an RPi5 as follows:  (-Wall gives warnings, -g keeps symbols for use by a debugger)
//   gcc RR_test_led1.c -Wall -g -lgpiod -o RR_test_led1; ./RR_test_led1

#include <stdio.h>
#include <unistd.h> // usleep, nanosleep
#include <signal.h>	// capture ctrl-c
#include <stdlib.h>
#include <string.h>
#include <gpiod.h>
#include <errno.h>  // perror

// these additional functions and structs are below the main code in this program
void cleanup(int signo);
int gpio_init(int chip, unsigned int lineA, unsigned int lineB, unsigned int lineC, unsigned int lineD,
	                    bool dirA, bool dirB, bool dirC, bool dirD);
int gpio_set(unsigned int lineA, unsigned int lineB, int valueA, int valueB);
int gpio_close(unsigned int lineA, unsigned int lineB, unsigned int lineC, unsigned int lineD);
struct gpiod_chip *the_gpio_chip;
struct gpiod_line_request *theLineRequestA = NULL;
struct gpiod_line_request *theLineRequestB = NULL;
struct gpiod_line_request *theLineRequestC = NULL;
struct gpiod_line_request *theLineRequestD = NULL;

// Define the following as global so we don't have to pass them around everywhere
int nLEDs=2;
int nButtons=2;
unsigned int LED_line[2]    = {22 27};
unsigned int Button_line[2] = {23 24};

int main(int argc, char *argv[]){
	int ret;
	int valC;
	int valD;
	int i=0;
	unsigned int lineA = 22;
	unsigned int lineB = 27;
	unsigned int lineC = 23;
	unsigned int lineD = 24;
	signal(SIGINT, cleanup); // signal catcher; calls the cleanup function on exit
	printf("Using gpio22 and gpio27 to drive LEDs, and gpio23 and gpio24 to read buttons.\n");

	ret = gpio_init(4, lineA, lineB, lineC, lineD, true, true, false, false);
	if (ret != 0) { perror("gpio inits"); return -1; } // handle errors

	printf("Setting gpioA and gpioB to OFF\n");
	ret = gpio_set(lineA, lineB, 0, 0);
	if (ret != 0) { perror("LED_gpios set to off"); return -1; }  // handle errors

	while (i < 5) {       // loop 5 times
		valC=gpiod_line_request_get_value(theLineRequestC, lineC);
		valD=gpiod_line_request_get_value(theLineRequestD, lineD);
		printf("valC = %d, valD = %d\n",valC,valD);
		printf("loop %d of %d\nSetting gpioA and gpioB to ON\n",i,5);
		ret = gpio_set(lineA, lineB, 1, 1);
		sleep(2);         // pause 2 seconds
		printf("Setting gpioA and gpioB to OFF\n");
		ret = gpio_set(lineA, lineB, 0, 0);
		sleep(2); i++;    // pause 2 seconds, increment i
	}
	ret = gpio_close(lineA, lineB, lineC, lineD);         // close out gpios
	return 0;                       // indicate we have successfully finished main program
}

void cleanup(int signo){
	if (signo == SIGINT){
		printf("received SIGINT Ctrl-C; closing\n");
		gpio_close(22,27,23,24);
		exit(0);
 	}
}

struct gpiod_chip * gpiod_chip_open_by_number(int chip){
	struct gpiod_chip *the_gpio_chip;
	char thePath[30];
	sprintf(thePath,"/dev/gpiochip%d",chip);
	the_gpio_chip = gpiod_chip_open(thePath);	
	return the_gpio_chip;
};

int gpio_set(unsigned int lineA, unsigned int lineB, int valA, int valB){
	int ret;
	if (valA > 0) {
		ret = gpiod_line_request_set_value(theLineRequestA, lineA, GPIOD_LINE_VALUE_ACTIVE);
		if (ret) { perror("in gpio_set, line set value ACTIVE"); }   // handle errors
	} else {
		ret = gpiod_line_request_set_value(theLineRequestA, lineA, GPIOD_LINE_VALUE_INACTIVE);
		if (ret) { perror("in gpio_set, line set value INACTIVE"); } // handle errors
	}
	if (valB > 0) {
		ret = gpiod_line_request_set_value(theLineRequestB, lineB, GPIOD_LINE_VALUE_ACTIVE);
		if (ret) { perror("in gpio_set, line set value ACTIVE"); }   // handle errors
	} else {
		ret = gpiod_line_request_set_value(theLineRequestB, lineB, GPIOD_LINE_VALUE_INACTIVE);
		if (ret) { perror("in gpio_set, line set value INACTIVE"); } // handle errors
	}
	return 0;
}

int  gpio_init(int chip, unsigned int lineA, unsigned int lineB, unsigned int lineC, unsigned int lineD,
	                     bool dirA, bool dirB, bool dirC, bool dirD) {
	int i=0;
	struct gpiod_line_settings *theLineSettings;
	struct gpiod_line_config *theLineConfig;
	struct gpiod_request_config *theRequestConfig = NULL;
	int ret;
	unsigned int line;
	bool dir;

	while (i < 4) {
		switch (i) {
			case 0: line=lineA; dir=dirA; break;
			case 1: line=lineB; dir=dirB; break;
			case 2: line=lineC; dir=dirC; break;
			case 3: line=lineD; dir=dirD; break;	
		}
		the_gpio_chip = gpiod_chip_open_by_number(chip);  	// open the chip first
		if (!the_gpio_chip) { printf("Open chip %d failed\n",chip); return -1; } // handle errors
		theLineSettings = gpiod_line_settings_new();
		if (!theLineSettings) {                             // handle errors
			perror("Get line settings");
			gpiod_chip_close(the_gpio_chip);
			return -1;
		}
		if (dir) {
			gpiod_line_settings_set_direction(theLineSettings, GPIOD_LINE_DIRECTION_OUTPUT);	
			theLineConfig = gpiod_line_config_new();
			printf("Initializing gpio%d as output\n",line);
			if (!theLineConfig){                           // handle errors
				perror("Get line config for output");
				gpiod_line_settings_free(theLineSettings);
				gpiod_chip_close(the_gpio_chip);
				return -1;
			}	
		} else {
			gpiod_line_settings_set_direction(theLineSettings, GPIOD_LINE_DIRECTION_INPUT);	
			theLineConfig = gpiod_line_config_new();
			printf("Initializing gpio%d as input\n",line);
			if (!theLineConfig){                           // handle errors
				perror("Get line config for input");
				gpiod_line_settings_free(theLineSettings);
				gpiod_chip_close(the_gpio_chip);
				return -1;
			}	
		}
		ret = gpiod_line_config_add_line_settings(theLineConfig, &line, 1, theLineSettings);
		if (ret) {                                        // handle errors
			perror("Add line settings");
			gpiod_line_config_free(theLineConfig);
			gpiod_line_settings_free(theLineSettings);
			gpiod_chip_close(the_gpio_chip);
			return -1;
		}	
		theRequestConfig = gpiod_request_config_new();
		if (!theRequestConfig){                           // handle errors
			perror("Request new config");
			gpiod_line_config_free(theLineConfig);
			gpiod_line_settings_free(theLineSettings);
			gpiod_chip_close(the_gpio_chip);
			return -1;
		}
		gpiod_request_config_set_consumer(theRequestConfig, "led demo");
		switch (i) {
			case 0: theLineRequestA = gpiod_chip_request_lines(the_gpio_chip, theRequestConfig, theLineConfig); break;
			case 1: theLineRequestB = gpiod_chip_request_lines(the_gpio_chip, theRequestConfig, theLineConfig); break;
			case 2: theLineRequestC = gpiod_chip_request_lines(the_gpio_chip, theRequestConfig, theLineConfig); break;
			case 3: theLineRequestD = gpiod_chip_request_lines(the_gpio_chip, theRequestConfig, theLineConfig); break;	
		}
		gpiod_request_config_free(theRequestConfig);     // clean up
		gpiod_line_config_free(theLineConfig);
		gpiod_line_settings_free(theLineSettings);
		gpiod_chip_close(the_gpio_chip);
		i++;
	}
	return 0;
}

// close out gpios
int gpio_close(unsigned int lineA, unsigned int lineB, unsigned int lineC, unsigned int lineD ) {
	gpiod_line_request_set_value(theLineRequestA, lineA, GPIOD_LINE_VALUE_INACTIVE); //turn it off
	gpiod_line_request_release(theLineRequestA); 	                   // release the line request
	gpiod_line_request_set_value(theLineRequestB, lineB, GPIOD_LINE_VALUE_INACTIVE); //turn it off
	gpiod_line_request_release(theLineRequestB); 	                   // release the line request
	gpiod_line_request_set_value(theLineRequestC, lineC, GPIOD_LINE_VALUE_INACTIVE); //turn it off
	gpiod_line_request_release(theLineRequestC); 	                   // release the line request
	gpiod_line_request_set_value(theLineRequestD, lineD, GPIOD_LINE_VALUE_INACTIVE); //turn it off
	gpiod_line_request_release(theLineRequestD); 	                   // release the line request
	return 0;
}