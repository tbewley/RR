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

/* NOTE:
 * There are both 7- and 8-bit versions of I2C addresses.
 * 7 bits identify the device, and the eighth bit determines
 * if it's being written to or read from. The Wire library uses
 * 7 bit addresses throughout. If you have a datasheet or sample code 
 * that uses 8 bit address, you'll want to drop the low bit
 * (i.e. shift the value one bit to the right), yielding an 
 * address between 0 and 127.
 * 
 * The HMC datasheet says...
 * " The default (factory) HMC5883L 7-bit slave address is 0x3C for write operations, or 0x3D for read operations. "
 * which is of course silly, what they mean is that these are 8=bit addresses and thus we want to shift right 
 * one of them to get the 7-bit address that Wire wants
 * 
 * 0x3C = 111100
 * >> 1 = 11110
 *      = 0x1E
 * 
 * 0x3D = 111101
 * >> 1 = 11110
 *      = 0x1E
 *   
 */
#include <stdint.h>
#define COMPASS_I2C_BUS      0x01
#define COMPASS_I2C_ADDRESS  0x3C >> 1

#define COMPASS_CONFIG_REGISTER_A 0x00
#define COMPASS_CONFIG_REGISTER_B 0x01
#define COMPASS_MODE_REGISTER     0x02
#define COMPASS_DATA_REGISTER     0x03
#define COMPASS_STATUS_REGISTER   0x09

// We use 16 bits for storing various configs
//  xxxxxxxxxxxxxxMM
//  MODE:

#define COMPASS_CONTINUOUS 0x00
#define COMPASS_SINGLE     0x01
#define COMPASS_IDLE       0x02

//  xxxxxxxxxxxSSSxx
//  SCALE:
//   A lower value indicates a higher precision
//   but "noisier", magentic noise may necessitate
//   you to choose a higher scale.

#define COMPASS_SCALE_088  0x00 << 2
#define COMPASS_SCALE_130  0x01 << 2
#define COMPASS_SCALE_190  0x02 << 2
#define COMPASS_SCALE_250  0x03 << 2
#define COMPASS_SCALE_400  0x04 << 2
#define COMPASS_SCALE_470  0x05 << 2
#define COMPASS_SCALE_560  0x06 << 2
#define COMPASS_SCALE_810  0x07 << 2

//  xxXXXYYYZZZxxxxx
//  ORIENTATION: 
#define COMPASS_NORTH 0x00 
#define COMPASS_SOUTH 0x01
#define COMPASS_WEST  0x02
#define COMPASS_EAST  0x03
#define COMPASS_UP    0x04
#define COMPASS_DOWN  0x05

// When "pointing" north, define the direction of each of the silkscreen'd arrows
// (imagine the Z arrow points out of the top of the device) only N/S/E/W are allowed
// Orientation is the bits marked XXXYYYZZZ in mode
//    xxXXXYYYZZZxxxxx
#define COMPASS_HORIZONTAL_X_NORTH  ( (COMPASS_NORTH << 6)  | (COMPASS_WEST  << 3)  | COMPASS_UP    ) << 5
#define COMPASS_HORIZONTAL_Y_NORTH  ( (COMPASS_EAST  << 6)  | (COMPASS_NORTH << 3)  | COMPASS_UP    ) << 5
#define COMPASS_VERTICAL_X_EAST     ( (COMPASS_EAST  << 6)  | (COMPASS_UP    << 3)  | COMPASS_SOUTH ) << 5
#define COMPASS_VERTICAL_Y_WEST     ( (COMPASS_UP    << 6)  | (COMPASS_WEST  << 3)  | COMPASS_SOUTH ) << 5

    // Configuration Methods
    int SetScale( uint16_t sampling_mode );
    int SetOrientation( uint16_t sampling_mode );    
    int SetDeclination( int declination_degs , int declination_mins, char declination_dir );
    int SetSamplingMode( uint16_t sampling_mode );
    	  
    // Get a heading in degrees
    float GetHeadingDegrees();
    
    struct MagnetometerSample
    {
      int16_t X;
      int16_t Y;
      int16_t Z;
    };
    
    struct MagnetometerSample ReadAxes();

    
    int magnetometer_init();
    int magnetometer_close();
    
    
