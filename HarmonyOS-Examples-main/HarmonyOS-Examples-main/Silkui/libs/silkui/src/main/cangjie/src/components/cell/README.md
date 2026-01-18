# Cell 单元格

### 介绍

单元格为列表中的单个展示项，可以包含标题、内容、图标等元素，常用于展示列表信息、链接或表单等。

### 引入

```js
import silkui.component.cell.{SilkCell, SilkCellGroup}
```

## 代码演示

### 基础用法

`Cell` 可以单独使用，也可以与 `CellGroup` 搭配使用

```js
@Builder
func fn1() {
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容")
    )
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容", label: "描述信息")
    )
}
...
SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn1)
```

### 卡片风格

通过 CellGroup 的 inset 属性，可以将单元格转换为圆角卡片风格

```js
@Builder
func fn1() {
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容")
    )
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容", label: "描述信息")
    )
}
...
SilkCellGroup(props: SilkCellGroupOptions(inset: true), Childrens: this.fn1)
```

### 单元格大小

通过 `size` 属性可以控制单元格的大小。

```js
@Builder
func fn2() {
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容", size: SilkCellSize.Large),
    )
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容", label: "描述信息", size: SilkCellSize.Large)
    )
}
...
SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn2)
```

### 展示图标

通过 `icon` 属性在单元格左侧展示图标。

```js
@Builder
func fn3() {
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容", icon: @r(app.media.location_o)),
    )
}
...
SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn3)
```

### 展示箭头

设置 `isLink` 属性后会在单元格右侧显示箭头，并且可以通过 `arrowDirection` 属性控制箭头方向。

```js
@Builder
func fn4() {
    SilkCell(
        props: SilkCellOptions(title: "单元格", isLink: true),
    )
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容", isLink: true)
    )
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容", isLink: true, arrowDirection: SilkCellArrowDirection.DOWN)
    )
}
...
SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn4)
```

### 分组标题

通过 `CellGroup` 的 `title` 属性可以指定分组标题。

```js
@Builder
func fn5() {
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容"),
    )
}
...
SilkCellGroup(props: SilkCellGroupOptions(title: @r(app.string.cell_group_name1)), Childrens: this.fn5)
SilkCellGroup(props: SilkCellGroupOptions(title: "分组2"), Childrens: this.fn5)
```

### 自定义内容

如果以上属性不满足你的需求，可以使用自定义内容来自定义单元格的各个部分。

```js
@Builder
func CustomTitle () {
    Row(4) {
        Text("单元格")
            .fontSize(@r(app.float.font_size_md))
        .fontColor(@r(app.color.text_color))
        Text("标签")
            .fontSize(@r(app.float.font_size_sm))
        .fontColor(@r(app.color.white))
        .padding(right: 4.0, left: 4.0)
        .borderRadius(@r(app.float.radius_sm))
        .backgroundColor(@r(app.color.primary_color))
    }
}
@Builder
func CustomValue () {
    Image(@r(app.media.search))
    .height(16)
        .fillColor(@r(app.color.text_color))
}
@Builder
func fn7() {
    SilkCell(
        hasTitle: true,
    Title: this.CustomTitle,
    props: SilkCellOptions(value: "内容", isLink: true),
    )
    SilkCell(
        hasRightIcon: true,
    RightIcon: this.CustomValue,
    props: SilkCellOptions(title: "单元格", icon: @r(app.media.shop_o)),
    )
}
...
SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn7)
```

### 垂直居中

通过 `center` 属性可以让单元格垂直居中对齐。

```js
@Builder
func fn8() {
    SilkCell(
        props: SilkCellOptions(title: "单元格", value: "内容", center: true, label: "描述信息"),
    )
}
...
SilkCellGroup(props: SilkCellGroupOptions(), Childrens: this.fn8)
```

## API

### SilkCell Props

