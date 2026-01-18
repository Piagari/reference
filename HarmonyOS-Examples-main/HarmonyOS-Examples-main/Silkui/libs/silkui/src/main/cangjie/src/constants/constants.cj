/**
 * Created on 2025/4/28
 * 这里定义全局样式变量
 */
package silkui.constants
internal import ohos.base.*
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import ohos.component.FontWeight
import std.collection.HashMap
import cj_res_silkui.*
import silkui.SilkUILinearGradientOptions
import silkui.ResourceColor
import silkui.ResourceStr

/**
 * 颜色常量枚举
 */
public enum SilkColorKey {
    // 基础颜色
    | BLACK
    | WHITE
    | GRAY_1
    | GRAY_2
    | GRAY_3
    | GRAY_4
    | GRAY_5
    | GRAY_6
    | GRAY_7
    | GRAY_8
    | RED
    | BLUE
    | ORANGE
    | ORANGE_DARK
    | ORANGE_LIGHT
    | GREEN

    // 组件颜色
    | PRIMARY_COLOR
    | SUCCESS_COLOR
    | DANGER_COLOR
    | WARNING_COLOR
    | TEXT_COLOR
    | TEXT_COLOR_2
    | TEXT_COLOR_3
    | ACTIVE_COLOR
    | BACKGROUND
    | BACKGROUND_2
    | OVERALAY_BACKGROUND

    // 边框颜色
    | BORDER_COLOR
    | TRANSPARENT
}

/**
 * 将颜色枚举转换为字符串
 * @param key 颜色枚举值
 * @return 对应的字符串键
 */
private func colorKeyToString(key: SilkColorKey): String {
    match (key) {
        // 基础颜色
        case SilkColorKey.BLACK => "--silk-black"
        case SilkColorKey.WHITE => "--silk-white"
        case SilkColorKey.GRAY_1 => "--silk-gray-1"
        case SilkColorKey.GRAY_2 => "--silk-gray-2"
        case SilkColorKey.GRAY_3 => "--silk-gray-3"
        case SilkColorKey.GRAY_4 => "--silk-gray-4"
        case SilkColorKey.GRAY_5 => "--silk-gray-5"
        case SilkColorKey.GRAY_6 => "--silk-gray-6"
        case SilkColorKey.GRAY_7 => "--silk-gray-7"
        case SilkColorKey.GRAY_8 => "--silk-gray-8"
        case SilkColorKey.RED => "--silk-red"
        case SilkColorKey.BLUE => "--silk-blue"
        case SilkColorKey.ORANGE => "--silk-orange"
        case SilkColorKey.ORANGE_DARK => "--silk-orange-dark"
        case SilkColorKey.ORANGE_LIGHT => "--silk-orange-light"
        case SilkColorKey.GREEN => "--silk-green"

        // 组件颜色
        case SilkColorKey.PRIMARY_COLOR => "--silk-primary-color"
        case SilkColorKey.SUCCESS_COLOR => "--silk-success-color"
        case SilkColorKey.DANGER_COLOR => "--silk-danger-color"
        case SilkColorKey.WARNING_COLOR => "--silk-warning-color"
        case SilkColorKey.TEXT_COLOR => "--silk-text-color"
        case SilkColorKey.TEXT_COLOR_2 => "--silk-text-color-2"
        case SilkColorKey.TEXT_COLOR_3 => "--silk-text-color-3"
        case SilkColorKey.ACTIVE_COLOR => "--silk-active-color"
        case SilkColorKey.BACKGROUND => "--silk-background"
        case SilkColorKey.BACKGROUND_2 => "--silk-background-2"
        case SilkColorKey.OVERALAY_BACKGROUND => "--silk-overlay-background"
        // 边框颜色
        case SilkColorKey.BORDER_COLOR => "--silk-border-color"
        case SilkColorKey.TRANSPARENT => "--silk-transpanent"
    }
}

/**
 * 样式常量枚举
 */
