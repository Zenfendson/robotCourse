from pynq import DefaultHierarchy
from pynq import PL
from pynq import GPIO
from pynq.xlnk import Xlnk
import numpy as np
xlnk = Xlnk()

class video_proc_wrapper(DefaultHierarchy):
    def __init__(self, description, vdma=None):
        
        super().__init__(description)
        self._dma = self.axi_dma_proc
        self._switch_front = self.axis_interconnect_front.xbar
        self._switch_back = self.axis_interconnect_back.xbar
        self._sendchannel = self._dma.sendchannel
        self._recvchannel = self._dma.recvchannel
        
        self.canny_core = self.Canny_accel_0
        self.gpio_dict = PL.gpio_dict
        if('image_process_reset' not in self.gpio_dict.keys()):
            raise ValueError("No reset pin connected or wrong pin name!")
        self.rst_pin = GPIO(GPIO.get_gpio_pin(self.gpio_dict['image_process_reset']['index']), "out")
        
         
        
    @staticmethod
    def checkhierarchy(description):
        return (
            'axi_dma_proc' in description['ip'] and
            'axis_interconnect_front' in description['hierarchies'] and
            'axis_interconnect_back' in description['hierarchies'] )
    
    def switch_stream(self,Index):
        if(Index >=4 | Index < 0):
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
    
    def reset(self):
        self.rst_pin.write(1)
        self.rst_pin.write(1)
        self.rst_pin.write(1)
        self.rst_pin.write(0)
        
    def init(self):
        
        self.reset()
        self.start()
        self.setBypass()
        self.canny_core.write(0x10, 20)
        self.canny_core.write(0x18, 80)
        self.canny_core.write(0x00, 81)
        
        
    def start(self):
        self._sendchannel.start()
        self._recvchannel.start()
    
    def stop(self):
        self._sendchannel.stop()
        self._recvchannel.stop()
    
    def SobelX(self,frame):
        self.setSobelX()
        if(frame.shape != (720,1280,4)):
            raise ValueError("invalid frame shape!")
        res = xlnk.cma_array((720,1280,4),dtype = np.uint8)
        self._sendchannel.transfer(frame)
        self._recvchannel.transfer(res)
        return res
    
    def SobelY(self,frame):
        self.setSobelY()
        if(frame.shape != (720,1280,4)):
            raise ValueError("invalid frame shape!")
        res = xlnk.cma_array((720,1280,4),dtype = np.uint8)
        self._sendchannel.transfer(frame)
        self._recvchannel.transfer(res)
        return res
    
    def Canny(self,frame,low_threshold,high_threshold):
        self.setCanny(low_threshold,high_threshold)
        if(frame.shape != (720,1280,4)):
            raise ValueError("invalid frame shape!")
        res = xlnk.cma_array((720,1280,4),dtype = np.uint8)
        self._sendchannel.transfer(frame)
        self._recvchannel.transfer(res)
        return res
    
    def Bypass(self,frame):
        self.setBypass()
        if(frame.shape != (720,1280,4)):
            raise ValueError("invalid frame shape!")
        res = xlnk.cma_array((720,1280,4),dtype = np.uint8)
        self._sendchannel.transfer(frame)
        self._recvchannel.transfer(res)
        return res
    
    def setSobelX(self):
        self.switch_stream(2)     
    
    def setSobelY(self):
        self.switch_stream(3)     
    
    def setCanny(self,low_threshold,high_threshold):
        self.canny_core.write(0x00, 0X00)
        self.canny_core.write(0x10, int(low_threshold))
        self.canny_core.write(0x18, int(high_threshold))
        self.canny_core.write(0x00, 0X81)
        self.switch_stream(1)     
    
    def setBypass(self):
        self.switch_stream(0)     
    
    def __del__(self):
        if(self._sendchannel.running()):
            self._sendchannel.stop()
        if(self._recvchannel.running()):
            self._recvchannel.stop()
