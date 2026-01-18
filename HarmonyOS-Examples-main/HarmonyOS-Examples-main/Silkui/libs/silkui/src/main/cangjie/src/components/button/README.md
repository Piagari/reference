# Button 按钮

### 介绍

按钮用于触发一个操作，如提交表单。

### 引入

```js
import silkui.component.button.{SilkButton, SilkButtonLoading, SilkButtonDisabled, SilkButtonAll}
```

## 代码演示

### 按钮类型

按钮支持 `default`、`primary`、`success`、`warning`、`danger` 五种类型，默认为 `default`。

```js
// 默认按钮
SilkButton(props: SilkButtonOptions(text: "默认按钮"))

// 主要按钮
SilkButton(props: SilkButtonOptions(text: "主要按钮", buttonType: SilkButtonType.PRIMARY))

// 成功按钮
SilkButton(props: SilkButtonOptions(text: "成功按钮", buttonType: SilkButtonType.SUCCESS))

// 警告按钮
SilkButton(props: SilkButtonOptions(text: "警告按钮", buttonType: SilkButtonType.WARNING))

// 危险按钮
SilkButton(props: SilkButtonOptions(text: "危险按钮", buttonType: SilkButtonType.DANGER))
```

### 朴素按钮

通过 `plain` 属性将按钮设置为朴素按钮，朴素按钮的文字为按钮颜色，背景为白色。

```js
SilkButton(props: SilkButtonOptions(text: "朴素按钮", plain: true))
SilkButton(props: SilkButtonOptions(text: "主要按钮", buttonType: SilkButtonType.PRIMARY, plain: true))
```

### 按钮尺寸

支持 `large`、`normal`、`small`、`mini` 四种尺寸，默认为 `normal`。

```js
SilkButton(props: SilkButtonOptions(text: "大号按钮", size: SilkButtonSize.LARGE))
SilkButton(props: SilkButtonOptions(text: "普通按钮", size: SilkButtonSize.NORMAL))
SilkButton(props: SilkButtonOptions(text: "小型按钮", size: SilkButtonSize.SMALL))
SilkButton(props: SilkButtonOptions(text: "迷你按钮", size: SilkButtonSize.MINI))
```

### 自定义颜色

通过 `color` 属性可以自定义按钮的颜色。

```js
SilkButton(props: SilkButtonOptions(text: "自定义颜色", color: Color(255, 0, 0, alpha: 1.0)))
```

### 加载状态

通过 `loading` 属性设置按钮为加载状态，加载状态下默认会禁用按钮。

```js
SilkButtonLoading(props: SilkButtonOptions(text: "加载中..."), loading: true)
```

### 禁用状态

通过 `disabled` 属性来禁用按钮，禁用状态下按钮不可点击。

```js
SilkButtonDisabled(props: SilkButtonOptions(text: "禁用状态"), disabled: true)
```

### 按钮形状

通过 `square` 设置方形按钮，通过 `round` 设置圆形按钮。

```js
SilkButton(props: SilkButtonOptions(text: "方形按钮", square: true))
SilkButton(props: SilkButtonOptions(text: "圆形按钮", round: true))
```

### 图标按钮

通过 `icon` 属性设置按钮图标，通过 `iconPosition` 属性设置图标位置。

```js
SilkButton(props: SilkButtonOptions(text: "图标按钮", icon: "plus"))
SilkButton(props: SilkButtonOptions(text: "图标按钮", icon: "plus", iconPosition: SilkButtonIconPosition.RIGHT))
```

## API

### Props

