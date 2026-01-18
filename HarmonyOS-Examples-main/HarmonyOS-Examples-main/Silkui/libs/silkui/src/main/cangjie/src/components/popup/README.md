# Popup 弹出层

### 介绍

弹出层组件用于在页面中弹出一个浮层，可以包含各种内容，如消息提示、选择器等。

### 引入

```js
import silkui.components.popup.{SilkPopup, SilkPopupOptions, SilkPopupPosition, SilkPopupClosePosition}
```

## 代码演示

### 基础用法

通过 `show` 属性控制弹出层是否显示，通过 `Children` 构建器设置弹出层内容。

```js
@State
var showPopup: Bool = false

@Builder
func PopupContent() {
  Column(){
    Text("内容")
    .fontSize(16)
    .fontColor(@r(app.color.text_color))
  }
  .padding(64)
}

SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(),
  Children: PopupContent
)

// 在需要显示弹出层的地方
Button("显示弹出层").onClick({ _ => showPopup = true })
```

### 弹出位置

通过 `position` 属性设置弹出位置，支持 `top`、`bottom`、`left`、`right` 和 `center` 五个方向。

```js
@Builder
func TopPopupContent() {
  Column(){
    // 内容
  }
  .width(100.percent)
  .height(30.percent)
}

@Builder
func BottomPopupContent() {
  Column(){
    // 内容
  }
  .width(100.percent)
  .height(30.percent)
}

@Builder
func LeftPopupContent() {
  Column(){
    // 内容
  }
  .width(100.percent)
  .height(100.percent)
}

@Builder
func RightPopupContent() {
  Column(){
    // 内容
  }
  .width(100.percent)
  .height(100.percent)
}

// 顶部弹出
SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(
    position: SilkPopupPosition.TOP
  ),
  Children: TopPopupContent
)

// 底部弹出
SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(
    position: SilkPopupPosition.BOTTOM
  ),
  Children: BottomPopupContent
)

// 左侧弹出
SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(
    position: SilkPopupPosition.LEFT
  ),
  Children: LeftPopupContent
)

// 右侧弹出
SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(
    position: SilkPopupPosition.RIGHT
  ),
  Children: RightPopupContent
)
```

### 关闭图标

通过 `showClose` 属性设置是否显示关闭图标，通过 `closeIcon` 属性自定义图标，通过 `closePosition` 属性设置图标位置。

```js
@Builder
func CloseIconPopupContent() {
  Column(){
    // 内容
  }
  .width(100.percent)
  .height(30.percent)
}

@Builder
func CustomIconPopupContent() {
  Column(){
    // 内容
  }
  .width(100.percent)
  .height(30.percent)
}

@Builder
func IconPositionPopupContent() {
  Column(){
    // 内容
  }
  .width(100.percent)
  .height(30.percent)
}

// 显示关闭图标
SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(
    position: SilkPopupPosition.BOTTOM,
    showClose: true
  ),
  Children: CloseIconPopupContent
)

// 自定义图标
SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(
    position: SilkPopupPosition.BOTTOM,
    showClose: true,
    closeIcon: @r(app.media.close)
  ),
  Children: CustomIconPopupContent
)

// 图标位置
SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(
    position: SilkPopupPosition.BOTTOM,
    showClose: true,
    closePosition: SilkPopupClosePosition.TOP_LEFT
  ),
  Children: IconPositionPopupContent
)
```

### 圆角弹窗

通过 `round` 属性设置是否显示圆角，通过 `roundValue` 属性设置圆角大小。

```js
@Builder
func CenterRoundPopupContent() {
  Column(){
    Text("内容")
    .fontSize(16)
    .fontColor(@r(app.color.text_color))
  }
  .padding(64)
}

@Builder
func BottomRoundPopupContent() {
  Column(){
    // 内容
  }
  .width(100.percent)
  .height(30.percent)
}

// 居中圆角弹窗
SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(
    round: true,
    roundValue: 16.vp
  ),
  Children: CenterRoundPopupContent
)

// 底部圆角弹窗
SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(
    position: SilkPopupPosition.BOTTOM,
    round: true,
    roundValue: 16.vp
  ),
  Children: BottomRoundPopupContent
)
```

### 事件监听

弹出层提供了多种事件监听方法，包括点击事件和生命周期事件。