public enum SilkStyleKey {
    // 字体
    | BASE_FONT
    | PRICE_FONT

    // 动画
    | EASE_OUT
    | EASE_IN
}

/**
 * 将样式枚举转换为字符串
 * @param key 样式枚举值
 * @return 对应的字符串键
 */
private func styleKeyToString(key: SilkStyleKey): String {
    match (key) {
        // 字体
        case SilkStyleKey.BASE_FONT => "--silk-base-font"
        case SilkStyleKey.PRICE_FONT => "--silk-price-font"

        // 动画
        case SilkStyleKey.EASE_OUT => "--silk-ease-out"
        case SilkStyleKey.EASE_IN => "--silk-ease-in"
    }
}

/**
 * 渐变颜色常量枚举
 */
public enum SilkGradientKey {
    | GRADIENT_TOP
    | GRADIENT_BOTTOM
}

/**
 * 将渐变颜色枚举转换为字符串
 * @param key 渐变颜色枚举值
 * @return 对应的字符串键
 */
private func gradientKeyToString(key: SilkGradientKey): String {
    match (key) {
        case SilkGradientKey.GRADIENT_TOP => "--silk-gradient-top"
        case SilkGradientKey.GRADIENT_BOTTOM => "--silk-gradient-bottom"
    }
}

/**
 * 文档主题常量枚举
 */
public enum SilkDocThemeKey {
    | DOC_TEXT_COLOR_1
    | DOC_TEXT_COLOR_2
    | DOC_TEXT_COLOR_3
    | DOC_TEXT_COLOR_4
    | DOC_LINK_COLOR
    | DOC_BACKGROUND
    | DOC_BACKGROUND_2
    | DOC_BACKGROUND_3
    | DOC_HEADER_BACKGROUND
    | DOC_BORDER_COLOR
    | DOC_CODE_COLOR
    | DOC_CODE_COMMENT_COLOR
    | DOC_CODE_BACKGROUND
    | DOC_BLOCKQUOTE_COLOR
    | DOC_BLOCKQUOTE_BACKGROUND
}

/**
 * 将文档主题枚举转换为字符串
 * @param key 文档主题枚举值
 * @return 对应的字符串键
 */
private func docThemeKeyToString(key: SilkDocThemeKey): String {
    match (key) {
        case SilkDocThemeKey.DOC_TEXT_COLOR_1 => "--silk-doc-text-color-1"
        case SilkDocThemeKey.DOC_TEXT_COLOR_2 => "--silk-doc-text-color-2"
        case SilkDocThemeKey.DOC_TEXT_COLOR_3 => "--silk-doc-text-color-3"
        case SilkDocThemeKey.DOC_TEXT_COLOR_4 => "--silk-doc-text-color-4"
        case SilkDocThemeKey.DOC_LINK_COLOR => "--silk-doc-link-color"
        case SilkDocThemeKey.DOC_BACKGROUND => "--silk-doc-background"
        case SilkDocThemeKey.DOC_BACKGROUND_2 => "--silk-doc-background-2"
        case SilkDocThemeKey.DOC_BACKGROUND_3 => "--silk-doc-background-3"
        case SilkDocThemeKey.DOC_HEADER_BACKGROUND => "--silk-doc-header-background"
        case SilkDocThemeKey.DOC_BORDER_COLOR => "--silk-doc-border-color"
        case SilkDocThemeKey.DOC_CODE_COLOR => "--silk-doc-code-color"
        case SilkDocThemeKey.DOC_CODE_COMMENT_COLOR => "--silk-doc-code-comment-color"
        case SilkDocThemeKey.DOC_CODE_BACKGROUND => "--silk-doc-code-background"
        case SilkDocThemeKey.DOC_BLOCKQUOTE_COLOR => "--silk-doc-blockquote-color"
        case SilkDocThemeKey.DOC_BLOCKQUOTE_BACKGROUND => "--silk-doc-blockquote-background"
    }
}

/**
 * 数值常量枚举
 */
