/**
 * Created on 2025/4/28
 *
 * SilkCollapse 折叠面板组件常量定义
 *
 * 本文件定义了折叠面板组件使用的各种常量，包括颜色、尺寸、动画时长等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/collapse
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import silkui.ResourceColor
import silkui.ResourceStr
import silkui.SilkUIPaddingOptions

/**
 * 折叠面板颜色常量枚举
 */
public enum SilkCollapseColorKey {
    | COLLAPSE_ITEM_CONTENT_TEXT_COLOR
    | COLLAPSE_ITEM_CONTENT_BACKGROUND
    | COLLAPSE_ITEM_TITLE_DISABLED_COLOR
}

/**
 * 将折叠面板颜色枚举转换为字符串
 * @param key 折叠面板颜色枚举值
 * @return 对应的字符串键
 */
private func collapseColorKeyToString(key: SilkCollapseColorKey): String {
    match (key) {
        case SilkCollapseColorKey.COLLAPSE_ITEM_CONTENT_TEXT_COLOR => "--silk-collapse-item-content-text-color"
        case SilkCollapseColorKey.COLLAPSE_ITEM_CONTENT_BACKGROUND => "--silk-collapse-item-content-background"
        case SilkCollapseColorKey.COLLAPSE_ITEM_TITLE_DISABLED_COLOR => "--silk-collapse-item-title-disabled-color"
    }
}

/**
 * 折叠面板尺寸常量枚举
 */
public enum SilkCollapseSizeKey {
    | COLLAPSE_ITEM_CONTENT_FONT_SIZE
}

/**
 * 将折叠面板尺寸枚举转换为字符串
 * @param key 折叠面板尺寸枚举值
 * @return 对应的字符串键
 */
private func collapseSizeKeyToString(key: SilkCollapseSizeKey): String {
    match (key) {
        case SilkCollapseSizeKey.COLLAPSE_ITEM_CONTENT_FONT_SIZE => "--silk-collapse-item-content-font-size"
    }
}

/**
 * 折叠面板内边距常量枚举
 */
public enum SilkCollapsePaddingKey {
    | COLLAPSE_ITEM_CONTENT_PADDING
}

/**
 * 将折叠面板内边距枚举转换为字符串
 * @param key 折叠面板内边距枚举值
 * @return 对应的字符串键
 */
private func collapsePaddingKeyToString(key: SilkCollapsePaddingKey): String {
    match (key) {
        case SilkCollapsePaddingKey.COLLAPSE_ITEM_CONTENT_PADDING => "--silk-collapse-item-content-padding"
    }
}

/**
 * 折叠面板动画常量枚举
 */
public enum SilkCollapseAnimationKey {
    | COLLAPSE_ITEM_DURATION
}

/**
 * 将折叠面板动画枚举转换为字符串
 * @param key 折叠面板动画枚举值
 * @return 对应的字符串键
 */
private func collapseAnimationKeyToString(key: SilkCollapseAnimationKey): String {
    match (key) {
        case SilkCollapseAnimationKey.COLLAPSE_ITEM_DURATION => "--silk-collapse-item-duration"
    }
}

/**
 * 折叠面板样式常量枚举
 */
public enum SilkCollapseStyleKey {
    | COLLAPSE_ITEM_CONTENT_LINE_HEIGHT
}

/**
 * 将折叠面板样式枚举转换为字符串
 * @param key 折叠面板样式枚举值
 * @return 对应的字符串键
 */
private func collapseStyleKeyToString(key: SilkCollapseStyleKey): String {
    match (key) {
        case SilkCollapseStyleKey.COLLAPSE_ITEM_CONTENT_LINE_HEIGHT => "--silk-collapse-item-content-line-height"
    }
}

/**
 * 默认折叠面板颜色常量
 *
 * 定义了折叠面板的默认颜色常量，用于重置
 */
private let DefaultSilkCollapseColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-collapse-item-content-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-collapse-item-content-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-collapse-item-title-disabled-color", getColorConstant(SilkColorKey.TEXT_COLOR_3))
])

/**
 * 折叠面板颜色常量
 *
 * 定义了折叠面板的各种颜色常量，包括内容文字颜色、背景颜色和禁用状态颜色
 */
