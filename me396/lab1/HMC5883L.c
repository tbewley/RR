/* ME396 Fall 2024
* I2C HMC5883L magnetometer lab for the RPi
* 10/31/2024 By Briggs
* Copyright USAFA 2024
*/
/* Original code from 
* James Sleeman, http://sparks.gogo.co.nz/
* for Arduino
* Copyright (C) 2014 James Sleeman
*/
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>	//sleep
#define _USE_MATH_DEFINES
#include <math.h>

#include "magnetometer.h"
// defined in rc_i2c.c
int rc_i2c_init(int bus, uint8_t devAddr);
int rc_i2c_close(int bus);
int rc_i2c_read_byte(int bus, uint8_t regAddr, uint8_t *data);
int rc_i2c_read_bytes(int bus, uint8_t regAddr, size_t count, uint8_t *data);
int rc_i2c_read_word(int bus, uint8_t regAddr, uint16_t *data);
int rc_i2c_write_word(int bus, uint8_t regAddr, uint16_t data);
int rc_i2c_write_byte(int bus, uint8_t regAddr, uint8_t data);
int rc_i2c_write_bytes(int bus, uint8_t regAddr, size_t count, uint8_t* data);

        
uint16_t  mode;    //internal mode settings
float    declination_offset_radians;
 
int magnetometer_init()
{
  int ret;
    
  fprintf(stdout,"In magnetometer_init, initializing rc_i2c with bus %d and device 0x%x\n", (int) COMPASS_I2C_BUS, (int)COMPASS_I2C_ADDRESS);
  ret = rc_i2c_init(COMPASS_I2C_BUS, COMPASS_I2C_ADDRESS);
	if (ret == -1){
		fprintf(stderr,"ERROR: in magnetometer_init, rc_i2c_init failed\n");
		return -1;
	}	
  mode = COMPASS_SINGLE | COMPASS_SCALE_130 | COMPASS_HORIZONTAL_X_NORTH;
  declination_offset_radians = 0;
  
  // Magnetic Declination is the correction applied according to your present location
  // in order to get True North from Magnetic North, it varies from place to place.
  // 
  // The declination for your area can be obtained from http://www.magnetic-declination.com/
  // Take the "Magnetic Declination" line that it gives you in the information, 
  //
  // Examples:
  //   Christchurch, 23° 35' EAST
  //   Wellington  , 22° 14' EAST
  //   Dunedin     , 25° 8'  EAST
  //   Auckland    , 19° 30' EAST
  //   Denver	    , 7   34  EAST
  //   Colorado Spring, 7  24 EAST
  // Take USAFA to be half way between Denver and CoS 
  SetDeclination(7, 29, 'E'); 
  
  // The device can operate in SINGLE (default) or CONTINUOUS mode
  //   SINGLE simply means that it takes a reading when you request one
  //   CONTINUOUS means that it is always taking readings
  // for most purposes, SINGLE is what you want.
  SetSamplingMode(COMPASS_SINGLE);
  //SetSamplingMode(COMPASS_CONTINUOUS);
  
  // The scale can be adjusted to one of several levels, you can probably leave it at the default.
  // Essentially this controls how sensitive the device is.
  //   Options are 088, 130 (default), 190, 250, 400, 470, 560, 810
  // Specify the option as COMPASS_SCALE_xxx
  // Lower values are more sensitive, higher values are less sensitive.
  // The default is probably just fine, it works for me.  If it seems very noisy
  // (jumping around), incrase the scale to a higher one.
  SetScale(COMPASS_SCALE_130);
  
  // The compass has 3 axes, but two of them must be close to parallel to the earth's surface to read it, 
  // (we do not compensate for tilt, that's a complicated thing) - just like a real compass has a floating 
  // needle you can imagine the digital compass does too.
  //
  // To allow you to mount the compass in different ways you can specify the orientation:
  //   COMPASS_HORIZONTAL_X_NORTH (default), the compass is oriented horizontally, top-side up. when pointing North the X silkscreen arrow will point North
  //   COMPASS_HORIZONTAL_Y_NORTH, top-side up, Y is the needle,when pointing North the Y silkscreen arrow will point North
  //   COMPASS_VERTICAL_X_EAST,    vertically mounted (tall) looking at the top side, when facing North the X silkscreen arrow will point East
  //   COMPASS_VERTICAL_Y_WEST,    vertically mounted (wide) looking at the top side, when facing North the Y silkscreen arrow will point West  
  SetOrientation(COMPASS_HORIZONTAL_X_NORTH);
  fprintf(stdout,"In magnetometer_init, using the default orientation of COMPASS_HORIZONTAL_X_NORTH\n");
  fprintf(stdout,"In magnetometer_init, with the compass oriented horizontally, top-side up, when pointing North, the X silkscreen arrow will point North\n");

  return 0;
};
int magnetometer_close(){
	int ret;
	ret = rc_i2c_close(COMPASS_I2C_BUS);
	if (ret == -1){
		fprintf(stderr,"ERROR: in magnetometer_close, rc_i2c_close failed\n");
		return -1;
	}	
	return 0;	
};


