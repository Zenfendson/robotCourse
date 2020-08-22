class Camera:

    def __init__(self,camera):
        self.__camera = camera
        self.__mode_dict = {'gray':1,'RGB':0}
        self.__camera.init()
        
    def get_frame(self, mode):
        if(mode not in self.__mode_dict.keys()):
            raise ValueError("Camera mode must be gray or RGB !")
        return self.__camera.get_frame(mode)
        
    def stop(self):
        self.__camera.stop()
        
    def start(self):
        self.__camera.start()

        
        