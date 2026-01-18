# Loading 加载

### 介绍

加载组件用于展示加载状态，提示用户等待，支持多种样式。

### 引入

```js
import silkui.component.loading.{SilkLoading, SilkLoadingType}
```

## 代码演示

### 基础用法

```js
SilkLoading()
SilkLoading(loadingType: SilkLoadingType.SPINNER)
```

### 自定义颜色

通过 `color` 属性可以自定义加载图标的颜色。

```js
SilkLoading(color: @r(app.color.primary_color))
SilkLoading(loadingType: SilkLoadingType.SPINNER, color: @r(app.color.primary_color))
```

### 自定义大小

通过 `size` 属性可以自定义加载图标的大小。

```js
SilkLoading(size: 24.vp)
SilkLoading(loadingType: SilkLoadingType.SPINNER, size: 24.vp)
```

### 加载文案

通过 `text` 属性可以设置加载文案。

```js
SilkLoading(size: 24.vp, text: "加载中...")
```

### 垂直排列

通过 `vertical` 属性可以设置图标和文字垂直排列。

```js
SilkLoading(size: 24.vp, text: "加载中...", vertical: true)
```

### 自定义文字样式

通过 `textSize` 和 `textColor` 属性可以自定义文字的大小和颜色。

```js
SilkLoading(color: @r(app.color.base_color), text: "加载中...", vertical: true)
SilkLoading(text: "加载中...", vertical: true, textColor: @r(app.color.base_color))
```

### 自定义图标

通过 `icon` 属性可以使用自定义图标替代默认的加载图标。

```js
SilkLoading(size: 24.vp, text: "加载中...", vertical: true, icon: @r(app.media.star_o))
```

## API

### Props

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| loadingType | 加载图标类型 | `SilkLoadingType` | `CIRCULAR` | `var` |
| color | 加载图标颜色 | `ResourceColor` | `--silk-loading-spinner-color` | `var` |
| icon | 自定义图标 | `ResourceStr` | - | `var` |
| size | 加载图标大小 | `Length` | `--silk-loading-spinner-size` | `var` |
| text | 加载文案 | `ResourceStr` | - | `var` |
| textSize | 文字大小 | `Length` | `--silk-loading-text-font-size` | `var` |
| textColor | 文字颜色 | `ResourceColor` | `--silk-loading-text-color` | `var` |
| vertical | 是否垂直排列图标和文字 | `Bool` | `false` | `var` |

### SilkLoadingType

```js
enum SilkLoadingType {
    | CIRCULAR  // 环形加载图标
    | SPINNER   // 菊花加载图标
}
```

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 颜色变量

| 变量名                            | 默认值                   | 说明       |
|--------------------------------|-----------------------|----------|
| `--silk-loading-text-color`    | `--silk-text-color-2` | 加载文案文字颜色 |
| `--silk-loading-spinner-color` | `--silk-gray-5`       | 加载图标颜色   |

#### 尺寸变量

| 变量名                             | 默认值                   | 说明       |
|---------------------------------|-----------------------|----------|
| `--silk-loading-text-font-size` | `--silk-font-size-md` | 加载文案字体大小 |
| `--silk-loading-spinner-size`   | `30vp`                | 加载图标大小   |

#### 动画变量

| 变量名                               | 默认值   | 说明        |
|-----------------------------------|-------|-----------|
| `--silk-loading-spinner-duration` | `0.8` | 加载动画时长（秒） |

### 定制示例

```js
// 修改加载组件颜色
import silkui.constants.SilkLoadingColorConstants
import silkui.constants.SilkLoadingColorKey
import silkui.constants.updateLoadingColorConstant

// 修改加载图标颜色
updateLoadingColorConstant(SilkLoadingColorKey.LOADING_SPINNER_COLOR, Color(0, 0, 255, alpha: 1.0))

// 修改加载组件尺寸
import silkui.constants.SilkLoadingSizeConstants
import silkui.constants.SilkLoadingSizeKey
import silkui.constants.updateLoadingSizeConstant

// 修改加载图标尺寸
updateLoadingSizeConstant(SilkLoadingSizeKey.LOADING_SPINNER_SIZE, 40.vp)

// 修改加载组件动画
import silkui.constants.SilkLoadingAnimationConstants
import silkui.constants.SilkLoadingAnimationKey
import silkui.constants.updateLoadingAnimationConstant

// 修改加载动画时长
updateLoadingAnimationConstant(SilkLoadingAnimationKey.LOADING_SPINNER_DURATION, 1.2)

// 重置加载组件常量
import silkui.constants.resetLoadingConstants

// 重置所有加载组件常量
resetLoadingConstants()
```

### 注意事项

1. 环形加载图标（CIRCULAR）使用Circle绘制实现，支持自定义颜色和大小。
2. 菊花加载图标（SPINNER）由12个小方块组成，支持自定义颜色和大小。
3. 当设置了自定义图标（icon）时，将使用自定义图标替代默认的加载图标，但仍会应用旋转动画。
4. 组件会在初始化时自动开始动画，在销毁时自动停止动画。
