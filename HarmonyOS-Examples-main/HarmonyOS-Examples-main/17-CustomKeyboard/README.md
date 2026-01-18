##  场景介绍


车牌号编辑是便捷生活应用的高频使用场景之一，如用户在离开停车场进行缴费时，需要输入车牌号进行缴费。

本示例主要基于TextInput和Grid组件实现自定义键盘，用于编辑车牌号。

## 效果预览

![chepaikeyboard.gif](https://raw.gitcode.com/user-images/assets/7178552/3f4d2267-757a-4696-8b36-98d447e2d641/chepaikeyboard.gif 'chepaikeyboard.gif')

## 实现思路
创建一个keyboard类，其中包含键盘类型，键盘行列数，键盘内容等属性

在index中

通过TitleBuilder渲染标题栏

LicensePlateInputBuilder渲染输入栏与键盘

PaymentInfoBuilder渲染订单信息

FooterBuilder渲染确定按钮与支付成功弹窗

通过TextInput组件的customKeyboard属性实现键盘的自定义并隐藏TextInput组件。

自定义键盘的布局采用Grid组件实现并实现车牌号每个字符的独立输入框。

## 约束与限制

本示例支持API Version 16 Release及以上版本。

本示例支持HarmonyOS 5.0.4 Release SDK及以上版本。

本示例需要使用DevEco Studio 5.0.4 Release及以上版本进行编译运行。

## 项目结构

![image.png](https://raw.gitcode.com/user-images/assets/7178552/b7a0d6a0-9138-48e1-a64b-231f4c4557c9/image.png 'image.png')
