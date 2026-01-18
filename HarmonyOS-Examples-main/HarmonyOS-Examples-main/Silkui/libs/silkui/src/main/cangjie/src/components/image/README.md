# Image 图片

### 介绍

增强版的 img 标签，提供多种图片填充模式，支持加载中提示、加载失败提示。

### 引入

```js
import silkui

.
components.image.
{
    SilkImage, SilkImageOptions, SilkImageFit, SilkImagePosition
}
```

## 代码演示

### 基础用法

基础用法与原生 `img` 标签一致，可以设置 `src`、`width`、`height`、`alt` 等原生属性。

```js
@
Builder
func
BasicImageContent()
{
    SilkImage(
        src:
    "https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg",
    props:
    SilkImageOptions(
        width:
    100.
    vp,
    height:
    100.
    vp
    )
    )
}
```

### 填充模式

通过 `fit`
属性可以设置图片填充模式，等同于原生的 [object-fit](https://developer.mozilla.org/zh-CN/docs/Web/CSS/object-fit)
属性，可选值见下方表格。

```js
@
Builder
func
FitImageContent()
{
    SilkImage(
        src:
    "https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg",
    props:
    SilkImageOptions(
        width:
    10.
    vp,
    height:
    10.
    vp,
    fit:
    SilkImageFit.CONTAIN
    )
    )
}
```

### 图片位置

通过 `position` 属性可以设置图片位置，结合 `fit`
属性使用，等同于原生的 [object-position](https://developer.mozilla.org/zh-CN/docs/Web/CSS/object-position) 属性。

```js
@
Builder
func
PositionImageContent()
{
    SilkImage(
        src:
    "https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg",
    props:
    SilkImageOptions(
        width:
    10.
    vp,
    height:
    10.
    vp,
    fit:
    SilkImageFit.COVER,
    position:
    SilkImagePosition.LEFT
    )
    )
}
```

### 圆形图片

通过 `round` 属性可以设置图片变圆，注意当图片宽高不相等且 `fit` 为 `CONTAIN` 或 `SCALE_DOWN` 时，将无法填充一个完整的圆形。

```js
@
Builder
func
RoundImageContent()
{
    SilkImage(
        src:
    "https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg",
    props:
    SilkImageOptions(
        width:
    10.
    vp,
    height:
    10.
    vp,
    round:
    true
    )
    )
}
```

### 加载中提示

`SilkImage` 组件提供了默认的加载中提示，支持通过 `Loading` 插槽自定义内容。

```js
@
Builder
func
LoadingContent()
{
    Column()
    {
        SilkLoading(size:
        20.
        vp
        )
    }
    .
    width(100.
    percent
    )
    .
    height(100.
    percent
    )
    .
    justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(Color(0xf7, 0xf8, 0xfa, alpha:
    1.0
    )
    )
}

@
Builder
func
LoadingImageContent()
{
    SilkImage(
        src:
    "https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg",
    props:
    SilkImageOptions(
        width:
    10.
    vp,
    height:
    10.
    vp
    )
    ,
    Loading: LoadingContent,
    hasLoading:
    true
    )
}
```

### 加载失败提示

`SilkImage` 组件提供了默认的加载失败提示，支持通过 `Error` 插槽自定义内容。

```js
@
Builder
func
ErrorContent()
{
    Column()
    {
        Text("加载失败")
            .fontSize(14.
        vp
        )
        .
        fontColor(Color(0x96, 0x97, 0x99, alpha:
        1.0
        )
        )
    }
    .
    width(100.
    percent
    )
    .
    height(100.
    percent
    )
    .
    justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(Color(0xf7, 0xf8, 0xfa, alpha:
    1.0
    )
    )
}

@
Builder
func
ErrorImageContent()
{
    SilkImage(
        src:
    "https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg",
    props:
    SilkImageOptions(
        width:
    10.
    vp,
    height:
    10.
    vp
    )
    ,
    Error: ErrorContent,
    hasError:
    true
    )
}
```

## API

### Props

| 参数         | 说明            | 类型                 | 默认值     | 装饰器             |
|------------|---------------|--------------------|---------|-----------------|
| src        | 图片链接          | `ResourceStr`      | -       | `@Prop`         |
| props      | 图片配置选项        | `SilkImageOptions` | -       | `@Prop`         |
| Children   | 自定义图片下方的内容    | `() -> Unit`       | -       | `@BuilderParam` |
| Loading    | 自定义加载中的提示内容   | `() -> Unit`       | -       | `@BuilderParam` |
| Error      | 自定义加载失败时的提示内容 | `() -> Unit`       | -       | `@BuilderParam` |
| hasLoading | 是否使用自定义加载中提示  | `Bool`             | `false` | -               |
| hasError   | 是否使用自定义加载失败提示 | `Bool`             | `false` | -               |

### SilkImageOptions

| 参数          | 说明              | 类型                  | 默认值            | 反应性  |
|-------------|-----------------|---------------------|----------------|------|
| fit         | 图片填充模式          | `SilkImageFit`      | `FILL`         | 非响应式 |
| position    | 图片位置            | `SilkImagePosition` | `CENTER`       | 非响应式 |
| alt         | 替代文本            | `ResourceStr`       | `""`           | 非响应式 |
| width       | 宽度              | `?Length`           | `None`         | 非响应式 |
| height      | 高度              | `?Length`           | `None`         | 非响应式 |
| radius      | 圆角大小            | `Length`            | `0.vp`         | 非响应式 |
| round       | 是否显示为圆形         | `Bool`              | `false`        | 非响应式 |
| block       | 是否将根节点设置为块级元素   | `Bool`              | `false`        | 非响应式 |
| showError   | 是否展示图片加载失败提示    | `Bool`              | `true`         | 非响应式 |
| showLoading | 是否展示图片加载中提示     | `Bool`              | `true`         | 非响应式 |
| errorIcon   | 失败时提示的图标名称或图片链接 | `ResourceStr`       | `"photo-fail"` | 非响应式 |
| loadingIcon | 加载时提示的图标名称或图片链接 | `ResourceStr`       | `"photo"`      | 非响应式 |
| iconSize    | 加载图标和失败图标的大小    | `Length`            | `32.vp`        | 非响应式 |
| iconPrefix  | 图标类名前缀          | `ResourceStr`       | `"silk-icon"`  | 非响应式 |

### 图片填充模式

| 名称         | 含义                          |
|------------|-----------------------------|
| CONTAIN    | 保持宽高缩放图片，使图片的长边能完全显示出来      |
| COVER      | 保持宽高缩放图片，使图片的短边能完全显示出来，裁剪长边 |
| FILL       | 拉伸图片，使图片填满元素                |
| NONE       | 保持图片原有尺寸                    |
| SCALE_DOWN | 取 `NONE` 或 `CONTAIN` 中较小的一个 |

### 图片位置 （image组件暂不支持该属性设置）

| 名称     | 含义   |
|--------|------|
| TOP    | 顶部对齐 |
| RIGHT  | 右侧对齐 |
| BOTTOM | 底部对齐 |
| LEFT   | 左侧对齐 |
| CENTER | 居中对齐 |

### Events

| 事件名   | 说明        | 回调参数                |
|-------|-----------|---------------------|
| click | 点击图片时触发   | `event: ClickEvent` |
| load  | 图片加载完毕时触发 | -                   |
| error | 图片加载失败时触发 | -                   |

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../theme)。

| 名称                                  | 默认值            | 说明       |
|-------------------------------------|----------------|----------|
| --silk-image-placeholder-text-color | `TEXT_COLOR_2` | 占位文本颜色   |
| --silk-image-placeholder-font-size  | `FONT_SIZE_MD` | 占位文本字体大小 |
| --silk-image-placeholder-background | `BACKGROUND`   | 占位背景色    |
| --silk-image-loading-icon-size      | `32vp`         | 加载图标大小   |
| --silk-image-loading-icon-color     | `GRAY_4`       | 加载图标颜色   |
| --silk-image-error-icon-size        | `32vp`         | 错误图标大小   |
| --silk-image-error-icon-color       | `GRAY_4`       | 错误图标颜色   |
| --silk-image-radius                 | `0vp`          | 图片圆角大小   |
