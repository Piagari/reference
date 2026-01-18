/**
 * Created on 2025/4/28
 *
 * SilkButton 按钮组件常量定义
 *
 * 本文件定义了按钮组件使用的各种常量，包括颜色、尺寸等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/button
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import silkui.ResourceColor
import ohos.resource_manager.Resource
import ohos.state_macro_manage.*
import cj_res_silkui.*

/**
 * 按钮颜色常量枚举
 */
public enum SilkButtonColorKey {
    | BUTTON_DEFAULT_COLOR
    | BUTTON_DEFAULT_BACKGROUND
    | BUTTON_DEFAULT_BORDER_COLOR
    | BUTTON_PRIMARY_COLOR
    | BUTTON_PRIMARY_BACKGROUND
    | BUTTON_PRIMARY_BORDER_COLOR
    | BUTTON_SUCCESS_COLOR
    | BUTTON_SUCCESS_BACKGROUND
    | BUTTON_SUCCESS_BORDER_COLOR
    | BUTTON_DANGER_COLOR
    | BUTTON_DANGER_BACKGROUND
    | BUTTON_DANGER_BORDER_COLOR
    | BUTTON_WARNING_COLOR
    | BUTTON_WARNING_BACKGROUND
    | BUTTON_WARNING_BORDER_COLOR
    | BUTTON_PLAIN_BACKGROUND
}

/**
 * 将按钮颜色枚举转换为字符串
 * @param key 按钮颜色枚举值
 * @return 对应的字符串键
 */
private func buttonColorKeyToString(key: SilkButtonColorKey): String {
    match (key) {
        case SilkButtonColorKey.BUTTON_DEFAULT_COLOR => "--silk-button-default-color"
        case SilkButtonColorKey.BUTTON_DEFAULT_BACKGROUND => "--silk-button-default-background"
        case SilkButtonColorKey.BUTTON_DEFAULT_BORDER_COLOR => "--silk-button-default-border-color"
        case SilkButtonColorKey.BUTTON_PRIMARY_COLOR => "--silk-button-primary-color"
        case SilkButtonColorKey.BUTTON_PRIMARY_BACKGROUND => "--silk-button-primary-background"
        case SilkButtonColorKey.BUTTON_PRIMARY_BORDER_COLOR => "--silk-button-primary-border-color"
        case SilkButtonColorKey.BUTTON_SUCCESS_COLOR => "--silk-button-success-color"
        case SilkButtonColorKey.BUTTON_SUCCESS_BACKGROUND => "--silk-button-success-background"
        case SilkButtonColorKey.BUTTON_SUCCESS_BORDER_COLOR => "--silk-button-success-border-color"
        case SilkButtonColorKey.BUTTON_DANGER_COLOR => "--silk-button-danger-color"
        case SilkButtonColorKey.BUTTON_DANGER_BACKGROUND => "--silk-button-danger-background"
        case SilkButtonColorKey.BUTTON_DANGER_BORDER_COLOR => "--silk-button-danger-border-color"
        case SilkButtonColorKey.BUTTON_WARNING_COLOR => "--silk-button-warning-color"
        case SilkButtonColorKey.BUTTON_WARNING_BACKGROUND => "--silk-button-warning-background"
        case SilkButtonColorKey.BUTTON_WARNING_BORDER_COLOR => "--silk-button-warning-border-color"
        case SilkButtonColorKey.BUTTON_PLAIN_BACKGROUND => "--silk-button-plain-background"
    }
}

/**
 * 按钮数值常量枚举
 */
public enum SilkButtonIntKey {
    | BUTTON_ICON_SIZE
    | BUTTON_DEFAULT_LINE_HEIGHT
    | BUTTON_DISABLED_OPACITY
}

/**
 * 将按钮数值枚举转换为字符串
 * @param key 按钮数值枚举值
 * @return 对应的字符串键
 */
private func buttonIntKeyToString(key: SilkButtonIntKey): String {
    match (key) {
        case SilkButtonIntKey.BUTTON_ICON_SIZE => "--silk-button-icon-size"
        case SilkButtonIntKey.BUTTON_DEFAULT_LINE_HEIGHT => "--silk-button-default-line-height"
        case SilkButtonIntKey.BUTTON_DISABLED_OPACITY => "--silk-button-disabled-opacity"
    }
}

