# SilkActionSheet 动作面板

动作面板从底部弹起，展示一系列操作选项供用户选择。

## 介绍

动作面板是一种常见的交互组件，通常用于展示多个操作选项，让用户进行选择。支持自定义标题、描述信息、图标、取消按钮等功能，并提供丰富的样式配置选项。

## 引入

```js
import silkui.components.action_sheet.SilkActionSheet
import silkui.components.action_sheet.SilkActionSheetOptions
import silkui.components.action_sheet.SilkActionSheetAction
```

## 代码演示

### 基础用法

通过 `actions` 属性设置选项列表，每个选项包含 `name` 属性。

```js
SilkActionSheet(
    show: show1,
    props: SilkActionSheetOptions(
        actions: [
            SilkActionSheetAction(name: "选项一"),
            SilkActionSheetAction(name: "选项二"),
            SilkActionSheetAction(name: "选项三")
        ]
    ),
    select: { action, _ => SilkToast.toast(action.name); show1 = false}
)
```

### 展示图标

通过 `icon` 属性为选项添加图标。

```js
SilkActionSheet(
    show: show2,
    props: SilkActionSheetOptions(
        actions: [
            SilkActionSheetAction(name: "选项一", icon: "cart-o"),
            SilkActionSheetAction(name: "选项二", icon: "shop-o"),
            SilkActionSheetAction(name: "选项三", icon: "star-o")
        ]
    ),
    select: { action, _ => SilkToast.toast(action.name); show2 = false}
)
```

### 展示取消按钮

设置 `cancelText` 属性可以显示取消按钮，点击取消按钮会触发 `cancel` 回调。

```js
SilkActionSheet(
    show: show3,
    props: SilkActionSheetOptions(
        cancelText: "取消",
        closeOnClickAction: true,
        actions: [
            SilkActionSheetAction(name: "选项一"),
            SilkActionSheetAction(name: "选项二"),
            SilkActionSheetAction(name: "选项三")
        ]
    ),
    cancel: { => SilkToast.toast("取消")}
)
```

### 展示描述信息

通过 `description` 属性可以在选项上方显示描述信息，选项可以设置 `subname` 属性显示子标题。

```js
SilkActionSheet(
    show: show4,
    props: SilkActionSheetOptions(
        cancelText: "取消",
        closeOnClickAction: true,
        description: "这是一段描述信息",
        actions: [
            SilkActionSheetAction(name: "选项一"),
            SilkActionSheetAction(name: "选项二"),
            SilkActionSheetAction(name: "选项三", subname: "描述信息")
        ]
    )
)
```

### 选项状态

选项可以设置禁用、加载状态，也可以自定义颜色。

```js
SilkActionSheet(
    show: show5,
    props: SilkActionSheetOptions(
        cancelText: "取消",
        closeOnClickAction: true,
        actions: [
            SilkActionSheetAction(name: "选项一", color: Color(0xffee0a24)),
            SilkActionSheetAction(name: "选项二", disabled: true),
            SilkActionSheetAction(name: "选项三", loading: true)
        ]
    )
)
```

### 自定义面板

通过 `content` 插槽可以完全自定义面板内容。

```js
@Builder
func content6 () {
    Text("内容")
}

SilkActionSheet(
    show: show6,
    props: SilkActionSheetOptions(
        title: "标题"
    ),
    content: {_ => content6(this)}
)
```

## API

### Props

| 参数    | 说明       | 类型                       | 默认值     | 装饰器     |
|-------|----------|--------------------------|---------|---------|
| show  | 是否显示动作面板 | `Bool`                   | `false` | `@Link` |
| props | 动作面板配置选项 | `SilkActionSheetOptions` | -       | `@Prop` |

### Events

| 事件名          | 说明        | 回调参数                                          |
|--------------|-----------|-----------------------------------------------|
| select       | 选项点击时触发   | `action: SilkActionSheetAction, index: Int64` |
| cancel       | 取消按钮点击时触发 | -                                             |
| open         | 面板开始打开时触发 | -                                             |
| close        | 面板开始关闭时触发 | -                                             |
| opened       | 面板完全打开后触发 | -                                             |
| closed       | 面板完全关闭后触发 | -                                             |
| clickOverlay | 遮罩层点击时触发  | -                                             |

### SilkActionSheetOptions

| 参数                  | 说明           | 类型                                         | 默认值         |
|---------------------|--------------|--------------------------------------------|-------------|
| actions             | 面板选项列表       | `Array<SilkActionSheetAction>`             | `[]`        |
| title               | 顶部标题         | `?ResourceStr`                             | `None`      |
| cancelText          | 取消按钮文字       | `?ResourceStr`                             | `None`      |
| description         | 选项上方的描述信息    | `?ResourceStr`                             | `None`      |
| closeable           | 是否显示关闭图标     | `Bool`                                     | 根据title自动判断 |
| closeIcon           | 关闭图标名称       | `ResourceStr`                              | `"cross"`   |
| duration            | 动画时长，单位毫秒    | `Int32`                                    | `300`       |
| round               | 是否显示圆角       | `Bool`                                     | `true`      |
| overlay             | 是否显示遮罩层      | `Bool`                                     | `true`      |
| overlayColor        | 遮罩层颜色        | `ResourceColor`                            | 预设颜色        |
| lockScroll          | 是否锁定背景滚动     | `Bool`                                     | `true`      |
| closeOnPopState     | 是否在页面回退时自动关闭 | `Bool`                                     | `true`      |
| closeOnClickAction  | 是否在点击选项后关闭   | `Bool`                                     | `false`     |
| closeOnClickOverlay | 是否在点击遮罩层后关闭  | `Bool`                                     | `true`      |
| safeAreaInsetBottom | 是否开启底部安全区适配  | `Bool`                                     | `true`      |
| beforeClose         | 关闭前的回调函数     | `Option<(action: String) -> Future<Bool>>` | `None`      |

