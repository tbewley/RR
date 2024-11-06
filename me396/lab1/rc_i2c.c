/**

 * @file i2c.c
 * @author James Strawson
 * adapted by Clark Briggs
 */

#include <stdint.h> // for uint8_t types etc
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/i2c-dev.h> //for IOCTL defs

//#include <rc/i2c.h>

// preposessor macros
#define unlikely(x)	__builtin_expect (!!(x), 0)
#define likely(x)	__builtin_expect (!!(x), 1)
/**
 * @brief      Maximum I2C bus identifier. Default is 5 for a total of 6 busses.
 *             This can be increased by the user for special cases.
 */
#define I2C_MAX_BUS 5

/**
 * @brief      size of i2c buffer in bytes for writing to registers. Only
 *             increase if you know what you are doing.
 */
#define I2C_BUFFER_SIZE 128

/**
 * contains the current state of a bus. you don't need to create your own
 * instance of this, one for each bus is allocated here
 */
typedef struct rc_i2c_state_t {
	/* data */
	uint8_t devAddr;
	int fd;
	int initialized;
	int lock;
} rc_i2c_state_t;

static rc_i2c_state_t i2c[I2C_MAX_BUS+1];
int rc_i2c_set_device_address(int bus, uint8_t devAddr);
int rc_i2c_read_byte(int bus, uint8_t regAddr, uint8_t *data);
int rc_i2c_read_bytes(int bus, uint8_t regAddr, size_t count, uint8_t *data);
int rc_i2c_read_word(int bus, uint8_t regAddr, uint16_t *data);
int rc_i2c_read_words(int bus, uint8_t regAddr, size_t count, uint16_t *data);
int rc_i2c_send_bytes(int bus, size_t count, uint8_t* data);

// local function
static int __check_bus_range(int bus)
{
	if(unlikely(bus<0 || bus>I2C_MAX_BUS)){
		fprintf(stderr,"ERROR: i2c bus must be between 0 & %d\n", I2C_MAX_BUS);
		return -1;
	}
	return 0;
}

/**
 * @brief      Initializes a bus and sets it to talk to a particular device
 *             address.
 *
 * @param[in]  bus      The bus
 * @param[in]  devAddr  The device address
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_init(int bus, uint8_t devAddr)
{
	// sanity check
	if(unlikely(__check_bus_range(bus))) return -1;

	// if already initialized just set the device address
	if(i2c[bus].initialized){
		return rc_i2c_set_device_address(bus, devAddr);
	}

	// lock the bus during this operation
	i2c[bus].lock = 1;
	i2c[bus].initialized = 0;

	// open file descriptor
	char str[16];
	sprintf(str,"/dev/i2c-%d",bus);
	i2c[bus].fd = open(str, O_RDWR);
	if(i2c[bus].fd==-1){
		fprintf(stderr,"ERROR: in rc_i2c_init, failed to open /dev/i2c\n");
		return -1;
	}

	// set device adress
	if(unlikely(ioctl(i2c[bus].fd, I2C_SLAVE, devAddr)<0)){
		fprintf(stderr,"ERROR: in rc_i2c_init, ioctl slave address change failed\n");
		return -1;
	}
	i2c[bus].devAddr = devAddr;
	// return the lock state to previous state.
	i2c[bus].lock = 0;
	i2c[bus].initialized = 1;
	//brag about it
	fprintf(stdout,"in rc_i2c_init: success\n");
	return 0;
}

/**
 * @brief      Closes an I2C bus
 *
 * @param[in]  bus   The bus
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_close(int bus)
{
	if(unlikely(__check_bus_range(bus))) return -1;
	close(i2c[bus].fd);
	i2c[bus].devAddr = 0;
	i2c[bus].initialized = 0;
	i2c[bus].lock=0;
	return 0;
}


/**
 * @brief      Changes the device address the bus is configured to talk to.
 *
 *             Actually changing the device address in the I2C driver requires a
 *             system call and is relatively slow. This function records which
 *             device address the bus is set to and will only make the system
 *             call if the requested address is different than the set address.
 *             This makes it safe to call this function repeatedly with no
 *             performance penalty.
 *
 * @param[in]  bus      The bus
 * @param[in]  devAddr  The new device address
 *
 * @return     { description_of_the_return_value }
 */
