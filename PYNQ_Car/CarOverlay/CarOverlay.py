import pynq.lib
from PYNQ_Car.OV5640_Driver import OV5640_driver
from PYNQ_Car.Video_proc import video_proc
from PYNQ_Car.Car_Arduino.mb_driver import Car_Arduino
from pynq.lib.video.pipeline import PixelPacker
import pynq

class CarOverlay(pynq.Overlay):
    def __init__(self, bitfile, **kwargs):
        super().__init__(bitfile, **kwargs)
        if self.is_loaded():
            self.OV5640 = self.ov5640_driver_wrapper
            self.Arduino = Car_Arduino(self.car_iop_arduino.mb_info)
            self.video_proc = self.image_processing
            self.video_proc.init()