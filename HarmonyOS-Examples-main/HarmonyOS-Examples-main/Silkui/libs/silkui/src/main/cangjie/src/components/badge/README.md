# SilkBadge 徽标

徽标用于展示数字、文本或红点标记，通常用于消息提醒、数量显示等场景。

## 介绍

徽标组件可以附加在其他元素上，用于显示计数、提示等信息。支持自定义内容、颜色、位置等属性。

## 引入

```js
import silkui.components.badge.SilkBadge
import silkui.components.badge.SilkBadgeOptions
import silkui.components.badge.SilkBadgePosition
```

## 代码演示

### 基础用法

```js
SilkBadge(
    props: SilkBadgeOptions(
        content: "5"
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
SilkBadge(
    props: SilkBadgeOptions(
        content: "10"
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
SilkBadge(
    props: SilkBadgeOptions(
        content: "Hot"
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
SilkBadge(
    props: SilkBadgeOptions(
        content: "5",
        dot: true
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
```

### 最大值

设置 `max` 属性后，当数值超过最大值时，会显示 `{max}+`。

```js
SilkBadge(
    props: SilkBadgeOptions(
        content: "10",
    max: 9
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
SilkBadge(
    props: SilkBadgeOptions(
        content: "21",
    max: 20
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
SilkBadge(
    props: SilkBadgeOptions(
        content: "100",
    max: 99
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
```

### 自定义颜色

通过 `color` 和 `backgroundColor` 属性设置徽标的颜色。

```js
SilkBadge(
    props: SilkBadgeOptions(
        content: "5",
        backgroundColor: Color(0xff1989fa)
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
SilkBadge(
    props: SilkBadgeOptions(
        content: "10",
        backgroundColor: Color(0xff1989fa)
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
SilkBadge(
    props: SilkBadgeOptions(
        dot: true,
        backgroundColor: Color(0xff1989fa)
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
```

### 自定义徽标内容

可以通过 `Content` 插槽自定义徽标的内容。

```js
SilkBadge(
    props: SilkBadgeOptions(),
    Content: C1,
    Children: Children,
    hasChildren: true,
    hasContent: true
)
SilkBadge(
    props: SilkBadgeOptions(),
    Content: C2,
    Children: Children,
    hasChildren: true,
    hasContent: true
)
SilkBadge(
    props: SilkBadgeOptions(),
    Content: C3,
    Children: Children,
    hasChildren: true,
    hasContent: true
)
```

### 自定义位置

通过 `position` 属性设置徽标的位置，支持 `TOP_LEFT`、`TOP_RIGHT`、`BOTTOM_LEFT`、`BOTTOM_RIGHT` 四个位置。

```js
SilkBadge(
    props: SilkBadgeOptions(
        content: "10",
        position: SilkBadgePosition.TOP_LEFT
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
SilkBadge(
    props: SilkBadgeOptions(
        content: "10",
        position: SilkBadgePosition.BOTTOM_LEFT
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
SilkBadge(
    props: SilkBadgeOptions(
        content: "10",
        position: SilkBadgePosition.BOTTOM_RIGHT
    ),
    Children: Children,
    hasChildren: true,
    hasContent: false
)
```


### 独立展示

徽标可独立展示

```js
SilkBadge(
    props: SilkBadgeOptions(
        content: "20",
    ),
    hasChildren: false,
    hasContent: false
)
SilkBadge(
    props: SilkBadgeOptions(
        content: "100",
        max: 99
    ),
    hasChildren: false,
    hasContent: false
)
```

## API

### Props

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| props | 徽标配置选项 | `SilkBadgeOptions` | - | `@Prop` |

