# Toast 轻提示

### 介绍

轻提示组件用于在页面中间弹出提示，支持多种类型，包括文字提示、加载提示、成功/失败提示等。

### 引入

```js
import silkui.component.toast.{SilkToast, SilkToastOptions, SilkToastType}
```

## 代码演示

### 基础用法

通过 `SilkToast.toast` 方法可以显示文字提示。

```js
// 简单文字提示
SilkToast.toast("提示内容")
SilkToast.loading(@r(app.string.test_toast))
SilkToast.success("成功文案")
SilkToast.error("失败文案")
```

### 自定义图标

通过 `icon` 属性可以自定义图标。

```js
SilkToast.toast(SilkToastOptions(message: "自定义图标", icon: @r(app.media.like_o)))
SilkCell(
    props: SilkCellOptions(title: "自定义图片", isLink: true),
    click: { e => SilkToast.toast(SilkToastOptions(message: "自定义图标", icon: "https://fastly.jsdelivr.net/npm/@vant/assets/logo.png"))}
)
SilkToast.loading(SilkToastOptions(message: "加载中...", loadingType: SilkLoadingType.SPINNER))
```

### 自定义位置

通过 `showPosition` 属性可以自定义轻提示的显示位置。

```js
SilkToast.toast(SilkToastOptions(message: "自定义图标", showPosition: SilkToastPosition.TOP))

SilkToast.toast(SilkToastOptions(message: "自定义图标", showPosition: SilkToastPosition.BOTTOM))
```

### 加载提示

执行 Toast 方法时会返回对应的 Toast控制器 实例，通过调用实例上的 setMessage 方法可以实现动态更新提示的效果。

```js
let toast = SilkToast.loading(
    SilkToastOptions(
        duration: 0,
        forbidClick: true,
        message: "倒计时 3 秒"
    )
);

spawn {
    =>
    var second = 3;
    while (second > 0) {
        sleep(1 * Duration.second);
        second--;
        if (second > 0) {
            toast.setMessage?("倒计时 ${second.toString()} 秒")
        } else {
            SilkToast.closeToast()
        }
    }
}
```


### 组件式调用

除了函数式调用外，还可以使用组件式调用。

```js
@State
var show: Bool = false

SilkToastComponent(show: show, Content: CusContentImage,
style: SilkToastStyle(padding: SilkUIPaddingOptions(0.vp)), hasContent: true)

// 显示提示
show = true
```

## API

### 方法

#### SilkToast

| 方法名 | 说明 | 参数 | 返回值 |
| --- | --- | --- | --- |
| toast | 展示文字提示 | `message: ResourceStr` 或 `options: SilkToastOptions` | - |
| success | 展示成功提示 | `message: ResourceStr` 或 `options: SilkToastOptions` | - |
| error | 展示失败提示 | `message: ResourceStr` 或 `options: SilkToastOptions` | - |
| warn | 展示警告提示 | `message: ResourceStr` 或 `options: SilkToastOptions` | - |
| loading | 展示加载提示 | `message: ResourceStr` 或 `options: SilkToastOptions` | `SilkToastDynamicController` |
| closeToast | 关闭所有提示 | - | - |

### SilkToastComponent Props

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| show | 是否显示轻提示 | `Bool` | `false` | `@Link` |
| props | 轻提示配置选项 | `SilkToastOptions` | - | `var` |
| style | 自定义样式 | `SilkToastStyle` | - | `var` |

### SilkToastOptions

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| message | 提示文字内容 | `ResourceStr` | - | `var` |
| duration | 展示时长(毫秒)，值为 0 时，toast 不会自动消失 | `Int64` | `3000` | `var` |
| showIcon | 是否显示图标 | `Bool` | `true` | `var` |
| icon | 自定义图标 | `ResourceStr` | - | `var` |
| iconSize | 图标大小 | `Length` | `TOAST_ICON_SIZE` | `var` |
| loadingSize | 加载图标大小 | `Length` | `TOAST_ICON_SIZE` | `var` |
| overlay | 是否显示遮罩层 | `Bool` | `false` | `var` |
| loadingType | 加载图标类型 | `SilkLoadingType` | `CIRCULAR` | `var` |
| showPosition | 显示位置 | `SilkToastPositon` | `CENTER` | `var` |
| wordBreak | 文本换行方式 | `WordBreak` | `BreakAll` | `var` |
| forbidClick | 是否禁止背景点击 | `Bool` | `false` | `var` |
| toastTyoe | 提示类型 | `SilkToastType` | `TOAST` | `var` |
| closeOnClick | 是否在点击时关闭 | `Bool` | `true` | `var` |
| closeOnClickOverlay | 是否在点击遮罩层时关闭 | `Bool` | `false` | `var` |
| onClose | 关闭时的回调函数 | `() -> Unit` | - | `var` |
| onOpened | 打开时的回调函数 | `() -> Unit` | - | `var` |
| offset | 偏移量 | `Length` | `20.percent` | `var` |

