
class MotionController:
    def __init__(self,mc):
        self.__mc = mc
        self.__mc.init()
        
    def set_velocity(self,velocity):
        self.__mc.set_velocity(velocity)
        
    def set_direction(self,direction):
        self.__mc.set_direction(direction)