/**
 * Created on 2025/4/28
 *
 * SilkIcon 图标组件常量定义
 *
 * 本文件定义了图标组件使用的各种常量，包括字体、尺寸等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/icon
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import silkui.ResourceColor
import silkui.ResourceStr

/**
 * 图标样式常量枚举
 */
public enum SilkIconStyleKey {
    | ICON_FONT_FAMILY
}

/**
 * 将图标样式枚举转换为字符串
 * @param key 图标样式枚举值
 * @return 对应的字符串键
 */
private func iconStyleKeyToString(key: SilkIconStyleKey): String {
    match (key) {
        case SilkIconStyleKey.ICON_FONT_FAMILY => "--silk-icon-font-family"
    }
}

/**
 * 图标尺寸常量枚举
 */
public enum SilkIconSizeKey {
    | ICON_SIZE_XS
    | ICON_SIZE_SM
    | ICON_SIZE_MD
    | ICON_SIZE_LG
    | ICON_SIZE_XL
}

/**
 * 将图标尺寸枚举转换为字符串
 * @param key 图标尺寸枚举值
 * @return 对应的字符串键
 */
private func iconSizeKeyToString(key: SilkIconSizeKey): String {
    match (key) {
        case SilkIconSizeKey.ICON_SIZE_XS => "--silk-icon-size-xs"
        case SilkIconSizeKey.ICON_SIZE_SM => "--silk-icon-size-sm"
        case SilkIconSizeKey.ICON_SIZE_MD => "--silk-icon-size-md"
        case SilkIconSizeKey.ICON_SIZE_LG => "--silk-icon-size-lg"
        case SilkIconSizeKey.ICON_SIZE_XL => "--silk-icon-size-xl"
    }
}

/**
 * 图标颜色常量枚举
 */
public enum SilkIconColorKey {
    | ICON_DEFAULT_COLOR
    | ICON_PRIMARY_COLOR
    | ICON_SUCCESS_COLOR
    | ICON_WARNING_COLOR
    | ICON_DANGER_COLOR
    | ICON_INFO_COLOR
}

/**
 * 将图标颜色枚举转换为字符串
 * @param key 图标颜色枚举值
 * @return 对应的字符串键
 */
private func iconColorKeyToString(key: SilkIconColorKey): String {
    match (key) {
        case SilkIconColorKey.ICON_DEFAULT_COLOR => "--silk-icon-default-color"
        case SilkIconColorKey.ICON_PRIMARY_COLOR => "--silk-icon-primary-color"
        case SilkIconColorKey.ICON_SUCCESS_COLOR => "--silk-icon-success-color"
        case SilkIconColorKey.ICON_WARNING_COLOR => "--silk-icon-warning-color"
        case SilkIconColorKey.ICON_DANGER_COLOR => "--silk-icon-danger-color"
        case SilkIconColorKey.ICON_INFO_COLOR => "--silk-icon-info-color"
    }
}

/**
 * 默认图标字体常量
 *
 * 定义了图标的默认字体相关常量，用于重置
 */
private let DefaultSilkIconStyleConstants: HashMap<String, ResourceStr> = HashMap<String, ResourceStr>([
    ("--silk-icon-font-family", "silk-icon")
])

/**
 * 图标字体常量
 *
 * 定义了图标的字体相关常量
 */
private let SilkIconStyleConstants: HashMap<String, ResourceStr> = HashMap<String, ResourceStr>([
    ("--silk-icon-font-family", "silk-icon")
])

/**
 * 默认图标尺寸常量
 *
 * 定义了图标的默认尺寸常量，用于重置
 */
private let DefaultSilkIconSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-icon-size-xs", Length(10, unitType: LengthType.vp)),
    ("--silk-icon-size-sm", Length(12, unitType: LengthType.vp)),
    ("--silk-icon-size-md", Length(16, unitType: LengthType.vp)),
    ("--silk-icon-size-lg", Length(20, unitType: LengthType.vp)),
    ("--silk-icon-size-xl", Length(24, unitType: LengthType.vp))
])

/**
 * 图标尺寸常量
 *
 * 定义了图标的各种尺寸常量
 */
