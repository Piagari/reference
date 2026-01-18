/**
 * Created on 2025/5/5
 *
 * SilkBadge 徽标组件常量定义
 *
 * 本文件定义了徽标组件使用的各种常量，包括颜色、尺寸、字体等
 * 这里定义样式变量。由于泛型的问题，所以此处不使用 resource，全部采用 string
 *
 * @module silkui/constants/badge
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
 * 徽标颜色常量枚举
 */
public enum SilkBadgeColorKey {
    | BADGE_COLOR
    | BADGE_BACKGROUND
    | BADGE_DOT_COLOR
}

/**
 * 将徽标颜色枚举转换为字符串
 * @param key 徽标颜色枚举值
 * @return 对应的字符串键
 */
private func badgeColorKeyToString(key: SilkBadgeColorKey): String {
    match (key) {
        case SilkBadgeColorKey.BADGE_COLOR => "--silk-badge-color"
        case SilkBadgeColorKey.BADGE_BACKGROUND => "--silk-badge-background"
        case SilkBadgeColorKey.BADGE_DOT_COLOR => "--silk-badge-dot-color"
    }
}

/**
 * 徽标尺寸常量枚举
 */
public enum SilkBadgeSizeKey {
    | BADGE_SIZE
    | BADGE_FONT_SIZE
    | BADGE_DOT_SIZE
}

/**
 * 将徽标尺寸枚举转换为字符串
 * @param key 徽标尺寸枚举值
 * @return 对应的字符串键
 */
private func badgeSizeKeyToString(key: SilkBadgeSizeKey): String {
    match (key) {
        case SilkBadgeSizeKey.BADGE_SIZE => "--silk-badge-size"
        case SilkBadgeSizeKey.BADGE_FONT_SIZE => "--silk-badge-font-size"
        case SilkBadgeSizeKey.BADGE_DOT_SIZE => "--silk-badge-dot-size"
    }
}

/**
 * 徽标样式常量枚举
 */
public enum SilkBadgeStyleKey {
    | BADGE_FONT
}

/**
 * 将徽标样式枚举转换为字符串
 * @param key 徽标样式枚举值
 * @return 对应的字符串键
 */
private func badgeStyleKeyToString(key: SilkBadgeStyleKey): String {
    match (key) {
        case SilkBadgeStyleKey.BADGE_FONT => "--silk-badge-font"
    }
}

/**
 * 徽标padding常量枚举
 */
public enum SilkBadgePaddingKey {
    | PADDING
}
/**
  * 将徽标padding枚举转换为字符串
  * @param key 徽标padding枚举值
  * @return 对应的字符串键
*/
private func badgePaddingKeyToString(key: SilkBadgePaddingKey): String {
    match (key) {
        case SilkBadgePaddingKey.PADDING => "--silk-badge-padding"
    }
}

public enum SilkBadgeIntKey {
    | BORDER_WIDTH
    | LINE_HEIGHT
}
private func badgeIntKeyToString (key: SilkBadgeIntKey): String {
    match (key) {
        case SilkBadgeIntKey.BORDER_WIDTH => "--silk-badge-border-width"
        case SilkBadgeIntKey.LINE_HEIGHT => "--silk-badge-line-height"
    }
}


/**
 * 默认徽标颜色常量
 *
 * 定义了徽标的默认颜色常量，用于重置
 */
private let DefaultSilkBadgeColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-badge-color",  getColorConstant(SilkColorKey.WHITE)),
    ("--silk-badge-background", getColorConstant(SilkColorKey.DANGER_COLOR)),
    ("--silk-badge-dot-color", getColorConstant(SilkColorKey.DANGER_COLOR))
])

/**
 * 徽标颜色常量
 *
 * 定义了徽标的各种颜色常量，包括文字颜色、背景颜色等
 */
private let SilkBadgeColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-badge-color",  getColorConstant(SilkColorKey.WHITE)),
    ("--silk-badge-background", getColorConstant(SilkColorKey.DANGER_COLOR)),
    ("--silk-badge-dot-color", getColorConstant(SilkColorKey.DANGER_COLOR))
])

/**
 * 默认徽标尺寸常量
 *
 * 定义了徽标的默认尺寸常量，用于重置
 */
private let DefaultSilkBadgeSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-badge-size", Length(16, unitType: LengthType.vp)),// 这里原始值是"0 3px"，需要分别处理左右内边距
    ("--silk-badge-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_SM)),
    ("--silk-badge-dot-size", Length(8, unitType: LengthType.vp))
])