private let SilkCollapseColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-collapse-item-content-text-color", getColorConstant(SilkColorKey.TEXT_COLOR_2)),
    ("--silk-collapse-item-content-background", getColorConstant(SilkColorKey.BACKGROUND_2)),
    ("--silk-collapse-item-title-disabled-color", getColorConstant(SilkColorKey.TEXT_COLOR_3))
])

/**
 * 默认折叠面板尺寸常量
 *
 * 定义了折叠面板的默认尺寸常量，用于重置
 */
private let DefaultSilkCollapseSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-collapse-item-content-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD))
])

/**
 * 折叠面板尺寸常量
 *
 * 定义了折叠面板的各种尺寸常量，包括字体大小和行高
 */
private let SilkCollapseSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-collapse-item-content-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_MD))
])

/**
 * 默认折叠面板内边距常量
 *
 * 定义了折叠面板的默认内边距常量，用于重置
 */
private let DefaultSilkCollapsePaddingConstants: HashMap<String, SilkUIPaddingOptions> = HashMap<String, SilkUIPaddingOptions>([
    ("--silk-collapse-item-content-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_SM),
        right: getSizeConstant(SilkSizeKey.PADDING_MD),
        bottom: getSizeConstant(SilkSizeKey.PADDING_SM),
        left: getSizeConstant(SilkSizeKey.PADDING_MD)
    ))
])

/**
 * 折叠面板内边距常量
 *
 * 定义了折叠面板的各种内边距常量
 */
private let SilkCollapsePaddingConstants: HashMap<String, SilkUIPaddingOptions> = HashMap<String, SilkUIPaddingOptions>([
    ("--silk-collapse-item-content-padding", SilkUIPaddingOptions(
        top: getSizeConstant(SilkSizeKey.PADDING_SM),
        right: getSizeConstant(SilkSizeKey.PADDING_MD),
        bottom: getSizeConstant(SilkSizeKey.PADDING_SM),
        left: getSizeConstant(SilkSizeKey.PADDING_MD)
    ))
])

/**
 * 默认折叠面板动画常量
 *
 * 定义了折叠面板的默认动画相关常量，用于重置
 */
private let DefaultSilkCollapseAnimationConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-collapse-item-duration", 0.3)
])

/**
 * 折叠面板动画常量
 *
 * 定义了折叠面板的动画相关常量，包括动画时长
 */
private let SilkCollapseAnimationConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-collapse-item-duration", 0.3)
])

/**
 * 默认折叠面板样式常量
 *
 * 定义了折叠面板的默认其他样式常量，用于重置
 */
private let DefaultSilkCollapseStyleConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-collapse-item-content-line-height", 1.5)
])

/**
 * 折叠面板样式常量
 *
 * 定义了折叠面板的其他样式常量，如行高等
 */
private let SilkCollapseStyleConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-collapse-item-content-line-height", 1.5)
])

/**
 * 通过枚举获取折叠面板颜色常量的值
 * @param key 折叠面板颜色枚举键
 * @return 对应的颜色值
 */
