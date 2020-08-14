# API_Doc

## class CarOverlay 

### 方法
无

### 成员

#### OV5640
**含义**: OV5640摄像头通路的驱动抽象
**类型** : OV5640_Driver
#### video_proc
**含义**: 图像处理模块的驱动抽象
**类型**: video_proc_wrapper
#### Arduino :
**含义**: Arduino Microblaze 的驱动抽象
**类型**: Car_Arduino

### 使用例
```
import CarOverlay
overlay = CarOverlay('car.bit')  
ov5640 = overlay.OV5640
video_proc = overlay.video_proc  
Arduino = overlay.Arduino  
...
```

## Class OV5640_Driver

### 方法
#### init()
**功能**: 初始化摄像头，在Overlay初始化时调用，无需显式调用
**参数** : 无
**返回**：无

#### get_cam_frame()
**功能**: 读取一张图片
**参数** : 无
**返回**：一张1280×720的**RGBA**或者**gray**图像,numpy兼容，不再需要时需要手动调用freebuffer()方法释放。**注意**：返回的图像是四通道的，gray图像在第0通道

#### stop()
**功能**: 停止内部VDMA
**参数** : 无
**返回**：无

#### reset()
**功能**: 复位内部VDMA
**参数** : 无
**返回**：无

#### set_rgba()
**功能**: 设置读取的是rgba图像
**参数** : 无
**返回**：无

#### set_gray()
**功能**: 设置读取的是gray图像
**参数** : 无
**返回**：无

### 成员
无

## Class video_proc_wrapper

### 方法
#### init()
**功能**: 初始化各处理模块，在Overlay初始化时调用，无需显式调用
**参数** : 无
**返回**：无

#### SobelX(frame)
**功能**: 对图片进行X方向的Sobel滤波
**参数** :   
frame：使用Xlnk分配的内存空间，或者从摄像头读取的四通道图片
**返回**：一张1280×720的**GBR**图像,numpy兼容，不再需要时需要手动调用freebuffer()方法释放。**注意**：输入的图像是四通道的，gray图像在第0通道

#### SobelY(frame)
**功能**: 对图片进行Y方向的Sobel滤波
**参数** :   
frame：使用Xlnk分配的内存空间，或者从摄像头读取的四通道图片  
**返回**：一张1280×720的**GBR**图像,numpy兼容，不再需要时需要手动调用freebuffer()方法释放。**注意**：输入的图像是四通道的，gray图像在第0通道

#### Canny(frame,low,high)
**功能**: 对输入图片进行Canny边缘检测
**参数** :   
frame: 使用Xlnk分配的内存空间，或者从摄像头读取的四通道图片  
(uint8)low: canny 算子的低阈值  
(uint8)high: canny 算子的高阈值  
**返回**：一张1280×720的**GBR**图像,numpy兼容，不再需要时需要手动调用freebuffer()方法释放。**注意**：输入的图像是四通道的，gray图像在第0通道 

#### ColorDetect(self,frame,H_low,H_high,S_low,S_high,V_low,V_high)
**功能**: 颜色检测，使用HSV颜色空间
**参数** :   
frame: 使用Xlnk分配的内存空间，或者从摄像头读取的四通道图片
(uint8)H_low: H通道低阈值  (取值范围0~180)
(uint8)H_high: H通道高阈值 (取值范围0~180)
(uint8)S_low: S通道低阈值
(uint8)S_high: S通道高阈值
(uint8)V_low: V通道低阈值
(uint8)V_high: V通道高阈值
**返回**：列表，顺序为posX,posY,widthX,widthY
(uint32)posX: 色块的X坐标
(uint32)posY：色块的Y坐标
(uint32)widthX: 色块的横向宽度
(uint32)windthY: 色块的纵向宽度