#### SilkButtonOptions

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| buttonType | 按钮类型，可选值为 `PRIMARY`、`SUCCESS`、`WARNING`、`DANGER`、`DEFAULT` | `SilkButtonType` | `DEFAULT` | `let` |
| size | 按钮尺寸，可选值为 `LARGE`、`NORMAL`、`SMALL`、`MINI` | `SilkButtonSize` | `NORMAL` | `let` |
| text | 按钮文字 | `ResourceStr` | - | `let` |
| textColor | 按钮文字颜色 | `ResourceColor` | - | `let` |
| color | 按钮背景颜色 | `ResourceColor` | - | `let` |
| linearGradient | 按钮渐变色配置 | `SilkUILinearGradientOptions` | - | `let` |
| icon | 按钮图标名称 | `ResourceStr` | - | `let` |
| iconPrefix | 图标字体库名称 | `ResourceStr` | `"silk-icon"` | `let` |
| iconPosition | 图标位置，可选值为 `LEFT`、`RIGHT` | `SilkButtonIconPosition` | `LEFT` | `let` |
| plain | 是否为朴素按钮 | `Bool` | `false` | `let` |
| square | 是否为方形按钮 | `Bool` | `false` | `let` |
| round | 是否为圆形按钮 | `Bool` | `false` | `let` |
| hairLine | 是否使用细边框 | `Bool` | `false` | `let` |
| width | 按钮宽度 | `Length` | - | `let` |
| height | 按钮高度 | `Length` | - | `let` |
| loadingText | 加载状态下的提示文字 | `ResourceStr` | - | `let` |
| loadingType | 加载图标类型 | `SilkLoadingType` | `CIRCULAR` | `let` |
| loadingSize | 加载图标大小 | `Length` | `20vp` | `let` |
| hasBorder | 是否有边框 | `Bool` | `true` | `let` |

#### SilkButtonLoading

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| props | 按钮配置选项 | `SilkButtonOptions` | - | `@Prop` |
| loading | 是否为加载状态 | `Bool` | `false` | `@Link` |
| click | 点击按钮时的回调函数 | `() -> Unit` | - | `var` |

#### SilkButtonDisabled

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| props | 按钮配置选项 | `SilkButtonOptions` | - | `@Prop` |
| disabled | 是否禁用按钮 | `Bool` | `false` | `@Prop` |
| click | 点击按钮时的回调函数 | `() -> Unit` | - | `var` |

#### SilkButtonAll

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| props | 按钮配置选项 | `SilkButtonOptions` | - | `@Prop` |
| loading | 是否为加载状态 | `Bool` | `false` | `@Link` |
| disabled | 是否禁用按钮 | `Bool` | `false` | `@Link` |
| click | 点击按钮时的回调函数 | `() -> Unit` | - | `var` |

### Slots

| 名称 | 说明 |
| --- | --- |
| Default | 自定义按钮内容 |
| Icon | 自定义图标内容 |
| Loading | 自定义加载状态内容（仅在 SilkButtonLoading 和 SilkButtonAll 中可用） |

### 类型定义

```js
enum SilkButtonType {
    | PRIMARY  // 主要按钮
    | SUCCESS  // 成功按钮
    | WARNING  // 警告按钮
    | DANGER   // 危险按钮
    | DEFAULT  // 默认按钮
}

enum SilkButtonSize {
    | LARGE   // 大型按钮
    | SMALL   // 小型按钮
    | MINI    // 迷你按钮
    | NORMAL  // 普通按钮
}

enum SilkButtonIconPosition {
    | LEFT   // 图标位于文字左侧
    | RIGHT  // 图标位于文字右侧
}
```

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 颜色变量

| 变量名                                  | 默认值                    | 说明       |
|--------------------------------------|------------------------|----------|
| `--silk-button-default-color`        | `--silk-text-color`    | 默认按钮文字颜色 |
| `--silk-button-default-background`   | `--silk-background-2`  | 默认按钮背景颜色 |
| `--silk-button-default-border-color` | `--silk-gray-4`        | 默认按钮边框颜色 |
| `--silk-button-primary-color`        | `--silk-white`         | 主要按钮文字颜色 |
| `--silk-button-primary-background`   | `--silk-primary-color` | 主要按钮背景颜色 |
| `--silk-button-primary-border-color` | `--silk-primary-color` | 主要按钮边框颜色 |
| `--silk-button-success-color`        | `--silk-white`         | 成功按钮文字颜色 |
| `--silk-button-success-background`   | `--silk-success-color` | 成功按钮背景颜色 |
| `--silk-button-success-border-color` | `--silk-success-color` | 成功按钮边框颜色 |
| `--silk-button-danger-color`         | `--silk-white`         | 危险按钮文字颜色 |
| `--silk-button-danger-background`    | `--silk-danger-color`  | 危险按钮背景颜色 |
| `--silk-button-danger-border-color`  | `--silk-danger-color`  | 危险按钮边框颜色 |
| `--silk-button-warning-color`        | `--silk-white`         | 警告按钮文字颜色 |
| `--silk-button-warning-background`   | `--silk-orange`        | 警告按钮背景颜色 |
| `--silk-button-warning-border-color` | `--silk-orange`        | 警告按钮边框颜色 |
| `--silk-button-plain-background`     | `--silk-transpanent`   | 朴素按钮背景颜色 |

