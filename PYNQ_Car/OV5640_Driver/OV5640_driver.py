from pynq import DefaultHierarchy
from PYNQ_Car.dma.dma import AxiVDMA
from PYNQ_Car.OV5640_Driver.ov5640_config import *
from pynq.lib.video.common import VideoMode
from pynq import PL
from pynq import GPIO

class OV5640_Driver(DefaultHierarchy):
    def __init__(self, description, vdma=None):
        super().__init__(description)
        ip_dict = self.description
        self._sccb = self.axi_sccb
        self._demosaic = self.a0_demosaic
        self.readchannel = self.axi_vdma_cam.readchannel
        self._switch_front = self.axis_interconnect_front.xbar
        self._switch_back = self.axis_interconnect_back.xbar
        
        
        self.gpio_dict = PL.gpio_dict
        if('camera_reset' not in self.gpio_dict.keys()):
            raise ValueError("No reset pin connected or wrong pin name!")
        self.rst_pin = GPIO(GPIO.get_gpio_pin(self.gpio_dict['camera_reset']['index']), "out")
        
        
    @staticmethod
    def checkhierarchy(description):
        return (
            'a0_demosaic' in description['ip'] and
            'axi_vdma_cam' in description['ip'] and
            'axi_sccb' in description['ip'])
    
    def init(self):
        self.reset()
        address = 0x3c
        length = 3
        for config in ov5640_config:
            tmp1 = config[0] >> 8;
            tmp2 = config[0] & 0xff;
            self._sccb.send(address, bytes([tmp1, tmp2, config[1]]), length)
        self._demosaic.write(0x10, 1280)
        self._demosaic.write(0x18, 720)
        self._demosaic.write(0x28, 1)
        self._demosaic.write(0x00, 0x81)
        self.readchannel.mode = VideoMode(1280,720,32)
        self.switch_stream(0)
        self.readchannel.start()
        
    def reset(self):
        for i in range(20):
            self.rst_pin.write(1)
        self.rst_pin.write(0)
        
    def set_rgba(self):
        self.stop()
        self.switch_stream(0)
        self.readchannel.start()
        
    def set_gray(self):
        self.stop()
        self.switch_stream(1)
        self.readchannel.start()
        
    def get_cam_frame(self):
        return self.readchannel.readframe()
    
    def stop(self):
        if(self.readchannel.running):
            self.readchannel.stop()
            
    def reset(self):
        if(self.readchannel.running):
            self.readchannel.stop()
         
        self.readchannel.reset()
        
    def switch_stream(self,Index):
        if(Index >1 | Index < 0):
            raise RuntimeError('Index is illegal!')
        
        MaxIndex = 5
        self._switch_front.write(0x00, ~0x02)
        for i in range(0,MaxIndex + 1):
            self._switch_front.write(0x40 + 4*Index, 0x80000000)
        self._switch_front.write(0x40 + 4*Index, 0)
        self._switch_front.write(0x00, 0x02)

        self._switch_back.write(0x00, ~0x02)
        for i in range(0,MaxIndex + 1):
            self._switch_front.write(0x40 + 4*Index, 0x80000000)
        self._switch_back.write(0x40 + 4*0, Index)
        self._switch_back.write(0x00, 0x02)
        