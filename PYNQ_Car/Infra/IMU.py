class IMU:
    def __init__(self,IMU):
        self.__IMU = IMU
        self.__IMU.init()
        
    def get_accl(self):
        return self.__IMU.get_accl()
        
    def get_gyro(self):
        return self.__IMU.get_gyro()

    def get_compass(self):
        return self.__IMU.get_compass()