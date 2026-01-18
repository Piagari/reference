# Rate 评分

### 介绍

评分组件，用于对事物进行评级操作，常用于评价场景。

### 引入

```js
import silkui.components.rate.{SilkRate, SilkRateControlled, SilkRateOptions}
```

## 代码演示

### 基础用法

评分组件的基础用法。

```js
SilkRate(props: SilkRateOptions())
```

### 自定义图标

通过 `icon` 和 `voidIcon` 属性自定义选中和未选中的图标。

```js
SilkRate(props: SilkRateOptions(
  icon: "like",
  voidIcon: "like-o"
))
```

### 自定义数量

通过 `count` 属性设置评分总数。

```js
SilkRate(props: SilkRateOptions(
  count: 6
))
```

### 自定义颜色

通过 `color` 属性设置选中时的图标颜色。

```js
SilkRate(props: SilkRateOptions(
  color: @r(app.color.primary_color)
))
```

### 半星

设置 `allowHalf` 属性后可以选中半星。

```js
SilkRate(props: SilkRateOptions(
  value: 2.5,
  allowHalf: true
))
```

### 自定义大小

通过 `size` 属性设置图标大小。

```js
SilkRate(props: SilkRateOptions(
  size: 25.vp
))
```

### 自定义间距

通过 `gutter` 属性设置图标间距。

```js
SilkRate(props: SilkRateOptions(
  gutter: 20.vp
))
```

### 只读状态

设置 `readonly` 属性后无法修改评分。

```js
SilkRate(props: SilkRateOptions(
  value: 3,
  readonly: true
))
```

### 禁用状态

设置 `disabled` 属性后禁用评分。

```js
SilkRate(props: SilkRateOptions(
  value: 3,
  disabled: true
))
```

### 监听事件

评分变化时，会触发 `change` 事件。

```js
@State
var score: Float64 = 3

SilkRate(
  props: SilkRateOptions(value: score),
  change: {value => score = value}
)
```

### 双向绑定

使用 `@Link` 装饰器可以实现双向绑定。

```js
@State
var score: Float64 = 3

SilkRate(
  props: SilkRateOptions(),
  value: $score,
  change: {value => score = value}
)

// 显示当前分值
Text("当前分值：" + score.toString())
```

## API

### Props

| 参数 | 说明 | 类型 | 默认值 |
| --- | --- | --- | --- |
| value | 当前分值 | `Float64` | `0` |
| count | 图标总数 | `Int64` | `5` |
| allowHalf | 是否允许半选 | `Bool` | `false` |
| readonly | 是否为只读状态 | `Bool` | `false` |
| disabled | 是否禁用评分 | `Bool` | `false` |
| touchable | 是否可以通过滑动手势选择评分 | `Bool` | `true` |
| icon | 选中时的图标名称 | `ResourceStr` | `star` |
| voidIcon | 未选中时的图标名称 | `ResourceStr` | `star-o` |
| halfIcon | 半选时的图标名称 | `ResourceStr` | `star-half-o` |
| color | 选中时的图标颜色 | `ResourceColor` | `--silk-rate-icon-full-color` |
| voidColor | 未选中时的图标颜色 | `ResourceColor` | `--silk-rate-icon-void-color` |
| disabledColor | 禁用时的图标颜色 | `ResourceColor` | `--silk-rate-icon-disabled-color` |
| halfColor | 半选时的图标颜色 | `ResourceColor` | `--silk-rate-icon-half-color` |
| size | 图标大小，默认单位为vp | `Length` | `--silk-rate-icon-size` |
| gutter | 图标间距，默认单位为vp | `Length` | `--silk-rate-icon-gutter` |

### Events

| 事件名 | 说明 | 回调参数 |
| --- | --- | --- |
| change | 当前分值变化时触发 | `value: Float64` |



### 样式变量

组件提供了下列变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 颜色变量

| 名称 | 默认值 | 描述 |
| --- | --- | --- |
| `--silk-rate-icon-void-color` | `--silk-gray-5` | 未选中时的图标颜色 |
| `--silk-rate-icon-full-color` | `--silk-orange` | 选中时的图标颜色 |
| `--silk-rate-icon-disabled-color` | `--silk-gray-5` | 禁用时的图标颜色 |
| `--silk-rate-icon-half-color` | `--silk-orange` | 半选时的图标颜色 |

#### 尺寸变量

| 名称 | 默认值 | 描述 |
| --- | --- | --- |
| `--silk-rate-icon-size` | `20vp` | 图标大小 |
| `--silk-rate-icon-gutter` | `4vp` | 图标间距 |

#### 数值变量

| 名称 | 默认值 | 描述 |
| --- | --- | --- |
| `--silk-rate-count` | `5` | 默认图标数量 |
| `--silk-rate-touch-threshold` | `50` | 触摸阈值 |

### 定制示例

```js
// 修改评分组件颜色
import silkui.constants.SilkRateColorKey
import silkui.constants.updateRateColorConstant

// 修改选中时的图标颜色
updateRateColorConstant(SilkRateColorKey.RATE_ICON_FULL_COLOR, Color(255, 0, 0, alpha: 1.0))

// 修改评分组件尺寸
import silkui.constants.SilkRateSizeKey
import silkui.constants.updateRateSizeConstant

// 修改图标大小
updateRateSizeConstant(SilkRateSizeKey.RATE_ICON_SIZE, 30.vp)

// 修改图标间距
updateRateSizeConstant(SilkRateSizeKey.RATE_ICON_GUTTER, 8.vp)

// 修改评分组件数值
import silkui.constants.SilkRateIntKey
import silkui.constants.updateRateIntConstant

// 修改默认图标数量
updateRateIntConstant(SilkRateIntKey.RATE_COUNT, 10)
```
