/**
 * Created on 2025/5/5
 *
 * SilkDialog 对话框组件常量定义
 *
 * 本文件定义了对话框组件使用的各种常量，包括尺寸、颜色、字体等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/dialog
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import cj_res_silkui.*
import silkui.ResourceColor
import silkui.ResourceStr
import silkui.SilkUIPaddingOptions
import ohos.component.FontWeight

/**
 * 对话框尺寸常量枚举
 */
public enum SilkDialogSizeKey {
    | DIALOG_WIDTH
    | DIALOG_SMALL_SCREEN_WIDTH
    | DIALOG_FONT_SIZE
    | DIALOG_RADIUS
    | DIALOG_HEADER_LINE_HEIGHT
    | DIALOG_HEADER_PADDING_TOP
    | DIALOG_MESSAGE_PADDING
    | DIALOG_MESSAGE_FONT_SIZE
    | DIALOG_MESSAGE_LINE_HEIGHT
    | DIALOG_MESSAGE_MAX_HEIGHT
    | DIALOG_HAS_TITLE_MESSAGE_PADDING_TOP
    | DIALOG_BUTTON_HEIGHT
    | DIALOG_ROUND_BUTTON_HEIGHT
}

/**
 * 将对话框尺寸枚举转换为字符串
 * @param key 对话框尺寸枚举值
 * @return 对应的字符串键
 */
private func dialogSizeKeyToString(key: SilkDialogSizeKey): String {
    match (key) {
        case SilkDialogSizeKey.DIALOG_WIDTH => "--silk-dialog-width"
        case SilkDialogSizeKey.DIALOG_SMALL_SCREEN_WIDTH => "--silk-dialog-small-screen-width"
        case SilkDialogSizeKey.DIALOG_FONT_SIZE => "--silk-dialog-font-size"
        case SilkDialogSizeKey.DIALOG_RADIUS => "--silk-dialog-radius"
        case SilkDialogSizeKey.DIALOG_HEADER_LINE_HEIGHT => "--silk-dialog-header-line-height"
        case SilkDialogSizeKey.DIALOG_HEADER_PADDING_TOP => "--silk-dialog-header-padding-top"
        case SilkDialogSizeKey.DIALOG_MESSAGE_PADDING => "--silk-dialog-message-padding"
        case SilkDialogSizeKey.DIALOG_MESSAGE_FONT_SIZE => "--silk-dialog-message-font-size"
        case SilkDialogSizeKey.DIALOG_MESSAGE_LINE_HEIGHT => "--silk-dialog-message-line-height"
        case SilkDialogSizeKey.DIALOG_MESSAGE_MAX_HEIGHT => "--silk-dialog-message-max-height"
        case SilkDialogSizeKey.DIALOG_HAS_TITLE_MESSAGE_PADDING_TOP => "--silk-dialog-has-title-message-padding-top"
        case SilkDialogSizeKey.DIALOG_BUTTON_HEIGHT => "--silk-dialog-button-height"
        case SilkDialogSizeKey.DIALOG_ROUND_BUTTON_HEIGHT => "--silk-dialog-round-button-height"
    }
}

/**
 * 对话框颜色常量枚举
 */
public enum SilkDialogColorKey {
    | DIALOG_BACKGROUND
    | DIALOG_HAS_TITLE_MESSAGE_TEXT_COLOR
    | DIALOG_CONFIRM_BUTTON_TEXT_COLOR
}

/**
 * 将对话框颜色枚举转换为字符串
 * @param key 对话框颜色枚举值
 * @return 对应的字符串键
 */
private func dialogColorKeyToString(key: SilkDialogColorKey): String {
    match (key) {
        case SilkDialogColorKey.DIALOG_BACKGROUND => "--silk-dialog-background"
        case SilkDialogColorKey.DIALOG_HAS_TITLE_MESSAGE_TEXT_COLOR => "--silk-dialog-has-title-message-text-color"
        case SilkDialogColorKey.DIALOG_CONFIRM_BUTTON_TEXT_COLOR => "--silk-dialog-confirm-button-text-color"
    }
}

/**
 * 对话框数值常量枚举
 */
public enum SilkDialogNumberKey {
    | DIALOG_TRANSITION
}

/**
 * 将对话框数值枚举转换为字符串
 * @param key 对话框数值枚举值
 * @return 对应的字符串键
 */
private func dialogNumberKeyToString(key: SilkDialogNumberKey): String {
    match (key) {
        case SilkDialogNumberKey.DIALOG_TRANSITION => "--silk-dialog-transition"
    }
}

/**
 * 对话框内边距常量枚举
 */
public enum SilkDialogPaddingKey {
    | DIALOG_HEADER_ISOLATED_PADDING
}

/**
 * 将对话框内边距枚举转换为字符串
 * @param key 对话框内边距枚举值
 * @return 对应的字符串键
 */