public enum SilkIntKey {
    | ACTIVE_OPACITY
    | DISABLED_OPACITY
    | DURATION_BASE
    | DURATION_FAST
}

/**
 * 将数值枚举转换为字符串
 * @param key 数值枚举值
 * @return 对应的字符串键
 */
private func intKeyToString(key: SilkIntKey): String {
    match (key) {
        case SilkIntKey.ACTIVE_OPACITY => "--silk-active-opacity"
        case SilkIntKey.DISABLED_OPACITY => "--silk-disabled-opacity"
        case SilkIntKey.DURATION_BASE => "--silk-duration-base"
        case SilkIntKey.DURATION_FAST => "--silk-duration-fast"
    }
}

/**
 * 尺寸常量枚举
 */
public enum SilkSizeKey {
    // 内边距
    | PADDING_BASE
    | PADDING_XS
    | PADDING_SM
    | PADDING_MD
    | PADDING_LG
    | PADDING_XL

    // 字体大小
    | FONT_SIZE_XS
    | FONT_SIZE_SM
    | FONT_SIZE_MD
    | FONT_SIZE_LG
    | LINE_HEIGHT_XS
    | LINE_HEIGHT_SM
    | LINE_HEIGHT_MD
    | LINE_HEIGHT_LG

    // 边框
    | BORDER_WIDTH
    | RADIUS_SM
    | RADIUS_MD
    | RADIUS_LG
    | RADIUS_MAX
}

/**
 * 将尺寸枚举转换为字符串
 * @param key 尺寸枚举值
 * @return 对应的字符串键
 */
private func sizeKeyToString(key: SilkSizeKey): String {
    match (key) {
        // 内边距
        case SilkSizeKey.PADDING_BASE => "--silk-padding-base"
        case SilkSizeKey.PADDING_XS => "--silk-padding-xs"
        case SilkSizeKey.PADDING_SM => "--silk-padding-sm"
        case SilkSizeKey.PADDING_MD => "--silk-padding-md"
        case SilkSizeKey.PADDING_LG => "--silk-padding-lg"
        case SilkSizeKey.PADDING_XL => "--silk-padding-xl"

        // 字体大小
        case SilkSizeKey.FONT_SIZE_XS => "--silk-font-size-xs"
        case SilkSizeKey.FONT_SIZE_SM => "--silk-font-size-sm"
        case SilkSizeKey.FONT_SIZE_MD => "--silk-font-size-md"
        case SilkSizeKey.FONT_SIZE_LG => "--silk-font-size-lg"
        case SilkSizeKey.LINE_HEIGHT_XS => "--silk-line-height-xs"
        case SilkSizeKey.LINE_HEIGHT_SM => "--silk-line-height-sm"
        case SilkSizeKey.LINE_HEIGHT_MD => "--silk-line-height-md"
        case SilkSizeKey.LINE_HEIGHT_LG => "--silk-line-height-lg"

        // 边框
        case SilkSizeKey.BORDER_WIDTH => "--silk-border-width"
        case SilkSizeKey.RADIUS_SM => "--silk-radius-sm"
        case SilkSizeKey.RADIUS_MD => "--silk-radius-md"
        case SilkSizeKey.RADIUS_LG => "--silk-radius-lg"
        case SilkSizeKey.RADIUS_MAX => "--silk-radius-max"
    }
}


