/**
 * Created on 2025/7/9
 *
 * SilkPicker 选择器组件常量定义
 *
 * 本文件定义了选择器组件使用的各种常量，包括颜色、尺寸、字体等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/picker
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
import silkui.SilkUILinearGradientOptions
import ohos.component.FontWeight

/**
 * 选择器颜色常量枚举
 */
public enum SilkPickerColorKey {
    | PICKER_BACKGROUND
    | PICKER_CONFIRM_ACTION_COLOR
    | PICKER_CANCEL_ACTION_COLOR
    | PICKER_OPTION_TEXT_COLOR
    | PICKER_LOADING_ICON_COLOR
    | PICKER_LOADING_MASK_COLOR
}

/**
 * 选择器渐变常量枚举
 */
public enum SilkPickerGradientKey {
    | PICKER_MASK_GRADIENT_TOP
    | PICKER_MASK_GRADIENT_BOTTOM
}

/**
 * 将选择器颜色枚举转换为字符串
 * @param key 选择器颜色枚举值
 * @return 对应的字符串键
 */
private func pickerColorKeyToString(key: SilkPickerColorKey): String {
    match (key) {
        case SilkPickerColorKey.PICKER_BACKGROUND => "--silk-picker-background"
        case SilkPickerColorKey.PICKER_CONFIRM_ACTION_COLOR => "--silk-picker-confirm-action-color"
        case SilkPickerColorKey.PICKER_CANCEL_ACTION_COLOR => "--silk-picker-cancel-action-color"
        case SilkPickerColorKey.PICKER_OPTION_TEXT_COLOR => "--silk-picker-option-text-color"
        case SilkPickerColorKey.PICKER_LOADING_ICON_COLOR => "--silk-picker-loading-icon-color"
        case SilkPickerColorKey.PICKER_LOADING_MASK_COLOR => "--silk-picker-loading-mask-color"
    }
}

/**
 * 将选择器渐变枚举转换为字符串
 * @param key 选择器渐变枚举值
 * @return 对应的字符串键
 */
private func pickerGradientKeyToString(key: SilkPickerGradientKey): String {
    match (key) {
        case SilkPickerGradientKey.PICKER_MASK_GRADIENT_TOP => "--silk-picker-mask-gradient-top"
        case SilkPickerGradientKey.PICKER_MASK_GRADIENT_BOTTOM => "--silk-picker-mask-gradient-bottom"
    }
}

/**
 * 选择器尺寸常量枚举
 */
public enum SilkPickerSizeKey {
    | PICKER_TOOLBAR_HEIGHT
    | PICKER_TITLE_FONT_SIZE
    | PICKER_TITLE_LINE_HEIGHT
    | PICKER_ACTION_FONT_SIZE
    | PICKER_OPTION_FONT_SIZE
    | PICKER_OPTION_DISABLED_OPACITY
    | PICKER_ACTION_PADDING_TOP
    | PICKER_ACTION_PADDING_RIGHT
    | PICKER_ACTION_PADDING_BOTTOM
    | PICKER_ACTION_PADDING_LEFT
    | PICKER_OPTION_PADDING_TOP
    | PICKER_OPTION_PADDING_RIGHT
    | PICKER_OPTION_PADDING_BOTTOM
    | PICKER_OPTION_PADDING_LEFT
}

/**
 * 将选择器尺寸枚举转换为字符串
 * @param key 选择器尺寸枚举值
 * @return 对应的字符串键
 */
private func pickerSizeKeyToString(key: SilkPickerSizeKey): String {
    match (key) {
        case SilkPickerSizeKey.PICKER_TOOLBAR_HEIGHT => "--silk-picker-toolbar-height"
        case SilkPickerSizeKey.PICKER_TITLE_FONT_SIZE => "--silk-picker-title-font-size"
        case SilkPickerSizeKey.PICKER_TITLE_LINE_HEIGHT => "--silk-picker-title-line-height"
        case SilkPickerSizeKey.PICKER_ACTION_FONT_SIZE => "--silk-picker-action-font-size"
        case SilkPickerSizeKey.PICKER_OPTION_FONT_SIZE => "--silk-picker-option-font-size"
        case SilkPickerSizeKey.PICKER_OPTION_DISABLED_OPACITY => "--silk-picker-option-disabled-opacity"
        case SilkPickerSizeKey.PICKER_ACTION_PADDING_TOP => "--silk-picker-action-padding-top"
        case SilkPickerSizeKey.PICKER_ACTION_PADDING_RIGHT => "--silk-picker-action-padding-right"
        case SilkPickerSizeKey.PICKER_ACTION_PADDING_BOTTOM => "--silk-picker-action-padding-bottom"
        case SilkPickerSizeKey.PICKER_ACTION_PADDING_LEFT => "--silk-picker-action-padding-left"
        case SilkPickerSizeKey.PICKER_OPTION_PADDING_TOP => "--silk-picker-option-padding-top"
        case SilkPickerSizeKey.PICKER_OPTION_PADDING_RIGHT => "--silk-picker-option-padding-right"
        case SilkPickerSizeKey.PICKER_OPTION_PADDING_BOTTOM => "--silk-picker-option-padding-bottom"
        case SilkPickerSizeKey.PICKER_OPTION_PADDING_LEFT => "--silk-picker-option-padding-left"
    }
}



