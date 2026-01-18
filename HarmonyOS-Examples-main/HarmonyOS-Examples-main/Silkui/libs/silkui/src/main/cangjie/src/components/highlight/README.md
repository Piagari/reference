# HighLight 文本高亮

### 介绍

文本高亮组件用于在文本中突出显示特定的关键词，常用于搜索结果展示等场景。

### 引入

```js
import silkui.component.highlight.SilkHighLight
```

## 代码演示

### 基础用法

通过 `sourceString` 属性设置原始文本，通过 `keywords` 属性设置需要高亮的关键词。

```js
SilkHighLight(
    props: SilkHighLightOptions(
        sourceString: "慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。",
        keywords: ["难题"]
    )
)
```

### 多个关键词

可以同时高亮多个关键词。

```js
SilkHighLight(
    props: SilkHighLightOptions(
        sourceString: "慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。",
        keywords: ["难题", "终有一天", "答案"]
    )
)
```

### 自定义高亮样式

通过 `color`、`fontSize` 和 `fontWeight` 属性可以自定义高亮文本的样式。

```js
SilkHighLight(
    props: SilkHighLightOptions(
        sourceString: "慢慢来，不要急，生活给你出了难题，可也终有一天会给出答案。",
        keywords: ["生活"],
        color: Color.RED
    )
)
```


## API

### Props

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| props | 高亮配置选项 | `SilkHighLightOptions` | - | `@Prop` |

#### SilkHighLightOptions

| 参数 | 说明 | 类型 | 默认值 | 装饰器 |
| --- | --- | --- | --- | --- |
| sourceString | 原始文本 | `String` | - | `let` |
| keywords | 需要高亮的关键词数组 | `Option<ArrayList<String>>` | - | `let` |
| color | 高亮文本颜色 | `ResourceColor` | `PRIMARY_COLOR` | `let` |
| fontSize | 高亮文本字体大小 | `Length` | `14.vp` | `let` |
| fontWeight | 高亮文本字体粗细 | `FontWeight` | `FontWeight.W500` | `let` |
| defaultColor | 普通文本颜色 | `ResourceColor` | `TEXT_COLOR` | `let` |
| defaultFontSize | 普通文本字体大小 | `Length` | `14.vp` | `let` |
| defaultFontWeight | 普通文本字体粗细 | `FontWeight` | `FontWeight.W400` | `let` |
| caseSensitive | 是否区分大小写 | `Bool` | `false` | `let` |
| autoEscape | 是否自动转义特殊字符 | `Bool` | `true` | `let` |

### 内部类型

```js
struct SilkHighLightChunk {
    public let high: Bool  // 是否为高亮文本
    public let text: String  // 文本内容
}
```

### 使用说明

1. 当没有提供关键词或关键词数组为空时，将显示原始文本而不进行高亮处理。
2. 高亮处理会保留原始文本的格式和顺序，只对匹配的关键词部分应用高亮样式。
3. 自动转义功能会处理关键词中的特殊字符，如 `*`、`.`、`?` 等，避免被误解为正则表达式。
4. 组件内部会将文本分割为多个文本块（SilkHighLightChunk），每个块可能是高亮或非高亮状态。

## 主题定制

### 样式变量

组件提供了以下变量，可用于自定义样式，使用方法请参考[主题定制](../../docs/content/guide/theme.md)。

#### 颜色变量

| 变量名                          | 默认值                    | 说明     |
|------------------------------|------------------------|--------|
| `--silk-highlight-tag-color` | `--silk-primary-color` | 高亮文本颜色 |

### 定制示例

```js
// 修改高亮文本颜色
import silkui.constants.SilkHighLightColorConstants
import silkui.constants.SilkHighLightColorKey
import silkui.constants.updateHighLightColorConstant

// 修改高亮文本颜色
updateHighLightColorConstant(SilkHighLightColorKey.HIGHLIGHT_TAG_COLOR, Color(255, 0, 0, alpha: 1.0))

// 重置高亮文本常量
import silkui.constants.resetHighLightConstants

// 重置所有高亮文本常量
resetHighLightConstants()
```
