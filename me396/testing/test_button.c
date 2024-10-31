#include <stdio.h>
#include <gpiod.h>

// from: https://www.google.com/search?q=gpiod+gpio+get+button+rpi+c (AI response)
// gcc test_button.c -Wall -g -lgpiod -o test_button; ./test_button

int main(int argc, char **argv) {
    const char *chipname = "gpiochip4"; // Default GPIO chip on Raspberry Pi
    unsigned int line_num = 23; // Replace with the GPIO pin number you're using

    struct gpiod_chip *chip;
    struct gpiod_line *line;
    int value;

    // Open the GPIO chip
    chip = gpiod_chip_open_by_name(chipname);
    if (!chip) {
        perror("gpiod_chip_open_by_name");
        return 1;
    }

    // Get the GPIO line
    line = gpiod_chip_get_line(chip, line_num);
    if (!line) {
        perror("gpiod_chip_get_line");
        gpiod_chip_close(chip);
        return 1;
    }

    // Set the line as input
    if (gpiod_line_request_input(line, "button") < 0) {
        perror("gpiod_line_request_input");
        gpiod_chip_close(chip);
        return 1;
    }

    // Read the value
    value = gpiod_line_get_value(line);
    if (value < 0) {
        perror("gpiod_line_get_value");
        gpiod_chip_close(chip);
        return 1;
    }

    printf("Button state: %d\n", value);

    // Cleanup
    gpiod_line_release(line);
    gpiod_chip_close(chip);
    return 0;
}