/**
 * 徽标尺寸常量
 *
 * 定义了徽标的各种尺寸常量，包括大小、内边距、字体大小等
 */
private let SilkBadgeSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-badge-size", Length(16, unitType: LengthType.vp)),// 这里原始值是"0 3px"，需要分别处理左右内边距
    ("--silk-badge-font-size", getSizeConstant(SilkSizeKey.FONT_SIZE_SM)),
    ("--silk-badge-dot-size", Length(8, unitType: LengthType.vp))
])

/**
 * 默认徽标样式常量
 *
 * 定义了徽标的默认样式常量，用于重置
 */
private let DefaultSilkBadgeStyleConstants: HashMap<String, ResourceStr> = HashMap<String, ResourceStr>([
    ("--silk-badge-font", "-apple-system-font, Helvetica Neue, Arial, sans-serif")
])

/**
 * 徽标样式常量
 *
 * 定义了徽标的各种样式常量，包括字体等
 */
private let SilkBadgeStyleConstants: HashMap<String, ResourceStr> = HashMap<String, ResourceStr>([
    ("--silk-badge-font", "-apple-system-font, Helvetica Neue, Arial, sans-serif")
])

/**
 * 默认徽标padding常量
 *
 * 定义了徽标的默认padding常量，用于重置
*/
private let DefaultSilkBadgePaddingConstants: HashMap<String, SilkUIPaddingOptions> = HashMap<String, SilkUIPaddingOptions>([
    ("--silk-badge-padding", SilkUIPaddingOptions(
                top: 0.vp,
                right: 3.vp,
                bottom: 0.vp,
                left: 3.vp
    ))
])

/**
 * 徽标padding常量
 *
 * 定义了徽标的各种padding常量，包括内边距等
*/
private let SilkBadgePaddingConstants: HashMap<String, SilkUIPaddingOptions> = HashMap<String, SilkUIPaddingOptions>([
    ("--silk-badge-padding", SilkUIPaddingOptions(
                top: 0.vp,
                right: 3.vp,
                bottom: 0.vp,
                left: 3.vp
    ))
])

/**
  * 默认徽标int常量
  *
  * 定义了徽标的默认int常量，用于重置
*/
private let DefaultSilkBadgeIntConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-badge-border-width", 1.0),
    ("--silk-badge-line-height", 1.2)
])

/**
  * 徽标int常量
  *
  * 定义了徽标的各种int常量，包括border-width等
*/
private let SilkBadgeIntConstants: HashMap<String, Float64> = HashMap<String, Float64>([
    ("--silk-badge-border-width", 1.0),
    ("--silk-badge-line-height", 1.2)
])

/**
 * 默认徽标字体权重常量
 */
private let __DefaultSilkBadgeWeight = FontWeight.W600

/**
 * 徽标字体权重常量
 */
public var __SilkBadgeWeight = FontWeight.W600
/**
 * 通过枚举获取徽标颜色常量的值
 * @param key 徽标颜色枚举键
 * @return 对应的颜色值
 */
