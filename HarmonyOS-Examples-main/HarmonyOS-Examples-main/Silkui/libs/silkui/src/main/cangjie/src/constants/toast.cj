/**
 * Created on 2025/4/28
 *
 * SilkToast 轻提示组件常量定义
 *
 * 本文件定义了轻提示组件使用的各种常量，包括尺寸、颜色、内边距等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/toast
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

/**
 * 轻提示尺寸常量枚举
 */
public enum SilkToastSizeKey {
    | TOAST_MAX_WIDTH
    | TOAST_MIN_WIDTH
    | TOAST_FONT_SIZE
    | TOAST_LINE_HEIGHT
    | TOAST_RADIUS
    | TOAST_ICON_SIZE
    | TOAST_TEXT_MIN_WIDTH
    | TOAST_DEFAULT_WIDTH
    | TOAST_DEFAULT_MIN_HEIGHT
    | TOAST_POSITION_TOP_DISTANCE
    | TOAST_POSITION_BOTTOM_DISTANCE
}

/**
 * 将轻提示尺寸枚举转换为字符串
 * @param key 轻提示尺寸枚举值
 * @return 对应的字符串键
 */
private func toastSizeKeyToString(key: SilkToastSizeKey): String {
    match (key) {
        case SilkToastSizeKey.TOAST_MAX_WIDTH => "--silk-toast-max-width"
        case SilkToastSizeKey.TOAST_MIN_WIDTH => "--silk-toast-min-width"
        case SilkToastSizeKey.TOAST_FONT_SIZE => "--silk-toast-font-size"
        case SilkToastSizeKey.TOAST_LINE_HEIGHT => "--silk-toast-line-height"
        case SilkToastSizeKey.TOAST_RADIUS => "--silk-toast-radius"
        case SilkToastSizeKey.TOAST_ICON_SIZE => "--silk-toast-icon-size"
        case SilkToastSizeKey.TOAST_TEXT_MIN_WIDTH => "--silk-toast-text-min-width"
        case SilkToastSizeKey.TOAST_DEFAULT_WIDTH => "--silk-toast-default-width"
        case SilkToastSizeKey.TOAST_DEFAULT_MIN_HEIGHT => "--silk-toast-default-min-height"
        case SilkToastSizeKey.TOAST_POSITION_TOP_DISTANCE => "--silk-toast-position-top-distance"
        case SilkToastSizeKey.TOAST_POSITION_BOTTOM_DISTANCE => "--silk-toast-position-bottom-distance"
    }
}

/**
 * 轻提示颜色常量枚举
 */
public enum SilkToastColorKey {
    | TOAST_TEXT_COLOR
    | TOAST_LOADING_ICON_COLOR
    | TOAST_BACKGROUND
}

/**
 * 将轻提示颜色枚举转换为字符串
 * @param key 轻提示颜色枚举值
 * @return 对应的字符串键
 */
private func toastColorKeyToString(key: SilkToastColorKey): String {
    match (key) {
        case SilkToastColorKey.TOAST_TEXT_COLOR => "--silk-toast-text-color"
        case SilkToastColorKey.TOAST_LOADING_ICON_COLOR => "--silk-toast-loading-icon-color"
        case SilkToastColorKey.TOAST_BACKGROUND => "--silk-toast-background"
    }
}

/**
 * 轻提示内边距常量枚举
 */
public enum SilkToastPaddingKey {
    | TOAST_TEXT_PADDING
    | TOAST_DEFAULT_PADDING
}

/**
 * 将轻提示内边距枚举转换为字符串
 * @param key 轻提示内边距枚举值
 * @return 对应的字符串键
 */
private func toastPaddingKeyToString(key: SilkToastPaddingKey): String {
    match (key) {
        case SilkToastPaddingKey.TOAST_TEXT_PADDING => "--silk-toast-text-padding"
        case SilkToastPaddingKey.TOAST_DEFAULT_PADDING => "--silk-toast-default-padding"
    }
}

/**
 * 默认轻提示尺寸常量
 *
 * 定义了轻提示的默认尺寸常量，用于重置
 */
private let DefaultSilkToastSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-toast-max-width", Length(70, unitType: LengthType.percent)),
    ("--silk-toast-min-width", Length(96, unitType: LengthType.vp)),
    ("--silk-toast-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-toast-line-height", Length(20, unitType: LengthType.vp)),
    ("--silk-toast-radius", getSizeConstant(SilkSizeKey.RADIUS_LG)),
    ("--silk-toast-icon-size", Length(36, unitType: LengthType.vp)),
    ("--silk-toast-text-min-width", Length(96, unitType: LengthType.vp)),
    ("--silk-toast-default-width", Length(88, unitType: LengthType.vp)),
    ("--silk-toast-default-min-height", Length(88, unitType: LengthType.vp)),
    ("--silk-toast-position-top-distance", Length(20, unitType: LengthType.percent)),
    ("--silk-toast-position-bottom-distance", Length(20, unitType: LengthType.percent))
])

/**
 * 轻提示尺寸常量
 *
 * 定义了轻提示的各种尺寸常量，包括宽度、高度、字体大小等
 */
private let SilkToastSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-toast-max-width", Length(70, unitType: LengthType.percent)),
    ("--silk-toast-min-width", Length(96, unitType: LengthType.vp)),
    ("--silk-toast-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD)),
    ("--silk-toast-line-height", Length(20, unitType: LengthType.vp)),
    ("--silk-toast-radius", getSizeConstant(SilkSizeKey.RADIUS_LG)),
    ("--silk-toast-icon-size", Length(36, unitType: LengthType.vp)),
    ("--silk-toast-text-min-width", Length(96, unitType: LengthType.vp)),
    ("--silk-toast-default-width", Length(88, unitType: LengthType.vp)),
    ("--silk-toast-default-min-height", Length(88, unitType: LengthType.vp)),
    ("--silk-toast-position-top-distance", Length(20, unitType: LengthType.percent)),
    ("--silk-toast-position-bottom-distance", Length(20, unitType: LengthType.percent))
])