### SilkBadgeOptions

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| content | 徽标内容 | `String` | `""` | `let` |
| color | 徽标文字颜色 | `ResourceColor` | `BADGE_COLOR` | `let` |
| dot | 是否显示为小红点 | `Bool` | `false` | `let` |
| max | 最大数值 | `Option<Int64>` | `None` | `let` |
| offset | 徽标偏移量 | `Length` | `0vp` | `let` |
| show_zero | 当数值为 0 时是否显示徽标 | `Bool` | `true` | `let` |
| position | 徽标位置 | `SilkBadgePosition` | `TOP_RIGHT` | `let` |
| backgroundColor | 徽标背景颜色 | `ResourceColor` | `BADGE_BACKGROUND` | `let` |
| fontSize | 徽标文字大小 | `Length` | `BADGE_FONT_SIZE` | `let` |
| padding | 徽标内边距 | `SilkUIPaddingOptions` | `BADGE_PADDING` | `let` |
| size | 徽标尺寸 | `Length` | `BADGE_SIZE` | `let` |
| fontWeight | 徽标文字字重 | `FontWeight` | `FontWeight.Medium` | `let` |
| border | 徽标边框配置 | `SilkUIBorderOptions` | - | `let` |
| radius | 徽标圆角大小 | `Length` | `RADIUS_MAX` | `let` |

### SilkBadge Slots

| 名称 | 说明 |
| --- | --- |
| Children | 徽标所附加的元素 |
| Content | 自定义徽标内容 |

### SilkBadgePosition

```js
enum SilkBadgePosition {
    | TOP_LEFT     // 左上角
    | TOP_RIGHT    // 右上角
    | BOTTOM_LEFT  // 左下角
    | BOTTOM_RIGHT // 右下角
}
```

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 颜色变量

| 变量名                       | 默认值                   | 说明     |
|---------------------------|-----------------------|--------|
| `--silk-badge-color`      | `--silk-white`        | 徽标文字颜色 |
| `--silk-badge-background` | `--silk-danger-color` | 徽标背景颜色 |
| `--silk-badge-dot-color`  | `--silk-danger-color` | 小红点颜色  |

#### 尺寸变量

| 变量名                      | 默认值                   | 说明     |
|--------------------------|-----------------------|--------|
| `--silk-badge-size`      | `16vp`                | 徽标尺寸   |
| `--silk-badge-font-size` | `--silk-font-size-sm` | 徽标文字大小 |
| `--silk-badge-dot-size`  | `8vp`                 | 小红点尺寸  |

#### 内边距变量

| 变量名                    | 默认值               | 说明    |
|------------------------|-------------------|-------|
| `--silk-badge-padding` | `0vp 3vp 0vp 3vp` | 徽标内边距 |

#### 其他变量

| 变量名                         | 默认值                                                     | 说明     |
|-----------------------------|---------------------------------------------------------|--------|
| `--silk-badge-border-width` | `1.0`                                                   | 徽标边框宽度 |
| `--silk-badge-line-height`  | `1.2`                                                   | 徽标文字行高 |
| `--silk-badge-font`         | `-apple-system-font, Helvetica Neue, Arial, sans-serif` | 徽标字体   |

### 定制示例

```js
// 修改徽标颜色
import silkui.constants.SilkBadgeColorConstants
import silkui.constants.SilkBadgeColorKey
import silkui.constants.updateBadgeColorConstant

// 修改徽标背景色
updateBadgeColorConstant(SilkBadgeColorKey.BADGE_BACKGROUND, Color(0, 0, 255, alpha: 1.0))

// 修改徽标尺寸
import silkui.constants.SilkBadgeSizeConstants
import silkui.constants.SilkBadgeSizeKey
import silkui.constants.updateBadgeSizeConstant

// 修改徽标尺寸
updateBadgeSizeConstant(SilkBadgeSizeKey.BADGE_SIZE, 20.vp)

// 修改徽标字体权重
import silkui.constants.updateBadgeFontWeight

// 修改徽标字体权重
updateBadgeFontWeight(FontWeight.W700)

// 重置徽标常量
import silkui.constants.resetBadgeConstants

// 重置所有徽标常量
resetBadgeConstants()
```

## 注意事项

1. 当 `content` 为数字时，如果超过 `max` 值，会显示为 `{max}+`。
2. 当设置 `dot` 为 `true` 时，会忽略 `content` 内容，显示一个小红点。
3. 当 `content` 为 `0` 且 `show_zero` 为 `false` 时，不会显示徽标。
4. 徽标的位置是相对于其容器元素的，可以通过 `position` 和 `offset` 属性调整位置。