int rc_i2c_set_device_address(int bus, uint8_t devAddr)
{
	// sanity check
	if(unlikely(__check_bus_range(bus))) return -1;
	if(unlikely(i2c[bus].initialized==0)){
		fprintf(stderr,"ERROR: in rc_i2c_set_device_address, bus not initialized yet\n");
		return -1;
	}
	// if the device address is already correct, just return
	if(i2c[bus].devAddr == devAddr){
		return 0;
	}
	// if not, change it with ioctl
	if(unlikely(ioctl(i2c[bus].fd, I2C_SLAVE, devAddr)<0)){
		fprintf(stderr,"ERROR: in rc_i2c_set_device_address, ioctl slave address change failed\n");
		return -1;
	}
	i2c[bus].devAddr = devAddr;
	return 0;
}

/**
 * @brief      Reads a single byte from a device register.
 *
 *             This sends the device address and register address to be read
 *             from before reading the response, works for most i2c devices.
 *
 * @param[in]  bus      The bus
 * @param[in]  regAddr  The register address
 * @param[out] data     The data pointer to write response to.
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_read_byte(int bus, uint8_t regAddr, uint8_t *data)
{
	return rc_i2c_read_bytes(bus, regAddr, 1, data);
}

/**
 * @brief      Reads multiple bytes from a device register.
 *
 *             This sends the device address and register address to be read
 *             from before reading the response, works for most i2c devices.
 *
 * @param[in]  bus      The bus
 * @param[in]  regAddr  The register address
 * @param[in]  count   number of bytes to read
 * @param[out] data     The data pointer to write response to.
 *
 * @return     returns number of bytes read or -1 on failure
 */
int rc_i2c_read_bytes(int bus, uint8_t regAddr, size_t count, uint8_t *data)
{
	int ret, old_lock;

	// sanity check
	if(unlikely(__check_bus_range(bus))) return -1;
	if(unlikely(i2c[bus].initialized==0)){
		fprintf(stderr,"ERROR: in rc_i2c_read_bytes, bus not initialized yet\n");
		return -1;
	}

	// lock the bus during this operation, preserving old state to return to
	old_lock = i2c[bus].lock;
	i2c[bus].lock = 1;

	// write register to device
	ret = write(i2c[bus].fd, &regAddr, 1);
	if(unlikely(ret!=1)){
		fprintf(stderr,"ERROR: in rc_i2c_read_bytes, failed to write regAddr to bus prior to read\n");
		i2c[bus].lock = old_lock;
		return -1;
	}

	// then read the response
	ret = read(i2c[bus].fd, data, count);
	if(unlikely((size_t)ret!=count)){
		fprintf(stderr,"ERROR: in rc_i2c_read_bytes, received %d bytes from device, expected %d\n", ret, (int)count);
		i2c[bus].lock = old_lock;
		return -1;
	}

	// return the lock state to previous state.
	i2c[bus].lock = old_lock;
	return ret;


}

