# Dialog 对话框

### 介绍

对话框用于展示重要信息或请求用户进行操作，支持多种样式和交互方式。

### 引入

```js
import silkui.component.dialog.{SilkDialog, ShowSilkDialog, ShowSilkConfirmDialog}
```

## 代码演示

### 函数式调用

通过 `ShowSilkDialog` 和 `ShowSilkConfirmDialog` 函数，可以快速创建对话框。

```js
// 显示对话框
ShowSilkDialog(props: SilkDialogOptions(
  title: "标题",
  message: "这是一段内容"
))
// 显示对话框（无标题）
ShowSilkDialog(SilkDialogOptions(
    message: "生命远不止连轴转和忙到极限，人类的体验远比这辽阔、丰富得多。"
))
// 显示确认对话框（带取消按钮）
ShowSilkConfirmDialog(props: SilkDialogOptions(
  title: "标题",
  message: "这是一段内容"
))
```

### 对话框类型

通过 `theme` 属性可以设置不同风格的对话框。

```js
// 圆角风格
ShowSilkDialog(SilkDialogOptions(
        title: "标题",
        message: "代码是写出来给人看的，附带能在机器上运行。",
        theme: SilkDialogTheme.ROUND_BUTTON,
        linearGradient: SilkUILinearGradientOptions(
            angle: 90.0,
            colors: [(Color(255, 96, 52, alpha: 1.0), 0.0), (Color(238, 10, 36, alpha: 1.0), 1.0)]
        )
    )
)

// 圆角按钮风格
ShowSilkDialog(SilkDialogOptions(
        message: "生命远不止连轴转和忙到极限，人类的体验远比这辽阔、丰富得多。",
        theme: SilkDialogTheme.ROUND_BUTTON,
        linearGradient: SilkUILinearGradientOptions(
            angle: 90.0,
            colors: [(Color(255, 96, 52, alpha: 1.0), 0.0), (Color(238, 10, 36, alpha: 1.0), 1.0)]
        )
    )
)
```

### 异步关闭

通过 `beforeClose` 属性可以在关闭前执行异步操作 函数类型 `(action: String) -> Future<Bool>`。

```js
ShowSilkConfirmDialog(SilkDialogOptions(
        title: "标题",
        message: "如果解决方法是丑陋的，那就肯定还有更好的解决方法，只是还没有发现而已。",
        beforeClose: { action =>
            spawn {
                =>
                sleep(3 * Duration.second);
                action == "confirm"
            }
        }
    )
)
```

### 自定义内容

通过插槽可以自定义对话框的内容。

```js
@State
var showDialog: Bool = false

@Builder
func F4Body () {
    Image("https://fastly.jsdelivr.net/npm/@vant/assets/apple-3.jpeg")
        .width(100.percent)
    .padding(left: 20.vp, right: 20.vp, top: 25.vp)
}

SilkDialog(
    show: showDialog,
    hasBody: true,
    Body: F4Body,
    props: SilkDialogOptions(
        title: "标题",
        showCancel: true
    )
)
```

## API

### SilkDialog Props

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| show | 是否显示对话框 | `Bool` | `false` | `@Link` |
| props | 对话框配置选项 | `SilkDialogOptions` | - | `var` |

### SilkDialogOptions

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| title | 对话框标题 | `ResourceStr` | - | `let` |
| titleSize | 标题字体大小 | `Length` | `DIALOG_FONT_SIZE` | `let` |
| titleColor | 标题字体颜色 | `ResourceColor` | `TEXT_COLOR` | `let` |
| message | 对话框内容 | `ResourceStr` | - | `let` |
| messageSize | 内容字体大小 | `Length` | `DIALOG_FONT_SIZE` | `let` |
| messageColor | 内容字体颜色 | `ResourceColor` | `DIALOG_HAS_TITLE_MESSAGE_TEXT_COLOR` | `let` |
| messageAlign | 内容对齐方式 | `TextAlign` | `Center` | `let` |
| messageLineHeight | 内容行高 | `Length` | `20.vp` | `let` |
| widthValue | 对话框宽度 | `Length` | `80.percent` | `let` |
| round | 对话框圆角大小 | `Length` | `DIALOG_RADIUS` | `let` |
| bgcColor | 对话框背景颜色 | `ResourceColor` | `DIALOG_BACKGROUND` | `let` |
| theme | 对话框风格 | `SilkDialogTheme` | `DEFAULT` | `let` |
| showConfirm | 是否显示确认按钮 | `Bool` | `true` | `let` |
| showCancel | 是否显示取消按钮 | `Bool` | `false` | `var` |
| confirmText | 确认按钮文字 | `ResourceStr` | `"确定"` | `let` |
| cancelText | 取消按钮文字 | `ResourceStr` | `"取消"` | `let` |
| confirmColor | 确认按钮文本颜色 | `ResourceColor` | - | `let` |
| confirmBgColor | 确认按钮背景色 | `ResourceColor` | - | `let` |
| cancelColor | 取消按钮文本颜色 | `ResourceColor` | - | `let` |
| cancelBgColor | 取消按钮背景色 | `ResourceColor` | - | `let` |
| buttonHeight | 按钮高度 | `Length` | 根据主题自动设置 | `let` |
| hasDivider | 是否有分割线 | `Bool` | `true` | `let` |
| autoCancel | 点击遮罩是否自动关闭 | `Bool` | `true` | `let` |
| beforeClose | 关闭前的回调函数 | `(action: String) -> Future<Bool>` | - | `let` |
| onConfirm | 点击确认按钮时的回调函数 | `() -> Unit` | - | `var` |
| onCancel | 点击取消按钮时的回调函数 | `() -> Unit` | - | `var` |

