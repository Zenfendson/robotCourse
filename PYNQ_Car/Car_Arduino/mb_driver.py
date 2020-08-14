import math
from pynq.lib.arduino import Arduino
import numpy as np
INIT				        =1
RESET 				      =3
SET_IIC_PINS			    =5
GET_ACCL_DATA 	  	=7
GET_GYRO_DATA 		  =9
GET_COMPASS_DATA 	  =11
GET_ENCODER_DATA 	  =13
SET_ENCODER_DIR 	  =15
SET_MOTOR_PINS 		  =17
SET_MOTOR_DIR 		  =19
SET_VELOCITY  		  =21
SET_SERVO_ANGLE  	  =23
SET_SERVO_PIN 		  =25
GET_ULRANGER_DATA 	=27
SET_MOTOR_MODE      =29

Arduino_pins_dict = {'D1': 0, 'D2': 1,'D3':2,'D4': 3, 'D5': 4,'D6':5,'D7': 6, 'D8': 7,'D9':8,'D10': 9, 'D11': 10,'D12':11,'D13': 12,'SDA': 13, 'SCL': 14}

Arduino_programs_dict = {'monomotor':"/usr/local/lib/python3.6/dist-packages/PYNQ_Car/Overlay/car_arduino_monomotor.bin",'bimotor':"/usr/local/lib/python3.6/dist-packages/PYNQ_Car/Overlay/car_arduino_bimotor.bin"}

Arduino_mode_dict = {'simple':0 , 'full_bridge':1}

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
        self.mb_info = mb_info
        self.isLoaded = False
        

    def reset(self):
        """Reset all the sensors on the grove IMU.
            
        Returns
        -------
        None
        
        """
        self.microblaze.write_blocking_command(RESET)

    def load(self,program_name):
        if program_name not in Arduino_programs_dict.keys():
            raise RuntimeError("Unsupported car type!")
        self.microblaze = Arduino(self.mb_info, Arduino_programs_dict[program_name])
        self.isLoaded = True
        
    def init(self):
        if self.isLoaded is not True:
            raise RuntimeError("Arduino program is not loaded!")
        
        self.microblaze.write_blocking_command(INIT)
    
    def set_iic_pins(self,sda_pin,scl_pin):
        if sda_pin not in Arduino_pins_dict.keys() or scl_pin not in Arduino_pins_dict.keys():
            raise RuntimeError("Unsupported pins!")
        self.microblaze.write_mailbox(0, Arduino_pins_dict[sda_pin])
        self.microblaze.write_mailbox(4, Arduino_pins_dict[scl_pin])
        self.microblaze.write_blocking_command(SET_IIC_PINS)
        
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
    
    def get_encoder_data(self):
        res0 = 0
        res1 = 0
        self.microblaze.write_blocking_command(GET_ENCODER_DATA)
        data0 = self.microblaze.read_mailbox(0, 1)
        data1 = self.microblaze.read_mailbox(4, 1)
        res0 = _reg2int(data0)
        res1 = _reg2int(data1)
        return res0,res1
    
    def set_encoder_dir(self,dir0,dir1 = 0):
        self.microblaze.write_mailbox(0, dir0)
        self.microblaze.write_mailbox(4, dir1)
        self.microblaze.write_blocking_command(SET_ENCODER_DIR)
        return
    
    def set_motor_pins(self,m0_out1_pin,m0_out2_pin,m1_out1_pin = None ,m1_out2_pin = None ):
        if (m0_out1_pin not in Arduino_pins_dict.keys()) or (m0_out2_pin not in Arduino_pins_dict.keys()):
            raise RuntimeError("Unsupported pins!")
        self.microblaze.write_mailbox(0, Arduino_pins_dict[m0_out1_pin])
        self.microblaze.write_mailbox(4, Arduino_pins_dict[m0_out2_pin])
        if ((m1_out1_pin is not None) and (m1_out2_pin is not None)):
            if (m1_out1_pin not in Arduino_pins_dict.keys()) or (m1_out2_pin not in Arduino_pins_dict.keys()):
                raise RuntimeError("Unsupported pins!")
            self.microblaze.write_mailbox(8, Arduino_pins_dict[m1_out1_pin])
            self.microblaze.write_mailbox(12, Arduino_pins_dict[m1_out2_pin])
        self.microblaze.write_blocking_command(SET_MOTOR_PINS)
        
    def set_velocity(self,data):
        if(data<-1000):
            data = -1000
        elif(data>1000):
            data = 1000
        self.microblaze.write_mailbox(0, data)
        self.microblaze.write_blocking_command(SET_VELOCITY)
        return

    
    def set_motor_dir(self,dir0,dir1 = 0):
        self.microblaze.write_mailbox(0, dir0)
        self.microblaze.write_mailbox(4, dir1)
        self.microblaze.write_blocking_command(SET_MOTOR_DIR)
        return
        
    def set_servo_angle(self,data):
        k = np.zeros((1,1),dtype = np.float32)
        k[0,0] = np.float32(data)
        k.dtype = np.int32
        self.microblaze.write_mailbox(0, int(k[0,0]))
        self.microblaze.write_blocking_command(SET_SERVO_ANGLE)
        return
        
    def set_servo_pin(self,pin):
        if pin not in Arduino_pins_dict.keys():
            raise RuntimeError("Unsupported pins!")
        self.microblaze.write_mailbox(0, Arduino_pins_dict[pin])
        self.microblaze.write_blocking_command(SET_SERVO_PIN)
        return
        
        
    def get_ultra_cm(self):
        self.microblaze.write_blocking_command(GET_ULRANGER_DATA)
        reg = self.microblaze.read_mailbox(0, 1)
        num_microseconds = _reg2int(reg)
        if num_microseconds * 0.001 > 30:
            return 500
        else:
            return num_microseconds/58
            
    def set_motor_mode(self,mode):
        if (mode not in Arduino_mode_dict.keys()):
            raise RuntimeError("Unsupported driving mode!")
        self.microblaze.write_mailbox(0, Arduino_mode_dict[mode])
        self.microblaze.write_mailbox(4, Arduino_mode_dict[mode])
        self.microblaze.write_blocking_command(SET_MOTOR_MODE)
        return
        