/**
 * 默认选择器颜色常量
 *
 * 定义了选择器的默认颜色常量，用于重置
 */
private let DefaultSilkPickerColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-picker-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-picker-confirm-action-color", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-picker-cancel-action-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-picker-option-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-picker-loading-icon-color", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-picker-loading-mask-color", Color(255, 255, 255, alpha: 0.9))
])

/**
 * 选择器颜色常量
 *
 * 定义了选择器的各种颜色常量，包括背景颜色、文字颜色等
 */
private let SilkPickerColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-picker-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-picker-confirm-action-color", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-picker-cancel-action-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-picker-option-text-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-picker-loading-icon-color", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-picker-loading-mask-color", Color(255, 255, 255, alpha: 0.9))
])

/**
 * 默认选择器渐变常量
 *
 * 定义了选择器的默认渐变常量，用于重置
 */
private let DefaultSilkPickerGradientConstants: HashMap<String, SilkUILinearGradientOptions> = HashMap<String, SilkUILinearGradientOptions>([
    ("--silk-picker-mask-gradient-top", SilkUILinearGradientOptions(
        angle: 180.0,
        colors: [(Color(255, 255, 255, alpha: 0.9), 0.0), (Color(255, 255, 255, alpha: 0.4), 1.0)]
    )),
    ("--silk-picker-mask-gradient-bottom", SilkUILinearGradientOptions(
        angle: 0.0,
        colors: [(Color(255, 255, 255, alpha: 0.9), 0.0), (Color(255, 255, 255, alpha: 0.4), 1.0)]
    ))
])

/**
 * 选择器渐变常量
 *
 * 定义了选择器的各种渐变常量
 */
private let SilkPickerGradientConstants: HashMap<String, SilkUILinearGradientOptions> = HashMap<String, SilkUILinearGradientOptions>([
    ("--silk-picker-mask-gradient-top", SilkUILinearGradientOptions(
        angle: 180.0,
        colors: [(Color(255, 255, 255, alpha: 0.9), 0.0), (Color(255, 255, 255, alpha: 0.4), 1.0)]
    )),
    ("--silk-picker-mask-gradient-bottom", SilkUILinearGradientOptions(
        angle: 0.0,
        colors: [(Color(255, 255, 255, alpha: 0.9), 0.0), (Color(255, 255, 255, alpha: 0.4), 1.0)]
    ))
])

/**
 * 默认选择器尺寸常量
 *
 * 定义了选择器的默认尺寸常量，用于重置
 */
private let DefaultSilkPickerSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-picker-toolbar-height", Length(44, unitType: LengthType.vp)),
    ("--silk-picker-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-picker-title-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_MD)),
    ("--silk-picker-action-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-picker-option-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-picker-option-disabled-opacity", Length(0.3, unitType: LengthType.percent)),
    ("--silk-picker-action-padding-top", Length(0, unitType: LengthType.vp)),
    ("--silk-picker-action-padding-right", getSizeConstant(SilkSizeKey.PADDING_MD)),
    ("--silk-picker-action-padding-bottom", Length(0, unitType: LengthType.vp)),
    ("--silk-picker-action-padding-left", getSizeConstant(SilkSizeKey.PADDING_MD)),
    ("--silk-picker-option-padding-top", Length(0, unitType: LengthType.vp)),
    ("--silk-picker-option-padding-right", getSizeConstant(SilkSizeKey.PADDING_BASE)),
    ("--silk-picker-option-padding-bottom", Length(0, unitType: LengthType.vp)),
    ("--silk-picker-option-padding-left", getSizeConstant(SilkSizeKey.PADDING_BASE))
])