#### 尺寸变量

| 变量名                                   | 默认值                   | 说明       |
|---------------------------------------|-----------------------|----------|
| `--silk-button-mini-height`           | `24vp`                | 迷你按钮高度   |
| `--silk-button-mini-padding-top`      | `0vp`                 | 迷你按钮上内边距 |
| `--silk-button-mini-padding-bottom`   | `0vp`                 | 迷你按钮下内边距 |
| `--silk-button-mini-padding-left`     | `--silk-padding-base` | 迷你按钮左内边距 |
| `--silk-button-mini-padding-right`    | `--silk-padding-base` | 迷你按钮右内边距 |
| `--silk-button-mini-font-size`        | `--silk-font-size-xs` | 迷你按钮字体大小 |
| `--silk-button-small-height`          | `32vp`                | 小型按钮高度   |
| `--silk-button-small-padding-top`     | `0vp`                 | 小型按钮上内边距 |
| `--silk-button-small-padding-bottom`  | `0vp`                 | 小型按钮下内边距 |
| `--silk-button-small-padding-left`    | `--silk-padding-xs`   | 小型按钮左内边距 |
| `--silk-button-small-padding-right`   | `--silk-padding-xs`   | 小型按钮右内边距 |
| `--silk-button-small-font-size`       | `--silk-font-size-sm` | 小型按钮字体大小 |
| `--silk-button-normal-font-size`      | `--silk-font-size-md` | 普通按钮字体大小 |
| `--silk-button-normal-padding-top`    | `0vp`                 | 普通按钮上内边距 |
| `--silk-button-normal-padding-bottom` | `0vp`                 | 普通按钮下内边距 |
| `--silk-button-normal-padding-left`   | `--silk-padding-md`   | 普通按钮左内边距 |
| `--silk-button-normal-padding-right`  | `--silk-padding-md`   | 普通按钮右内边距 |
| `--silk-button-large-height`          | `50vp`                | 大型按钮高度   |
| `--silk-button-default-height`        | `44vp`                | 默认按钮高度   |
| `--silk-button-default-font-size`     | `--silk-font-size-lg` | 默认按钮字体大小 |
| `--silk-button-border-width`          | `--silk-border-width` | 按钮边框宽度   |
| `--silk-button-radius`                | `--silk-radius-md`    | 按钮圆角     |
| `--silk-button-round-radius`          | `--silk-radius-max`   | 圆形按钮圆角   |
| `--silk-button-loading-icon-size`     | `20vp`                | 加载图标大小   |

#### 其他变量

| 变量名                                 | 默认值                       | 说明      |
|-------------------------------------|---------------------------|---------|
| `--silk-button-icon-size`           | `1.2`                     | 图标大小倍数  |
| `--silk-button-default-line-height` | `1.2`                     | 默认行高    |
| `--silk-button-disabled-opacity`    | `--silk-disabled-opacity` | 禁用状态透明度 |

### 定制示例

```js
// 修改按钮颜色
import silkui.constants.SilkButtonColorConstants
import silkui.constants.SilkButtonColorKey
import silkui.constants.updateButtonColorConstant

// 修改主要按钮背景色
updateButtonColorConstant(SilkButtonColorKey.BUTTON_PRIMARY_BACKGROUND, Color(114, 50, 221, alpha: 1.0))

// 修改按钮尺寸
import silkui.constants.SilkButtonSizeConstants
import silkui.constants.SilkButtonSizeKey
import silkui.constants.updateButtonSizeConstant

// 修改默认按钮高度
updateButtonSizeConstant(SilkButtonSizeKey.BUTTON_DEFAULT_HEIGHT, 48.vp)

// 重置按钮常量
import silkui.constants.resetButtonConstants

// 重置所有按钮常量
resetButtonConstants()
```
