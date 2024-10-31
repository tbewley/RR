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
// Compile and execute as follows:  (-Wall gives warnings, -g keeps symbols for use by a debugger)
//     gcc RR_test_led.c -Wall -g -lgpiod -o RR_test_led; ./RR_test_led

#include <stdio.h>
#include <unistd.h> // usleep, nanosleep
#include <signal.h>	// capture ctrl-c
#include <stdlib.h>
#include <string.h>
#include <gpiod.h>

// these additional functions and structs are below the main code in this program
void cleanup(int signo);
int gpio_init(int chip, unsigned int line);
int gpio_set(unsigned int line, int value);
int gpio_close(unsigned int line);
struct gpiod_chip *the_gpio_chip;
struct gpiod_line_request *theLineRequest = NULL;  // Is this line dead code??

int main(int argc, char *argv[]){
	int ret;
	int i=0;
	signal(SIGINT, cleanup); // signal catcher; calls the cleanup function on exit
	printf("Using gpio22 and gpio27 to drive LEDs.  Ignoring buttons for now.\n");

	ret = gpio_init(4, 22, true);
	if (ret != 0) { printf("gpio22 init as output failed\n"); return -1; } // handle errors
	ret = gpio_init(4, 27, true);
	if (ret != 0) { printf("gpio27 init as output failed\n"); return -1; } // handle errors
	ret = gpio_init(4, 23, false);
	if (ret != 0) { printf("gpio23 init as input failed\n"); return -1; } // handle errors
	ret = gpio_init(4, 24, false);
	if (ret != 0) { printf("gpio24 init as input failed\n"); return -1; } // handle errors

	printf("Setting gpio22 and gpio27 to OFF\n");
	ret = gpio_set(22, 0);
	if (ret != 0) { printf("gpio22 set to off failed\n"); return -1; }    // handle errors
	ret = gpio_set(27, 0);
	if (ret != 0) { printf("gpio27 set to off failed\n"); return -1; }    // handle errors

	while (i < 5) {       // loop 5 times
		printf("loop %d of %d\n Setting gpio22 and gpio27 to to ON\n",i,5);
		ret = gpio_set(22, 1);
		if (ret != 0) { printf("gpio22 set to on failed\n"); return -1; } // handle errors
		ret = gpio_set(27, 1);
		if (ret != 0) { printf("gpio27 set to on failed\n"); return -1; } // handle errors
		sleep(2);         // pause 2 seconds
		printf("Setting gpio22 and gpio27 to OFF\n");
		ret = gpio_set(22, 0);
		if (ret != 0) { printf("gpio22 set to off failed\n"); return -1; } // handle errors
		ret = gpio_set(27, 0);
		if (ret != 0) { printf("gpio27 set to off failed\n"); return -1; } // handle errors
		sleep(2); i++;    // pause 2 seconds, increment i
	}
	gpio_close(22); gpio_close(27); // close gpio22 and gpio27 outputs
	gpio_close(23); gpio_close(24); // close gpio23 and gpio24 inputs
	return 0;                       // indicate we have successfully finished main program
}

void cleanup(int signo){
	if (signo == SIGINT){
		printf("received SIGINT Ctrl-C; closing\n");
		gpio_close(12);
		exit(0);
 	}
}

struct gpiod_chip * gpiod_chip_open_by_number(int chip){
	struct gpiod_chip *the_gpio_chip;
	char thePath[30];
	sprintf(thePath,"/dev/gpiochip%d",chip);
	printf("Opening gpio chip %s\n",thePath);
	the_gpio_chip = gpiod_chip_open(thePath);	
	return the_gpio_chip;
};

int gpio_set(unsigned int line, int val){
	int ret;
	if (val > 0) {
		ret = gpiod_line_request_set_value(theLineRequest, line,  GPIOD_LINE_VALUE_ACTIVE);
		if (ret) { printf("in gpio_set, line set value ACTIVE failed\n"); }   // handle errors
	} else {
		ret = gpiod_line_request_set_value(theLineRequest, line,  GPIOD_LINE_VALUE_INACTIVE);
		if (ret) { printf("in gpio_set, line set value INACTIVE failed\n"); } // handle errors
	}
	return ret;
}

int  gpio_init (int chip, unsigned int line, bool line_direction_output) {
	struct gpiod_line_settings *theLineSettings;
	struct gpiod_line_config *theLineConfig;
	struct gpiod_request_config *theRequestConfig = NULL;
	int ret;
	printf("Initializing GPIO chip=%d line=%d\n", chip, line);

	the_gpio_chip = gpiod_chip_open_by_number(chip);  	// open the chip first
	if (!the_gpio_chip) { printf("Open chip %d failed\n",chip); return -1; } // handle errors
	theLineSettings = gpiod_line_settings_new();
	if (!theLineSettings) {                             // handle errors
		printf("Get line settings failed\n");
		gpiod_chip_close(the_gpio_chip);
		return -1;
	}
	if (line_direction_output) {
		gpiod_line_settings_set_direction(theLineSettings, GPIOD_LINE_DIRECTION_OUTPUT);	
		theLineConfig = gpiod_line_config_new();
		if (!theLineConfig){                           // handle errors
			printf("Get line config for output failed\n");
			gpiod_line_settings_free(theLineSettings);
			gpiod_chip_close(the_gpio_chip);
			return -1;
		}	
	} else {
		gpiod_line_settings_set_direction(theLineSettings, GPIOD_LINE_DIRECTION_INPUT);	
		theLineConfig = gpiod_line_config_new();
		if (!theLineConfig){                           // handle errors
			printf("Get line config for input failed\n");
			gpiod_line_settings_free(theLineSettings);
			gpiod_chip_close(the_gpio_chip);
			return -1;
		}	
	}
	ret = gpiod_line_config_add_line_settings(theLineConfig, &line, 1, theLineSettings);
	if (ret) {                                        // handle errors
		printf("Add line settings failed\n");
		gpiod_line_config_free(theLineConfig);
		gpiod_line_settings_free(theLineSettings);
		gpiod_chip_close(the_gpio_chip);
		return -1;
	}	
	theRequestConfig = gpiod_request_config_new();
	if (!theRequestConfig){                           // handle errors
		printf("Request new config failed\n");
		gpiod_line_config_free(theLineConfig);
		gpiod_line_settings_free(theLineSettings);
		gpiod_chip_close(the_gpio_chip);
		return -1;
	}
	gpiod_request_config_set_consumer(theRequestConfig, "led demo");
	theLineRequest = gpiod_chip_request_lines(the_gpio_chip, theRequestConfig, theLineConfig);
	gpiod_request_config_free(theRequestConfig);     // clean up
	gpiod_line_config_free(theLineConfig);
	gpiod_line_settings_free(theLineSettings);
	gpiod_chip_close(the_gpio_chip);
	printf("gpio init succeeded\n");
	return 0;
}

// close out gpios
int gpio_close(unsigned int line ) {
	gpiod_line_request_set_value(theLineRequest, line, GPIOD_LINE_VALUE_INACTIVE); //turn it off
	gpiod_line_request_release(theLineRequest); 	                 // release the line request
	return 0;
}