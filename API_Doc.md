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

### 使用例
```
ov5640.init()  
frame = ov5640.get_cam_frame()  
imshow(frame)  
frame.freebuffer()  
...
```

## Class video_proc_wrapper

### 方法
#### init()
**功能**: 初始化各处理模块，在Overlay初始化时调用，无需显式调用
**参数** : 无
**返回**：无

#### SobelX(frame)
**功能**: 对图片进行X方向的Sobel滤波
**参数** :   
frame：使用Xlnk分配的内存空间，或者从摄像头读取的三通道图片
**返回**：一张1280×720的**GBR**图像,numpy兼容，不再需要时需要手动调用freebuffer()方法释放。**注意**：输入的图像是四通道的，gray图像在第0通道

#### SobelY(frame)
**功能**: 对图片进行Y方向的Sobel滤波
**参数** :   
frame：使用Xlnk分配的内存空间，或者从摄像头读取的三通道图片  
**返回**：一张1280×720的**GBR**图像,numpy兼容，不再需要时需要手动调用freebuffer()方法释放。**注意**：输入的图像是四通道的，gray图像在第0通道

#### Canny(frame,low,high)
**功能**: 对输入图片进行Canny边缘检测
**参数** :   
frame: 使用Xlnk分配的内存空间，或者从摄像头读取的三通道图片  
low: canny 算子的低阈值  
high: canny 算子的高阈值  
**返回**：一张1280×720的**GBR**图像,numpy兼容，不再需要时需要手动调用freebuffer()方法释放。**注意**：输入的图像是四通道的，gray图像在第0通道 


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

### 使用例
```
video_proc.init()  
frame = ov5640.get_cam_frame()
res = video_proc.SobelX(frame)  
imshow(res)  
frame.freebuffer()
res.freebuffer()
...
```

## Class Car_Arduino

### 方法
#### reset()
**功能**: 复位microblaze
**参数** : 无
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
**返回**: (int32) 编码器读数，有符号

#### set_encoder_dir_pos()
**功能**: 设置编码器计数方向为正
**参数** : 无
**返回**：无  

#### set_encoder_dir_neg()
**功能**: 设置编码器计数方向为负
**参数** : 无
**返回**：无  

#### set_encoder_sample_interval_ms(data)
**功能**: 设置编码器采样时间间隔
**参数** : (uint32)data, 以毫秒计时间间隔
**返回**：无  

#### set_set_motor_freq(freq)
**功能**: 设置电机控制PWM波的频率
**参数** : (uint32)freq, 频率，必须小于100M
**返回**：无  

#### set_set_motor_PWM(data)
**功能**: 设置电机控制PWM波的占空比
**参数** : (int32)data, 占空比，-1000~1000之间
**返回**：无  

#### set_set_motor_dir_pos()
**功能**: 设置电机旋转方向为正方向
**参数** : 无  
**返回**：无  

#### set_set_motor_dir_neg(）
**功能**: 设置电机旋转方向为反方向
**参数** : 无  
**返回**：无  

#### set_set_motor_dir_neg(data)
**功能**: 设置舵机控制PWM波占空比（频率为200Hz）
**参数** : （uint32)data, 占空比值，300为中值  
**返回**：无  

### 成员
无

### 使用例
```
Arduino.set_set_motor_PWM(800)
Arduino.set_set_motor_PWM(-200)
ax,ay,az = Arduino.get_accel()
gx,gy,gz = Arduino.get_gyro()
...
```