public func getBadgeColorConstant(key: SilkBadgeColorKey): ResourceColor {
    let stringKey = badgeColorKeyToString(key)
    return SilkBadgeColorConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改徽标颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateBadgeColorConstant(key: SilkBadgeColorKey, value: ResourceColor): Bool {
    let stringKey = badgeColorKeyToString(key)
    if (SilkBadgeColorConstants.contains(stringKey)) {
        SilkBadgeColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取徽标尺寸常量的值
 * @param key 徽标尺寸枚举键
 * @return 对应的尺寸值
 */
public func getBadgeSizeConstant(key: SilkBadgeSizeKey): Length {
    let stringKey = badgeSizeKeyToString(key)
    return SilkBadgeSizeConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改徽标尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateBadgeSizeConstant(key: SilkBadgeSizeKey, value: Length): Bool {
    let stringKey = badgeSizeKeyToString(key)
    if (SilkBadgeSizeConstants.contains(stringKey)) {
        SilkBadgeSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取徽标样式常量的值
 * @param key 徽标样式枚举键
 * @return 对应的样式值
 */
public func getBadgeStyleConstant(key: SilkBadgeStyleKey): ResourceStr {
    let stringKey = badgeStyleKeyToString(key)
    return SilkBadgeStyleConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改徽标样式常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的样式值
 * @return 是否修改成功
 */
public func updateBadgeStyleConstant(key: SilkBadgeStyleKey, value: ResourceStr): Bool {
    let stringKey = badgeStyleKeyToString(key)
    if (SilkBadgeStyleConstants.contains(stringKey)) {
        SilkBadgeStyleConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
  * 通过枚举获取徽标内边距常量的值
  * @param key 徽标内边距枚举键
  * @return 对应的内边距值
*/
public func getBadgePaddingConstant (key: SilkBadgePaddingKey): SilkUIPaddingOptions {
    let stringKey = badgePaddingKeyToString(key)
    return SilkBadgePaddingConstants.get(stringKey).getOrThrow()
}

/**
  * 通过枚举修改徽标内边距常量的值
  * @param key 要修改的常量的枚举键
  * @param value 新的内边距值
  * @return 是否修改成功
*/
public func updateBadgePaddingConstant(key: SilkBadgePaddingKey, value: SilkUIPaddingOptions): Bool {
    let stringKey = badgePaddingKeyToString(key)
    if (SilkBadgePaddingConstants.contains(stringKey)) {
        SilkBadgePaddingConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
  * 通过枚举获取徽标数值常量的值
  * @param key 徽标数值常量键
  * @return 对应的数值 Float64
*/
public func getBadgeIntConstant (key: SilkBadgeIntKey): Float64 {
    let stringKey = badgeIntKeyToString(key)
    return SilkBadgeIntConstants.get(stringKey).getOrThrow()
}

/**
  * 通过枚举修改徽标数值常量的值
  * @param key 要修改的常量的枚举键
  * @param value 新的数值
*/
public func updateBadgeIntConstant(key: SilkBadgeIntKey, value: Float64): Bool {
    let stringKey = badgeIntKeyToString(key)
    if (SilkBadgeIntConstants.contains(stringKey)) {
        SilkBadgeIntConstants.put(stringKey, value)
        return true
    }
    return false
}

func updateBadgeFontWeight (value: FontWeight) {
    __SilkBadgeWeight = value
}

/**
 * 重置所有徽标常量为默认值
 *
 * 将所有徽标常量重置为初始默认值
 */
public func resetBadgeConstants() {
    // 重置徽标颜色常量
    resetBadgeColorConstants()

    // 重置徽标尺寸常量
    resetBadgeSizeConstants()

    // 重置徽标样式常量
    resetBadgeStyleConstants()

    // 重置徽标内边距常量
    resetBadgePaddingConstants()

    // 重置徽标数值常量
    resetBadgeIntConstants()

    // 重置徽标字体权重常量
    resetBadgeFontWeight()
}

/**
 * 重置徽标颜色常量为默认值
 */
public func resetBadgeColorConstants() {
    SilkBadgeColorConstants.clear()
    for ((key, value) in DefaultSilkBadgeColorConstants) {
        SilkBadgeColorConstants.put(key, value)
    }
}

/**
 * 重置徽标尺寸常量为默认值
 */
public func resetBadgeSizeConstants() {
    SilkBadgeSizeConstants.clear()
    for ((key, value) in DefaultSilkBadgeSizeConstants) {
        SilkBadgeSizeConstants.put(key, value)
    }
}

/**
 * 重置徽标样式常量为默认值
 */
public func resetBadgeStyleConstants() {
    SilkBadgeStyleConstants.clear()
    for ((key, value) in DefaultSilkBadgeStyleConstants) {
        SilkBadgeStyleConstants.put(key, value)
    }
}

/**
 * 重置徽标内边距常量为默认值
 */
public func resetBadgePaddingConstants() {
    SilkBadgePaddingConstants.clear()
    for ((key, value) in DefaultSilkBadgePaddingConstants) {
        SilkBadgePaddingConstants.put(key, value)
    }
}

/**
 * 重置徽标数值常量为默认值
 */
public func resetBadgeIntConstants() {
    SilkBadgeIntConstants.clear()
    for ((key, value) in DefaultSilkBadgeIntConstants) {
        SilkBadgeIntConstants.put(key, value)
    }
}

/**
 * 重置徽标字体权重常量为默认值
 */
public func resetBadgeFontWeight() {
    __SilkBadgeWeight = __DefaultSilkBadgeWeight
}