private func dialogPaddingKeyToString(key: SilkDialogPaddingKey): String {
    match (key) {
        case SilkDialogPaddingKey.DIALOG_HEADER_ISOLATED_PADDING => "--silk-dialog-header-isolated-padding"
    }
}

/**
 * 默认对话框尺寸常量
 *
 * 定义了对话框的默认尺寸常量，用于重置
 */
private let DefaultSilkDialogSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-dialog-width", Length(320, unitType: LengthType.vp)),
    ("--silk-dialog-small-screen-width", Length(90, unitType: LengthType.percent)),
    ("--silk-dialog-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-dialog-radius", Length(16, unitType: LengthType.vp)),
    ("--silk-dialog-header-line-height", Length(24, unitType: LengthType.vp)),
    ("--silk-dialog-header-padding-top", Length(26, unitType: LengthType.vp)),
    ("--silk-dialog-message-padding", getSizeConstant(SilkSizeKey.PADDING_LG)),
    ("--silk-dialog-message-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-dialog-message-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_MD)),
    ("--silk-dialog-message-max-height", Length(60, unitType: LengthType.percent)),
    ("--silk-dialog-has-title-message-padding-top", getSizeConstant(SilkSizeKey.PADDING_XS)),
    ("--silk-dialog-button-height", Length(48, unitType: LengthType.vp)),
    ("--silk-dialog-round-button-height", Length(36, unitType: LengthType.vp)),
    ("--silk-button-default-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG))
])

/**
 * 对话框尺寸常量
 *
 * 定义了对话框的各种尺寸常量，包括宽度、高度、内边距等
 */
private let SilkDialogSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-dialog-width", Length(320, unitType: LengthType.vp)),
    ("--silk-dialog-small-screen-width", Length(90, unitType: LengthType.percent)),
    ("--silk-dialog-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-dialog-radius", Length(16, unitType: LengthType.vp)),
    ("--silk-dialog-header-line-height", Length(24, unitType: LengthType.vp)),
    ("--silk-dialog-header-padding-top", Length(26, unitType: LengthType.vp)),
    ("--silk-dialog-message-padding", getSizeConstant(SilkSizeKey.PADDING_LG)),
    ("--silk-dialog-message-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-dialog-message-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_MD)),
    ("--silk-dialog-message-max-height", Length(60, unitType: LengthType.percent)),
    ("--silk-dialog-has-title-message-padding-top", getSizeConstant(SilkSizeKey.PADDING_XS)),
    ("--silk-dialog-button-height", Length(48, unitType: LengthType.vp)),
    ("--silk-dialog-round-button-height", Length(36, unitType: LengthType.vp)),
    ("--silk-button-default-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG))
])

/**
 * 默认对话框颜色常量
 *
 * 定义了对话框的默认颜色常量，用于重置
 */
private let DefaultSilkDialogColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-dialog-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-dialog-has-title-message-text-color", getColorConstant(SilkColorKey.GRAY_7)),
    ("--silk-dialog-confirm-button-text-color", getColorConstant(SilkColorKey.PRIMARY_COLOR))
])

/**
 * 对话框颜色常量
 *
 * 定义了对话框的各种颜色常量，包括背景颜色、文字颜色等
 */
private let SilkDialogColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-dialog-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-dialog-has-title-message-text-color", getColorConstant(SilkColorKey.GRAY_7)),
    ("--silk-dialog-confirm-button-text-color", getColorConstant(SilkColorKey.PRIMARY_COLOR))
])

/**
 * 默认对话框数值常量
 *
 * 定义了对话框的默认数值常量，用于重置
 */
private let DefaultSilkDialogNumberConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-dialog-transition", getIntConstant(SilkIntKey.DURATION_BASE))
])

/**
 * 对话框数值常量
 *
 * 定义了对话框的各种数值常量
 */
private let SilkDialogNumberConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-dialog-transition", getIntConstant(SilkIntKey.DURATION_BASE))
])

/**
 * 默认对话框内边距常量
 *
 * 定义了对话框的默认内边距常量，用于重置
 */
private let DefaultSilkDialogPaddingConstants: HashMap<String, SilkUIPaddingOptions> = HashMap<String, SilkUIPaddingOptions>([
    ("--silk-dialog-header-isolated-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_LG),
        right: Length(0, unitType: LengthType.vp),
        bottom: getSizeConstant(SilkSizeKey.PADDING_LG),
        left: Length(0, unitType: LengthType.vp)
    ))
])

/**
 * 对话框内边距常量
 *
 * 定义了对话框的内边距常量
 */
private let SilkDialogPaddingConstants: HashMap<String, SilkUIPaddingOptions> = HashMap<String, SilkUIPaddingOptions>([
    ("--silk-dialog-header-isolated-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_LG),
        right: Length(0, unitType: LengthType.vp),
        bottom: getSizeConstant(SilkSizeKey.PADDING_LG),
        left: Length(0, unitType: LengthType.vp)
    ))
])