// 默认颜色常量，用于重置
private let DefaultSilkColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    // 基础颜色
    ("--silk-black", @r(app.color.silk_black)),
    ("--silk-white", @r(app.color.silk_white)),
    ("--silk-gray-1", @r(app.color.gray_1)),
    ("--silk-gray-2", @r(app.color.gray_2)),
    ("--silk-gray-3", @r(app.color.gray_3)),
    ("--silk-gray-4", @r(app.color.gray_4)),
    ("--silk-gray-5", @r(app.color.gray_5)),
    ("--silk-gray-6", @r(app.color.gray_6)),
    ("--silk-gray-7", @r(app.color.gray_7)),
    ("--silk-gray-8", @r(app.color.gray_8)),
    ("--silk-red", @r(app.color.red)),
    ("--silk-blue", @r(app.color.blue)),
    ("--silk-orange", @r(app.color.orange)),
    ("--silk-orange-dark", @r(app.color.orange_dark)),
    ("--silk-orange-light", @r(app.color.orange_light)),
    ("--silk-green", @r(app.color.green)),

    // 组件颜色
    ("--silk-primary-color", @r(app.color.primary_color)),
    ("--silk-success-color", @r(app.color.success_color)),
    ("--silk-danger-color", @r(app.color.danger_color)),
    ("--silk-warning-color", @r(app.color.warning_color)),
    ("--silk-text-color", @r(app.color.text_color)),
    ("--silk-text-color-2", @r(app.color.text_color_2)),
    ("--silk-text-color-3", @r(app.color.text_color_3)),
    ("--silk-active-color", @r(app.color.active_color)),
    ("--silk-background", @r(app.color.background)),
    ("--silk-background-2", @r(app.color.background_2)),
    ("--silk-overlay-background", @r(app.color.overlay_bg)),
    // 边框颜色
    ("--silk-border-color", @r(app.color.border_color)),
     ("--silk-transpanent", Color.TRANSPARENT)
])

// 颜色相关的常量
private let SilkColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    // 基础颜色
    ("--silk-black", @r(app.color.silk_black)),
    ("--silk-white", @r(app.color.silk_white)),
    ("--silk-gray-1", @r(app.color.gray_1)),
    ("--silk-gray-2", @r(app.color.gray_2)),
    ("--silk-gray-3", @r(app.color.gray_3)),
    ("--silk-gray-4", @r(app.color.gray_4)),
    ("--silk-gray-5", @r(app.color.gray_5)),
    ("--silk-gray-6", @r(app.color.gray_6)),
    ("--silk-gray-7", @r(app.color.gray_7)),
    ("--silk-gray-8", @r(app.color.gray_8)),
    ("--silk-red", @r(app.color.red)),
    ("--silk-blue", @r(app.color.blue)),
    ("--silk-orange", @r(app.color.orange)),
    ("--silk-orange-dark", @r(app.color.orange_dark)),
    ("--silk-orange-light", @r(app.color.orange_light)),
    ("--silk-green", @r(app.color.green)),


    // 组件颜色
    ("--silk-primary-color", @r(app.color.primary_color)),
    ("--silk-success-color", @r(app.color.success_color)),
    ("--silk-danger-color", @r(app.color.danger_color)),
    ("--silk-warning-color", @r(app.color.warning_color)),
    ("--silk-text-color", @r(app.color.text_color)),
    ("--silk-text-color-2", @r(app.color.text_color_2)),
    ("--silk-text-color-3", @r(app.color.text_color_3)),
    ("--silk-active-color", @r(app.color.active_color)),
    ("--silk-background", @r(app.color.background)),
    ("--silk-background-2", @r(app.color.background_2)),
    ("--silk-overlay-background", @r(app.color.overlay_bg)),
    // 边框颜色
    ("--silk-border-color", @r(app.color.border_color)),
     ("--silk-transpanent", Color.TRANSPARENT)
])

// 默认字体和动画相关的常量
private let DefaultSilkStyleConstants: HashMap<String, ResourceStr> = HashMap<String, ResourceStr>([
    // 字体
    ("--silk-base-font", "-apple-system, BlinkMacSystemFont, 'Helvetica Neue', Helvetica, Segoe UI, Arial, Roboto, 'PingFang SC', 'miui', 'Hiragino Sans GB', 'Microsoft Yahei', sans-serif"),
    ("--silk-price-font", "Avenir-Heavy, PingFang SC, Helvetica Neue, Arial, sans-serif"),

    // 动画
    ("--silk-ease-out", "ease-out"),
    ("--silk-ease-in", "ease-in")
])