#### SilkCellOptions

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| title | 左侧标题 | `ResourceStr` | - | `@Publish` |
| value | 右侧内容 | `ResourceStr` | - | `@Publish` |
| titleColor | 标题颜色 | `ResourceColor` | `CELL_TEXT_COLOR` | `@Publish` |
| valueColor | 右侧内容颜色 | `ResourceColor` | `CELL_VALUE_COLOR` | `@Publish` |
| backgroundColor | 背景颜色 | `ResourceColor` | `CELL_BACKGROUND` | `@Publish` |
| height | 单元格高度 | `Float64` | `44.0` | `@Publish` |
| label | 标题下方的描述信息 | `ResourceStr` | - | `@Publish` |
| size | 单元格大小，可选值为 `Large`、`Normal` | `SilkCellSize` | `Normal` | `@Publish` |
| icon | 左侧图标名称 | `ResourceStr` | - | `@Publish` |
| clickable | 是否可点击 | `Bool` | `false` | `@Publish` |
| isLink | 是否显示右侧箭头并开启点击反馈 | `Bool` | `false` | `@Publish` |
| required | 是否显示表单必填星号 | `Bool` | `false` | `@Publish` |
| center | 是否使内容垂直居中 | `Bool` | `false` | `@Publish` |
| border | 是否显示内边框 | `Bool` | `true` | `@Publish` |
| customBorder | 自定义边框样式 | `SilkUIBorderOptions` | - | `@Publish` |
| padding | 内容区域内边距 | `SilkUIPaddingOptions` | - | `@Publish` |
| arrowDirection | 箭头方向，可选值为 `UP`、`DOWN`、`LEFT`、`RIGHT` | `SilkCellArrowDirection` | `RIGHT` | `@Publish` |

#### 自定义内容属性

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| props | 单元格配置选项 | `SilkCellOptions` | - | `@Prop` |
| hasTitle | 是否使用自定义标题 | `Bool` | `false` | `var` |
| hasIcon | 是否使用自定义图标 | `Bool` | `false` | `var` |
| hasLabel | 是否使用自定义标签 | `Bool` | `false` | `var` |
| hasValue | 是否使用自定义值 | `Bool` | `false` | `var` |
| hasRightIcon | 是否使用自定义右侧图标 | `Bool` | `false` | `var` |

### SilkCellGroup Props

#### SilkCellGroupOptions

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| title | 分组标题 | `ResourceStr` | - | `@Publish` |
| inset | 是否展示为圆角卡片风格 | `Bool` | `false` | `@Publish` |
| hasBorder | 是否显示外边框 | `Bool` | `true` | `@Publish` |
| customBorder | 自定义边框样式 | `SilkUIBorderOptions` | - | `@Publish` |
| marginValue | 外边距值 | `Length` | - | `@Publish` |
| padding | 内边距 | `SilkUIPaddingOptions` | - | `@Publish` |
| radius | 圆角大小 | `Int64` | `8` | `@Publish` |

### SilkCell Slots

| 名称 | 说明 |
| --- | --- |
| Title | 自定义标题内容 |
| Value | 自定义右侧内容 |
| Label | 自定义描述内容 |
| Icon | 自定义左侧图标 |
| RightIcon | 自定义右侧图标 |

### SilkCellGroup Slots

| 名称 | 说明 |
| --- | --- |
| Childrens | 自定义单元格组内容 |

### 类型定义

```js
enum SilkCellSize {
    | Large   // 大型单元格
    | Normal  // 标准单元格
}

enum SilkCellArrowDirection {
    | UP     // 向上箭头
    | DOWN   // 向下箭头
    | LEFT   // 向左箭头
    | RIGHT  // 向右箭头
}
```

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 颜色变量

| 变量名                          | 默认值                   | 说明        |
|------------------------------|-----------------------|-----------|
| `--silk-cell-text-color`     | `--silk-text-color`   | 单元格标题颜色   |
| `--silk-cell-value-color`    | `--silk-text-color-2` | 单元格右侧内容颜色 |
| `--silk-cell-label-color`    | `--silk-text-color-3` | 单元格描述信息颜色 |
| `--silk-cell-background`     | `--silk-white`        | 单元格背景颜色   |
| `--silk-cell-border-color`   | `--silk-border-color` | 单元格边框颜色   |
| `--silk-cell-active-color`   | `--silk-active-color` | 单元格点击态颜色  |
| `--silk-cell-required-color` | `--silk-danger-color` | 单元格必填星号颜色 |
| `--silk-cell-disabled-color` | `--silk-text-color-3` | 单元格禁用态颜色  |