/**
 * 选择器尺寸常量
 *
 * 定义了选择器的各种尺寸常量，包括大小、字体大小等
 */
private let SilkPickerSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-picker-toolbar-height", Length(44, unitType: LengthType.vp)),
    ("--silk-picker-title-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-picker-title-line-height", getSizeConstant(SilkSizeKey.LINE_HEIGHT_MD)),
    ("--silk-picker-action-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-picker-option-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_LG)),
    ("--silk-picker-option-disabled-opacity", Length(0.3, unitType: LengthType.percent)),
    ("--silk-picker-action-padding-top", Length(0, unitType: LengthType.vp)),
    ("--silk-picker-action-padding-right", getSizeConstant(SilkSizeKey.PADDING_MD)),
    ("--silk-picker-action-padding-bottom", Length(0, unitType: LengthType.vp)),
    ("--silk-picker-action-padding-left", getSizeConstant(SilkSizeKey.PADDING_MD)),
    ("--silk-picker-option-padding-top", Length(0, unitType: LengthType.vp)),
    ("--silk-picker-option-padding-right", getSizeConstant(SilkSizeKey.PADDING_BASE)),
    ("--silk-picker-option-padding-bottom", Length(0, unitType: LengthType.vp)),
    ("--silk-picker-option-padding-left", getSizeConstant(SilkSizeKey.PADDING_BASE))
])



/**
 * 通过枚举获取选择器颜色常量的值
 * @param key 选择器颜色枚举键
 * @return 对应的颜色值
 */
public func getPickerColorConstant(key: SilkPickerColorKey): ResourceColor {
    let stringKey = pickerColorKeyToString(key)
    return SilkPickerColorConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改选择器颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updatePickerColorConstant(key: SilkPickerColorKey, value: ResourceColor): Bool {
    let stringKey = pickerColorKeyToString(key)
    if (SilkPickerColorConstants.contains(stringKey)) {
        SilkPickerColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取选择器尺寸常量的值
 * @param key 选择器尺寸枚举键
 * @return 对应的尺寸值
 */
public func getPickerSizeConstant(key: SilkPickerSizeKey): Length {
    let stringKey = pickerSizeKeyToString(key)
    return SilkPickerSizeConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改选择器尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updatePickerSizeConstant(key: SilkPickerSizeKey, value: Length): Bool {
    let stringKey = pickerSizeKeyToString(key)
    if (SilkPickerSizeConstants.contains(stringKey)) {
        SilkPickerSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取选择器渐变常量的值
 * @param key 选择器渐变枚举键
 * @return 对应的渐变值
 */
public func getPickerGradientConstant(key: SilkPickerGradientKey): SilkUILinearGradientOptions {
    let stringKey = pickerGradientKeyToString(key)
    return SilkPickerGradientConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改选择器渐变常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的渐变值
 * @return 是否修改成功
 */
public func updatePickerGradientConstant(key: SilkPickerGradientKey, value: SilkUILinearGradientOptions): Bool {
    let stringKey = pickerGradientKeyToString(key)
    if (SilkPickerGradientConstants.contains(stringKey)) {
        SilkPickerGradientConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置所有选择器常量为默认值
 *
 * 将所有选择器常量重置为初始默认值
 */
public func resetPickerConstants() {
    // 重置选择器颜色常量
    resetPickerColorConstants()

    // 重置选择器尺寸常量
    resetPickerSizeConstants()

    // 重置选择器渐变常量
    resetPickerGradientConstants()
}

/**
 * 重置选择器颜色常量为默认值
 */
public func resetPickerColorConstants() {
    SilkPickerColorConstants.clear()
    for ((key, value) in DefaultSilkPickerColorConstants) {
        SilkPickerColorConstants.put(key, value)
    }
}

/**
 * 重置选择器尺寸常量为默认值
 */
public func resetPickerSizeConstants() {
    SilkPickerSizeConstants.clear()
    for ((key, value) in DefaultSilkPickerSizeConstants) {
        SilkPickerSizeConstants.put(key, value)
    }
}

/**
 * 重置选择器渐变常量为默认值
 */
public func resetPickerGradientConstants() {
    SilkPickerGradientConstants.clear()
    for ((key, value) in DefaultSilkPickerGradientConstants) {
        SilkPickerGradientConstants.put(key, value)
    }
}