#### Bypass(frame)
**功能**: 内部DMA读写通道直接相连，用于检查DMA是否正常工作
**参数** :   
frame: 使用Xlnk分配的内存空间，或者从摄像头读取的三通道图片  
**返回**：一张1280×720的**gray**或者**rgba**图像,numpy兼容，不再需要时需要手动调用freebuffer()方法释放。**注意**：输入的图像是四通道的，gray图像在第0通道  

#### stop()
**功能**: 停止内部VDMA
**参数** : 无
**返回**：无  

#### reset()
**功能**: 复位内部VDMA
**参数** : 无
**返回**：无  

### 成员
无

## Class Car_Arduino

### 方法
#### reset()
**功能**: 复位microblaze
**参数**: 无
**返回**：无

#### load(program_name)
**功能**: 选择车体
**参数** : 
(string)program_name: 'bimotor':双电机, 'monomotor':单电机
**返回**：无

#### init()
**功能**: 初始化arduino microblaze。**注意**：必须选择车体并设置好引脚引脚后显式调用
**参数**: 无
**返回**：无

#### get_accel()
**功能**: 返回加速度计XYZ三轴数据列表
**参数**: 无
**返回**：(list)加速度计XYZ三轴数据列表

#### get_gyro()
**功能**: 返回陀螺仪三周数据
**参数**: 无
**返回**：(list)陀螺仪XYZ三轴数据列表

#### get_compass()
**功能**: 返回磁力计数据
**参数**: 无
**返回**：(list)磁力计XYZ三轴数据列表

#### get_encoder_data()
**功能**: 读取编码器数据
**参数**: 无
**返回**: 列表，顺序为encoder0,encoder1
encoder0: (int32) 左编码器读数，单电机时为编码器读数
encoder1: (int32) 右编码器读书，单电机时无效

#### set_encoder_dir(dir0,dir1 = 0)
**功能**: 设置编码器计数方向为正
**参数** : 
(bool) dir0: 左编码器的方向，单电机时为编码器方向
(bool) dir1: 右编码器的方向，单电机时无效
**返回**：无  

#### set_motor_pins(m0_out1_pin,m0_out2_pin,m1_out1_pin = None ,m1_out2_pin = None )
**功能**: 设置电机驱动引脚，0号电机驱动在双电机时是左轮驱动，1号是右轮驱动；单电机时0号是电机驱动，1号无效
**参数** : 
(string) m0_out1_pin: 0号电机输出0，使用full_bridge驱动器为IN1，普通驱动器时为PWM
(string) m0_out2_pin: 0号电机输出1，使用full_bridge驱动器为IN2，普通驱动器时为DIR
(string) m1_out1_pin: 1号电机输出0，使用full_bridge驱动器为IN1，普通驱动器时为PWM
(string) m1_out2_pin: 1号电机输出1，使用full_bridge驱动器为IN2，普通驱动器时为DIR
**返回**：无  
 
#### set_velocity(data)
**功能**: 设置车速
**参数** : 
(int32)data： 车速，-1000~1000之间
**返回**：无  

#### set_motor_mode(mode):
**功能**: 设置电机控制方式
**参数** : (string)mode : 'simple':普通驱动器，‘full_bridge’:全桥驱动器  
**返回**：无  

#### set_motor_dir(dir0,dir1 = 0)
**功能**: 设置电机旋转方向
**参数** : 
(bool)dir0: 双电机时为左电机方向，单电机时为电机方向
(bool)dir1: 双电机时为右电机方向，单电机时无效  
**返回**：无  

#### set_servo_angle(angle)
**功能**: 设置舵机角度
**参数**: 
(float32)angle：角度，-45~45，大于0时右转  
**返回**：无  

#### set_servo_pin(pin)
**功能**: 设置舵机引脚
**参数**: 
(string)pin：舵机引脚  
**返回**：无  

#### get_ultra_cm()
**功能**: 读取超声波测距模块的数据
**参数**: 无
**返回**：(float32)distance: 距离，单位为cm

### 成员
无
