/**
 * Created on 2025/5/5
 *
 * SilkPopup 弹出层组件常量定义
 *
 * 本文件定义了弹出层组件使用的各种常量，包括背景颜色、过渡动画、圆角半径等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/popup
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import silkui.ResourceColor
import ohos.state_macro_manage.*
import ohos.resource_manager.*
import cj_res_silkui.*

/**
 * 弹出层尺寸常量枚举
 */
public enum SilkPopupSizeKey {
    | POPUP_ROUND_RADIUS
    | POPUP_CLOSE_ICON_SIZE
    | POPUP_CLOSE_ICON_MARGIN
}

/**
 * 将弹出层尺寸枚举转换为字符串
 * @param key 弹出层尺寸枚举值
 * @return 对应的字符串键
 */
private func popupSizeKeyToString(key: SilkPopupSizeKey): String {
    match (key) {
        case SilkPopupSizeKey.POPUP_ROUND_RADIUS => "--silk-popup-round-radius"
        case SilkPopupSizeKey.POPUP_CLOSE_ICON_SIZE => "--silk-popup-close-icon-size"
        case SilkPopupSizeKey.POPUP_CLOSE_ICON_MARGIN => "--silk-popup-close-icon-margin"
    }
}

/**
 * 弹出层颜色常量枚举
 */
public enum SilkPopupColorKey {
    | POPUP_BACKGROUND
    | POPUP_CLOSE_ICON_COLOR
    | POPUP_OVERLAY_BACKGROUND
}

/**
 * 将弹出层颜色枚举转换为字符串
 * @param key 弹出层颜色枚举值
 * @return 对应的字符串键
 */
private func popupColorKeyToString(key: SilkPopupColorKey): String {
    match (key) {
        case SilkPopupColorKey.POPUP_BACKGROUND => "--silk-popup-background"
        case SilkPopupColorKey.POPUP_CLOSE_ICON_COLOR => "--silk-popup-close-icon-color"
        case SilkPopupColorKey.POPUP_OVERLAY_BACKGROUND => "--silk-popup-overlay-background"
    }
}

/**
 * 弹出层数值常量枚举
 */
public enum SilkPopupNumberKey {
    | POPUP_TRANSITION
}

/**
 * 将弹出层数值枚举转换为字符串
 * @param key 弹出层数值枚举值
 * @return 对应的字符串键
 */
private func popupNumberKeyToString(key: SilkPopupNumberKey): String {
    match (key) {
        case SilkPopupNumberKey.POPUP_TRANSITION => "--silk-popup-transition"
    }
}

/**
 * 默认弹出层尺寸常量
 *
 * 定义了弹出层的默认尺寸常量，用于重置
 */
private let DefaultSilkPopupSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-popup-round-radius", Length(0, unitType: LengthType.vp)),
    ("--silk-popup-close-icon-size", Length(22, unitType: LengthType.vp)),
    ("--silk-popup-close-icon-margin", Length(16, unitType: LengthType.vp))
])

/**
 * 弹出层尺寸常量
 *
 * 定义了弹出层的各种尺寸常量，包括圆角半径、关闭图标尺寸和边距
 */
private let SilkPopupSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-popup-round-radius", Length(16, unitType: LengthType.vp)),
    ("--silk-popup-close-icon-size", Length(22, unitType: LengthType.vp)),
    ("--silk-popup-close-icon-margin", Length(16, unitType: LengthType.vp))
])

/**
 * 默认弹出层颜色常量
 *
 * 定义了弹出层的默认颜色常量，用于重置
 */
private let DefaultSilkPopupColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-popup-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-popup-close-icon-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-popup-overlay-background", getColorConstant(SilkColorKey.OVERALAY_BACKGROUND))
])

/**
 * 弹出层颜色常量
 *
 * 定义了弹出层的各种颜色常量，包括背景颜色、关闭图标颜色和遮罩层颜色
 */
private let SilkPopupColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-popup-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-popup-close-icon-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-popup-overlay-background", getColorConstant(SilkColorKey.OVERALAY_BACKGROUND))
])

/**
 * 默认弹出层数值常量
 *
 * 定义了弹出层的默认数值常量，用于重置
 */
private let DefaultSilkPopupNumberConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-popup-transition", getIntConstant(SilkIntKey.DURATION_BASE)),
    ("--silk-popup-close-icon-z-index", 1.0)
])

/**
 * 弹出层数值常量
 *
 * 定义了弹出层的各种数值常量，包括过渡动画时间和关闭图标的z-index
 */
private let SilkPopupNumberConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-popup-transition", getIntConstant(SilkIntKey.DURATION_BASE)),
    ("--silk-popup-close-icon-z-index", 1.0)
])

/**
 * 通过枚举获取弹出层尺寸常量的值
 * @param key 弹出层尺寸枚举键
 * @return 对应的尺寸值
 */
public func getPopupSizeConstant(key: SilkPopupSizeKey): Length {
    let stringKey = popupSizeKeyToString(key)
    return SilkPopupSizeConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改弹出层尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updatePopupSizeConstant(key: SilkPopupSizeKey, value: Length): Bool {
    let stringKey = popupSizeKeyToString(key)
    if (SilkPopupSizeConstants.contains(stringKey)) {
        SilkPopupSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取弹出层颜色常量的值
 * @param key 弹出层颜色枚举键
 * @return 对应的颜色值
 */
public func getPopupColorConstant(key: SilkPopupColorKey): ResourceColor {
    let stringKey = popupColorKeyToString(key)
    return SilkPopupColorConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改弹出层颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updatePopupColorConstant(key: SilkPopupColorKey, value: ResourceColor): Bool {
    let stringKey = popupColorKeyToString(key)
    if (SilkPopupColorConstants.contains(stringKey)) {
        SilkPopupColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取弹出层数值常量的值
 * @param key 弹出层数值枚举键
 * @return 对应的数值
 */
public func getPopupNumberConstant(key: SilkPopupNumberKey): Float64 {
    let stringKey = popupNumberKeyToString(key)
    return SilkPopupNumberConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改弹出层数值常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的数值
 * @return 是否修改成功
 */
public func updatePopupNumberConstant(key: SilkPopupNumberKey, value: Float64): Bool {
    let stringKey = popupNumberKeyToString(key)
    if (SilkPopupNumberConstants.contains(stringKey)) {
        SilkPopupNumberConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置弹出层尺寸常量为默认值
 */
public func resetPopupSizeConstants() {
    SilkPopupSizeConstants.clear()
    for ((key, value) in DefaultSilkPopupSizeConstants) {
        SilkPopupSizeConstants.put(key, value)
    }
}

/**
 * 重置弹出层颜色常量为默认值
 */
public func resetPopupColorConstants() {
    SilkPopupColorConstants.clear()
    for ((key, value) in DefaultSilkPopupColorConstants) {
        SilkPopupColorConstants.put(key, value)
    }
}

/**
 * 重置弹出层数值常量为默认值
 */
public func resetPopupNumberConstants() {
    SilkPopupNumberConstants.clear()
    for ((key, value) in DefaultSilkPopupNumberConstants) {
        SilkPopupNumberConstants.put(key, value)
    }
}

/**
 * 重置所有弹出层常量为默认值
 *
 * 将所有弹出层常量重置为初始默认值
 */
public func resetPopupConstants() {
    // 重置尺寸常量
    resetPopupSizeConstants()

    // 重置颜色常量
    resetPopupColorConstants()

    // 重置数值常量
    resetPopupNumberConstants()
}