// 字体和动画相关的常量（不能转换为 Color 类型）
private let SilkStyleConstants: HashMap<String, ResourceStr> = HashMap<String, ResourceStr>([
    // 字体
    ("--silk-base-font", "-apple-system, BlinkMacSystemFont, 'Helvetica Neue', Helvetica, Segoe UI, Arial, Roboto, 'PingFang SC', 'miui', 'Hiragino Sans GB', 'Microsoft Yahei', sans-serif"),
    ("--silk-price-font", "Avenir-Heavy, PingFang SC, Helvetica Neue, Arial, sans-serif"),

    // 动画
    ("--silk-ease-out", "ease-out"),
    ("--silk-ease-in", "ease-in")
])

// 默认渐变颜色
private let DefaultSilkLineraGradientConstants: HashMap<String, SilkUILinearGradientOptions> = HashMap<String, SilkUILinearGradientOptions>([
    ("--silk-gradient-top", SilkUILinearGradientOptions(
                angle: -90.0,
                colors: [(Color(255, 255, 255, alpha: 1.0), 0.0), (Color(247, 248, 250, alpha: 1.0), 1.0)] // f7f8fa
    )),
    ("--silk-gradient-bottom", SilkUILinearGradientOptions(
                angle: 90.0,
                 colors: [(Color(255, 255, 255, alpha: 1.0), 0.0), (Color(247, 248, 250, alpha: 1.0), 1.0)] // f7f8fa
    ))
])

// 渐变颜色
private let SilkLineraGradientConstants: HashMap<String, SilkUILinearGradientOptions> = HashMap<String, SilkUILinearGradientOptions>([
    ("--silk-gradient-top", SilkUILinearGradientOptions(
                angle: -90.0,
                colors: [(Color(255, 255, 255, alpha: 1.0), 0.0), (Color(247, 248, 250, alpha: 1.0), 1.0)] // f7f8fa
    )),
    ("--silk-gradient-bottom", SilkUILinearGradientOptions(
                angle: 90.0,
                 colors: [(Color(255, 255, 255, alpha: 1.0), 0.0), (Color(247, 248, 250, alpha: 1.0), 1.0)] // f7f8fa
    ))
])

// 默认文档主题常量
private let DefaultSilkDocThemeConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-doc-text-color-1", @r(app.color.silk_doc_text_color_1)),
    ("--silk-doc-text-color-2", @r(app.color.silk_doc_text_color_2)),
    ("--silk-doc-text-color-3", @r(app.color.silk_doc_text_color_3)),
    ("--silk-doc-text-color-4", @r(app.color.silk_doc_text_color_4)),
    ("--silk-doc-link-color", @r(app.color.silk_doc_link_color)),
    ("--silk-doc-background", @r(app.color.silk_doc_background)),
    ("--silk-doc-background-2", @r(app.color.silk_doc_background_2)),
    ("--silk-doc-background-3", @r(app.color.silk_doc_background_3)),
    ("--silk-doc-header-background", @r(app.color.silk_doc_header_background)),
    ("--silk-doc-border-color", @r(app.color.silk_doc_border_color)),
    ("--silk-doc-code-color", @r(app.color.silk_doc_code_color)),
    ("--silk-doc-code-comment-color", @r(app.color.silk_doc_code_comment_color)),
    ("--silk-doc-code-background", @r(app.color.silk_doc_code_background)),
    ("--silk-doc-blockquote-color", @r(app.color.silk_doc_blockquote_color)),
    ("--silk-doc-blockquote-background", @r(app.color.silk_doc_blockquote_background))
])