int SetDeclination( int ideclination_degs , int ideclination_mins, char declination_dir )
{    
  float fdeclination_degs, fdeclination_mins;
  fdeclination_degs = (float) ideclination_degs;
  fdeclination_mins = (float) ideclination_mins;
  //fprintf(stdout,"In SetDeclination, given declination_degs %d, declination_mins %d, (or declination degrees %f), dir %c\n",ideclination_degs, ideclination_mins, ( fdeclination_degs + (1.0/60.0 * fdeclination_mins)), declination_dir);
  // Convert declination to decimal degrees
  switch(declination_dir)
  {
    // North and East are positive   
    case 'E': 
      declination_offset_radians = ( fdeclination_degs + (1.0/60.0 * fdeclination_mins)) * (M_PI / 180.0);
      break;
      
    // South and West are negative    
    case 'W':
      declination_offset_radians =  0.0 - (( fdeclination_degs + (1.0/60.0 * fdeclination_mins) ) * (M_PI / 180.0));
      break;
      
   //cry about any other dir
   default:
      fprintf(stdout,"In SetDeclination, direction must be E or W but got %c\n",declination_dir);  
      return -1; 
  } 
  //fprintf(stdout,"In SetDeclination, declination_offset degrees %f radians %f\n",declination_offset_radians*180/M_PI,declination_offset_radians);
  return 0;
}

/** Set the sampling mode to one of COMPASS_CONTINUOUS or COMPASS_SINGLE
 */

int SetSamplingMode( uint16_t sampling_mode )
{  
  int ret;
  uint8_t data;
  //uint8_t check;
  switch (sampling_mode) {
    case COMPASS_CONTINUOUS:
    case COMPASS_SINGLE:
      //arg sampling_mode is ok
      // Mode is the bits marked M in mode
      //    xxxxxxxxxxxSSSMM
      mode = (mode & ~0x03) | (sampling_mode & 0x03);
      data = (uint8_t) mode & 0x03;
      ret = rc_i2c_write_byte(COMPASS_I2C_BUS, COMPASS_MODE_REGISTER, data);   //mode & 0x03);  
      if (ret == -1){
        fprintf(stderr,"Error: In SetSamplingMode, write to mode register 0x%x value 0x%x failed\n",(int) COMPASS_MODE_REGISTER,(int)(mode & 0x03));
        return -1;
      }
      break;
    default:
      fprintf(stderr,"Error: In SetSamplingMode, arg must be one of COMPASS_CONTINUOUS or COMPASS_SINGLE\n");
      return -1;
  }
  // the mew mode is updated internally and written to the device
    
  //ret = rc_i2c_read_byte(COMPASS_I2C_BUS, COMPASS_MODE_REGISTER, &check);
  //fprintf(stdout,"In SetSamplingMode, read back of mode register gave 0x%x\n", check);
  return 0;
}

/** Set the scale to one of COMPASS_SCALE_088 through COMPASS_SCALE_810
 * Higher scales are less sensitive and less noisy
 * Lower scales are more sensitive and more noisy
 */

