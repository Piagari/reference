# Collapse 折叠面板

### 介绍

折叠面板用于将内容区域折叠/展开，节省页面空间，常用于分组显示复杂内容。

### 引入

```js
import silkui.component.collapse.{SilkCollapse, SilkCollapseItem, SilkCollapseItemCustomTitle}
```

## 代码演示

### 基础用法

通过 `SilkCollapseItem` 组件构建折叠面板，`active` 属性控制面板是否默认展开。

```js
@Builder
func C1_Children1 () {
    Text("代码是写出来给人看的，附带能在机器上运行附带能在机器上运行。")
        .width(100.percent)
    .padding(top: 12,bottom: 12)
    .fontSize(14)
        .fontColor(@r(app.color.silkdoctextcolor4))
    .textAlign(TextAlign.Start)
}
@Builder
func C1_Children2 () {
    Text("技术无非就是那些开发它的人的共同灵魂。")
        .width(100.percent)
    .padding(top: 12,bottom: 12)
    .fontSize(14)
        .fontColor(@r(app.color.silkdoctextcolor4))
    .textAlign(TextAlign.Start)
}
@Builder
func C1_Children3 () {
    Text("在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准。")
        .width(100.percent)
    .padding(top: 12,bottom: 12)
    .fontSize(14)
        .fontColor(@r(app.color.silkdoctextcolor4))
    .textAlign(TextAlign.Start)
}
@Builder
func Children1 () {
    Column(){
        SilkCollapseItem(active: true, props: SilkCollapseOptions(title: "标题1"), Content: C1_Children1)
        SilkCollapseItem(active: false, props: SilkCollapseOptions(title: "标题2"), Content: C1_Children2)
        SilkCollapseItem(active: false, props: SilkCollapseOptions(title: "标题3"), Content: C1_Children3)
    }
}
...
SilkCollapse(accordion: false, Childrens: Children1)
```

### 手风琴模式

通过 `accordion` 属性可以设置为手风琴模式，最多展开一个面板。

```js
@Builder
func C1_Children1 () {
    Text("代码是写出来给人看的，附带能在机器上运行附带能在机器上运行。")
        .width(100.percent)
    .padding(top: 12,bottom: 12)
    .fontSize(14)
        .fontColor(@r(app.color.silkdoctextcolor4))
    .textAlign(TextAlign.Start)
}
@Builder
func C1_Children2 () {
    Text("技术无非就是那些开发它的人的共同灵魂。")
        .width(100.percent)
    .padding(top: 12,bottom: 12)
    .fontSize(14)
        .fontColor(@r(app.color.silkdoctextcolor4))
    .textAlign(TextAlign.Start)
}
@Builder
func C1_Children3 () {
    Text("在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准。")
        .width(100.percent)
    .padding(top: 12,bottom: 12)
    .fontSize(14)
        .fontColor(@r(app.color.silkdoctextcolor4))
    .textAlign(TextAlign.Start)
}
@Builder
func Children1 () {
    Column(){
        SilkCollapseItem(active: true, props: SilkCollapseOptions(title: "标题1"), Content: C1_Children1)
        SilkCollapseItem(active: false, props: SilkCollapseOptions(title: "标题2"), Content: C1_Children2)
        SilkCollapseItem(active: false, props: SilkCollapseOptions(title: "标题3"), Content: C1_Children3)
    }
}
...
SilkCollapse(accordion: true, Childrens: Children1)
```

### 禁用状态

通过 `disabled` 属性可以禁用折叠面板项。

```js
@Builder
func Children2 () {
    Column(){
        SilkCollapseItem(active: true, props: SilkCollapseOptions(title: "标题1"), Content: C1_Children1)
        SilkCollapseItem(active: false, props: SilkCollapseOptions(title: "标题2", disabled: true), Content: C1_Children2)
        SilkCollapseItem(active: false, props: SilkCollapseOptions(title: "标题3", disabled: true), Content: C1_Children3)
    }
}
...
SilkCollapse(accordion: true, Childrens: Children2)
```

### 自定义标题

可以使用 `SilkCollapseItemCustomTitle` 自定义标题内容。

```js
@Builder
func CollapseTitle1 () {
    Text() {
        Span("标题1")
        ImageSpan(@r(app.media.ic_public_warn))
        .width(12)
            .aspectRatio(1)
    }
}
@Builder
func CollapseCon () {
    Text('在代码阅读过程中人们说脏话的频率是衡量代码质量的唯一标准')
        .width(100.percent)
    .padding(top: 12, bottom: 12)
    .fontSize(14)
        .fontColor(@r(app.color.silkdoctextcolor4))
    .textAlign(TextAlign.Start)
}
@Builder
func Children3 () {
    Column(){
        SilkCollapseItemCustomTitle(active: true, props: SilkCollapseOptions(), Content: CollapseCon, Title: CollapseTitle1)
    }
}
...
SilkCollapse(accordion: true, Childrens: Children3)
```

### 全部展开/收起

使用 `SilkCollapseAll` 和 `SilkCollapseToggleController` 可以实现全部展开/收起功能。

```js
let toggleController = SilkCollapseToggleController()

SilkCollapseAll(silkCollapseToggleController: silkCollapseToggleController, Childrens: Children1)

// 全部展开
toggleController.toggleAll(flag: true)

// 全部收起
toggleController.toggleAll(flag: false)
```

## API

### SilkCollapse Props

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| accordion | 是否开启手风琴模式 | `Bool` | `false` | `@Prop` |

### SilkCollapseAll Props

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| silkCollapseToggleController | 折叠面板切换控制器 | `SilkCollapseToggleController` | - | `@Prop` |