private let SilkIconSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-icon-size-xs", Length(10, unitType: LengthType.vp)),
    ("--silk-icon-size-sm", Length(12, unitType: LengthType.vp)),
    ("--silk-icon-size-md", Length(16, unitType: LengthType.vp)),
    ("--silk-icon-size-lg", Length(20, unitType: LengthType.vp)),
    ("--silk-icon-size-xl", Length(24, unitType: LengthType.vp))
])

/**
 * 默认图标颜色常量
 *
 * 定义了图标的默认颜色常量，用于重置
 */
private let DefaultSilkIconColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-icon-default-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-icon-primary-color", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-icon-success-color", getColorConstant(SilkColorKey.SUCCESS_COLOR)),
    ("--silk-icon-warning-color", getColorConstant(SilkColorKey.WARNING_COLOR)),
    ("--silk-icon-danger-color", getColorConstant(SilkColorKey.DANGER_COLOR)),
    ("--silk-icon-info-color", getColorConstant(SilkColorKey.GRAY_6))
])

/**
 * 图标颜色常量
 *
 * 定义了图标的各种颜色常量
 */
private let SilkIconColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-icon-default-color", getColorConstant(SilkColorKey.TEXT_COLOR)),
    ("--silk-icon-primary-color", getColorConstant(SilkColorKey.PRIMARY_COLOR)),
    ("--silk-icon-success-color", getColorConstant(SilkColorKey.SUCCESS_COLOR)),
    ("--silk-icon-warning-color", getColorConstant(SilkColorKey.WARNING_COLOR)),
    ("--silk-icon-danger-color", getColorConstant(SilkColorKey.DANGER_COLOR)),
    ("--silk-icon-info-color", getColorConstant(SilkColorKey.GRAY_6))
])

/**
 * 通过枚举获取图标样式常量的值
 * @param key 图标样式枚举键
 * @return 对应的样式值
 */
public func getIconStyleConstant(key: SilkIconStyleKey): ResourceStr {
    let stringKey = iconStyleKeyToString(key)
    return SilkIconStyleConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改图标样式常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的样式值
 * @return 是否修改成功
 */
public func updateIconStyleConstant(key: SilkIconStyleKey, value: ResourceStr): Bool {
    let stringKey = iconStyleKeyToString(key)
    if (SilkIconStyleConstants.contains(stringKey)) {
        SilkIconStyleConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取图标尺寸常量的值
 * @param key 图标尺寸枚举键
 * @return 对应的尺寸值
 */
public func getIconSizeConstant(key: SilkIconSizeKey): Length {
    let stringKey = iconSizeKeyToString(key)
    return SilkIconSizeConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改图标尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateIconSizeConstant(key: SilkIconSizeKey, value: Length): Bool {
    let stringKey = iconSizeKeyToString(key)
    if (SilkIconSizeConstants.contains(stringKey)) {
        SilkIconSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取图标颜色常量的值
 * @param key 图标颜色枚举键
 * @return 对应的颜色值
 */
public func getIconColorConstant(key: SilkIconColorKey): ResourceColor {
    let stringKey = iconColorKeyToString(key)
    return SilkIconColorConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改图标颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateIconColorConstant(key: SilkIconColorKey, value: ResourceColor): Bool {
    let stringKey = iconColorKeyToString(key)
    if (SilkIconColorConstants.contains(stringKey)) {
        SilkIconColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置所有图标常量为默认值
 *
 * 将所有图标常量重置为初始默认值
 */
public func resetIconConstants() {
    // 重置图标样式常量
    resetIconStyleConstants()

    // 重置图标尺寸常量
    resetIconSizeConstants()

    // 重置图标颜色常量
    resetIconColorConstants()
}

/**
 * 重置图标样式常量为默认值
 */
public func resetIconStyleConstants() {
    SilkIconStyleConstants.clear()
    for ((key, value) in DefaultSilkIconStyleConstants) {
        SilkIconStyleConstants.put(key, value)
    }
}

/**
 * 重置图标尺寸常量为默认值
 */
public func resetIconSizeConstants() {
    SilkIconSizeConstants.clear()
    for ((key, value) in DefaultSilkIconSizeConstants) {
        SilkIconSizeConstants.put(key, value)
    }
}

/**
 * 重置图标颜色常量为默认值
 */
public func resetIconColorConstants() {
    SilkIconColorConstants.clear()
    for ((key, value) in DefaultSilkIconColorConstants) {
        SilkIconColorConstants.put(key, value)
    }
}