/**
 * 按钮尺寸常量枚举
 */
public enum SilkButtonSizeKey {
    | BUTTON_MINI_HEIGHT
    | BUTTON_MINI_PADDING_TOP
    | BUTTON_MINI_PADDING_BOTTOM
    | BUTTON_MINI_PADDING_LEFT
    | BUTTON_MINI_PADDING_RIGHT
    | BUTTON_MINI_FONT_SIZE
    | BUTTON_SMALL_HEIGHT
    | BUTTON_SMALL_PADDING_TOP
    | BUTTON_SMALL_PADDING_BOTTOM
    | BUTTON_SMALL_PADDING_LEFT
    | BUTTON_SMALL_PADDING_RIGHT
    | BUTTON_SMALL_FONT_SIZE
    | BUTTON_NORMAL_FONT_SIZE
    | BUTTON_NORMAL_PADDING_TOP
    | BUTTON_NORMAL_PADDING_BOTTOM
    | BUTTON_NORMAL_PADDING_LEFT
    | BUTTON_NORMAL_PADDING_RIGHT
    | BUTTON_LARGE_HEIGHT
    | BUTTON_DEFAULT_HEIGHT
    | BUTTON_DEFAULT_FONT_SIZE
    | BUTTON_BORDER_WIDTH
    | BUTTON_RADIUS
    | BUTTON_ROUND_RADIUS
    | BUTTON_LOADING_ICON_SIZE
}

/**
 * 将按钮尺寸枚举转换为字符串
 * @param key 按钮尺寸枚举值
 * @return 对应的字符串键
 */
private func buttonSizeKeyToString(key: SilkButtonSizeKey): String {
    match (key) {
        case SilkButtonSizeKey.BUTTON_MINI_HEIGHT => "--silk-button-mini-height"
        case SilkButtonSizeKey.BUTTON_MINI_PADDING_TOP => "--silk-button-mini-padding-top"
        case SilkButtonSizeKey.BUTTON_MINI_PADDING_BOTTOM => "--silk-button-mini-padding-bottom"
        case SilkButtonSizeKey.BUTTON_MINI_PADDING_LEFT => "--silk-button-mini-padding-left"
        case SilkButtonSizeKey.BUTTON_MINI_PADDING_RIGHT => "--silk-button-mini-padding-right"
        case SilkButtonSizeKey.BUTTON_MINI_FONT_SIZE => "--silk-button-mini-font-size"
        case SilkButtonSizeKey.BUTTON_SMALL_HEIGHT => "--silk-button-small-height"
        case SilkButtonSizeKey.BUTTON_SMALL_PADDING_TOP => "--silk-button-small-padding-top"
        case SilkButtonSizeKey.BUTTON_SMALL_PADDING_BOTTOM => "--silk-button-small-padding-bottom"
        case SilkButtonSizeKey.BUTTON_SMALL_PADDING_LEFT => "--silk-button-small-padding-left"
        case SilkButtonSizeKey.BUTTON_SMALL_PADDING_RIGHT => "--silk-button-small-padding-right"
        case SilkButtonSizeKey.BUTTON_SMALL_FONT_SIZE => "--silk-button-small-font-size"
        case SilkButtonSizeKey.BUTTON_NORMAL_FONT_SIZE => "--silk-button-normal-font-size"
        case SilkButtonSizeKey.BUTTON_NORMAL_PADDING_TOP => "--silk-button-normal-padding-top"
        case SilkButtonSizeKey.BUTTON_NORMAL_PADDING_BOTTOM => "--silk-button-normal-padding-bottom"
        case SilkButtonSizeKey.BUTTON_NORMAL_PADDING_LEFT => "--silk-button-normal-padding-left"
        case SilkButtonSizeKey.BUTTON_NORMAL_PADDING_RIGHT => "--silk-button-normal-padding-right"
        case SilkButtonSizeKey.BUTTON_LARGE_HEIGHT => "--silk-button-large-height"
        case SilkButtonSizeKey.BUTTON_DEFAULT_HEIGHT => "--silk-button-default-height"
        case SilkButtonSizeKey.BUTTON_DEFAULT_FONT_SIZE => "--silk-button-default-font-size"
        case SilkButtonSizeKey.BUTTON_BORDER_WIDTH => "--silk-button-border-width"
        case SilkButtonSizeKey.BUTTON_RADIUS => "--silk-button-radius"
        case SilkButtonSizeKey.BUTTON_ROUND_RADIUS => "--silk-button-round-radius"
        case SilkButtonSizeKey.BUTTON_LOADING_ICON_SIZE => "--silk-button-loading-icon-size"
    }
}
/**
 * 默认按钮颜色常量
 *
 * 定义了按钮的默认颜色，用于重置
 */