### SilkCollapseItem Props

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| props | 折叠面板项配置选项 | `SilkCollapseOptions` | - | `@Prop` |
| active | 是否默认展开 | `Bool` | `false` | `@Prop` |

### SilkCollapseItemCustomTitle Props

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| props | 折叠面板项配置选项 | `SilkCollapseOptions` | - | `@Prop` |
| active | 是否默认展开 | `Bool` | `false` | `@Prop` |

### SilkCollapseOptions

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| icon | 右侧箭头图标名称 | `ResourceStr` | `"arrow"` | `@Publish` |
| title | 面板标题 | `ResourceStr` | `"标题"` | `@Publish` |
| value | 面板右侧内容 | `ResourceStr` | - | `@Publish` |
| showIcon | 是否显示右侧箭头图标 | `Bool` | `true` | `@Publish` |
| disabled | 是否禁用面板 | `Bool` | `false` | `@Publish` |
| isReadonly | 是否为只读状态 | `Bool` | `false` | `@Publish` |
| border | 是否显示内边框 | `Bool` | `false` | `@Publish` |
| paddingValue | 内边距配置 | `SilkUIPaddingOptions` | - | `@Publish` |

### SilkCollapse Slots

| 名称 | 说明 |
| --- | --- |
| Childrens | 折叠面板内容，通常是多个 SilkCollapseItem |

### SilkCollapseAll Slots

| 名称 | 说明 |
| --- | --- |
| Childrens | 折叠面板内容，通常是多个 SilkCollapseItem |

### SilkCollapseItem Slots

| 名称 | 说明 |
| --- | --- |
| Content | 折叠面板项内容 |

### SilkCollapseItemCustomTitle Slots

| 名称 | 说明 |
| --- | --- |
| Title | 自定义标题内容 |
| Content | 折叠面板项内容 |

### SilkCollapseToggleController 方法

| 方法名 | 说明 | 参数 | 返回值 |
| --- | --- | --- | --- |
| toggleAll | 切换所有面板的展开/折叠状态 | `flag: Bool` - true 表示全部展开，false 表示全部折叠 | - |

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 颜色变量

| 变量名                                         | 默认值                   | 说明         |
|---------------------------------------------|-----------------------|------------|
| `--silk-collapse-item-content-text-color`   | `--silk-text-color-2` | 折叠面板内容文字颜色 |
| `--silk-collapse-item-content-background`   | `--silk-background-2` | 折叠面板内容背景颜色 |
| `--silk-collapse-item-title-disabled-color` | `--silk-text-color-3` | 禁用状态下标题颜色  |

#### 尺寸变量

| 变量名                                      | 默认值                   | 说明         |
|------------------------------------------|-----------------------|------------|
| `--silk-collapse-item-content-font-size` | `--silk-font-size-md` | 折叠面板内容字体大小 |

#### 内边距变量

| 变量名                                    | 默认值                                                                       | 说明        |
|----------------------------------------|---------------------------------------------------------------------------|-----------|
| `--silk-collapse-item-content-padding` | `--silk-padding-sm --silk-padding-md --silk-padding-sm --silk-padding-md` | 折叠面板内容内边距 |

#### 其他变量

| 变量名                                        | 默认值   | 说明       |
|--------------------------------------------|-------|----------|
| `--silk-collapse-item-duration`            | `0.3` | 折叠动画时长   |
| `--silk-collapse-item-content-line-height` | `1.5` | 折叠面板内容行高 |

### 定制示例

```js
// 修改折叠面板颜色
import silkui

.
constants.SilkCollapseColorConstants
import silkui

.
constants.SilkCollapseColorKey
import silkui

.
constants.updateCollapseColorConstant

// 修改折叠面板内容背景色
updateCollapseColorConstant(SilkCollapseColorKey.COLLAPSE_ITEM_CONTENT_BACKGROUND, Color(245, 245, 245, alpha:
1.0
)
)

// 修改折叠面板尺寸
import silkui

.
constants.SilkCollapseSizeConstants
import silkui

.
constants.SilkCollapseSizeKey
import silkui

.
constants.updateCollapseSizeConstant

// 修改折叠面板内容字体大小
updateCollapseSizeConstant(SilkCollapseSizeKey.COLLAPSE_ITEM_CONTENT_FONT_SIZE, 16.
vp
)

// 修改折叠面板内边距
import silkui

.
constants.SilkCollapsePaddingConstants
import silkui

.
constants.SilkCollapsePaddingKey
import silkui

.
constants.updateCollapsePaddingConstant

// 修改折叠面板内容内边距
updateCollapsePaddingConstant(
    SilkCollapsePaddingKey.COLLAPSE_ITEM_CONTENT_PADDING,
    SilkUIPaddingOptions(
        top:
16.
vp,
right:
16.
vp,
bottom:
16.
vp,
left:
16.
vp
)
)

// 修改折叠面板动画时长
import silkui

.
constants.SilkCollapseAnimationConstants
import silkui

.
constants.SilkCollapseAnimationKey
import silkui

.
constants.updateCollapseAnimationConstant

// 修改折叠面板动画时长
updateCollapseAnimationConstant(SilkCollapseAnimationKey.COLLAPSE_ITEM_DURATION, 0.5)

// 修改折叠面板样式
import silkui

.
constants.SilkCollapseStyleConstants
import silkui

.
constants.SilkCollapseStyleKey
import silkui

.
constants.updateCollapseStyleConstant

// 修改折叠面板内容行高
updateCollapseStyleConstant(SilkCollapseStyleKey.COLLAPSE_ITEM_CONTENT_LINE_HEIGHT, 1.8)

// 重置折叠面板常量
import silkui

.
constants.resetCollapseConstants

// 重置所有折叠面板常量
resetCollapseConstants()
```