int SetScale( uint16_t scale )
{
  int ret;
  uint8_t data;
  if (scale < 0x00 || scale > 0x07) {
    fprintf(stderr, "Error: In SetScale, arg scale must be >= 0x00 (COMPASS_SCALE_088) and <= 0x07 (COMPASS_SCALE_810)\n");
    return -1;
  }
  // Scale is the bits marked S in mode
  //    xxxxxxxxxxxSSSMM  
  mode = (mode & ~0x1C) | (scale & 0x1C);
  data = (uint8_t)((( mode >> 2 ) & 0x07) << 5);
  ret = rc_i2c_write_byte(COMPASS_I2C_BUS, COMPASS_CONFIG_REGISTER_B, data);   //(( mode >> 2 ) & 0x07) << 5);
  if (ret == -1){
    fprintf(stderr, "Error: In SetScale, write to config register B 0x%x value 0x%x failed\n",(int) COMPASS_CONFIG_REGISTER_B,(int)((( mode >> 2 ) & 0x07) << 5));
  }
  return 0;
}

/** Set the orientation to one of COMPASS_HORIZONTAL_X_NORTH 
 * through COMPASS_VERTICAL_Y_WEST
 *  
 */

int SetOrientation( uint16_t orientation )
{
  switch (orientation) {
    case COMPASS_NORTH:
    case COMPASS_SOUTH:
    case COMPASS_WEST:
    case COMPASS_EAST:
    case COMPASS_UP:
    case COMPASS_DOWN:
      //arg orientation is ok 

      // Orientation is the bits marked XXXYYYZZZ in mode
      //    xxXXXYYYZZZxxxxx
      mode = (mode & ~0x3FE0) | (orientation & 0x3FE0);   
      return 0;
    default:
      fprintf(stderr, "Error: In SetOrientation, arg orientation must be >= 0x00 (COMPASS_NORTH) and <= 0x05 (COMPASS_DOWN)\n");   
      return -1;
  } 
  return 0;
}

/** Get the heading of the compass in degrees. */
float GetHeadingDegrees()
{     
  // Obtain a sample of the magnetic axes
  struct MagnetometerSample sample = ReadAxes();
  
  float heading;  
  //float uheading;  
  
  // Determine which of the Axes to use for North and West (when compass is "pointing" north)
  float mag_north, mag_west;
   
  // Z = bits 0-2
  switch((mode >> 5) & 0x07 )
  {
    case COMPASS_NORTH: mag_north = sample.Z; break;
    case COMPASS_SOUTH: mag_north = 0.0-sample.Z; break;
    case COMPASS_WEST:  mag_west  = sample.Z; break;
    case COMPASS_EAST:  mag_west  = 0.0-sample.Z; break;
      
    // Don't care
    case COMPASS_UP:
    case COMPASS_DOWN:
     break;
  }
  
  // Y = bits 3 - 5
  switch(((mode >> 5) >> 3) & 0x07 )
  {
    case COMPASS_NORTH: mag_north = sample.Y;  break;
    case COMPASS_SOUTH: mag_north = 0.0-sample.Y; ;  break;
    case COMPASS_WEST:  mag_west  = sample.Y;  break;
    case COMPASS_EAST:  mag_west  = 0.0-sample.Y;  break;
      
    // Don't care
    case COMPASS_UP:
    case COMPASS_DOWN:
     break;
  }
  
  // X = bits 6 - 8
  switch(((mode >> 5) >> 6) & 0x07 )
  {
    case COMPASS_NORTH: mag_north = sample.X; break;
    case COMPASS_SOUTH: mag_north = 0.0-sample.X; break;
    case COMPASS_WEST:  mag_west  = sample.X; break;
    case COMPASS_EAST:  mag_west  = 0.0-sample.X; break;
      
    // Don't care
    case COMPASS_UP:
    case COMPASS_DOWN:
     break;
  }
    
  // calculate heading from the north and west magnetic axes
  heading = atan2(mag_west, mag_north);
  //uheading = heading;
  // Correct for when signs are reversed.
  //if(uheading < 0)
  //  uheading += 2.0*M_PI; 
  // Check for wrap due to addition of declination.
  //if(uheading > 2.0*M_PI)
  //  uheading -= 2.0*M_PI;  
  //fprintf(stdout,"In GetHeadingDegrees, uncorrected heading is %f radians or %f degrees\n",uheading, uheading * 180.0/M_PI);
  
  // Adjust the heading by the declination
  heading += declination_offset_radians;
  
  //I dunno why
  heading += 90.0*M_PI/180.0;

  
  // Correct for when signs are reversed.
  if(heading < 0)
    heading += 2.0*M_PI;
    
  // Check for wrap due to addition of declination.
  if(heading > 2.0*M_PI)
    heading -= 2.0*M_PI;
  //fprintf(stdout,"In GetHeadingDegrees, declination_offset_radians %f corrected heading %f deg\n",declination_offset_radians, heading * 180.0/M_PI);
  // Convert radians to degrees for readability.
  return heading * 180.0/M_PI; 
}