private let DefaultSilkButtonColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-button-default-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-button-default-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-button-default-border-color", getColorConstant(SilkColorKey.GRAY_4)),
    ("--silk-button-primary-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-button-primary-background", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-button-primary-border-color", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-button-success-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-button-success-background", getColorConstant(SilkColorKey.SUCCESS_COLOR)),
    ("--silk-button-success-border-color", getColorConstant(SilkColorKey.SUCCESS_COLOR)),
    ("--silk-button-danger-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-button-danger-background", getColorConstant(SilkColorKey.DANGER_COLOR)),
    ("--silk-button-danger-border-color", getColorConstant(SilkColorKey.DANGER_COLOR)),
    ("--silk-button-warning-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-button-warning-background", getColorConstant(SilkColorKey.ORANGE)),
    ("--silk-button-warning-border-color", getColorConstant(SilkColorKey.ORANGE)),
    ("--silk-button-plain-background", getColorConstant(SilkColorKey.TRANSPARENT))
])

/**
 * 按钮颜色常量
 *
 * 定义了按钮的各种颜色，包括文字颜色、背景颜色和边框颜色
 */
private let SilkButtonColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-button-default-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-button-default-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-button-default-border-color", getColorConstant(SilkColorKey.GRAY_4)),
    ("--silk-button-primary-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-button-primary-background", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-button-primary-border-color", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-button-success-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-button-success-background", getColorConstant(SilkColorKey.SUCCESS_COLOR)),
    ("--silk-button-success-border-color", getColorConstant(SilkColorKey.SUCCESS_COLOR)),
    ("--silk-button-danger-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-button-danger-background", getColorConstant(SilkColorKey.DANGER_COLOR)),
    ("--silk-button-danger-border-color", getColorConstant(SilkColorKey.DANGER_COLOR)),
    ("--silk-button-warning-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-button-warning-background", getColorConstant(SilkColorKey.ORANGE)),
    ("--silk-button-warning-border-color", getColorConstant(SilkColorKey.ORANGE)),
    ("--silk-button-plain-background", getColorConstant(SilkColorKey.TRANSPARENT))
])

/**
 * 默认按钮数值常量
 *
 * 定义了按钮的默认数值比例常量，用于重置
 */
private let DefaultSilkButtonIntConstants : HashMap<String, Float64> = HashMap<String, Float64>([
        ("--silk-button-icon-size", 1.2), // 图标倍数
        ("--silk-button-default-line-height", 1.2), // 行高
        ("--silk-button-disabled-opacity", getIntConstant(SilkIntKey.DISABLED_OPACITY))
    ])

/**
 * 按钮数值常量
 *
 * 定义了按钮的各种数值比例常量
 */
private let SilkButtonIntConstants : HashMap<String, Float64> = HashMap<String, Float64>([
        ("--silk-button-icon-size", 1.2), // 图标倍数
        ("--silk-button-default-line-height", 1.2), // 行高
        ("--silk-button-disabled-opacity", getIntConstant(SilkIntKey.DISABLED_OPACITY))
    ])
// 默认尺寸相关的常量
/**
 * 默认按钮尺寸常量
 *
 * 定义了按钮的默认尺寸常量，用于重置
 */
