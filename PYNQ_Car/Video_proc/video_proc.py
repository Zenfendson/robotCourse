from pynq import DefaultHierarchy

class video_proc_wrapper(DefaultHierarchy):
    def __init__(self, description, vdma=None):
        
        super().__init__(description)
        ip_dict = self.description
        self._vdma = self.axi_dma_proc
        self._switch_front = self.axis_interconnect_front.xbar
        self._switch_back = self.axis_interconnect_back.xbar
        self._sendchannel = self._dma.sendchannel
        self._recvchannel = self._dma.recvchannel
        
        self.canny_core = self.Canny_accel_0
        self.sobel_core = self.Sobel_accel_0
         
        
    @staticmethod
    def checkhierarchy(description):
        return (
            'axi_dma_proc' in description['ip'] and
            'axis_interconnect_front' in description['hierarchies'] and
            'axis_interconnect_back' in description['hierarchies'])
    
    def switch_stream(self,Index):
        if(Index >=3 | Index < 0):
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
        
    def init(self):
        self._mode = VideoMode(1280,720,24)
        self._sendchannel.mode = self._mode
        self._recvchannel.mode = self._mode
        self._sendchannel.start()
        self._recvchannel.start()
        self.setBypass()
        
        self.canny_core.write(0x10, 720)
        self.canny_core.write(0x18, 1280)
        self.canny_core.write(0x00, 0x81)
        
        self.sobel_core.write(0x10, 720)
        self.sobel_core.write(0x18, 1280)
        self.sobel_core.write(0x00, 0x81)
        
    def writeframe(self,frame):
        self._sendchannel.writeframe(frame);
    
    def readframe(self):
        res = self._recvchannel.readframe()
        res.freebuffer()
        res = self._recvchannel.readframe()
        return res;
        
    def start(self):
        self._sendchannel.start()
        self._recvchannel.start()
    
    def stop(self):
        self._sendchannel.stop()
        self._recvchannel.stop()
    
    def SobelX(self,frame):
        self.setSobelX()
        self.writeframe(frame)
        res = self.readframe()
        res = self.readframe()        
        return res
    
    def SobelY(self,frame):
        self.setSobelY()
        self.writeframe(frame)
        res = self.readframe()
        res = self.readframe()        
        return res
    
    def Canny(self,frame,low_threshold,high_threshold):
        self.setCanny(low_threshold,high_threshold)
        self.writeframe(frame)
        res = self.readframe()
        res = self.readframe()        
        return res
    
    def Bypass(self,frame):
        self.setBypass()
        self.writeframe(frame)
        res = self.readframe()
        res = self.readframe()        
        return res
    
    def setSobelX(self):
        self.sobel_core.write(0x20, 0)
        self.switch_stream(1)     
    
    def setSobelY(self):
        self.sobel_core.write(0x20, 1)
        self.switch_stream(1)     
    
    def setCanny(self,low_threshold,high_threshold):
        self.canny_core.write(0x20, int(low_threshold))
        self.canny_core.write(0x28, int(high_threshold))
        self.switch_stream(2)     
    
    def setBypass(self):
        self.switch_stream(0)     
    
    def __del__(self):
        if(self._sendchannel.running()):
            self._sendchannel.stop()
        if(self._recvchannel.running()):
            self._recvchannel.stop()