### SilkToastStyle

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| padding | 内边距 | `SilkUIPaddingOptions` | - | `@Publish` |
| backgroundColor | 背景颜色 | `ResourceColor` | `TOAST_BACKGROUND` | `@Publish` |
| radius | 圆角大小 | `Int64` | `8` | `@Publish` |
| fillColor | 文字颜色 | `ResourceColor` | `TOAST_TEXT_COLOR` | `@Publish` |

### SilkToastDynamicController 方法

| 方法名 | 说明 | 参数 | 返回值 |
| --- | --- | --- | --- |
| close | 关闭当前提示 | - | - |
| setMessage | 修改提示文字 | `message: ResourceStr` | - |

### 类型定义

```js
enum SilkToastType {
    | WARN     // 警告提示
    | ERROR    // 错误提示
    | SUCCESS  // 成功提示
    | TOAST    // 普通文字提示
    | LOADING  // 加载提示
}

enum SilkToastPosition {
    | TOP     // 顶部显示
    | BOTTOM  // 底部显示
    | CENTER  // 中间显示
}

enum SilkLoadingType {
    | CIRCULAR  // 环形加载图标
    | SPINNER   // 菊花加载图标
}
```

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 尺寸变量

| 变量名                                     | 默认值                   | 说明          |
|-----------------------------------------|-----------------------|-------------|
| `--silk-toast-max-width`                | `70%`                 | 轻提示最大宽度     |
| `--silk-toast-min-width`                | `96vp`                | 轻提示最小宽度     |
| `--silk-toast-font-size`                | `--silk-font-size-md` | 轻提示文字大小     |
| `--silk-toast-line-height`              | `20vp`                | 轻提示文字行高     |
| `--silk-toast-radius`                   | `--silk-radius-lg`    | 轻提示圆角       |
| `--silk-toast-icon-size`                | `36vp`                | 轻提示图标大小     |
| `--silk-toast-text-min-width`           | `96vp`                | 纯文字轻提示最小宽度  |
| `--silk-toast-default-width`            | `88vp`                | 默认轻提示宽度     |
| `--silk-toast-default-min-height`       | `88vp`                | 默认轻提示最小高度   |
| `--silk-toast-position-top-distance`    | `20%`                 | 顶部轻提示距离顶部距离 |
| `--silk-toast-position-bottom-distance` | `20%`                 | 底部轻提示距离底部距离 |

#### 颜色变量

| 变量名                               | 默认值                  | 说明      |
|-----------------------------------|----------------------|---------|
| `--silk-toast-text-color`         | `--silk-white`       | 轻提示文字颜色 |
| `--silk-toast-loading-icon-color` | `--silk-white`       | 加载图标颜色  |
| `--silk-toast-background`         | `rgba(0, 0, 0, 0.7)` | 轻提示背景颜色 |

#### 内边距变量

| 变量名                            | 默认值                                                                       | 说明        |
|--------------------------------|---------------------------------------------------------------------------|-----------|
| `--silk-toast-text-padding`    | `--silk-padding-xs --silk-padding-sm --silk-padding-xs --silk-padding-sm` | 纯文字轻提示内边距 |
| `--silk-toast-default-padding` | `--silk-padding-md --silk-padding-md --silk-padding-md --silk-padding-md` | 带图标轻提示内边距 |

### 定制示例

```js
// 修改轻提示尺寸
import silkui.constants.SilkToastSizeConstants
import silkui.constants.SilkToastSizeKey
import silkui.constants.updateToastSizeConstant

// 修改轻提示图标大小
updateToastSizeConstant(SilkToastSizeKey.TOAST_ICON_SIZE, 40.vp)

// 修改轻提示颜色
import silkui.constants.SilkToastColorConstants
import silkui.constants.SilkToastColorKey
import silkui.constants.updateToastColorConstant

// 修改轻提示背景色
updateToastColorConstant(SilkToastColorKey.TOAST_BACKGROUND, Color(0, 0, 0, alpha: 0.8))

// 修改轻提示内边距
import silkui.constants.SilkToastPaddingConstants
import silkui.constants.SilkToastPaddingKey
import silkui.constants.updateToastPaddingConstant

// 修改纯文字轻提示内边距
updateToastPaddingConstant(
  SilkToastPaddingKey.TOAST_TEXT_PADDING,
  SilkUIPaddingOptions(
    top: 10.vp,
    right: 16.vp,
    bottom: 10.vp,
    left: 16.vp
  )
)

// 重置轻提示常量
import silkui.constants.resetToastConstants

// 重置所有轻提示常量
resetToastConstants()
```