/**
 * 默认轻提示颜色常量
 *
 * 定义了轻提示的默认颜色常量，用于重置
 */
private let DefaultSilkToastColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-toast-text-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-toast-loading-icon-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-toast-background", @r(app.color.overlay_bg))
])

/**
 * 轻提示颜色常量
 *
 * 定义了轻提示的各种颜色常量，包括文字颜色、背景颜色等
 */
private let SilkToastColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-toast-text-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-toast-loading-icon-color", getColorConstant(SilkColorKey.WHITE)),
    ("--silk-toast-background", @r(app.color.overlay_bg))
])

/**
 * 默认轻提示内边距常量
 *
 * 定义了轻提示的默认内边距常量，用于重置
 */
private let DefaultSilkToastPaddingConstants: HashMap<String, SilkUIPaddingOptions> = HashMap<String, SilkUIPaddingOptions>([
    ("--silk-toast-text-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_XS),
        right: getSizeConstant(SilkSizeKey.PADDING_SM),
        bottom: getSizeConstant(SilkSizeKey.PADDING_XS),
        left: getSizeConstant(SilkSizeKey.PADDING_SM)
    )),
    ("--silk-toast-default-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_MD),
        right: getSizeConstant(SilkSizeKey.PADDING_MD),
        bottom: getSizeConstant(SilkSizeKey.PADDING_MD),
        left: getSizeConstant(SilkSizeKey.PADDING_MD)
    ))
])

/**
 * 轻提示内边距常量
 *
 * 定义了轻提示的各种内边距常量
 */
private let SilkToastPaddingConstants: HashMap<String, SilkUIPaddingOptions> = HashMap<String, SilkUIPaddingOptions>([
    ("--silk-toast-text-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_XS),
        right: getSizeConstant(SilkSizeKey.PADDING_SM),
        bottom: getSizeConstant(SilkSizeKey.PADDING_XS),
        left: getSizeConstant(SilkSizeKey.PADDING_SM)
    )),
    ("--silk-toast-default-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_MD),
        right: getSizeConstant(SilkSizeKey.PADDING_MD),
        bottom: getSizeConstant(SilkSizeKey.PADDING_MD),
        left: getSizeConstant(SilkSizeKey.PADDING_MD)
    ))
])

/**
 * 通过枚举获取轻提示尺寸常量的值
 * @param key 轻提示尺寸枚举键
 * @return 对应的尺寸值
 */
public func getToastSizeConstant(key: SilkToastSizeKey): Length {
    let stringKey = toastSizeKeyToString(key)
    return SilkToastSizeConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改轻提示尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateToastSizeConstant(key: SilkToastSizeKey, value: Length): Bool {
    let stringKey = toastSizeKeyToString(key)
    if (SilkToastSizeConstants.contains(stringKey)) {
        SilkToastSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取轻提示颜色常量的值
 * @param key 轻提示颜色枚举键
 * @return 对应的颜色值
 */
public func getToastColorConstant(key: SilkToastColorKey): ResourceColor {
    let stringKey = toastColorKeyToString(key)
    return SilkToastColorConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改轻提示颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateToastColorConstant(key: SilkToastColorKey, value: ResourceColor): Bool {
    let stringKey = toastColorKeyToString(key)
    if (SilkToastColorConstants.contains(stringKey)) {
        SilkToastColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取轻提示内边距常量的值
 * @param key 轻提示内边距枚举键
 * @return 对应的内边距值
 */
public func getToastPaddingConstant(key: SilkToastPaddingKey): SilkUIPaddingOptions {
    let stringKey = toastPaddingKeyToString(key)
    return SilkToastPaddingConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改轻提示内边距常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的内边距值
 * @return 是否修改成功
 */
public func updateToastPaddingConstant(key: SilkToastPaddingKey, value: SilkUIPaddingOptions): Bool {
    let stringKey = toastPaddingKeyToString(key)
    if (SilkToastPaddingConstants.contains(stringKey)) {
        SilkToastPaddingConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置所有轻提示常量为默认值
 *
 * 将所有轻提示常量重置为初始默认值
 */
public func resetToastConstants() {
    // 重置轻提示尺寸常量
    resetToastSizeConstants()

    // 重置轻提示颜色常量
    resetToastColorConstants()

    // 重置轻提示内边距常量
    resetToastPaddingConstants()
}

/**
 * 重置轻提示尺寸常量为默认值
 */
public func resetToastSizeConstants() {
    SilkToastSizeConstants.clear()
    for ((key, value) in DefaultSilkToastSizeConstants) {
        SilkToastSizeConstants.put(key, value)
    }
}

/**
 * 重置轻提示颜色常量为默认值
 */
public func resetToastColorConstants() {
    SilkToastColorConstants.clear()
    for ((key, value) in DefaultSilkToastColorConstants) {
        SilkToastColorConstants.put(key, value)
    }
}

/**
 * 重置轻提示内边距常量为默认值
 */
public func resetToastPaddingConstants() {
    SilkToastPaddingConstants.clear()
    for ((key, value) in DefaultSilkToastPaddingConstants) {
        SilkToastPaddingConstants.put(key, value)
    }
}