#### 尺寸变量

| 变量名                              | 默认值                   | 说明          |
|----------------------------------|-----------------------|-------------|
| `--silk-cell-font-size`          | `--silk-font-size-md` | 单元格字体大小     |
| `--silk-cell-line-height`        | `24vp`                | 单元格行高       |
| `--silk-cell-vertical-padding`   | `10vp`                | 单元格垂直内边距    |
| `--silk-cell-horizontal-padding` | `--silk-padding-md`   | 单元格水平内边距    |
| `--silk-cell-text-max-width`     | `60%`                 | 单元格标题最大宽度   |
| `--silk-cell-label-font-size`    | `--silk-font-size-sm` | 单元格描述信息字体大小 |
| `--silk-cell-label-line-height`  | `18vp`                | 单元格描述信息行高   |
| `--silk-cell-label-margin-top`   | `4vp`                 | 单元格描述信息上边距  |
| `--silk-cell-value-font-size`    | `--silk-font-size-md` | 单元格右侧内容字体大小 |
| `--silk-cell-icon-size`          | `16vp`                | 单元格图标大小     |
| `--silk-cell-right-icon-margin`  | `4vp`                 | 单元格右侧图标外边距  |

#### 分组变量

| 变量名                                     | 默认值                                                                       | 说明          |
|-----------------------------------------|---------------------------------------------------------------------------|-------------|
| `--silk-cell-group-title-padding`       | `--silk-padding-md --silk-padding-md --silk-padding-xs --silk-padding-md` | 分组标题内边距     |
| `--silk-cell-group-title-font-size`     | `--silk-font-size-md`                                                     | 分组标题字体大小    |
| `--silk-cell-group-title-line-height`   | `16vp`                                                                    | 分组标题行高      |
| `--silk-cell-group-title-color`         | `--silk-text-color-2`                                                     | 分组标题颜色      |
| `--silk-cell-group-inset-padding`       | `0vp --silk-padding-md 0vp --silk-padding-md`                             | 卡片风格分组内边距   |
| `--silk-cell-group-inset-title-padding` | `--silk-padding-md --silk-padding-md --silk-padding-xs --silk-padding-xl` | 卡片风格分组标题内边距 |
| `--silk-cell-group-inset-radius`        | `8vp`                                                                     | 卡片风格分组圆角    |
| `--silk-cell-group-inset-margin`        | `0vp --silk-padding-md --silk-padding-md --silk-padding-md`               | 卡片风格分组外边距   |

### 定制示例

```js
// 修改单元格颜色
import silkui.constants.SilkCellColorConstants
import silkui.constants.SilkCellColorKey
import silkui.constants.updateCellColorConstant

// 修改单元格背景色
updateCellColorConstant(SilkCellColorKey.CELL_BACKGROUND, Color(250, 250, 250, alpha: 1.0))

// 修改单元格尺寸
import silkui.constants.SilkCellSizeConstants
import silkui.constants.SilkCellSizeKey
import silkui.constants.updateCellSizeConstant

// 修改单元格内边距
updateCellSizeConstant(SilkCellSizeKey.CELL_HORIZONTAL_PADDING, 20.vp)

// 修改单元格内边距
import silkui.constants.SilkCellPaddingConstants
import silkui.constants.SilkCellPaddingKey
import silkui.constants.updateCellPaddingConstant

// 修改分组标题内边距
updateCellPaddingConstant(
  SilkCellPaddingKey.CELL_GROUP_TITLE_PADDING,
  SilkUIPaddingOptions(
    top: 16.vp,
    right: 16.vp,
    bottom: 8.vp,
    left: 16.vp
  )
)

// 重置单元格常量
import silkui.constants.resetCellConstants

// 重置所有单元格常量
resetCellConstants()
```