### SilkDialog Slots

| 名称 | 说明 |
| --- | --- |
| Header | 自定义标题内容 |
| Body | 自定义内容 |
| Footer | 自定义底部按钮区域 |

### 方法

#### ShowSilkDialog

显示对话框。

```js
ShowSilkDialog(props: SilkDialogOptions)
```

#### ShowSilkConfirmDialog

显示带取消按钮的确认对话框。

```js
ShowSilkConfirmDialog(props: SilkDialogOptions)
```

### 类型定义

```js
enum SilkDialogTheme {
    | ROUND_BUTTON  // 圆角按钮风格
    | DEFAULT       // 默认风格
    | CUSTOM        // 自定义风格
}

enum SilkDialogMessageAlign {
    | LEFT    // 左对齐
    | RIGHT   // 右对齐
    | CENTER  // 居中对齐
}
```

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 颜色变量

| 变量名                                          | 默认值                    | 说明           |
|----------------------------------------------|------------------------|--------------|
| `--silk-dialog-background`                   | `--silk-background-2`  | 对话框背景颜色      |
| `--silk-dialog-has-title-message-text-color` | `--silk-gray-7`        | 带标题对话框内容文字颜色 |
| `--silk-dialog-confirm-button-text-color`    | `--silk-primary-color` | 确认按钮文字颜色     |

#### 尺寸变量

| 变量名                                           | 默认值                     | 说明           |
|-----------------------------------------------|-------------------------|--------------|
| `--silk-dialog-width`                         | `320vp`                 | 对话框宽度        |
| `--silk-dialog-small-screen-width`            | `90%`                   | 小屏幕下对话框宽度    |
| `--silk-dialog-font-size`                     | `--silk-font-size-lg`   | 对话框字体大小      |
| `--silk-dialog-radius`                        | `16vp`                  | 对话框圆角        |
| `--silk-dialog-header-line-height`            | `24vp`                  | 对话框标题行高      |
| `--silk-dialog-header-padding-top`            | `26vp`                  | 对话框标题上内边距    |
| `--silk-dialog-message-padding`               | `--silk-padding-lg`     | 对话框内容内边距     |
| `--silk-dialog-message-font-size`             | `--silk-font-size-md`   | 对话框内容字体大小    |
| `--silk-dialog-message-line-height`           | `--silk-line-height-md` | 对话框内容行高      |
| `--silk-dialog-message-max-height`            | `60%`                   | 对话框内容最大高度    |
| `--silk-dialog-has-title-message-padding-top` | `--silk-padding-xs`     | 带标题对话框内容上内边距 |
| `--silk-dialog-button-height`                 | `48vp`                  | 对话框按钮高度      |
| `--silk-dialog-round-button-height`           | `36vp`                  | 圆角按钮高度       |
| `--silk-button-default-font-size`             | `--silk-font-size-lg`   | 按钮默认字体大小     |

#### 内边距变量

| 变量名                                     | 默认值                                       | 说明      |
|-----------------------------------------|-------------------------------------------|---------|
| `--silk-dialog-header-isolated-padding` | `--silk-padding-lg 0 --silk-padding-lg 0` | 独立标题内边距 |

#### 其他变量

| 变量名                        | 默认值                    | 说明      |
|----------------------------|------------------------|---------|
| `--silk-dialog-transition` | `--silk-duration-base` | 对话框动画时长 |

### 定制示例

```js
// 修改对话框颜色
import silkui

.
constants.SilkDialogColorConstants
import silkui

.
constants.SilkDialogColorKey
import silkui

.
constants.updateDialogColorConstant

// 修改对话框背景色
updateDialogColorConstant(SilkDialogColorKey.DIALOG_BACKGROUND, Color(245, 245, 245, alpha:
1.0
)
)

// 修改对话框尺寸
import silkui

.
constants.SilkDialogSizeConstants
import silkui

.
constants.SilkDialogSizeKey
import silkui

.
constants.updateDialogSizeConstant

// 修改对话框圆角
updateDialogSizeConstant(SilkDialogSizeKey.DIALOG_RADIUS, 20.
vp
)

// 修改对话框内边距
import silkui

.
constants.SilkDialogPaddingConstants
import silkui

.
constants.SilkDialogPaddingKey
import silkui

.
constants.updateDialogPaddingConstant

// 修改对话框标题内边距
updateDialogPaddingConstant(
    SilkDialogPaddingKey.DIALOG_HEADER_ISOLATED_PADDING,
    SilkUIPaddingOptions(
        top:
24.
vp,
right:
0.
vp,
bottom:
24.
vp,
left:
0.
vp
)
)

// 修改对话框字体权重
import silkui

.
constants.updateDialogHeaderFontWeight

// 修改对话框标题字体权重
updateDialogHeaderFontWeight(FontWeight.W700)

// 重置对话框常量
import silkui

.
constants.resetDialogConstants

// 重置所有对话框常量
resetDialogConstants()
```