private let DefaultSilkButtonSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-button-mini-height", Length(24, unitType: LengthType.vp)),
    ("--silk-button-mini-padding-top", Length(0, unitType: LengthType.vp)), // --silk-padding-base 对应 4vp
    ("--silk-button-mini-padding-bottom", Length(0, unitType: LengthType.vp)), // --silk-padding-base 对应 4vp
    ("--silk-button-mini-padding-left", getSizeConstant(SilkSizeKey.PADDING_BASE)), // --silk-padding-base 对应 4vp
    ("--silk-button-mini-padding-right", getSizeConstant(SilkSizeKey.PADDING_BASE)), // --silk-padding-base 对应 4vp
    ("--silk-button-mini-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_XS)), // --silk-font-size-xs 对应 10vp
    ("--silk-button-small-height", Length(32, unitType: LengthType.vp)),
    ("--silk-button-small-padding-top", Length(0, unitType: LengthType.vp)), // --silk-padding-xs 对应 8vp
    ("--silk-button-small-padding-bottom", Length(0, unitType: LengthType.vp)), // --silk-padding-xs 对应 8vp
    ("--silk-button-small-padding-left", getSizeConstant(SilkSizeKey.PADDING_XS)), // --silk-padding-xs 对应 8vp
    ("--silk-button-small-padding-right", getSizeConstant(SilkSizeKey.PADDING_XS)), // --silk-padding-xs 对应 8vp
    ("--silk-button-small-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_SM)), // --silk-font-size-sm 对应 12vp
    ("--silk-button-normal-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)), // --silk-font-size-md 对应 14vp
    ("--silk-button-normal-padding-top", Length(0, unitType: LengthType.vp)),
    ("--silk-button-normal-padding-bottom", Length(0, unitType: LengthType.vp)),
    ("--silk-button-normal-padding-left", Length(15, unitType: LengthType.vp)),
    ("--silk-button-normal-padding-right", Length(15, unitType: LengthType.vp)),
    ("--silk-button-large-height", Length(50, unitType: LengthType.vp)),
    ("--silk-button-default-height", Length(44, unitType: LengthType.vp)),
    ("--silk-button-default-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)), // --silk-font-size-lg 对应 16vp
    ("--silk-button-border-width", getSizeConstant(SilkSizeKey.BORDER_WIDTH)), // --silk-border-width 对应 1vp
    ("--silk-button-radius", getSizeConstant(SilkSizeKey.RADIUS_MD)), // --silk-radius-md 对应 4vp
    ("--silk-button-round-radius", getSizeConstant(SilkSizeKey.RADIUS_MAX)), // --silk-radius-max 对应 999vp
    ("--silk-button-loading-icon-size", Length(20, unitType: LengthType.vp))
])

// 尺寸相关的常量
/**
 * 按钮尺寸常量
 *
 * 定义了按钮的各种尺寸常量，包括高度、内边距、字体大小等
 */
private let SilkButtonSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-button-mini-height", Length(24, unitType: LengthType.vp)),
    ("--silk-button-mini-padding-top", Length(0, unitType: LengthType.vp)), // --silk-padding-base 对应 4vp
    ("--silk-button-mini-padding-bottom", Length(0, unitType: LengthType.vp)), // --silk-padding-base 对应 4vp
    ("--silk-button-mini-padding-left", getSizeConstant(SilkSizeKey.PADDING_BASE)), // --silk-padding-base 对应 4vp
    ("--silk-button-mini-padding-right", getSizeConstant(SilkSizeKey.PADDING_BASE)), // --silk-padding-base 对应 4vp
    ("--silk-button-mini-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_XS)), // --silk-font-size-xs 对应 10vp
    ("--silk-button-small-height", Length(32, unitType: LengthType.vp)),
    ("--silk-button-small-padding-top", Length(0, unitType: LengthType.vp)), // --silk-padding-xs 对应 8vp
    ("--silk-button-small-padding-bottom", Length(0, unitType: LengthType.vp)), // --silk-padding-xs 对应 8vp
    ("--silk-button-small-padding-left", getSizeConstant(SilkSizeKey.PADDING_XS)), // --silk-padding-xs 对应 8vp
    ("--silk-button-small-padding-right", getSizeConstant(SilkSizeKey.PADDING_XS)), // --silk-padding-xs 对应 8vp
    ("--silk-button-small-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_SM)), // --silk-font-size-sm 对应 12vp
    ("--silk-button-normal-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)), // --silk-font-size-md 对应 14vp
    ("--silk-button-normal-padding-top", Length(0, unitType: LengthType.vp)),
    ("--silk-button-normal-padding-bottom", Length(0, unitType: LengthType.vp)),
    ("--silk-button-normal-padding-left", Length(15, unitType: LengthType.vp)),
    ("--silk-button-normal-padding-right", Length(15, unitType: LengthType.vp)),
    ("--silk-button-large-height", Length(50, unitType: LengthType.vp)),
    ("--silk-button-default-height", Length(44, unitType: LengthType.vp)),
    ("--silk-button-default-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)), // --silk-font-size-lg 对应 16vp
    ("--silk-button-border-width", getSizeConstant(SilkSizeKey.BORDER_WIDTH)), // --silk-border-width 对应 1vp
    ("--silk-button-radius", getSizeConstant(SilkSizeKey.RADIUS_MD)), // --silk-radius-md 对应 4vp
    ("--silk-button-round-radius", getSizeConstant(SilkSizeKey.RADIUS_MAX)), // --silk-radius-max 对应 999vp
    ("--silk-button-loading-icon-size", Length(20, unitType: LengthType.vp))
])

/**
 * 通过枚举获取按钮颜色常量的值
 * @param key 按钮颜色枚举键
 * @return 对应的颜色值
 */
public func getButtonColorConstant(key: SilkButtonColorKey): ResourceColor {
    let stringKey = buttonColorKeyToString(key)
    return SilkButtonColorConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改按钮颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateButtonColorConstant(key: SilkButtonColorKey, value: ResourceColor): Bool {
    let stringKey = buttonColorKeyToString(key)
    if (SilkButtonColorConstants.contains(stringKey)) {
        SilkButtonColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取按钮尺寸常量的值
 * @param key 按钮尺寸枚举键
 * @return 对应的尺寸值
 */
public func getButtonSizeConstant(key: SilkButtonSizeKey): Length {
    let stringKey = buttonSizeKeyToString(key)
    return SilkButtonSizeConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改按钮尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateButtonSizeConstant(key: SilkButtonSizeKey, value: Length): Bool {
    let stringKey = buttonSizeKeyToString(key)
    if (SilkButtonSizeConstants.contains(stringKey)) {
        SilkButtonSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取按钮数值常量的值
 * @param key 按钮数值枚举键
 * @return 对应的数值
 */
public func getButtonIntConstant(key: SilkButtonIntKey): Float64 {
    let stringKey = buttonIntKeyToString(key)
    return SilkButtonIntConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改按钮数值常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的数值值
 * @return 是否修改成功
 */
public func updateButtonIntConstant(key: SilkButtonIntKey, value: Float64): Bool {
    let stringKey = buttonIntKeyToString(key)
    if (SilkButtonIntConstants.contains(stringKey)) {
        SilkButtonIntConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置所有按钮常量为默认值
 *
 * 将所有按钮常量重置为初始默认值
 */
public func resetButtonConstants() {
    // 重置按钮颜色常量
    resetButtonColorConstants()

    // 重置按钮数值常量
    resetButtonIntConstants()

    // 重置按钮尺寸常量
    resetButtonSizeConstants()
}

/**
 * 重置按钮颜色常量为默认值
 */
public func resetButtonColorConstants() {
    SilkButtonColorConstants.clear()
    for ((key, value) in DefaultSilkButtonColorConstants) {
        SilkButtonColorConstants.put(key, value)
    }
}

/**
 * 重置按钮数值常量为默认值
 */
public func resetButtonIntConstants() {
    SilkButtonIntConstants.clear()
    for ((key, value) in DefaultSilkButtonIntConstants) {
        SilkButtonIntConstants.put(key, value)
    }
}

/**
 * 重置按钮尺寸常量为默认值
 */
public func resetButtonSizeConstants() {
    SilkButtonSizeConstants.clear()
    for ((key, value) in DefaultSilkButtonSizeConstants) {
        SilkButtonSizeConstants.put(key, value)
    }
}