### SilkActionSheetAction

| 参数       | 说明       | 类型                   | 默认值     |
|----------|----------|----------------------|---------|
| name     | 选项名称     | `ResourceStr`        | -       |
| subname  | 选项子标题    | `?ResourceStr`       | `None`  |
| color    | 选项颜色     | `ResourceColor`      | 预设颜色    |
| icon     | 显示的图标名称  | `?ResourceStr`       | `None`  |
| disabled | 是否为禁用状态  | `Bool`               | `false` |
| loading  | 是否显示加载状态 | `Bool`               | `false` |
| callback | 选项点击回调   | `Option<() -> Unit>` | `None`  |

### Slots

| 名称      | 说明      |
|---------|---------|
| content | 自定义面板内容 |

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 颜色变量

| 变量名                                            | 默认值                   | 说明         |
|------------------------------------------------|-----------------------|------------|
| `--silk-action-sheet-description-color`        | `--silk-text-color-2` | 描述信息文字颜色   |
| `--silk-action-sheet-item-background`          | `--silk-background-2` | 选项背景颜色     |
| `--silk-action-sheet-item-text-color`          | `--silk-text-color`   | 选项文字颜色     |
| `--silk-action-sheet-item-disabled-text-color` | `--silk-text-color-3` | 禁用选项文字颜色   |
| `--silk-action-sheet-subname-color`            | `--silk-text-color-2` | 子标题文字颜色    |
| `--silk-action-sheet-close-icon-color`         | `--silk-gray-5`       | 关闭图标颜色     |
| `--silk-action-sheet-cancel-text-color`        | `--silk-gray-7`       | 取消按钮文字颜色   |
| `--silk-action-sheet-cancel-padding-color`     | `--silk-background`   | 取消按钮区域背景颜色 |

#### 尺寸变量

| 变量名                                             | 默认值                     | 说明       |
|-------------------------------------------------|-------------------------|----------|
| `--silk-action-sheet-header-height`             | `48vp`                  | 标题区域高度   |
| `--silk-action-sheet-header-font-size`          | `--silk-font-size-lg`   | 标题文字大小   |
| `--silk-action-sheet-description-font-size`     | `--silk-font-size-md`   | 描述信息文字大小 |
| `--silk-action-sheet-description-line-height`   | `--silk-line-height-md` | 描述信息行高   |
| `--silk-action-sheet-item-font-size`            | `--silk-font-size-lg`   | 选项文字大小   |
| `--silk-action-sheet-item-line-height`          | `--silk-line-height-lg` | 选项文字行高   |
| `--silk-action-sheet-item-icon-size`            | `18vp`                  | 选项图标大小   |
| `--silk-action-sheet-item-icon-margin-right`    | `--silk-padding-xs`     | 选项图标右边距  |
| `--silk-action-sheet-subname-font-size`         | `--silk-font-size-sm`   | 子标题文字大小  |
| `--silk-action-sheet-subname-line-height`       | `--silk-line-height-sm` | 子标题行高    |
| `--silk-action-sheet-close-icon-size`           | `22vp`                  | 关闭图标大小   |
| `--silk-action-sheet-loading-icon-size`         | `22vp`                  | 加载图标大小   |
| `--silk-action-sheet-close-icon-padding-top`    | `0vp`                   | 关闭图标上内边距 |
| `--silk-action-sheet-close-icon-padding-right`  | `--silk-padding-md`     | 关闭图标右内边距 |
| `--silk-action-sheet-close-icon-padding-bottom` | `0vp`                   | 关闭图标下内边距 |
| `--silk-action-sheet-close-icon-padding-left`   | `--silk-padding-md`     | 关闭图标左内边距 |
| `--silk-action-sheet-cancel-padding-top`        | `--silk-padding-xs`     | 取消按钮上内边距 |

#### 百分比变量

| 变量名                                      | 默认值   | 说明     |
|------------------------------------------|-------|--------|
| `--silk-action-sheet-max-height-percent` | `80%` | 面板最大高度 |

### 定制示例

```js
// 修改动作面板颜色
import silkui.constants.updateActionSheetColorConstant
import silkui.constants.SilkActionSheetColorKey

// 修改选项文字颜色
updateActionSheetColorConstant(
    SilkActionSheetColorKey.ACTION_SHEET_ITEM_TEXT_COLOR,
    Color(0xff1989fa)
)

// 修改动作面板尺寸
import silkui.constants.updateActionSheetSizeConstant
import silkui.constants.SilkActionSheetSizeKey

// 修改选项文字大小
updateActionSheetSizeConstant(
    SilkActionSheetSizeKey.ACTION_SHEET_ITEM_FONT_SIZE,
    18.vp
)

// 重置动作面板常量
import silkui.constants.resetActionSheetConstants

// 重置所有动作面板常量
resetActionSheetConstants()
```

## 注意事项

1. 动作面板会从底部弹起，建议在移动端使用。
2. 当设置 `closeOnClickAction` 为 `true` 时，点击选项后会自动关闭面板。
3. 当设置 `beforeClose` 回调时，可以通过返回 `false` 阻止面板关闭。
4. 选项的 `disabled` 状态会禁用点击事件，`loading` 状态会显示加载图标。
5. 使用 `content` 插槽时，会忽略 `actions` 配置，完全自定义面板内容。
