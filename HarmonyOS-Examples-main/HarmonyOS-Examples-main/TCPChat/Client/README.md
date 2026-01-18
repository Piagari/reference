# TCPChat

### 作者：清明雨揽月

## 介绍
#### 本项目为C/S模型，在该项目中展示的是使用仓颉编程语言编写的Client端，接下来将逐一介绍Client端和Server端

## 项目运行效果
![img.png](screenshots%2Fimg.png)
### Client端
![img_1.png](screenshots%2Fimg_1.png)
#### Client端使用仓颉SDK，共一个页面，为index.cj。在entry/src/main/cangjie/src中，有两个文件夹，分别为models文件夹和utils文件夹

### models文件夹

#### 存放聊天结构类

##### name：名称，msg：消息内容，sendOrReceive：消息方还是发送方

### utils文件夹

#### 存放统一日志类HiLog和Tcp通信类Socket4CJ

### Server端
![img_2.png](screenshots%2Fimg_2.png)
#### Server端地址为上一级文件夹的Sever目录

##### Sever端主要为接收客户端（Client）消息、给客户端发送消息等