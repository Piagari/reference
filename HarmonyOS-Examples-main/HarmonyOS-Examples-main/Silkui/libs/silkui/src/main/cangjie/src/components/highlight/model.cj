/**
 * Created on 2025/4/28
 *
 * SilkHighLight 文本高亮组件
 *
 * 文本高亮组件用于在文本中突出显示特定的关键词，常用于搜索结果展示等场景。
 *
 * @module silkui/components/highlight
 */
package silkui.components.highlight
internal import ohos.base.*
import std.collection.ArrayList
import ohos.component.FontWeight
import silkui.ResourceColor
import silkui.constants.SilkHighLightColorKey
import silkui.constants.SilkColorKey
import silkui.constants.getHighLightColorConstant
import silkui.constants.getColorConstant

/**
 * 文本高亮配置选项
 *
 * 用于配置文本高亮的各种属性，包括关键词、样式等
 */
public struct SilkHighLightOptions {
    /**
     * 是否自动转义特殊字符
     * 默认为 true
     */
    public let autoEscape: Bool

    /**
     * 是否区分大小写
     * 默认为 false
     */
    public let caseSensitive: Bool

    /**
     * 需要高亮的关键词列表
     * 默认为 None
     */
    public let keywords: ?Array<String>

    /**
     * 源文本内容
     * 默认为空字符串
     */
    public let sourceString: String

    /**
     * 高亮文本颜色
     * 默认为预设颜色
     */
    public let color: ResourceColor

    /**
     * 高亮文本字号
     * 默认为 16vp
     */
    public let fontSize: Length

    /**
     * 高亮文本字重
     * 默认为 FontWeight.W400
     */
    public let fontWeight: FontWeight

    /**
     * 普通文本颜色
     * 默认为预设颜色
     */
    public let defaultColor: ResourceColor

    /**
     * 普通文本字号
     * 默认为 16vp
     */
    public let defaultFontSize: Length

    /**
     * 普通文本字重
     * 默认为 FontWeight.W400
     */
    public let defaultFontWeight: FontWeight
    /**
     * 创建文本高亮配置选项
     *
     * @param autoEscape 是否自动转义特殊字符，默认为 true
     * @param caseSensitive 是否区分大小写，默认为 false
     * @param keywords 需要高亮的关键词列表，默认为 None
     * @param sourceString 源文本内容，默认为空字符串
     * @param color 高亮文本颜色，默认为预设颜色
     * @param fontSize 高亮文本字号，默认为 16vp
     * @param fontWeight 高亮文本字重，默认为 FontWeight.W400
     * @param defaultColor 普通文本颜色，默认为预设颜色
     * @param defaultFontSize 普通文本字号，默认为 16vp
     * @param defaultFontWeight 普通文本字重，默认为 FontWeight.W400
     */
    public init (
        autoEscape!: Bool = true,
        caseSensitive!: Bool = false,
        keywords!: ?Array<String> = Option.None,
        sourceString!: String = String.empty,
        color!: ResourceColor = getHighLightColorConstant(SilkHighLightColorKey.HIGHLIGHT_TAG_COLOR),
        fontSize!: Length = 16.vp,
        fontWeight!: FontWeight = FontWeight.W400,
        defaultColor!: ResourceColor = getColorConstant(SilkColorKey.TEXT_COLOR_2),
        defaultFontSize!: Length = 16.vp,
        defaultFontWeight!: FontWeight = FontWeight.W400
    ) {
        this.autoEscape = autoEscape
        this.caseSensitive = caseSensitive
        this.keywords = keywords
        this.sourceString = sourceString
        this.color = color
        this.fontSize = fontSize
        this.fontWeight = fontWeight
        this.defaultColor = defaultColor
        this.defaultFontSize = defaultFontSize
        this.defaultFontWeight = defaultFontWeight
    }
}

/**
 * 文本高亮片段
 *
 * 表示文本中的一个片段，可能是高亮的或普通的
 */
public struct SilkHighLightChunk {
    /**
     * 是否为高亮片段
     */
    public let high: Bool

    /**
     * 片段文本内容
     */
    public let text: String

    /**
     * 创建文本高亮片段
     *
     * @param high 是否为高亮片段
     * @param text 片段文本内容
     */
    public init (
        high!: Bool,
        text!: String
    ) {
        this.high = high
        this.text = text
    }
}