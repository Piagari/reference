# Picker 选择器

选择器组件用于从一组选项中选择一个或多个值，支持单列、多列和级联选择。参考 Vant Picker 组件设计，提供丰富的配置选项和交互功能。

## 功能特性

- 🎯 **单列选择** - 支持基础的单列选择
- 📊 **多列选择** - 支持多列并行选择
- 🔗 **级联选择** - 支持层级级联选择
- 🚫 **禁用选项** - 支持禁用特定选项
- 📱 **触摸交互** - 支持滑动、惯性滚动和点击选择
- 🎨 **3D效果** - 内置选项的3D视觉效果
- ⚡ **响应式** - 支持动态数据更新
- 🔄 **双向绑定** - 支持数据双向绑定

## 引入

```cangjie
import silkui.components.picker.{SilkPicker, SilkPickerOptions, SilkPickerColumn, SilkPickerOption}
```

## 基础用法

```cangjie
let options = [
    SilkPickerOption(text: "杭州", value: "Hangzhou"),
    SilkPickerOption(text: "宁波", value: "Ningbo"),
    SilkPickerOption(text: "温州", value: "Wenzhou")
]

let columns = [SilkPickerColumn(options)]

SilkPicker(
    columns: ObservedArrayList(columns),
    options: SilkPickerOptions(),
    confirm: { values, indexes => 
        SilkToast.toast("选择了: ${values.toString()}")
    }
)
```

## 多列选择

```cangjie
let columns = [
    SilkPickerColumn([
        SilkPickerOption(text: "周一", value: "Monday"),
        SilkPickerOption(text: "周二", value: "Tuesday"),
        SilkPickerOption(text: "周三", value: "Wednesday")
    ]),
    SilkPickerColumn([
        SilkPickerOption(text: "上午", value: "Morning"),
        SilkPickerOption(text: "下午", value: "Afternoon"),
        SilkPickerOption(text: "晚上", value: "Evening")
    ])
]

SilkPicker(
    columns: ObservedArrayList(columns),
    options: SilkPickerOptions(title: "选择时间")
)
```

## 级联选择

```cangjie
let cascadeOptions = [
    SilkPickerOption(
        text: "浙江",
        value: "Zhejiang",
        children: [
            SilkPickerOption(
                text: "杭州",
                value: "Hangzhou",
                children: [
                    SilkPickerOption(text: "西湖区", value: "Xihu"),
                    SilkPickerOption(text: "余杭区", value: "Yuhang")
                ]
            ),
            SilkPickerOption(
                text: "温州",
                value: "Wenzhou",
                children: [
                    SilkPickerOption(text: "鹿城区", value: "Lucheng"),
                    SilkPickerOption(text: "瓯海区", value: "Ouhai")
                ]
            )
        ]
    )
]

let columns = [SilkPickerColumn(cascadeOptions)]

SilkPicker(
    columns: ObservedArrayList(columns),
    options: SilkPickerOptions(title: "选择地区")
)
```

## 禁用选项

```cangjie
let options = [
    SilkPickerOption(text: "杭州", value: "Hangzhou", disabled: true),
    SilkPickerOption(text: "宁波", value: "Ningbo"),
    SilkPickerOption(text: "温州", value: "Wenzhou")
]

let columns = [SilkPickerColumn(options)]

SilkPicker(
    columns: ObservedArrayList(columns),
    options: SilkPickerOptions()
)
```

## 加载状态

```cangjie
@State var pickerOptions = SilkPickerOptions()

// 显示加载状态
pickerOptions.loading = true

SilkPicker(
    columns: ObservedArrayList(columns),
    options: pickerOptions
)
```

## 双向绑定

```cangjie
@State var selectedValues: ObservedArrayList<String> = ObservedArrayList([])

SilkPickerLink(
    values: selectedValues,
    columns: ObservedArrayList(columns),
    options: SilkPickerOptions()
)
```

## 搭配弹出层使用

```cangjie
@State var showPicker: Bool = false

SilkCell(
    props: SilkCellOptions(title: "选择城市", value: "内容", isLink: true)
).onClick { 
    showPicker = true 
}

SilkPopup(
    show: showPicker,
    props: SilkPopupOptions(position: SilkPopupPosition.BOTTOM, round: true)
) {
    SilkPicker(
        columns: ObservedArrayList(columns),
        options: SilkPickerOptions(title: "选择城市"),
        confirm: { values, indexes => 
            showPicker = false
            // 处理选择结果
        },
        cancel: { => showPicker = false }
    )
}
```

## API

### SilkPicker Props