// 文档主题常量
private let SilkDocThemeConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-doc-text-color-1", @r(app.color.silk_doc_text_color_1)),
    ("--silk-doc-text-color-2", @r(app.color.silk_doc_text_color_2)),
    ("--silk-doc-text-color-3", @r(app.color.silk_doc_text_color_3)),
    ("--silk-doc-text-color-4", @r(app.color.silk_doc_text_color_4)),
    ("--silk-doc-link-color", @r(app.color.silk_doc_link_color)),
    ("--silk-doc-background", @r(app.color.silk_doc_background)),
    ("--silk-doc-background-2", @r(app.color.silk_doc_background_2)),
    ("--silk-doc-background-3", @r(app.color.silk_doc_background_3)),
    ("--silk-doc-header-background", @r(app.color.silk_doc_header_background)),
    ("--silk-doc-border-color", @r(app.color.silk_doc_border_color)),
    ("--silk-doc-code-color", @r(app.color.silk_doc_code_color)),
    ("--silk-doc-code-comment-color", @r(app.color.silk_doc_code_comment_color)),
    ("--silk-doc-code-background", @r(app.color.silk_doc_code_background)),
    ("--silk-doc-blockquote-color", @r(app.color.silk_doc_blockquote_color)),
    ("--silk-doc-blockquote-background", @r(app.color.silk_doc_blockquote_background))
])


// 默认数值常量
private let DefaultSilkIntConstants : HashMap<String, Float64> = HashMap<String, Float64>([
        ("--silk-active-opacity", 0.6),
        ("--silk-disabled-opacity", 0.5),
            // 动画时长
        ("--silk-duration-base", 300.0),
        ("--silk-duration-fast", 200.0)
    ])

private let SilkIntConstants : HashMap<String, Float64> = HashMap<String, Float64>([
        ("--silk-active-opacity", 0.6),
        ("--silk-disabled-opacity", 0.5),
            // 动画时长
        ("--silk-duration-base", 300.0),
        ("--silk-duration-fast", 200.0)
    ])
// 默认字重常量
private let __DefaultSilkFontWeight = FontWeight.W600

// 当前字重常量
public var __SilkFontWeight = FontWeight.W600

// 默认尺寸相关的常量
private let DefaultSilkSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    // 内边距
    ("--silk-padding-base", Length(4, unitType: LengthType.vp)),
    ("--silk-padding-xs", Length(8, unitType: LengthType.vp)),
    ("--silk-padding-sm", Length(12, unitType: LengthType.vp)),
    ("--silk-padding-md", Length(16, unitType: LengthType.vp)),
    ("--silk-padding-lg", Length(24, unitType: LengthType.vp)),
    ("--silk-padding-xl", Length(32, unitType: LengthType.vp)),

    // 字体大小
    ("--silk-font-size-xs", Length(10, unitType: LengthType.vp)),
    ("--silk-font-size-sm", Length(12, unitType: LengthType.vp)),
    ("--silk-font-size-md", Length(14, unitType: LengthType.vp)),
    ("--silk-font-size-lg", Length(16, unitType: LengthType.vp)),
    ("--silk-line-height-xs", Length(14, unitType: LengthType.vp)),
    ("--silk-line-height-sm", Length(18, unitType: LengthType.vp)),
    ("--silk-line-height-md", Length(20, unitType: LengthType.vp)),
    ("--silk-line-height-lg", Length(22, unitType: LengthType.vp)),

    // 边框
    ("--silk-border-width", Length(1, unitType: LengthType.vp)),
    ("--silk-radius-sm", Length(2, unitType: LengthType.vp)),
    ("--silk-radius-md", Length(4, unitType: LengthType.vp)),
    ("--silk-radius-lg", Length(8, unitType: LengthType.vp)),
    ("--silk-radius-max", Length(999, unitType: LengthType.vp))
])