```js
@Builder
func EventPopupContent() {
  Column(){
    Text("内容")
    .fontSize(16)
    .fontColor(@r(app.color.text_color))
  }
  .padding(64)
}

SilkPopup(
  show: showPopup,
  props: SilkPopupOptions(
    showClose: true,
    round: true
  ),
  Children: EventPopupContent,
  // 点击遮罩层
  clickOverlay: { => PromptAction.showToast(message: "点击遮罩层") },
  // 点击关闭图标
  clickClose: { => PromptAction.showToast(message: "点击关闭图标") },
  // 弹出层打开时触发
  open: { => PromptAction.showToast(message: "open") },
  // 弹出层打开动画结束后触发
  opened: { => PromptAction.showToast(message: "opened") },
  // 弹出层关闭时触发
  close: { => PromptAction.showToast(message: "close") },
  // 弹出层关闭动画结束后触发
  closed: { => PromptAction.showToast(message: "closed") }
)
```

## API

### Props

#### SilkPopup

| 参数       | 说明       | 类型               | 默认值   | 装饰器           |
|----------|----------|------------------|-------|---------------|
| show     | 是否显示弹出层  | Bool             | false | @Link         |
| props    | 弹出层配置选项  | SilkPopupOptions | -     | @Prop         |
| Children | 自定义内容构建器 | () -> Unit       | -     | @BuilderParam |

#### SilkPopupOptions

| 参数                  | 说明           | 类型                     | 默认值                 | 反应性  |
|---------------------|--------------|------------------------|---------------------|------|
| showOverlay         | 是否显示遮罩层      | Bool                   | true                | 非响应式 |
| position            | 弹出位置         | SilkPopupPosition      | CENTER              | 非响应式 |
| overlayColor        | 遮罩层颜色        | ResourceColor          | OVERALAY_BACKGROUND | 非响应式 |
| duration            | 动画持续时间（毫秒）   | Float64                | 300                 | 非响应式 |
| round               | 是否使用圆角       | Bool                   | false               | 非响应式 |
| roundValue          | 圆角大小         | ?Length                | POPUP_ROUND_RADIUS  | 非响应式 |
| closeOnPopState     | 页面切换时是否关闭弹窗  | Bool                   | true                | 非响应式 |
| closeOnClickOverlay | 点击遮罩层时是否关闭弹窗 | Bool                   | true                | 非响应式 |
| showClose           | 是否显示关闭图标     | Bool                   | false               | 非响应式 |
| closeIcon           | 关闭图标         | ResourceStr            | "cross"             | 非响应式 |
| closePosition       | 关闭图标位置       | SilkPopupClosePosition | TOP_RIGHT           | 非响应式 |
| widthValue          | 弹出层宽度        | Length                 | 70.percent          | 非响应式 |
| closeHandler        | 关闭回调函数       | Option<() -> Unit>     | None                | 非响应式 |
| safeTop             | 是否开启顶部安全区适配  | Bool                   | false               | 非响应式 |
| safeBottom          | 是否开启底部安全区适配  | Bool                   | false               | 非响应式 |

### Events

| 事件名          | 说明                           | 回调参数               |
|--------------|------------------------------|--------------------|
| click        | 点击弹出层时触发                     | -                  |
| clickOverlay | 点击遮罩层时触发                     | -                  |
| clickClose   | 点击关闭图标时触发                    | -                  |
| open         | 打开弹出层时触发                     | -                  |
| opened       | 打开弹出层动画结束后触发                 | -                  |
| close        | 关闭弹出层时触发                     | -                  |
| closed       | 关闭弹出层动画结束后触发                 | -                  |
| beforeClose  | 关闭弹出层前的回调函数，返回 `true` 表示允许关闭 | () -> Future<Bool> |

### SilkPopupPosition

| 名称     | 说明   |
|--------|------|
| TOP    | 顶部弹出 |
| BOTTOM | 底部弹出 |
| LEFT   | 左侧弹出 |
| RIGHT  | 右侧弹出 |
| CENTER | 中间弹出 |

### SilkPopupClosePosition

| 名称           | 说明  |
|--------------|-----|
| TOP_LEFT     | 左上角 |
| TOP_RIGHT    | 右上角 |
| BOTTOM_LEFT  | 左下角 |
| BOTTOM_RIGHT | 右下角 |

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../theme)。

| 名称                              | 默认值                 | 说明      |
|---------------------------------|---------------------|---------|
| --silk-popup-round-radius       | 16vp                | 弹出层圆角半径 |
| --silk-popup-close-icon-size    | 22vp                | 关闭图标大小  |
| --silk-popup-close-icon-margin  | 16vp                | 关闭图标边距  |
| --silk-popup-background         | BACKGROUND_2        | 弹出层背景色  |
| --silk-popup-close-icon-color   | GRAY_5              | 关闭图标颜色  |
| --silk-popup-overlay-background | OVERALAY_BACKGROUND | 遮罩层背景色  |
| --silk-popup-transition         | DURATION_BASE       | 动画时长    |
| --silk-popup-close-icon-z-index | 1                   | 关闭图标层级  |
