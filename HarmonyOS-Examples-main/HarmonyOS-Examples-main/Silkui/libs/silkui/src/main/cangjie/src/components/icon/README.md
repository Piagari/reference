# Icon 图标

### 介绍

图标组件用于展示各种图标，支持字体图标和图片图标。

### 引入

```js
import silkui.component.icon.SilkIcon
```

## 代码演示

### 基础用法

通过 `name` 属性指定需要使用的图标名称。

```js
SilkIcon(name: "arrow")
```

### 自定义颜色

通过 `fontColor` 属性设置图标颜色。

```js
SilkIcon(name: "arrow", fontColor: Color(255, 0, 0, alpha: 1.0))
```

### 自定义大小

通过 `fontSize` 属性设置图标大小。

```js
SilkIcon(name: "arrow", fontSize: 24.vp)
```

### 使用图片URL

当 `name` 是一个URL时，将渲染为图片图标。

```js
SilkIcon(name: "https://example.com/icon.png")
```

### 使用资源图片

当 `name` 是一个资源引用时，将渲染为图片图标。

```js
SilkIcon(name: @r(app.icon.arrow))
```

### 自定义字体族

通过 `family` 属性可以自定义字体图标的字体族。

```js
SilkIcon(name: "arrow", family: "my-icon-font")
```

### 自定义字重

通过 `weight` 属性可以设置字体图标的粗细。

```js
SilkIcon(name: "arrow", weight: FontWeight.Bold)
```

## API

### Props

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| name | 图标名称或URL | `ResourceStr` | `"arrow"` | `var` |
| fontColor | 图标颜色 | `ResourceColor` | `TEXT_COLOR` | `var` |
| fontSize | 图标大小 | `Length` | `32.vp` | `var` |
| lineHeight | 图标行高 | `Length` | `32.vp` | `var` |
| weight | 字体粗细 | `FontWeight` | `FontWeight.Normal` | `var` |
| family | 字体族名称 | `ResourceStr` | `ICON_FONT_FAMILY` | `var` |

### 内置图标

SilkUI 内置了一套图标库，可以直接通过名称使用。以下是部分常用图标：

- `arrow` - 箭头图标
- `plus` - 加号图标
- `minus` - 减号图标
- `cross` - 关闭图标
- `success` - 成功图标
- `fail` - 失败图标
- `info` - 信息图标
- `warning` - 警告图标
- `question` - 问号图标
- `contact` - 联系人图标
- `location` - 位置图标
- `cart` - 购物车图标
- `star` - 星星图标
- `home` - 首页图标
- `search` - 搜索图标
- `setting` - 设置图标

> 注意：完整的图标列表请参考图标库文档。

### 使用说明

1. 字体图标基于字体文件实现，确保应用中已引入相应的字体文件。
2. 使用URL或资源引用作为图标名称时，将自动渲染为图片图标。
3. 图片图标支持设置颜色，会应用为图片的填充色。

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 样式变量

| 变量名                       | 默认值         | 说明      |
|---------------------------|-------------|---------|
| `--silk-icon-font-family` | `silk-icon` | 图标字体族名称 |

#### 尺寸变量

| 变量名                   | 默认值    | 说明     |
|-----------------------|--------|--------|
| `--silk-icon-size-xs` | `10vp` | 极小图标尺寸 |
| `--silk-icon-size-sm` | `12vp` | 小型图标尺寸 |
| `--silk-icon-size-md` | `16vp` | 中型图标尺寸 |
| `--silk-icon-size-lg` | `20vp` | 大型图标尺寸 |
| `--silk-icon-size-xl` | `24vp` | 特大图标尺寸 |

#### 颜色变量

| 变量名                         | 默认值                    | 说明     |
|-----------------------------|------------------------|--------|
| `--silk-icon-default-color` | `--silk-text-color`    | 默认图标颜色 |
| `--silk-icon-primary-color` | `--silk-primary-color` | 主要图标颜色 |
| `--silk-icon-success-color` | `--silk-success-color` | 成功图标颜色 |
| `--silk-icon-warning-color` | `--silk-warning-color` | 警告图标颜色 |
| `--silk-icon-danger-color`  | `--silk-danger-color`  | 危险图标颜色 |
| `--silk-icon-info-color`    | `--silk-gray-6`        | 信息图标颜色 |

### 定制示例

```js
// 修改图标样式
import silkui.constants.SilkIconStyleConstants
import silkui.constants.SilkIconStyleKey
import silkui.constants.updateIconStyleConstant

// 修改图标字体族
updateIconStyleConstant(SilkIconStyleKey.ICON_FONT_FAMILY, "custom-icon-font")

// 修改图标尺寸
import silkui.constants.SilkIconSizeConstants
import silkui.constants.SilkIconSizeKey
import silkui.constants.updateIconSizeConstant

// 修改中型图标尺寸
updateIconSizeConstant(SilkIconSizeKey.ICON_SIZE_MD, 18.vp)

// 修改图标颜色
import silkui.constants.SilkIconColorConstants
import silkui.constants.SilkIconColorKey
import silkui.constants.updateIconColorConstant

// 修改主要图标颜色
updateIconColorConstant(SilkIconColorKey.ICON_PRIMARY_COLOR, Color(114, 50, 221, alpha: 1.0))

// 重置图标常量
import silkui.constants.resetIconConstants

// 重置所有图标常量
resetIconConstants()
```
