from pynq import DefaultHierarchy
from pynq import PL
from pynq import GPIO
from pynq.xlnk import Xlnk
from pynq.lib.video.pipeline import PixelPacker
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
        self.canny_low = 80
        self.canny_high = 80
        
        self.unpack_core = self.pixel_unpack
        self.pack_core = self.pixel_pack
        
        self.canny_core = self.Canny_accel_0
        self.color_detect_core = self.color_detect
        self.gpio_dict = PL.gpio_dict
        if('image_process_reset' not in self.gpio_dict.keys()):
            raise ValueError("No reset pin connected or wrong pin name!")
        self.rst_pin = GPIO(GPIO.get_gpio_pin(self.gpio_dict['image_process_reset']['index']), "out")
        
        self.unpack_core.bits_per_pixel = 24
        self.pack_core.bits_per_pixel = 24 
        
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
        self.setBypass(3)
        self.canny_core.write(0x00, 0X00)
        self.canny_core.write(0x10, 80)
        self.canny_core.write(0x18, 80)
        self.canny_core.write(0x00, 0X81)
        self.start()
        
        
    def start(self):
        self._sendchannel.start()
        self._recvchannel.start()
    
    def stop(self):
        self._sendchannel.stop()
        self._recvchannel.stop()
        self.reset()
    
    def SobelX(self,frame):
        if(frame.shape != (720,1280)):
            raise ValueError("invalid frame shape!")
        self.setSobelX()
        src = xlnk.cma_array((720,1280),dtype = np.uint8)
        dst = xlnk.cma_array((720,1280),dtype = np.uint8)
        
        if(not hasattr(frame,'cacheable')):
            np.copyto(src,frame)
            self._sendchannel.transfer(src)
        else:
            self._sendchannel.transfer(frame)
            
        self._recvchannel.transfer(dst)
        self._recvchannel.wait()
        src.freebuffer()

        return dst
    
    def SobelY(self,frame):
        if(frame.shape != (720,1280)):
            raise ValueError("invalid frame shape!")
        self.setSobelY()
        src = xlnk.cma_array((720,1280),dtype = np.uint8)
        dst = xlnk.cma_array((720,1280),dtype = np.uint8)
        
        if(not hasattr(frame,'cacheable')):
            np.copyto(src,frame)
            self._sendchannel.transfer(src)
        else:
            self._sendchannel.transfer(frame)
            
        self._recvchannel.transfer(dst)
        self._recvchannel.wait()
        src.freebuffer()

        return dst
    
    def Canny(self,frame,low_threshold,high_threshold):
        if(frame.shape != (720,1280)):
            raise ValueError("invalid frame shape!")
        self.setCanny(low_threshold,high_threshold)
        
        src = xlnk.cma_array((720,1280),dtype = np.uint8)
        dst = xlnk.cma_array((720,1280),dtype = np.uint8)
        
        if(not hasattr(frame,'cacheable')):
            np.copyto(src,frame)
            self._sendchannel.transfer(src)
        else:
            self._sendchannel.transfer(frame)
            
        self._recvchannel.transfer(dst)
        self._recvchannel.wait()
        src.freebuffer()
        return dst
        
    def ColorDetect(self,frame,H_low,H_high,S_low,S_high,V_low,V_high):
        if(frame.shape != (720,1280,3)):
            raise ValueError("invalid frame shape!")
        self.setColor_Detect(H_low,H_high,S_low,S_high,V_low,V_high)
        
        if(not hasattr(frame,'cacheable')):
            src = xlnk.cma_array((720,1280,3),dtype = np.uint8)
            np.copyto(src,frame)
            self._sendchannel.transfer(src)
            while not (self.color_detect_core.read(0x38) & 0x01):
                pass
            src.freebuffer()
        else:
            self._sendchannel.transfer(frame)
            while not (self.color_detect_core.read(0x38) & 0x01):
                pass
        posX = self.color_detect_core.read(0x28)
        posY = self.color_detect_core.read(0x2c)
        widthX = self.color_detect_core.read(0x30)
        widthY = self.color_detect_core.read(0x34)
        return posX,posY,widthX,widthY
    
    def Bypass(self,frame):
        if(frame.shape != (720,1280,3) and frame.shape != (720,1280)):
            raise ValueError("invalid frame shape!")
            
        if(frame.shape == (720,1280,3)):
            src = xlnk.cma_array((720,1280,3),dtype = np.uint8)
            dst = xlnk.cma_array((720,1280,3),dtype = np.uint8)
            self.setBypass(3)    
        else:
            src = xlnk.cma_array((720,1280),dtype = np.uint8)
            dst = xlnk.cma_array((720,1280),dtype = np.uint8)
            self.setBypass(1)
            
        if(not hasattr(frame,'cacheable')):
            np.copyto(src,frame)
            self._sendchannel.transfer(src)
        else:
            self._sendchannel.transfer(frame)
            
        self._recvchannel.transfer(dst)
        self._recvchannel.wait()
        src.freebuffer()

        return dst
    
    def setSobelX(self):
        self.switch_stream(2)
        self.unpack_core.bits_per_pixel = 8
        self.pack_core.bits_per_pixel = 8      
    
    def setSobelY(self):
        self.switch_stream(3)
        self.unpack_core.bits_per_pixel = 8
        self.pack_core.bits_per_pixel = 8     
    
    def setCanny(self,low_threshold,high_threshold):
        self.switch_stream(1) 
        self.canny_core.write(0x00, 0X00)
        self.canny_core.write(0x10, int(low_threshold))
        self.canny_core.write(0x18, int(high_threshold))
        self.canny_core.write(0x00, 0X81)
        self.unpack_core.bits_per_pixel = 8
        self.pack_core.bits_per_pixel = 8
        
    def setColor_Detect(self,H_low,H_high,S_low,S_high,V_low,V_high):
        self.switch_stream(4) 
        self.canny_core.write(0x00, 0X00)
        self.color_detect_core.write(0x00,0x00)
        self.color_detect_core.write(0x10,H_high+(H_low << 8))
        self.color_detect_core.write(0x18,S_high+(S_low << 8))
        self.color_detect_core.write(0x20,S_high+(S_low << 8))
        self.color_detect_core.write(0x00,0x81)
        self.unpack_core.bits_per_pixel = 24
        self.pack_core.bits_per_pixel = 24
        
            
    
    def setBypass(self,nchannels):
        self.switch_stream(0)
        if(nchannels == 3):
            self.unpack_core.bits_per_pixel = 24
            self.pack_core.bits_per_pixel = 24
            return
        if(nchannels == 1):
            self.unpack_core.bits_per_pixel = 8
            self.pack_core.bits_per_pixel = 8
            return     
    
    def __del__(self):
        if(self._sendchannel.running):
            self._sendchannel.stop()
        if(self._recvchannel.running):
            self._recvchannel.stop()