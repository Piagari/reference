/**
 * Created on 2025/5/15
 *
 * SilkRate 评分组件常量定义
 *
 * 本文件定义了评分组件使用的各种常量，包括颜色、尺寸等
 *
 * @module silkui/constants/rate
 */
package silkui.constants
import std.collection.HashMap
import ohos.base.Length
import ohos.base.LengthType
import ohos.base.Color
import silkui.ResourceColor
import silkui.ResourceStr

/**
 * 评分颜色常量枚举
 */
public enum SilkRateColorKey {
    | RATE_ICON_FULL_COLOR
    | RATE_ICON_VOID_COLOR
    | RATE_ICON_DISABLED_COLOR
    | RATE_ICON_HALF_COLOR
}

/**
 * 将评分颜色枚举转换为字符串
 * @param key 评分颜色枚举值
 * @return 对应的字符串键
 */
private func rateColorKeyToString(key: SilkRateColorKey): String {
    match (key) {
        case SilkRateColorKey.RATE_ICON_FULL_COLOR => "--silk-rate-icon-full-color"
        case SilkRateColorKey.RATE_ICON_VOID_COLOR => "--silk-rate-icon-void-color"
        case SilkRateColorKey.RATE_ICON_DISABLED_COLOR => "--silk-rate-icon-disabled-color"
        case SilkRateColorKey.RATE_ICON_HALF_COLOR => "--silk-rate-icon-half-color"
    }
}

/**
 * 评分尺寸常量枚举
 */
public enum SilkRateSizeKey {
    | RATE_ICON_SIZE
    | RATE_ICON_GUTTER
}

/**
 * 将评分尺寸枚举转换为字符串
 * @param key 评分尺寸枚举值
 * @return 对应的字符串键
 */
private func rateSizeKeyToString(key: SilkRateSizeKey): String {
    match (key) {
        case SilkRateSizeKey.RATE_ICON_SIZE => "--silk-rate-icon-size"
        case SilkRateSizeKey.RATE_ICON_GUTTER => "--silk-rate-icon-gutter"
    }
}

/**
 * 评分数值常量枚举
 */
public enum SilkRateIntKey {
    | RATE_COUNT
    | RATE_TOUCH_THRESHOLD
}

/**
 * 将评分数值枚举转换为字符串
 * @param key 评分数值枚举值
 * @return 对应的字符串键
 */
private func rateIntKeyToString(key: SilkRateIntKey): String {
    match (key) {
        case SilkRateIntKey.RATE_COUNT => "--silk-rate-count"
        case SilkRateIntKey.RATE_TOUCH_THRESHOLD => "--silk-rate-touch-threshold"
    }
}

/**
 * 默认评分颜色常量
 *
 * 定义了评分的默认颜色常量，用于重置
 */
private let DefaultSilkRateColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-rate-icon-full-color", getColorConstant(SilkColorKey.ORANGE)),
    ("--silk-rate-icon-void-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-rate-icon-disabled-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-rate-icon-half-color", getColorConstant(SilkColorKey.ORANGE))
])

/**
 * 评分颜色常量
 *
 * 定义了评分的各种颜色常量
 */
private let SilkRateColorConstants: HashMap<String, ResourceColor> = HashMap<String, ResourceColor>([
    ("--silk-rate-icon-full-color", getColorConstant(SilkColorKey.ORANGE)),
    ("--silk-rate-icon-void-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-rate-icon-disabled-color", getColorConstant(SilkColorKey.GRAY_5)),
    ("--silk-rate-icon-half-color", getColorConstant(SilkColorKey.ORANGE))
])

/**
 * 默认评分尺寸常量
 *
 * 定义了评分的默认尺寸常量，用于重置
 */
private let DefaultSilkRateSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-rate-icon-size", Length(20, unitType: LengthType.vp)),
    ("--silk-rate-icon-gutter", Length(4, unitType: LengthType.vp))
])

/**
 * 评分尺寸常量
 *
 * 定义了评分的各种尺寸常量
 */
private let SilkRateSizeConstants: HashMap<String, Length> = HashMap<String, Length>([
    ("--silk-rate-icon-size", Length(20, unitType: LengthType.vp)),
    ("--silk-rate-icon-gutter", Length(4, unitType: LengthType.vp))
])

/**
 * 默认评分数值常量
 *
 * 定义了评分的默认数值常量，用于重置
 */
private let DefaultSilkRateIntConstants: HashMap<String, Int64> = HashMap<String, Int64>([
    ("--silk-rate-count", 5),
    ("--silk-rate-touch-threshold", 50)
])

/**
 * 评分数值常量
 *
 * 定义了评分的各种数值常量
 */
private let SilkRateIntConstants: HashMap<String, Int64> = HashMap<String, Int64>([
    ("--silk-rate-count", 5),
    ("--silk-rate-touch-threshold", 50)
])

/**
 * 通过枚举获取评分颜色常量的值
 * @param key 评分颜色枚举键
 * @return 对应的颜色值
 */
public func getRateColorConstant(key: SilkRateColorKey): ResourceColor {
    let stringKey = rateColorKeyToString(key)
    return SilkRateColorConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改评分颜色常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的颜色值
 * @return 是否修改成功
 */
public func updateRateColorConstant(key: SilkRateColorKey, value: ResourceColor): Bool {
    let stringKey = rateColorKeyToString(key)
    if (SilkRateColorConstants.contains(stringKey)) {
        SilkRateColorConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取评分尺寸常量的值
 * @param key 评分尺寸枚举键
 * @return 对应的尺寸值
 */
public func getRateSizeConstant(key: SilkRateSizeKey): Length {
    let stringKey = rateSizeKeyToString(key)
    return SilkRateSizeConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改评分尺寸常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的尺寸值
 * @return 是否修改成功
 */
public func updateRateSizeConstant(key: SilkRateSizeKey, value: Length): Bool {
    let stringKey = rateSizeKeyToString(key)
    if (SilkRateSizeConstants.contains(stringKey)) {
        SilkRateSizeConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 通过枚举获取评分数值常量的值
 * @param key 评分数值枚举键
 * @return 对应的数值
 */
public func getRateIntConstant(key: SilkRateIntKey): Int64 {
    let stringKey = rateIntKeyToString(key)
    return SilkRateIntConstants.get(stringKey).getOrThrow()
}

/**
 * 通过枚举修改评分数值常量的值
 * @param key 要修改的常量的枚举键
 * @param value 新的数值
 * @return 是否修改成功
 */
public func updateRateIntConstant(key: SilkRateIntKey, value: Int64): Bool {
    let stringKey = rateIntKeyToString(key)
    if (SilkRateIntConstants.contains(stringKey)) {
        SilkRateIntConstants.put(stringKey, value)
        return true
    }
    return false
}

/**
 * 重置评分颜色常量为默认值
 * @return 是否重置成功
 */
public func resetRateColorConstants(): Bool {
    for ((key, value) in DefaultSilkRateColorConstants) {
        SilkRateColorConstants.put(key, value)
    }
    return true
}

/**
 * 重置评分尺寸常量为默认值
 * @return 是否重置成功
 */
public func resetRateSizeConstants(): Bool {
    for ((key, value) in DefaultSilkRateSizeConstants) {
        SilkRateSizeConstants.put(key, value)
    }
    return true
}

/**
 * 重置评分数值常量为默认值
 * @return 是否重置成功
 */
public func resetRateIntConstants(): Bool {
    for ((key, value) in DefaultSilkRateIntConstants) {
        SilkRateIntConstants.put(key, value)
    }
    return true
}