public func getCollapseColorConstant(key: SilkCollapseColorKey): ResourceColor {
    let stringKey = collapseColorKeyToString(key)
    return SilkCollapseColorConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改折叠面板颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateCollapseColorConstant(key: SilkCollapseColorKey, value: ResourceColor): Bool {
    let stringKey = collapseColorKeyToString(key)
    if (SilkCollapseColorConstants.contains(stringKey)) {
        SilkCollapseColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取折叠面板尺寸常量的值
 * @param key 折叠面板尺寸枚举键
 * @return 对应的尺寸值
 */
public func getCollapseSizeConstant(key: SilkCollapseSizeKey): Length {
    let stringKey = collapseSizeKeyToString(key)
    return SilkCollapseSizeConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改折叠面板尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateCollapseSizeConstant(key: SilkCollapseSizeKey, value: Length): Bool {
    let stringKey = collapseSizeKeyToString(key)
    if (SilkCollapseSizeConstants.contains(stringKey)) {
        SilkCollapseSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取折叠面板内边距常量的值
 * @param key 折叠面板内边距枚举键
 * @return 对应的内边距值
 */
public func getCollapsePaddingConstant(key: SilkCollapsePaddingKey): SilkUIPaddingOptions {
    let stringKey = collapsePaddingKeyToString(key)
    return SilkCollapsePaddingConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改折叠面板内边距常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的内边距值
 * @return 是否修改成功
 */
public func updateCollapsePaddingConstant(key: SilkCollapsePaddingKey, value: SilkUIPaddingOptions): Bool {
    let stringKey = collapsePaddingKeyToString(key)
    if (SilkCollapsePaddingConstants.contains(stringKey)) {
        SilkCollapsePaddingConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取折叠面板动画常量的值
 * @param key 折叠面板动画枚举键
 * @return 对应的动画时长值（秒）
 */
public func getCollapseAnimationConstant(key: SilkCollapseAnimationKey): Float64 {
    let stringKey = collapseAnimationKeyToString(key)
    return SilkCollapseAnimationConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改折叠面板动画常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的动画时长值（秒）
 * @return 是否修改成功
 */
public func updateCollapseAnimationConstant(key: SilkCollapseAnimationKey, value: Float64): Bool {
    let stringKey = collapseAnimationKeyToString(key)
    if (SilkCollapseAnimationConstants.contains(stringKey)) {
        SilkCollapseAnimationConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取折叠面板样式常量的值
 * @param key 折叠面板样式枚举键
 * @return 对应的样式值
 */
public func getCollapseStyleConstant(key: SilkCollapseStyleKey): Float64 {
    let stringKey = collapseStyleKeyToString(key)
    return SilkCollapseStyleConstants.get(stringKey).getOrThrow()
}


/**
 * 通过枚举修改折叠面板样式常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的样式值
 * @return 是否修改成功
 */
public func updateCollapseStyleConstant(key: SilkCollapseStyleKey, value: Float64): Bool {
    let stringKey = collapseStyleKeyToString(key)
    if (SilkCollapseStyleConstants.contains(stringKey)) {
        SilkCollapseStyleConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置所有折叠面板常量为默认值
 *
 * 将所有折叠面板常量重置为初始默认值
 */
public func resetCollapseConstants() {
    // 重置折叠面板颜色常量
    resetCollapseColorConstants()

    // 重置折叠面板尺寸常量
    resetCollapseSizeConstants()

    // 重置折叠面板内边距常量
    resetCollapsePaddingConstants()

    // 重置折叠面板动画常量
    resetCollapseAnimationConstants()

    // 重置折叠面板样式常量
    resetCollapseStyleConstants()
}

/**
 * 重置折叠面板颜色常量为默认值
 */
public func resetCollapseColorConstants() {
    SilkCollapseColorConstants.clear()
    for ((key, value) in DefaultSilkCollapseColorConstants) {
        SilkCollapseColorConstants.put(key, value)
    }
}

/**
 * 重置折叠面板尺寸常量为默认值
 */
public func resetCollapseSizeConstants() {
    SilkCollapseSizeConstants.clear()
    for ((key, value) in DefaultSilkCollapseSizeConstants) {
        SilkCollapseSizeConstants.put(key, value)
    }
}

/**
 * 重置折叠面板内边距常量为默认值
 */
public func resetCollapsePaddingConstants() {
    SilkCollapsePaddingConstants.clear()
    for ((key, value) in DefaultSilkCollapsePaddingConstants) {
        SilkCollapsePaddingConstants.put(key, value)
    }
}

/**
 * 重置折叠面板动画常量为默认值
 */
public func resetCollapseAnimationConstants() {
    SilkCollapseAnimationConstants.clear()
    for ((key, value) in DefaultSilkCollapseAnimationConstants) {
        SilkCollapseAnimationConstants.put(key, value)
    }
}

/**
 * 重置折叠面板样式常量为默认值
 */
public func resetCollapseStyleConstants() {
    SilkCollapseStyleConstants.clear()
    for ((key, value) in DefaultSilkCollapseStyleConstants) {
        SilkCollapseStyleConstants.put(key, value)
    }
}