/** Read the axes from the magnetometer.
 * In SINGLE mode we take a sample.  In CONTINUOUS mode we 
 * just grab the most recent result in the registers.
 */

struct MagnetometerSample ReadAxes()
{
  int ret;
  uint8_t data;
  uint8_t rdy;
  struct MagnetometerSample sample;  //presume zero filled for failure return
  
  if(mode & COMPASS_SINGLE) 
  {    
    //trigger a measurement
    data = (uint8_t)( mode & 0x03 );
    ret = rc_i2c_write_byte(COMPASS_I2C_BUS, COMPASS_MODE_REGISTER, data);    //(uint8_t)( mode & 0x03 )); 
    if (ret == -1){
      fprintf(stderr,"Error: In ReadAxes, write to mode register 0x%x value 0x%x failed\n",(int) COMPASS_MODE_REGISTER,(int)( mode & 0x03 ));
      return sample; 
    }
    usleep(66000); // 66 milliseconds. We could listen to the data ready pin instead of waiting.
  }
  //ret = rc_i2c_read_byte(COMPASS_I2C_BUS,COMPASS_STATUS_REGISTER,&rdy);
  //if (ret == -1){
  //    fprintf(stderr,"Error: In ReadAxes, read from status register 0x%x failed\n",(int) COMPASS_STATUS_REGISTER);
  //    return sample; 
  //}
  //fprintf(stdout,"In ReadAxes, read from status register 0x%x after trigger and sleep returned 0x%x\n",(int) COMPASS_STATUS_REGISTER,rdy);
  
  uint8_t buffer[6];
  ret = rc_i2c_read_bytes(COMPASS_I2C_BUS, COMPASS_DATA_REGISTER, 6, buffer);
  if (ret == -1){
    fprintf(stderr,"Error:In ReadAxes, read from data register 0x%x failed\n",(int)COMPASS_DATA_REGISTER);
    return sample; 
  }
  //ret = rc_i2c_read_byte(COMPASS_I2C_BUS,COMPASS_STATUS_REGISTER,&rdy);
  //if (ret == -1){
  //    fprintf(stderr,"Error: In ReadAxes, read from status register 0x%x failed\n",(int) COMPASS_STATUS_REGISTER);
  //    return sample; 
  //}
  //fprintf(stdout,"In ReadAxes, read from status register 0x%x after read bytes returned 0x%x\n",(int) COMPASS_STATUS_REGISTER,rdy);
  
  //fprintf(stdout,"In ReadAxes, buffer returned Xhi %d Xlo %d, Zhi %d, Zlo %d, Yhi %d, Ylo %d\n",buffer[0],buffer[1],buffer[2],buffer[3],buffer[4],buffer[5]);
  // NOTE:
  // The registers are in the order X Z Y  (page 11 of datasheet)
  // the datasheet when it describes the registers details then in order X Y Z (page 15)
  // stupid datasheet writers
  sample.X = (buffer[0] << 8) | buffer[1];  
  sample.Z = (buffer[2] << 8) | buffer[3];
  sample.Y = (buffer[4] << 8) | buffer[5];
  
  //fprintf(stdout,"In ReadAxes, data as 16 bit ints: X %d, Z %d, Y %d\n",sample.X, sample.Z, sample.Y);
  return sample;
}
