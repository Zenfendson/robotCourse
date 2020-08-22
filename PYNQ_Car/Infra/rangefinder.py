class rangefinder:
 
    def __init__(self,rf):
        self.__rf = rf
        self.__rf.init()
         
    def get_range_cm(self):
        return self.__rf.get_range_cm()