/**
 * @brief      Reads a single word (16 bits) from a device register.
 *
 *             This sends the device address and register address to be read
 *             from before reading the response, works for most i2c devices.
 *
 * @param[in]  bus      The bus
 * @param[in]  regAddr  The register address
 * @param[out] data     The data pointer to write response to.
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_read_word(int bus, uint8_t regAddr, uint16_t *data)
{
	return rc_i2c_read_words(bus, regAddr, 1, data);
}

/**
 * @brief      Reads multiple words (16 bytes each) from a device register.
 *
 *             This sends the device address and register address to be read
 *             from before reading the response, works for most i2c devices.
 *
 * @param[in]  bus      The bus
 * @param[in]  regAddr  The register address
 * @param[in]  count    Number of 16-bit words to read, NOT number of bytes to read
 * @param[out] data     The data pointer to write response to.
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_read_words(int bus, uint8_t regAddr, size_t count, uint16_t *data)
{
	int ret, old_lock;
	size_t i;
	char buf[count*2];

	// sanity check
	if(unlikely(__check_bus_range(bus))) return -1;
	if(unlikely(i2c[bus].initialized==0)){
		fprintf(stderr,"ERROR: in rc_i2c_read_words, bus not initialized yet\n");
		return -1;
	}

	// lock the bus during this operation
	old_lock = i2c[bus].lock;
	i2c[bus].lock = 1;

	// write register to device
	ret = write(i2c[bus].fd, &regAddr, 1);
	if(unlikely(ret!=1)){
		fprintf(stderr,"ERROR: in rc_i2c_read_words, failed to write to bus\n");
		i2c[bus].lock = old_lock;
		return -1;
	}

	// then read the response
	ret = read(i2c[bus].fd, buf, count*2);
	if(ret!=(signed)(count*2)){
		fprintf(stderr,"ERROR: in rc_i2c_read_words, received %d bytes, expected %zu\n", ret, count*2);
		i2c[bus].lock = old_lock;
		return -1;
	}

	// form words from bytes and put into user's data array
	for(i=0;i<count;i++){
		data[i] = (((uint16_t)buf[i*2])<<8 | buf[(i*2)+1]);
	}

	// return the lock state to previous state.
	i2c[bus].lock = old_lock;
	return 0;
}




/**
 * @brief      Writes multiple bytes to a specified register address.
 *
 *             This sends the device address and register address followed by
 *             the actual data to be written. Works for most i2c devices.
 *
 * @param[in]  bus      The bus
 * @param[in]  regAddr  The register address to write to
 * @param[in]  count    The number of bytes to write
 * @param      data     pointer to user's data to be writen
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_write_bytes(int bus, uint8_t regAddr, size_t count, uint8_t* data)
{
	int ret, old_lock;
	size_t i;
	uint8_t writeData[count+1];

	// sanity check
	if(unlikely(__check_bus_range(bus))) return -1;
	if(unlikely(i2c[bus].initialized==0)){
		fprintf(stderr,"ERROR: in rc_i2c_write_bytes, bus not initialized yet\n");
		return -1;
	}

	// lock the bus during this operation
	old_lock = i2c[bus].lock;
	i2c[bus].lock = 1;

	// assemble array to send, starting with the register address
	writeData[0] = regAddr;
	for(i=0; i<count; i++) writeData[i+1]=data[i];

	// send the bytes
	ret = write(i2c[bus].fd, writeData, count+1);
	// write should have returned the correct # bytes written
	if(unlikely(ret!=(signed)(count+1))){
		fprintf(stderr,"ERROR in rc_i2c_write_bytes, bus wrote %d bytes, expected %zu\n", ret, count+1);
		i2c[bus].lock = old_lock;
		return -1;
	}
	// return the lock state to previous state.
	i2c[bus].lock = old_lock;
	return 0;
}

/**
 * @brief      Writes a single byte to a specified register address.
 *
 *             This sends the device address and register address followed by
 *             the actual data to be written. Works for most i2c devices.
 *
 * @param[in]  bus      The bus
 * @param[in]  regAddr  The register address
 * @param[in]  data     Single byte to be writen
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_write_byte(int bus, uint8_t regAddr, uint8_t data)
{
	int ret, old_lock;
	uint8_t writeData[2];

	// sanity check
	if(unlikely(__check_bus_range(bus))) return -1;
	if(unlikely(i2c[bus].initialized==0)){
		fprintf(stderr,"ERROR: in rc_i2c_write_byte, bus not initialized yet\n");
		return -1;
	}

	// lock the bus during this operation
	old_lock = i2c[bus].lock;
	i2c[bus].lock = 1;

	// assemble array to send, starting with the register address
	writeData[0] = regAddr;
	writeData[1] = data;

	// send the bytes
	ret = write(i2c[bus].fd, writeData, 2);

	// write should have returned the correct # bytes written
	if(unlikely(ret!=2)){
		fprintf(stderr,"ERROR: in rc_i2c_write_byte, system write returned %d, expected 2\n", ret);
		i2c[bus].lock = old_lock;
		return -1;
	}
	// return the lock state to previous state.
	i2c[bus].lock = old_lock;
	return 0;
}

/**
 * @brief      Writes multiple words (16 bits each) to a specified register
 *             address.
 *
 *             This sends the device address and register address followed by
 *             the actual data to be written. Works for most i2c devices.
 *
 * @param[in]  bus      The bus
 * @param[in]  regAddr  The register address
 * @param[in]  count    Number of 16-bit words to write, NOT number of bytes
 * @param[in]  data     The data
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_write_words(int bus, uint8_t regAddr, size_t count, uint16_t* data)
{
	int ret,old_lock;
	size_t i;
	uint8_t writeData[(count*2)+1];

	// sanity check
	if(unlikely(__check_bus_range(bus))) return -1;
	if(unlikely(i2c[bus].initialized==0)){
		fprintf(stderr,"ERROR: in rc_i2c_write_words, bus not initialized yet\n");
		return -1;
	}

	// lock the bus during this operation
	old_lock = i2c[bus].lock;
	i2c[bus].lock = 1;

	// assemble bytes to send
	writeData[0] = regAddr;
	for (i=0; i<count; i++){
		writeData[(i*2)+1] = (uint8_t)(data[i] >> 8);
		writeData[(i*2)+2] = (uint8_t)(data[i] & 0xFF);
	}

	ret = write(i2c[bus].fd, writeData, (count*2)+1);
	if(unlikely(ret!=(signed)(count*2)+1)){
		fprintf(stderr,"ERROR: in rc_i2c_write_words, system write returned %d, expected %zu\n", ret, (count*2)+1);
		i2c[bus].lock = old_lock;
		return -1;
	}
	// return the lock state to previous state.
	i2c[bus].lock = old_lock;
	return 0;
}

/**
 * @brief      Writes a single word (16 bits) to a specified register address.
 *
 *             This sends the device address and register address followed by
 *             the actual data to be written. Works for most i2c devices.
 *
 * @param[in]  bus      The bus
 * @param[in]  regAddr  The register address to write to
 * @param[in]  data     16-bit word to be written
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_write_word(int bus, uint8_t regAddr, uint16_t data)
{
	int ret,old_lock;
	uint8_t writeData[3];

	// sanity check
	if(unlikely(__check_bus_range(bus))) return -1;
	if(unlikely(i2c[bus].initialized==0)){
		fprintf(stderr,"ERROR: in rc_i2c_write_words, bus not initialized yet\n");
		return -1;
	}

	// lock the bus during this operation
	old_lock = i2c[bus].lock;
	i2c[bus].lock = 1;

	// assemble bytes to send from data casted as uint8_t*
	writeData[0] = regAddr;
	writeData[1] = (uint8_t)(data >> 8);
	writeData[2] = (uint8_t)(data & 0xFF);

	ret = write(i2c[bus].fd, writeData, 3);
	if(unlikely(ret!=3)){
		fprintf(stderr,"ERROR: in rc_i2c_write_word, system write returned %d, expected 3\n", ret);
		i2c[bus].lock = old_lock;
		return -1;
	}
	// return the lock state to previous state.
	i2c[bus].lock = old_lock;
	return 0;
}

/**
 * @brief      Sends exactly user-defined data without prepending a register
 *             address.
 *
 *             Instead of automatically sending a device address before the data
 *             which is typical for reading/writing registers, the
 *             rc_i2c_send_bytes function send only the data given by the data
 *             argument. This is useful for more complicated IO such as
 *             uploading firmware to a device.
 *
 * @param[in]  bus   The bus
 * @param[in]  data  The data
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_send_byte(int bus, uint8_t data)
{
	return rc_i2c_send_bytes(bus,1,&data);
}

/**
 * @brief      Sends exactly user-defined data without prepending a register
 *             address.
 *
 *             Instead of automatically sending a device address before the data
 *             which is typical for reading/writing registers, the
 *             rc_i2c_send_bytes function send only the data given by the data
 *             argument. This is useful for more complicated IO such as
 *             uploading firmware to a device.
 *
 * @param[in]  bus     The bus
 * @param[in]  count   Number of bytes to send
 * @param[in]  data    The data
 *
 * @return     0 on success or -1 on failure
 */
