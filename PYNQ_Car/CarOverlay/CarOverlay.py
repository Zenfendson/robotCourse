import pynq.lib
import OV5640_driver
import video_proc
from mb_driver import Car_Arduino
import pynq

class CarOverlay(pynq.Overlay):
    def __init__(self, bitfile, **kwargs):
        super().__init__(bitfile, **kwargs)
        if self.is_loaded():
            self.OV5640 = self.ov5640_driver_wrapper
            self.Arduino = Car_Arduino(self.car_iop_arduino.mb_info)
            self.video_proc = self.image_processing
            self.OV5640.init()
            self.video_proc.init()
            self.stream_tie()
            
    def stream_tie(self):
        self.OV5640.readchannel.tie(self.video_proc._sendchannel)