// 尺寸相关的常量
private let SilkSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    // 内边距
    ("--silk-padding-base", Length(4, unitType: LengthType.vp)),
    ("--silk-padding-xs", Length(8, unitType: LengthType.vp)),
    ("--silk-padding-sm", Length(12, unitType: LengthType.vp)),
    ("--silk-padding-md", Length(16, unitType: LengthType.vp)),
    ("--silk-padding-lg", Length(24, unitType: LengthType.vp)),
    ("--silk-padding-xl", Length(32, unitType: LengthType.vp)),

    // 字体大小
    ("--silk-font-size-xs", Length(10, unitType: LengthType.vp)),
    ("--silk-font-size-sm", Length(12, unitType: LengthType.vp)),
    ("--silk-font-size-md", Length(14, unitType: LengthType.vp)),
    ("--silk-font-size-lg", Length(16, unitType: LengthType.vp)),
    ("--silk-line-height-xs", Length(14, unitType: LengthType.vp)),
    ("--silk-line-height-sm", Length(18, unitType: LengthType.vp)),
    ("--silk-line-height-md", Length(20, unitType: LengthType.vp)),
    ("--silk-line-height-lg", Length(22, unitType: LengthType.vp)),

    // 边框
    ("--silk-border-width", Length(1, unitType: LengthType.vp)),
    ("--silk-radius-sm", Length(2, unitType: LengthType.vp)),
    ("--silk-radius-md", Length(4, unitType: LengthType.vp)),
    ("--silk-radius-lg", Length(8, unitType: LengthType.vp)),
    ("--silk-radius-max", Length(999, unitType: LengthType.vp))
])

/**
 * 获取颜色常量的值
 * @param key 颜色枚举键
 * @return 对应的颜色值
 */
/**
 * 通过枚举获取颜色常量的值
 * @param key 颜色枚举键
 * @return 对应的颜色值
 */