int rc_i2c_send_bytes(int bus, size_t count, uint8_t* data)
{
	int ret;

	// sanity check
	if(unlikely(__check_bus_range(bus))) return -1;
	if(unlikely(i2c[bus].initialized==0)){
		fprintf(stderr,"ERROR: in rc_i2c_send_bytes, bus not initialized yet\n");
		return -1;
	}

	// lock the bus during this operation
	int old_lock= i2c[bus].lock;
	i2c[bus].lock = 1;

	// send the bytes
	ret = write(i2c[bus].fd, data, count);
	// write should have returned the correct # bytes written
	if(ret!=(signed)count){
		fprintf(stderr,"ERROR: in rc_i2c_send_bytes, system write returned %d, expected %zu\n", ret, count);
		i2c[bus].lock = old_lock;
		return -1;
	}

	// return the lock state to previous state.
	i2c[bus].lock = old_lock;

	return 0;
}





/**
 * @brief      Locks the bus so other threads in the process know the bus is in
 *             use.
 *
 *             Locking a bus is similar to locking a mutex, it is a way for
 *             threads to communicate within one process when sharing a bus.
 *             This, however, is not a hard lock in the sense that it does not
 *             block and does not stop any of the other functions in this API
 *             from being called. It only serves as a flag that can be checked
 *             between threads if the user chooses to do so. This is encouraged
 *             in multithraded applications to prevent timing-sensitive i2c
 *             communication from being interrupted but is not enforced.
 *
 *             All read/write functions in this API will lock the bus during the
 *             transaction and return the lockstate to what it was at the
 *             beginning of the transaction. Ideally the user should lock the
 *             bus themselves before a sequence of transactions and unlock it
 *             afterwards.
 *
 * @param[in]  bus   The bus ID
 *
 * @return     Returns the lock state (0 or 1) when this function is called, or -1 on
 *             error.
 */
