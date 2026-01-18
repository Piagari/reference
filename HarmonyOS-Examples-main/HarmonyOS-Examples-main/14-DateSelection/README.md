# **选择日期范围**

## 介绍

选择日期范围是旅游园区类应用中高频使用场景之一，如用户在预订酒店时需要选择住宿日期。

本示例使用层叠布局、Grid组件、Router组件实现页面跳转以及选择日期范围后的颜色变化效果。

## 效果预览

|  |  |  |
| ------------------------ | ------------------------ | ------------------------ |
|![image.png](https://raw.gitcode.com/user-images/assets/7178552/724a4801-4e85-4896-9572-a3b6e97ef05a/image.png 'image.png') |![image.png](https://raw.gitcode.com/user-images/assets/7178552/761592fe-2180-43c8-b0b3-76766981ca3c/image.png 'image.png') | ![image.png](https://raw.gitcode.com/user-images/assets/7178552/414cea8f-3460-4fbc-85cd-809c0e2dea54/image.png 'image.png')
 |

## 约束与限制

本示例支持 API Version 16 Release 及以上版本。

本示例支持 Harmony 5.0.4 Release SDK 及以上版本。

本示例需要使用 DevEco Studio 5.0.4 Release 及以上版本进行编译运行。

## 使用说明

点击入住日期会跳转到日期选择页面，选择日期范围后，点击确认按钮回到首页。

## 实现思路

通过Grid组件实现日历的日期排列，调用if-else逻辑语句比较所选日期的早晚，确定日期范围。

通过Stack布局，为选中的GridItem添加颜色叠加效果。

添加Tabs组件实现底部菜单，方便后续功能的扩展

对原有代码结构进行重构，创建MyDate，MyMonth类对日期进行统一管理，但仍待优化

并添加限制条件无法在当前时间之前无法预定