public func getColorConstant(key: SilkColorKey): ResourceColor {
    let stringKey = colorKeyToString(key)
    return SilkColorConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举获取样式常量的值
 * @param key 样式枚举键
 * @return 对应的样式值
 */
public func getStyleConstant(key: SilkStyleKey): ResourceStr {
    let stringKey = styleKeyToString(key)
    return SilkStyleConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举获取渐变颜色常量的值
 * @param key 渐变颜色枚举键
 * @return 对应的渐变颜色值
 */
public func getGradientConstant(key: SilkGradientKey): SilkUILinearGradientOptions {
    let stringKey = gradientKeyToString(key)
    return SilkLineraGradientConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举获取文档主题常量的值
 * @param key 文档主题枚举键
 * @return 对应的文档主题值
 */
public func getDocThemeConstant(key: SilkDocThemeKey): ResourceColor {
    let stringKey = docThemeKeyToString(key)
    return SilkDocThemeConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举获取数值常量的值
 * @param key 数值枚举键
 * @return 对应的数值
 */
public func getIntConstant(key: SilkIntKey): Float64 {
    let stringKey = intKeyToString(key)
    return SilkIntConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举获取尺寸常量的值
 * @param key 尺寸枚举键
 * @return 对应的尺寸值
 */
public func getSizeConstant(key: SilkSizeKey): Length {
    let stringKey = sizeKeyToString(key)
    return SilkSizeConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateColorConstant(key: SilkColorKey, value: ResourceColor): Bool {
    let stringKey = colorKeyToString(key)
    if (SilkColorConstants.contains(stringKey)) {
        SilkColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举修改样式常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的样式值
 * @return 是否修改成功
 */
public func updateStyleConstant(key: SilkStyleKey, value: ResourceStr): Bool {
    let stringKey = styleKeyToString(key)
    if (SilkStyleConstants.contains(stringKey)) {
        SilkStyleConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举修改渐变颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的渐变颜色值
 * @return 是否修改成功
 */
public func updateGradientConstant(key: SilkGradientKey, value: SilkUILinearGradientOptions): Bool {
    let stringKey = gradientKeyToString(key)
    if (SilkLineraGradientConstants.contains(stringKey)) {
        SilkLineraGradientConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举修改文档主题常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的文档主题值
 * @return 是否修改成功
 */
public func updateDocThemeConstant(key: SilkDocThemeKey, value: ResourceColor): Bool {
    let stringKey = docThemeKeyToString(key)
    if (SilkDocThemeConstants.contains(stringKey)) {
        SilkDocThemeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举修改数值常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的数值
 * @return 是否修改成功
 */
public func updateIntConstant(key: SilkIntKey, value: Float64): Bool {
    let stringKey = intKeyToString(key)
    if (SilkIntConstants.contains(stringKey)) {
        SilkIntConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举修改尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateSizeConstant(key: SilkSizeKey, value: Length): Bool {
    let stringKey = sizeKeyToString(key)
    if (SilkSizeConstants.contains(stringKey)) {
        SilkSizeConstants.put(stringKey, value)
        return true
    }
    return false
}


/**
 * 修改字重常量的值
 * @param value 新的字重值
 */
public func updateFontWeight(value: FontWeight) {
    __SilkFontWeight = value
}

/**
 * 重置所有基础常量为默认值
 *
 * 将所有基础常量重置为初始默认值
 */
public func resetAllConstants() {
    // 重置颜色常量
    resetColorConstants()

    // 重置样式常量
    resetStyleConstants()

    // 重置渐变颜色常量
    resetGradientConstants()

    // 重置文档主题常量
    resetDocThemeConstants()

    // 重置数值常量
    resetIntConstants()

    // 重置字重常量
    resetFontWeight()

    // 重置尺寸常量
    resetSizeConstants()
}

/**
 * 重置所有组件常量为默认值
 *
 * 一键重置所有组件的常量为初始默认值
 */
public func resetAll() {
    // 重置基础常量
    resetAllConstants()

    // 重置按钮常量
    resetButtonConstants()

    // 重置单元格常量
    resetCellConstants()

    // 重置对话框常量
    resetDialogConstants()

    // 重置徽标常量
    resetBadgeConstants()

    // 重置折叠面板常量
    resetCollapseConstants()

    // 重置高亮文本常量
    resetHighLightConstants()

    // 重置图标常量
    resetIconConstants()

    // 重置加载组件常量
    resetLoadingConstants()

    // 重置轻提示常量
    resetToastConstants()

    // 重置弹出层常量
    resetPopupConstants()

    // 重置评分组件常量
    resetRateConstants()
}

/**
 * 重置颜色常量为默认值
 */
public func resetColorConstants() {
    SilkColorConstants.clear()
    for ((key, value) in DefaultSilkColorConstants) {
        SilkColorConstants.put(key, value)
    }
}

/**
 * 重置样式常量为默认值
 */
public func resetStyleConstants() {
    SilkStyleConstants.clear()
    for ((key, value) in DefaultSilkStyleConstants) {
        SilkStyleConstants.put(key, value)
    }
}

/**
 * 重置渐变颜色常量为默认值
 */
public func resetGradientConstants() {
    SilkLineraGradientConstants.clear()
    for ((key, value) in DefaultSilkLineraGradientConstants) {
        SilkLineraGradientConstants.put(key, value)
    }
}

/**
 * 重置文档主题常量为默认值
 */
public func resetDocThemeConstants() {
    SilkDocThemeConstants.clear()
    for ((key, value) in DefaultSilkDocThemeConstants) {
        SilkDocThemeConstants.put(key, value)
    }
}

/**
 * 重置数值常量为默认值
 */
public func resetIntConstants() {
    SilkIntConstants.clear()
    for ((key, value) in DefaultSilkIntConstants) {
        SilkIntConstants.put(key, value)
    }
}

/**
 * 重置字重常量为默认值
 */
public func resetFontWeight() {
    __SilkFontWeight = __DefaultSilkFontWeight
}

/**
 * 重置尺寸常量为默认值
 */
public func resetSizeConstants() {
    SilkSizeConstants.clear()
    for ((key, value) in DefaultSilkSizeConstants) {
        SilkSizeConstants.put(key, value)
    }
}

/**
 * 重置评分组件常量为默认值
 */
public func resetRateConstants() {
    // 重置评分颜色常量
    resetRateColorConstants()

    // 重置评分尺寸常量
    resetRateSizeConstants()

    // 重置评分数值常量
    resetRateIntConstants()
}