int rc_i2c_lock_bus(int bus)
{
	if(unlikely(__check_bus_range(bus))) return -1;
	int ret=i2c[bus].lock;
	i2c[bus].lock=1;
	return ret;
}

/**
 * @brief      Unlocks a bus to indicate to other threads in the process that
 *             the bus is now free.
 *
 *             see rc_i2c_lock_bus for further description.
 *
 * @param[in]  bus   The bus ID
 *
 * @return     Returns the lock state (0 or 1) when this function is called, or -1 on
 *             error.
 */
int rc_i2c_unlock_bus(int bus)
{
	if(unlikely(__check_bus_range(bus))) return -1;
	int ret=i2c[bus].lock;
	i2c[bus].lock=0;
	return ret;
}

/**
 * @brief      Fetches the current lock state of the bus.
 *
 * @param[in]  bus   The bus ID
 *
 * @return     Returns 0 if unlocked, 1 if locked, or -1 on error.
 */
int rc_i2c_get_lock(int bus)
{
	if(unlikely(__check_bus_range(bus))) return -1;
	return i2c[bus].lock;
}

/**
 * @brief      Gets file descriptor.
 *
 *
 * @param[in]  bus      The bus
 *
 * @return     returns file descriptor of the specified bus or -1 on failure
 */
int rc_i2c_get_fd(int bus) {
	if(unlikely(__check_bus_range(bus))) return -1;
	if(unlikely(i2c[bus].initialized==0)){
		fprintf(stderr,"ERROR: in rc_i2c_get_fd, bus not initialized yet\n");
		return -1;
	}
	return i2c[bus].fd;
}


/*#ifdef RC_AUTOPILOT_EXT
int rc_i2c_read_data(int bus, uint8_t regAddr, size_t length, uint8_t *data)
{
	return rc_i2c_read_bytes(bus, regAddr, length, data);
}
#endif // RC_AUTOPILOT_EXT
*/