/**
 * 默认对话框字体权重常量
 */
private let __DefaultSilkDialogHeaderFontWeight = __SilkFontWeight

/**
 * 对话框字体权重常量
 */
public var __SilkDialogHeaderFontWeight = __SilkFontWeight

/**
 * 通过枚举获取对话框尺寸常量的值
 * @param key 对话框尺寸枚举键
 * @return 对应的尺寸值
 */
public func getDialogSizeConstant(key: SilkDialogSizeKey): Length {
    let stringKey = dialogSizeKeyToString(key)
    return SilkDialogSizeConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改对话框尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateDialogSizeConstant(key: SilkDialogSizeKey, value: Length): Bool {
    let stringKey = dialogSizeKeyToString(key)
    if (SilkDialogSizeConstants.contains(stringKey)) {
        SilkDialogSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取对话框颜色常量的值
 * @param key 对话框颜色枚举键
 * @return 对应的颜色值
 */
public func getDialogColorConstant(key: SilkDialogColorKey): ResourceColor {
    let stringKey = dialogColorKeyToString(key)
    return SilkDialogColorConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改对话框颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateDialogColorConstant(key: SilkDialogColorKey, value: ResourceColor): Bool {
    let stringKey = dialogColorKeyToString(key)
    if (SilkDialogColorConstants.contains(stringKey)) {
        SilkDialogColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取对话框数值常量的值
 * @param key 对话框数值枚举键
 * @return 对应的数值
 */
public func getDialogNumberConstant(key: SilkDialogNumberKey): Float64 {
    let stringKey = dialogNumberKeyToString(key)
    return SilkDialogNumberConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改对话框数值常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的数值
 * @return 是否修改成功
 */
public func updateDialogNumberConstant(key: SilkDialogNumberKey, value: Float64): Bool {
    let stringKey = dialogNumberKeyToString(key)
    if (SilkDialogNumberConstants.contains(stringKey)) {
        SilkDialogNumberConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取对话框内边距常量的值
 * @param key 对话框内边距枚举键
 * @return 对应的内边距值
 */
public func getDialogPaddingConstant(key: SilkDialogPaddingKey): SilkUIPaddingOptions {
    let stringKey = dialogPaddingKeyToString(key)
    return SilkDialogPaddingConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改对话框内边距常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的内边距值
 * @return 是否修改成功
 */
public func updateDialogPaddingConstant(key: SilkDialogPaddingKey, value: SilkUIPaddingOptions): Bool {
    let stringKey = dialogPaddingKeyToString(key)
    if (SilkDialogPaddingConstants.contains(stringKey)) {
        SilkDialogPaddingConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 修改对话框标题字体权重
 * @param value 新的字体权重值
 */
public func updateDialogHeaderFontWeight(value: FontWeight) {
    __SilkDialogHeaderFontWeight = value
}

/**
 * 重置所有对话框常量为默认值
 *
 * 将所有对话框常量重置为初始默认值
 */
public func resetDialogConstants() {
    // 重置对话框尺寸常量
    resetDialogSizeConstants()

    // 重置对话框颜色常量
    resetDialogColorConstants()

    // 重置对话框数值常量
    resetDialogNumberConstants()

    // 重置对话框内边距常量
    resetDialogPaddingConstants()

    // 重置对话框字体权重常量
    resetDialogHeaderFontWeight()
}

/**
 * 重置对话框尺寸常量为默认值
 */
public func resetDialogSizeConstants() {
    SilkDialogSizeConstants.clear()
    for ((key, value) in DefaultSilkDialogSizeConstants) {
        SilkDialogSizeConstants.put(key, value)
    }
}

/**
 * 重置对话框颜色常量为默认值
 */
public func resetDialogColorConstants() {
    SilkDialogColorConstants.clear()
    for ((key, value) in DefaultSilkDialogColorConstants) {
        SilkDialogColorConstants.put(key, value)
    }
}

/**
 * 重置对话框数值常量为默认值
 */
public func resetDialogNumberConstants() {
    SilkDialogNumberConstants.clear()
    for ((key, value) in DefaultSilkDialogNumberConstants) {
        SilkDialogNumberConstants.put(key, value)
    }
}

/**
 * 重置对话框内边距常量为默认值
 */
public func resetDialogPaddingConstants() {
    SilkDialogPaddingConstants.clear()
    for ((key, value) in DefaultSilkDialogPaddingConstants) {
        SilkDialogPaddingConstants.put(key, value)
    }
}

/**
 * 重置对话框字体权重常量为默认值
 */
public func resetDialogHeaderFontWeight() {
    __SilkDialogHeaderFontWeight = __DefaultSilkDialogHeaderFontWeight
}
