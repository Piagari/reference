# 基于Http的新闻应用

## 简介

本应用为仓颉编程语言进阶应用，适用于希望深入学习仓颉编程语言开发技术、使用仓颉编程语言开发HarmonyOS应用的读者。

## 内容

本应用为使用仓颉语言开发的基于Http新闻应用，分服务器端和客户端两部分，帮助读者深入理解和实践仓颉数据库与网络编程开发技术，构建开发Http新闻数据服务器；熟悉仓颉鸿蒙UI框架与网络请求框架，开发实现Http新闻客户端App。

## 开发环境

基于Http的新闻应用开发环境拓扑如下图所示，其中：

- 新闻服务器与新闻客户端开发设备可共用一台笔记本或台式机；

- 客户端应用调试设备可采用HarmonyOS智能终端或模拟器。

  ​                                    <img src="https://raw.gitcode.com/szLilyWu/HttpNewsServer-Cangjie/attachment/uploads/9a12f71d-dc41-49d3-b7a3-a9a89f3912a3/%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83%E6%8B%93%E6%89%91.png" alt="img" style="zoom:80%;" /> 

### 硬件环境要求

为了保证实验的顺利进行，建议每套实验硬件环境用如下表配置：

​                                      <img src="https://raw.gitcode.com/szLilyWu/HttpNewsServer-Cangjie/attachment/uploads/be0852c8-0079-4d98-9688-530f9e96304c/%E7%A1%AC%E4%BB%B6%E7%8E%AF%E5%A2%83.png" alt="img" style="zoom: 60%;" /> 

### 软件环境要求

- #### 服务器端开发工具：

1. IDE：Visual Studio Code 1.95及以上
2. SDK：Cangjie-0.53.*-windows_x64及以上
3. Plugin：Cangjie-vscode-0.53.*及以上
4. DB：MySQL8.0 + Navicat Premium + Nginx 1.15

- #### App客户端开发工具：

1. IDE：DevEco Studio 5.0及以上
2. Plugin：DevEco Studio-Cangjie Plugin 5.0及以上
3. 鸿蒙开发包SDK：HarmonyOS 5.0及以上
4. 应用调试设备：HarmonyOS 5.0及以上Emulator或华为Meta60以上真机

- #### 开发者许可：华为开发者账号

#### **注意：**

- 读者须自行配置新闻数据服务器及图片下载服务器
- 本应用案例使用小皮集成环境（MySQL8.0 + Nginx1.15）
- 数据库开发使用第三方驱动mysqlclient-ffi，具体使用方法请参考https://gitcode.com/Cangjie-TPC/mysqlclient-ffi

## 参考文档

- 仓颉编程语言官网：[https://cangjie-lang.cn](https://cangjie-lang.cn/)
- 仓颉鸿蒙开发官网：https://developer.huawei.com/consumer/cn/cangjie
- 仓颉开发者社区：https://gitcode.com/Cangjie

## 运行效果

### 服务器端： 

<img src="https://raw.gitcode.com/szLilyWu/HttpNewsServer-Cangjie/attachment/uploads/3ed4ca11-ca5b-4fd6-9c21-ed027d6a55d6/Server1-demo1.png" alt="img" style="zoom: 60%;" />

 

<img src="https://raw.gitcode.com/szLilyWu/HttpNewsServer-Cangjie/attachment/uploads/e9a56181-282b-45b7-ac33-228f2262ac05/Server1-demo2.png" alt="img" style="zoom:60%;" />

 

<img src="https://raw.gitcode.com/szLilyWu/HttpNewsServer-Cangjie/attachment/uploads/5fbc2738-45e5-4533-8418-578d93d18ea1/Server1-demo3.png" alt="img" style="zoom:64%;" />

### App客户端： 

<img src="https://raw.gitcode.com/szLilyWu/HttpNewsServer-Cangjie/attachment/uploads/8e264ab9-7a8e-4b3f-84c7-7abb38c2edd6/Client-demo1.png" alt="img" style="zoom:60%;" />

 

<img src="https://raw.gitcode.com/szLilyWu/HttpNewsServer-Cangjie/attachment/uploads/e10c89c9-3570-49b3-8b48-6ad7a3a1922f/Client-demo2.png" alt="img" style="zoom:65%;" />

<img src="https://raw.gitcode.com/szLilyWu/HttpNewsServer-Cangjie/attachment/uploads/7b673aea-5aaa-4ff7-aaf3-113278232cdb/Client-demo3.png" alt="img" style="zoom:67%;" />

 