| 参数      | 说明       | 类型                                                                           | 默认值  |
|---------|----------|------------------------------------------------------------------------------|------|
| columns | 选择器列配置   | `ObservedArrayList<SilkPickerColumn>`                                        | `[]` |
| options | 选择器配置选项  | `SilkPickerOptions`                                                          | -    |
| confirm | 确认按钮点击回调 | `(values: Array<String>, indexes: Array<Int32>) -> Unit`                     | -    |
| cancel  | 取消按钮点击回调 | `() -> Unit`                                                                 | -    |
| change  | 选项改变回调   | `(values: Array<String>, indexes: Array<Int32>, columnIndex: Int64) -> Unit` | -    |

### SilkPickerOptions Props

| 参数                | 说明       | 类型            | 默认值            |
|-------------------|----------|---------------|----------------|
| title             | 选择器标题    | `ResourceStr` | `String.empty` |
| confirmButtonText | 确认按钮文字   | `ResourceStr` | `"确认"`         |
| cancelButtonText  | 取消按钮文字   | `ResourceStr` | `"取消"`         |
| toolbarPosition   | 工具栏位置    | `Bool`        | `true`（顶部）     |
| loading           | 是否显示加载状态 | `Bool`        | `false`        |
| loadingText       | 加载提示文字   | `ResourceStr` | `"加载中..."`     |
| readonly          | 是否只读     | `Bool`        | `false`        |
| itemHeight        | 选项高度     | `Length`      | `44.vp`        |
| visibleItemCount  | 可见选项数量   | `Int32`       | `6`            |
| swipeDuration     | 惯性滚动时长   | `Int32`       | `1000`         |

### SilkPickerColumn Props

| 参数      | 说明    | 类型                        | 默认值  |
|---------|-------|---------------------------|------|
| options | 列选项列表 | `Array<SilkPickerOption>` | `[]` |

### SilkPickerOption Props

| 参数       | 说明        | 类型                        | 默认值       |
|----------|-----------|---------------------------|-----------|
| text     | 选项文本      | `ResourceStr`             | -         |
| value    | 选项值       | `ResourceStr`             | 与 text 相同 |
| disabled | 是否禁用      | `Bool`                    | `false`   |
| children | 子选项列表（级联） | `Array<SilkPickerOption>` | `[]`      |

### SilkPickerLink Props

| 参数      | 说明       | 类型                                    | 默认值  |
|---------|----------|---------------------------------------|------|
| values  | 双向绑定的选中值 | `ObservedArrayList<String>`           | -    |
| columns | 选择器列配置   | `ObservedArrayList<SilkPickerColumn>` | `[]` |
| options | 选择器配置选项  | `SilkPickerOptions`                   | -    |

## 事件

### confirm

确认按钮点击时触发

```cangjie
confirm: { values, indexes => 
    // values: Array<String> - 选中的值数组
    // indexes: Array<Int32> - 选中的索引数组
}
```

### cancel

取消按钮点击时触发

```cangjie
cancel: { => 
    // 处理取消逻辑
}
```

### change

选项改变时触发

```cangjie
change: { values, indexes, columnIndex => 
    // values: Array<String> - 当前选中的值数组
    // indexes: Array<Int32> - 当前选中的索引数组  
    // columnIndex: Int64 - 改变的列索引
}
```

## 主题定制

Picker 组件的样式可以通过以下 CSS 变量进行定制：

| CSS 变量                              | 说明       | 默认值       |
|-------------------------------------|----------|-----------|
| --picker-background                 | 选择器背景色   | `#ffffff` |
| --picker-toolbar-height             | 工具栏高度    | `44px`    |
| --picker-option-font-size           | 选项字体大小   | `16px`    |
| --picker-option-text-color          | 选项文字颜色   | `#323233` |
| --picker-option-disabled-text-color | 禁用选项文字颜色 | `#aaaaaa` |
| --picker-loading-icon-color         | 加载图标颜色   | `#1989fa` |
| --picker-action-padding             | 操作按钮内边距  | `0 16px`  |
| --picker-action-font-size           | 操作按钮字体大小 | `14px`    |
| --picker-confirm-action-color       | 确认按钮颜色   | `#1989fa` |
| --picker-cancel-action-color        | 取消按钮颜色   | `#969799` |

## 注意事项

1. **级联模式检测**：组件会自动检测数据结构，如果第一列选项包含 `children` 则启用级联模式
2. **禁用选项处理**：禁用选项会自动跳过，确保用户无法选择到禁用状态的选项
3. **性能优化**：大数据量时建议使用虚拟滚动，避免性能问题
4. **响应式更新**：`loading` 属性使用 `@Publish` 装饰器，支持动态更新
5. **触摸交互**：支持滑动、惯性滚动和点击选择，提供流畅的用户体验

## 更新日志

### v1.0.0

- 🎉 新增 Picker 选择器组件
- ✨ 支持单列、多列和级联选择
- ✨ 支持禁用选项功能
- ✨ 支持3D视觉效果
- ✨ 支持触摸交互和惯性滚动
- ✨ 支持双向数据绑定
- ✨ 支持加载状态显示 