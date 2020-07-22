import math
from pynq.lib.arduino import Arduino

ARDUINO_CAR_PROGRAM = "/usr/local/lib/python3.6/dist-packages/PYNQ_Car/car_arduino.bin"
RESET = 1
GET_ACCL_DATA = 3
GET_GYRO_DATA = 5
GET_COMPASS_DATA = 7
GET_ENCODER_DATA = 9
SET_ENCODER_DIR = 11
SET_ENCODER_SAMPLE_INTERVAL_MS = 13
SET_MOTOR_FREQ = 15
SET_MOTOR_PWM = 17
SET_MOTOR_DIR = 19
SET_SERVO_PWM = 21


def _reg2float(reg):
    """Converts 32-bit register value to floats in Python.
    Parameters
    ----------
    reg: int
        A 32-bit register value read from the mailbox.
    Returns
    -------
    float
        A float number translated from the register value.
    """
    if reg == 0:
        return 0.0
    sign = (reg & 0x80000000) >> 31 & 0x01
    exp = ((reg & 0x7f800000) >> 23) - 127
    if exp == 0:
        man = (reg & 0x007fffff) / pow(2, 23)
    else:
        man = 1 + (reg & 0x007fffff) / pow(2, 23)
    result = pow(2, exp) * man * ((sign * -2) + 1)
    return float("{0:.2f}".format(result))


def _reg2int(reg):
    """Converts 32-bit register value to signed integer in Python.
    Parameters
    ----------
    reg: int
        A 32-bit register value read from the mailbox.
    Returns
    -------
    int
        A signed integer translated from the register value.
    """
    result = -(reg >> 31 & 0x1) * (1 << 31)
    for i in range(31):
        result += (reg >> i & 0x1) * (1 << i)
    return result


class Car_Arduino(object):
    """
    ----------
    microblaze : Arduino
        Microblaze processor instance used by this module.
        
    """
    def __init__(self, mb_info):
        """Return a new instance of an Grove IMU object. 
        
        Parameters
        ----------
        mb_info : dict
            A dictionary storing Microblaze information, such as the
            IP name and the reset name.
        gr_pin: list
            A group of pins on arduino-grove shield.
        """
        
        self.microblaze = Arduino(mb_info, ARDUINO_CAR_PROGRAM)
        self.reset()

    def reset(self):
        """Reset all the sensors on the grove IMU.
            
        Returns
        -------
        None
        
        """
        self.microblaze.write_blocking_command(RESET)
        
    def get_accl(self):
        """Get the data from the accelerometer.
        
        Returns
        -------
        list
            A list of the acceleration data along X-axis, Y-axis, and Z-axis.
        
        """
        self.microblaze.write_blocking_command(GET_ACCL_DATA)
        data = self.microblaze.read_mailbox(0, 3)
        [ax, ay, az] = [_reg2int(i) for i in data]
        return [float("{0:.2f}".format(ax / 16384)),
                float("{0:.2f}".format(ay / 16384)),
                float("{0:.2f}".format(az / 16384))]
        
    def get_gyro(self):
        """Get the data from the gyroscope.
        
        Returns
        -------
        list
            A list of the gyro data along X-axis, Y-axis, and Z-axis.
        
        """
        self.microblaze.write_blocking_command(GET_GYRO_DATA)
        data = self.microblaze.read_mailbox(0, 3)
        [gx, gy, gz] = [_reg2int(i) for i in data]
        return [float("{0:.2f}".format(gx * 250 / 32768)),
                float("{0:.2f}".format(gy * 250 / 32768)),
                float("{0:.2f}".format(gz * 250 / 32768))]

    def get_compass(self):
        """Get the data from the magnetometer.
        
        Returns
        -------
        list
            A list of the compass data along X-axis, Y-axis, and Z-axis.
        
        """
        self.microblaze.write_blocking_command(GET_COMPASS_DATA)
        data = self.microblaze.read_mailbox(0, 3)
        [mx, my, mz] = [_reg2int(i) for i in data]
        return [float("{0:.2f}".format(mx * 1200 / 4096)),
                float("{0:.2f}".format(my * 1200 / 4096)),
                float("{0:.2f}".format(mz * 1200 / 4096))]

    def get_heading(self):
        """Get the value of the heading.
        
        Returns
        -------
        float
            The angle deviated from the X-axis, toward the positive Y-axis.
        
        """
        [mx, my, _] = self.get_compass()
        heading = 180 * math.atan2(my, mx) / math.pi
        if heading < 0:
            heading += 360
        return float("{0:.2f}".format(heading))

    def get_tilt_heading(self):
        """Get the value of the tilt heading.
        
        Returns
        -------
        float
            The tilt heading value.
        
        """
        [ax, ay, _] = self.get_accl()
        [mx, my, mz] = self.get_compass()

        try:
            pitch = math.asin(-ax)
            roll = math.asin(ay / math.cos(pitch))
        except ZeroDivisionError:
            raise RuntimeError("Value out of range or device not connected.")

        xh = mx * math.cos(pitch) + mz * math.sin(pitch)
        yh = mx * math.sin(roll) * math.sin(pitch) + \
            my * math.cos(roll) - mz * math.sin(roll) * math.cos(pitch)
        _ = -mx * math.cos(roll) * math.sin(pitch) + \
            my * math.sin(roll) + mz * math.cos(roll) * math.cos(pitch)
        tilt_heading = 180 * math.atan2(yh, xh) / math.pi
        if yh < 0:
            tilt_heading += 360
        return float("{0:.2f}".format(tilt_heading))
    
    def get_encoder_data(self):
        self.microblaze.write_blocking_command(GET_ENCODER_DATA)
        data = self.microblaze.read_mailbox(0, 1)
        return _reg2int(data)
    
    def set_encoder_dir_pos(self):
        self.microblaze.write_mailbox(0, 0)
        self.microblaze.write_blocking_command(SET_ENCODER_DIR)
        return
    
    def set_encoder_dir_neg(self):
        self.microblaze.write_mailbox(0, 1)
        self.microblaze.write_blocking_command(SET_ENCODER_DIR)
        return
    
    def set_encoder_sample_interval_ms(self,data):
        self.microblaze.write_mailbox(0, data)
        self.microblaze.write_blocking_command(SET_ENCODER_SAMPLE_INTERVAL_MS)
        return
    
    def set_motor_freq(self,freq):
        data = 100000000/freq
        self.microblaze.write_mailbox(0, data)
        self.microblaze.write_blocking_command(SET_MOTOR_FREQ)
        return
        
    def set_motor_pwm(self,data):
        if(data<-1000):
            data = -1000
        elif(data>1000):
            data = 1000
        self.microblaze.write_mailbox(0, data)
        self.microblaze.write_blocking_command(SET_MOTOR_PWM)
        return

    
    def set_motor_dir_pos(self):
        self.microblaze.write_mailbox(0, 0)
        self.microblaze.write_blocking_command(SET_MOTOR_DIR)
        return
    
    def set_motor_dir_neg(self):
        self.microblaze.write_mailbox(0, 1)
        self.microblaze.write_blocking_command(SET_MOTOR_DIR)
        return
        
    def set_servo_pwm(self,data):
        if(data<240):
            data = 240
        elif(data>360):
            data= 360 
        self.microblaze.write_mailbox(0, data)
        self.microblaze.write_blocking_command(SET_SERVO_PWM)
        return